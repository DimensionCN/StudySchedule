import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Subjects,
  FixedEvents,
  TimetableEvents,
  PlanItems,
  DeferredRecords,
  UserSettingsTable,
  UserGoals,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.deleteTable('subjects');
            await m.createTable(subjects);
          }
          if (from < 3) {
            await m.deleteTable('fixed_events');
            await m.createTable(fixedEvents);
          }
          if (from < 4) {
            await m.deleteTable('subjects');
            await m.createTable(subjects);
          }
          if (from < 5) {
            await m.addColumn(planItems, planItems.customName);
          }
          if (from < 6) {
            await m.addColumn(planItems, planItems.isCompleted);
            await m.createTable(userGoals);
          }
        },
      );

  // ========== Subject CRUD ==========
  Future<List<Subject>> getAllSubjects() => select(subjects).get();
  Stream<List<Subject>> watchAllSubjects() => select(subjects).watch();
  Future<int> insertSubject(SubjectsCompanion entry) => into(subjects).insert(entry);
  Future<bool> updateSubject(SubjectsCompanion entry) => update(subjects).replace(entry);
  Future<int> deleteSubject(int id) => (delete(subjects)..where((t) => t.id.equals(id))).go();

  // ========== FixedEvent CRUD ==========
  Future<List<FixedEvent>> getAllFixedEvents() => select(fixedEvents).get();
  Stream<List<FixedEvent>> watchAllFixedEvents() => select(fixedEvents).watch();
  Future<int> insertFixedEvent(FixedEventsCompanion entry) => into(fixedEvents).insert(entry);
  Future<bool> updateFixedEvent(FixedEventsCompanion entry) => update(fixedEvents).replace(entry);
  Future<int> deleteFixedEvent(int id) => (delete(fixedEvents)..where((t) => t.id.equals(id))).go();

  // ========== TimetableEvent CRUD ==========
  Future<List<TimetableEvent>> getAllTimetableEvents() => select(timetableEvents).get();
  Stream<List<TimetableEvent>> watchAllTimetableEvents() => select(timetableEvents).watch();
  Future<int> insertTimetableEvent(TimetableEventsCompanion entry) => into(timetableEvents).insert(entry);
  Future<bool> updateTimetableEvent(TimetableEventsCompanion entry) => update(timetableEvents).replace(entry);
  Future<int> deleteTimetableEvent(int id) => (delete(timetableEvents)..where((t) => t.id.equals(id))).go();

  // ========== PlanItem CRUD ==========
  Future<List<PlanItem>> getPlanItemsByDate(String date) =>
      (select(planItems)..where((t) => t.date.equals(date))..orderBy([(t) => OrderingTerm.asc(t.orderIndex)])).get();
  Stream<List<PlanItem>> watchPlanItemsByDate(String date) =>
      (select(planItems)..where((t) => t.date.equals(date))..orderBy([(t) => OrderingTerm.asc(t.orderIndex)])).watch();
  Future<int> insertPlanItem(PlanItemsCompanion entry) => into(planItems).insert(entry);
  Future<bool> updatePlanItem(PlanItemsCompanion entry) => update(planItems).replace(entry);
  Future<int> deletePlanItem(int id) => (delete(planItems)..where((t) => t.id.equals(id))).go();
  Future<int> deleteAutoPlanItemsByDate(String date) =>
      (delete(planItems)..where((t) => t.date.equals(date) & t.isManual.equals(false))).go();

  // ========== DeferredRecord CRUD ==========
  Future<List<DeferredRecord>> getDeferredRecordsByWeek(String weekStart) =>
      (select(deferredRecords)..where((t) => t.weekStart.equals(weekStart))).get();
  Future<int> insertDeferredRecord(DeferredRecordsCompanion entry) => into(deferredRecords).insert(entry);
  Future<int> deleteDeferredRecord(int id) => (delete(deferredRecords)..where((t) => t.id.equals(id))).go();

  // ========== UserSettings ==========
  Future<UserSettingsTableData> getSettings() async {
    final results = await select(userSettingsTable).get();
    if (results.isEmpty) {
      await into(userSettingsTable).insert(const UserSettingsTableCompanion());
      return (await select(userSettingsTable).get()).first;
    }
    return results.first;
  }

  Future<int> updateSettings(UserSettingsTableCompanion entry) async {
    final settings = await getSettings();
    return (update(userSettingsTable)..where((t) => t.id.equals(settings.id))).write(entry);
  }

  // ========== UserGoals ==========
  Future<UserGoal?> getGoal(String type, String targetDate) async {
    final results = await (select(userGoals)
      ..where((t) => t.type.equals(type) & t.targetDate.equals(targetDate))).get();
    return results.isEmpty ? null : results.first;
  }

  Future<int> insertOrUpdateGoal(UserGoalsCompanion entry) async {
    final existing = await getGoal(entry.type.value, entry.targetDate.value);
    if (existing != null) {
      return (update(userGoals)..where((t) => t.id.equals(existing.id))).write(entry);
    }
    return into(userGoals).insert(entry);
  }

  // ========== PlanItem helpers ==========
  Future<void> togglePlanItemCompleted(int id, bool isCompleted) async {
    await (update(planItems)..where((t) => t.id.equals(id))).write(
      PlanItemsCompanion(isCompleted: Value(isCompleted)),
    );
  }

  /// 查询日期范围内按科目分组的已完成学习分钟数
  Future<Map<int, int>> getCompletedMinutesBySubject(String fromDate, String toDate) async {
    final results = await (select(planItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(fromDate) &
          t.date.isSmallerOrEqualValue(toDate) &
          t.isCompleted.equals(true) &
          t.subjectId.isNotNull() &
          t.isRest.equals(false)))
      .get();
    final map = <int, int>{};
    for (final item in results) {
      map[item.subjectId!] = (map[item.subjectId] ?? 0) + item.durationMinutes;
    }
    return map;
  }

  /// 查询日期范围内总已完成分钟数
  Future<int> getCompletedMinutes(String fromDate, String toDate) async {
    final query = selectOnly(planItems)
      ..addColumns([planItems.durationMinutes.sum()])
      ..where(planItems.date.isBiggerOrEqualValue(fromDate) &
          planItems.date.isSmallerOrEqualValue(toDate) &
          planItems.isCompleted.equals(true) &
          planItems.subjectId.isNotNull() &
          planItems.isRest.equals(false));
    final result = await query.getSingle();
    return result.read(planItems.durationMinutes.sum()) ?? 0;
  }

  /// 清理超过指定天数的延迟记录
  Future<int> cleanOldDeferredRecords(int daysToKeep) async {
    final cutoff = DateTime.now().subtract(Duration(days: daysToKeep));
    final cutoffStr = '${cutoff.year.toString().padLeft(4, '0')}-${cutoff.month.toString().padLeft(2, '0')}-${cutoff.day.toString().padLeft(2, '0')}';
    return (delete(deferredRecords)..where((t) => t.fromDate.isSmallerThanValue(cutoffStr))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'schedule.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
