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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'schedule.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
