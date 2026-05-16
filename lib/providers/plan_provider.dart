import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../main.dart';
import '../services/plan_generator.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final planItemsProvider = StreamProvider.autoDispose<List<PlanItem>>((ref) {
  final db = ref.watch(databaseProvider);
  final date = ref.watch(selectedDateProvider);
  final dateStr = DateFormat('yyyy-MM-dd').format(date);
  return db.watchPlanItemsByDate(dateStr);
});

final generatePlanProvider = FutureProvider.autoDispose<void>((ref) async {
  final db = ref.read(databaseProvider);
  final date = ref.read(selectedDateProvider);
  final dateStr = DateFormat('yyyy-MM-dd').format(date);
  final dayOfWeek = date.weekday;

  // 计算当前周次（简化：从学期开始日期推算）
  final settings = await db.getSettings();
  int currentWeek = 1;
  if (settings.semesterStartDate != null) {
    currentWeek = date.difference(settings.semesterStartDate!).inDays ~/ 7 + 1;
    if (currentWeek < 1) currentWeek = 1;
  }

  // 获取数据
  final subjects = await db.getAllSubjects();
  final fixedEvents = await db.getAllFixedEvents();
  final timetableEvents = await db.getAllTimetableEvents();

  // 获取本周一日期
  final weekStart = date.subtract(Duration(days: dayOfWeek - 1));
  final weekStartStr = DateFormat('yyyy-MM-dd').format(weekStart);
  final pendingDeferred = await db.getDeferredRecordsByWeek(weekStartStr);

  // 获取已有的手动计划项
  final existingItems = await db.getPlanItemsByDate(dateStr);
  final manualItems = existingItems.where((i) => i.isManual).toList();

  // 生成计划
  final result = PlanGenerator.generate(
    date: dateStr,
    dayOfWeek: dayOfWeek,
    currentWeek: currentWeek,
    subjects: subjects,
    fixedEvents: fixedEvents,
    timetableEvents: timetableEvents,
    settings: settings,
    pendingDeferred: pendingDeferred,
    existingManualItems: manualItems,
  );

  // 删除旧的自动生成的计划项
  await db.deleteAutoPlanItemsByDate(dateStr);

  // 插入新的计划项
  for (final item in result.items) {
    await db.insertPlanItem(item);
  }

  // 记录顺延
  for (final d in result.deferred) {
    await db.insertDeferredRecord(DeferredRecordsCompanion(
      subjectId: Value(d.subjectId),
      deferredMinutes: Value(d.minutes),
      fromDate: Value(d.fromDate),
      weekStart: Value(weekStartStr),
    ));
  }

  ref.invalidate(planItemsProvider);
});
