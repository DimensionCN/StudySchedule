import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../main.dart';

final timetableListProvider = StreamProvider<List<TimetableEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllTimetableEvents();
});

final timetableActionsProvider = Provider((ref) => TimetableActions(ref));

class TimetableActions {
  final Ref _ref;
  TimetableActions(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<void> addEvent({
    required String courseName,
    required int dayOfWeek,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    String weekType = 'all',
    int startWeek = 1,
    int endWeek = 20,
  }) async {
    await _db.insertTimetableEvent(TimetableEventsCompanion(
      courseName: Value(courseName),
      dayOfWeek: Value(dayOfWeek),
      startHour: Value(startHour),
      startMinute: Value(startMinute),
      endHour: Value(endHour),
      endMinute: Value(endMinute),
      weekType: Value(weekType),
      startWeek: Value(startWeek),
      endWeek: Value(endWeek),
    ));
    _ref.invalidate(timetableListProvider);
  }

  Future<void> deleteEvent(int id) async {
    await _db.deleteTimetableEvent(id);
    _ref.invalidate(timetableListProvider);
  }
}
