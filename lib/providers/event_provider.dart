import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../main.dart';

final fixedEventListProvider = StreamProvider<List<FixedEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllFixedEvents();
});

final fixedEventActionsProvider = Provider((ref) => FixedEventActions(ref));

class FixedEventActions {
  final Ref _ref;
  FixedEventActions(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<void> addEvent({
    required String name,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    bool supportsFragmented = false,
  }) async {
    await _db.insertFixedEvent(FixedEventsCompanion(
      name: Value(name),
      startHour: Value(startHour),
      startMinute: Value(startMinute),
      endHour: Value(endHour),
      endMinute: Value(endMinute),
      supportsFragmented: Value(supportsFragmented),
    ));
    _ref.invalidate(fixedEventListProvider);
  }

  Future<void> toggleEvent(int id, bool isActive) async {
    await _db.updateFixedEvent(FixedEventsCompanion(
      id: Value(id),
      isActive: Value(isActive),
    ));
    _ref.invalidate(fixedEventListProvider);
  }

  Future<void> deleteEvent(int id) async {
    await _db.deleteFixedEvent(id);
    _ref.invalidate(fixedEventListProvider);
  }
}
