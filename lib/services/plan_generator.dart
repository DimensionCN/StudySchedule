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
  /// 碎片时间段阈值：小于此值的空闲段视为碎片时间
  static const _fragmentedThreshold = 30; // 分钟
  /// 课表事件前后的碎片缓冲时间
  static const _classBuffer = 10; // 分钟

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
    // ===== Step 1: 收集占用段和碎片源 =====
    final occupiedSlots = <TimeSlot>[];
    final fragmentedSlots = <TimeSlot>[]; // 碎片段时间

    // 固定事件
    for (final fe in fixedEvents) {
      if (!fe.isActive) continue;
      final slot = TimeSlot(
        fe.startHour * 60 + fe.startMinute,
        fe.endHour * 60 + fe.endMinute,
      );
      occupiedSlots.add(slot);
      // 支持碎片化学习的固定事件（如吃饭），整段时间都是碎片时间
      if (fe.supportsFragmented) {
        fragmentedSlots.add(slot);
      }
    }

    // 课表事件 + 上下课前后 10 分钟碎片时间
    final todayClasses = <TimeSlot>[];
    for (final te in timetableEvents) {
      if (te.dayOfWeek != dayOfWeek) continue;
      if (currentWeek < te.startWeek || currentWeek > te.endWeek) continue;
      if (te.weekType == 'odd' && currentWeek % 2 == 0) continue;
      if (te.weekType == 'even' && currentWeek % 2 == 1) continue;

      final classStart = te.startHour * 60 + te.startMinute;
      final classEnd = te.endHour * 60 + te.endMinute;
      occupiedSlots.add(TimeSlot(classStart, classEnd));
      todayClasses.add(TimeSlot(classStart, classEnd));

      // 上课前 10 分钟 = 碎片时间
      fragmentedSlots.add(TimeSlot(
        (classStart - _classBuffer).clamp(0, classStart),
        classStart,
      ));
      // 下课后 10 分钟 = 碎片时间
      fragmentedSlots.add(TimeSlot(
        classEnd,
        (classEnd + _classBuffer).clamp(classEnd, 1440),
      ));
    }

    // 手动计划项占用
    for (final mi in existingManualItems) {
      occupiedSlots.add(TimeSlot(
        mi.startMinutes,
        mi.startMinutes + mi.durationMinutes,
      ));
    }

    // ===== Step 2: 计算所有空闲段 =====
    final wakeMinutes = settings.wakeHour * 60 + settings.wakeMinute;
    final sleepMinutes = settings.sleepHour * 60 + settings.sleepMinute;
    final mergedOccupied = _mergeSlots(occupiedSlots);
    final freeSlots = _subtractSlots(
      TimeSlot(wakeMinutes, sleepMinutes),
      mergedOccupied,
    );

    if (freeSlots.isEmpty || subjects.isEmpty) {
      return PlanGenerationResult(items: [], deferred: []);
    }

    // ===== Step 3: 将空闲段分为碎片段和大段 =====
    final smallSlots = <TimeSlot>[];  // < 30min 的小空隙
    final largeSlots = <TimeSlot>[];  // >= 30min 的大段
    for (final slot in freeSlots) {
      if (slot.duration < _fragmentedThreshold) {
        smallSlots.add(slot);
      } else {
        largeSlots.add(slot);
      }
    }

    // 碎片时间来源汇总：
    // 1. 小空隙（<30min 的空闲段）
    // 2. 上下课前后 10 分钟（但要确保在空闲范围内）
    // 3. 支持碎片化学习的固定事件时间段（但要确保在空闲范围内）
    final allFragmentedSlots = <TimeSlot>[];
    allFragmentedSlots.addAll(smallSlots);

    // 将课表缓冲时间和支持碎片的固定事件，裁剪到空闲段内
    for (final frag in fragmentedSlots) {
      for (final free in freeSlots) {
        final overlap = _intersect(frag, free);
        if (overlap != null && overlap.duration > 0) {
          allFragmentedSlots.add(overlap);
        }
      }
    }

    // 合并并去重碎片段
    final mergedFragmented = _mergeSlots(allFragmentedSlots);
    final fragmentedTotal = mergedFragmented.fold<int>(0, (s, slot) => s + slot.duration);
    final largeTotal = largeSlots.fold<int>(0, (s, slot) => s + slot.duration);

    // ===== Step 4: 分离碎片科目和普通科目 =====
    final fragmentedSubjects = <SubjectAllocation>[];
    final normalSubjects = <SubjectAllocation>[];
    for (final s in subjects) {
      var dailyTarget = s.dailyMinutes;
      final deferredForSubject = pendingDeferred
          .where((d) => d.subjectId == s.id)
          .fold<int>(0, (sum, d) => sum + d.deferredMinutes);
      dailyTarget += deferredForSubject;

      final alloc = SubjectAllocation(subject: s, targetMinutes: dailyTarget);
      if (s.isFragmented) {
        fragmentedSubjects.add(alloc);
      } else {
        normalSubjects.add(alloc);
      }
    }

    // ===== Step 5: 分配时间 =====
    // 碎片科目 → 只用碎片段时间
    if (fragmentedSubjects.isNotEmpty && fragmentedTotal > 0) {
      _allocateTime(fragmentedSubjects, fragmentedTotal);
    }
    // 普通科目 → 只用大段时间
    if (normalSubjects.isNotEmpty && largeTotal > 0) {
      _allocateTime(normalSubjects, largeTotal);
    }

    // ===== Step 6: 生成时间块 =====
    final items = <PlanItemsCompanion>[];
    int orderIndex = 0;

    // 6a: 碎片科目 → 填入碎片段（连续学习，不插休息）
    if (fragmentedSubjects.isNotEmpty) {
      final activeFrag = fragmentedSubjects
          .where((a) => a.allocatedMinutes > 0)
          .toList()
        ..sort((a, b) => b.subject.priority.compareTo(a.subject.priority));

      int fragIdx = 0;
      for (final slot in mergedFragmented) {
        int pos = slot.start;
        while (pos < slot.end && fragIdx < activeFrag.length) {
          final alloc = activeFrag[fragIdx];
          if (alloc.allocatedMinutes <= 0) { fragIdx++; continue; }
          final use = (slot.end - pos).clamp(0, alloc.allocatedMinutes);
          items.add(_makePlanItem(date, alloc.subject.id, pos, use, false, orderIndex++));
          pos += use;
          alloc.allocatedMinutes -= use;
        }
      }
    }

    // 6b: 普通科目 → 填入大段
    if (normalSubjects.isNotEmpty) {
      final studyMin = settings.studyBlockMinutes;
      final restMin = settings.restBlockMinutes;
      final cycleMin = studyMin + restMin;

      final activeNormal = normalSubjects
          .where((a) => a.allocatedMinutes > 0)
          .toList()
        ..sort((a, b) => b.subject.priority.compareTo(a.subject.priority));

      int normIdx = 0;
      for (final slot in largeSlots) {
        int pos = slot.start;
        while (pos < slot.end && normIdx < activeNormal.length) {
          final alloc = activeNormal[normIdx];
          final remaining = slot.end - pos;

          if (alloc.allocatedMinutes <= 0) {
            normIdx++;
            continue;
          }

          if (alloc.subject.usesPomodoro) {
            // 番茄钟模式：学习 + 休息循环
            if (remaining >= cycleMin) {
              items.add(_makePlanItem(date, alloc.subject.id, pos, studyMin, false, orderIndex++));
              items.add(_makePlanItem(date, null, pos + studyMin, restMin, true, orderIndex++));
              pos += cycleMin;
              alloc.allocatedMinutes -= studyMin;
            } else if (remaining >= studyMin * 0.5) {
              final restTime = (restMin * 0.5).round().clamp(5, remaining ~/ 5);
              final studyTime = remaining - restTime;
              items.add(_makePlanItem(date, alloc.subject.id, pos, studyTime, false, orderIndex++));
              if (restTime > 0) {
                items.add(_makePlanItem(date, null, pos + studyTime, restTime, true, orderIndex++));
              }
              pos = slot.end;
              alloc.allocatedMinutes -= studyTime;
            } else {
              items.add(_makePlanItem(date, alloc.subject.id, pos, remaining, false, orderIndex++));
              pos = slot.end;
              alloc.allocatedMinutes -= remaining;
            }
          } else {
            // 连续学习模式：不插休息，整段填入
            final use = remaining.clamp(0, alloc.allocatedMinutes);
            items.add(_makePlanItem(date, alloc.subject.id, pos, use, false, orderIndex++));
            pos += use;
            alloc.allocatedMinutes -= use;
          }
        }
      }
    }

    // ===== Step 7: 顺延处理 =====
    final allAllocations = [...fragmentedSubjects, ...normalSubjects];
    final deferred = <DeferredAllocation>[];
    for (final alloc in allAllocations) {
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

  /// 计算两个时间段的交集
  static TimeSlot? _intersect(TimeSlot a, TimeSlot b) {
    final start = a.start > b.start ? a.start : b.start;
    final end = a.end < b.end ? a.end : b.end;
    if (start >= end) return null;
    return TimeSlot(start, end);
  }

  /// 按权重比例分配时间
  static void _allocateTime(List<SubjectAllocation> allocations, int totalFree) {
    if (allocations.isEmpty) return;

    final priorityFactors = {1: 0.8, 2: 0.9, 3: 1.0, 4: 1.1, 5: 1.2};

    double totalWeight = 0;
    for (final a in allocations) {
      final factor = priorityFactors[a.subject.priority] ?? 1.0;
      totalWeight += a.subject.dailyMinutes * factor;
    }

    if (totalWeight <= 0) return;

    for (final a in allocations) {
      final factor = priorityFactors[a.subject.priority] ?? 1.0;
      final rawAllocation = (totalFree * a.subject.dailyMinutes * factor / totalWeight).round();
      a.allocatedMinutes = rawAllocation.clamp(0, a.targetMinutes);
    }

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
      customName: const Value(null),
      startMinutes: startMinutes,
      durationMinutes: duration,
      isRest: Value(isRest),
      isManual: const Value(false),
      orderIndex: orderIndex,
    );
  }
}
