import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';

/// 时间段表示
class TimeSlot {
  final int start; // 从00:00起的分钟偏移
  final int end;
  const TimeSlot(this.start, this.end);
  int get duration => end - start;
}

/// 待分配的科目信息
class SubjectAllocation {
  final Subject subject;
  int allocatedMinutes;
  final int targetMinutes;

  SubjectAllocation({
    required this.subject,
    required this.targetMinutes,
    this.allocatedMinutes = 0,
  });

  int get remaining => targetMinutes - allocatedMinutes;
}

/// 计划生成结果
class PlanGenerationResult {
  final List<PlanItemsCompanion> items;
  final List<DeferredAllocation> deferred;

  PlanGenerationResult({required this.items, required this.deferred});
}

/// 顺延分配
class DeferredAllocation {
  final int subjectId;
  final int minutes;
  final String fromDate;

  DeferredAllocation({
    required this.subjectId,
    required this.minutes,
    required this.fromDate,
  });
}

class PlanGenerator {
  /// 生成指定日期的学习计划
  static PlanGenerationResult generate({
    required String date,
    required int dayOfWeek, // 1=周一
    required int currentWeek,
    required List<Subject> subjects,
    required List<FixedEvent> fixedEvents,
    required List<TimetableEvent> timetableEvents,
    required UserSettingsTableData settings,
    required List<DeferredRecord> pendingDeferred,
    required List<PlanItem> existingManualItems,
  }) {
    // Step 1: 收集所有固定占用时间段
    final occupiedSlots = <TimeSlot>[];

    // 添加固定事件（吃饭、睡觉等）
    for (final fe in fixedEvents) {
      if (fe.isActive) {
        occupiedSlots.add(TimeSlot(
          fe.startHour * 60 + fe.startMinute,
          fe.endHour * 60 + fe.endMinute,
        ));
      }
    }

    // 添加课表事件（按星期和周次过滤）
    for (final te in timetableEvents) {
      if (te.dayOfWeek != dayOfWeek) continue;
      if (currentWeek < te.startWeek || currentWeek > te.endWeek) continue;
      if (te.weekType == 'odd' && currentWeek % 2 == 0) continue;
      if (te.weekType == 'even' && currentWeek % 2 == 1) continue;

      occupiedSlots.add(TimeSlot(
        te.startHour * 60 + te.startMinute,
        te.endHour * 60 + te.endMinute,
      ));
    }

    // 添加已有的手动计划项占用
    for (final mi in existingManualItems) {
      occupiedSlots.add(TimeSlot(
        mi.startMinutes,
        mi.startMinutes + mi.durationMinutes,
      ));
    }

    // Step 2: 计算可用时间片
    final wakeMinutes = settings.wakeHour * 60 + settings.wakeMinute;
    final sleepMinutes = settings.sleepHour * 60 + settings.sleepMinute;

    // 合并重叠的占用时间段
    final mergedOccupied = _mergeSlots(occupiedSlots);

    // 计算空闲时间段
    final freeSlots = _subtractSlots(
      TimeSlot(wakeMinutes, sleepMinutes),
      mergedOccupied,
    );

    // Step 3: 计算总可用分钟
    final totalFree = freeSlots.fold<int>(0, (sum, slot) => sum + slot.duration);
    if (totalFree <= 0 || subjects.isEmpty) {
      return PlanGenerationResult(items: [], deferred: []);
    }

    // Step 4: 计算每个科目需要分配的时长
    final allocations = <SubjectAllocation>[];
    for (final s in subjects) {
      // 每天目标时长
      var dailyTarget = s.dailyMinutes;

      // 加上顺延的时长
      final deferredForSubject = pendingDeferred
          .where((d) => d.subjectId == s.id)
          .fold<int>(0, (sum, d) => sum + d.deferredMinutes);
      dailyTarget += deferredForSubject;

      allocations.add(SubjectAllocation(
        subject: s,
        targetMinutes: dailyTarget,
      ));
    }

    // Step 5: 按权重分配时间
    _allocateTime(allocations, totalFree);

    // Step 6: 生成时间块（番茄钟）
    final items = <PlanItemsCompanion>[];
    final studyMin = settings.studyBlockMinutes;
    final restMin = settings.restBlockMinutes;
    final cycleMin = studyMin + restMin;

    // 按优先级排序（高优先级先排）
    allocations.sort((a, b) => b.subject.priority.compareTo(a.subject.priority));

    // 过滤出有分配的科目
    final activeAllocations = allocations.where((a) => a.allocatedMinutes > 0).toList();

    int allocIndex = 0;
    int orderIndex = 0;

    for (final slot in freeSlots) {
      int pos = slot.start;

      while (pos < slot.end && allocIndex < activeAllocations.length) {
        final alloc = activeAllocations[allocIndex];
        final remaining = slot.end - pos;

        if (alloc.allocatedMinutes <= 0) {
          allocIndex++;
          continue;
        }

        if (remaining >= cycleMin) {
          // 完整番茄钟
          items.add(_makePlanItem(date, alloc.subject.id, pos, studyMin, false, orderIndex++));
          items.add(_makePlanItem(date, null, pos + studyMin, restMin, true, orderIndex++));
          pos += cycleMin;
          alloc.allocatedMinutes -= studyMin;
        } else if (remaining >= studyMin * 0.5) {
          // 压缩块
          final restTime = (restMin * 0.5).round().clamp(5, remaining ~/ 5);
          final studyTime = remaining - restTime;
          items.add(_makePlanItem(date, alloc.subject.id, pos, studyTime, false, orderIndex++));
          if (restTime > 0) {
            items.add(_makePlanItem(date, null, pos + studyTime, restTime, true, orderIndex++));
          }
          pos = slot.end;
          alloc.allocatedMinutes -= studyTime;
        } else {
          // 碎片利用
          items.add(_makePlanItem(date, alloc.subject.id, pos, remaining, false, orderIndex++));
          pos = slot.end;
          alloc.allocatedMinutes -= remaining;
        }
      }
    }

    // Step 7: 顺延处理 - 记录未分配完的科目
    final deferred = <DeferredAllocation>[];
    for (final alloc in allocations) {
      if (alloc.allocatedMinutes > 0) {
        deferred.add(DeferredAllocation(
          subjectId: alloc.subject.id,
          minutes: alloc.allocatedMinutes,
          fromDate: date,
        ));
      }
    }

    return PlanGenerationResult(items: items, deferred: deferred);
  }

  /// 按权重比例分配时间
  static void _allocateTime(List<SubjectAllocation> allocations, int totalFree) {
    if (allocations.isEmpty) return;

    // 计算权重：dailyMinutes × priority_factor
    final priorityFactors = {1: 0.8, 2: 0.9, 3: 1.0, 4: 1.1, 5: 1.2};

    double totalWeight = 0;
    for (final a in allocations) {
      final factor = priorityFactors[a.subject.priority] ?? 1.0;
      totalWeight += a.subject.dailyMinutes * factor;
    }

    if (totalWeight <= 0) return;

    // 按比例分配
    for (final a in allocations) {
      final factor = priorityFactors[a.subject.priority] ?? 1.0;
      final rawAllocation = (totalFree * a.subject.dailyMinutes * factor / totalWeight).round();
      // 不超过目标时长
      a.allocatedMinutes = rawAllocation.clamp(0, a.targetMinutes);
    }

    // 如果有剩余时间，重新分配给未满的科目
    var allocated = allocations.fold<int>(0, (sum, a) => sum + a.allocatedMinutes);
    var remaining = totalFree - allocated;

    while (remaining > 0) {
      bool gave = false;
      for (final a in allocations) {
        if (a.allocatedMinutes < a.targetMinutes && remaining > 0) {
          final give = (a.targetMinutes - a.allocatedMinutes).clamp(0, remaining);
          a.allocatedMinutes += give;
          remaining -= give;
          gave = true;
        }
      }
      if (!gave) break;
    }
  }

  /// 合并重叠的时间段
  static List<TimeSlot> _mergeSlots(List<TimeSlot> slots) {
    if (slots.isEmpty) return [];
    final sorted = List<TimeSlot>.from(slots)..sort((a, b) => a.start.compareTo(b.start));
    final merged = <TimeSlot>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final last = merged.last;
      final current = sorted[i];
      if (current.start <= last.end) {
        merged[merged.length - 1] = TimeSlot(last.start, last.end > current.end ? last.end : current.end);
      } else {
        merged.add(current);
      }
    }
    return merged;
  }

  /// 从主时间段中减去占用时间段，得到空闲时间段
  static List<TimeSlot> _subtractSlots(TimeSlot main, List<TimeSlot> occupied) {
    var result = <TimeSlot>[main];
    for (final occ in occupied) {
      final newList = <TimeSlot>[];
      for (final slot in result) {
        if (occ.end <= slot.start || occ.start >= slot.end) {
          newList.add(slot);
        } else {
          if (occ.start > slot.start) {
            newList.add(TimeSlot(slot.start, occ.start));
          }
          if (occ.end < slot.end) {
            newList.add(TimeSlot(occ.end, slot.end));
          }
        }
      }
      result = newList;
    }
    return result;
  }

  static PlanItemsCompanion _makePlanItem(
    String date,
    int? subjectId,
    int startMinutes,
    int duration,
    bool isRest,
    int orderIndex,
  ) {
    return PlanItemsCompanion.insert(
      date: date,
      subjectId: Value(subjectId),
      startMinutes: startMinutes,
      durationMinutes: duration,
      isRest: Value(isRest),
      isManual: const Value(false),
      orderIndex: orderIndex,
    );
  }
}
