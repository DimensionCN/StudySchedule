import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../main.dart';

final settingsProvider = FutureProvider<UserSettingsTableData>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getSettings();
});

final settingsActionsProvider = Provider((ref) => SettingsActions(ref));

class SettingsActions {
  final Ref _ref;
  SettingsActions(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<void> updateSettings({
    int? wakeHour,
    int? wakeMinute,
    int? sleepHour,
    int? sleepMinute,
    int? studyBlockMinutes,
    int? restBlockMinutes,
    DateTime? semesterStartDate,
  }) async {
    await _db.updateSettings(UserSettingsTableCompanion(
      wakeHour: wakeHour != null ? Value(wakeHour) : const Value.absent(),
      wakeMinute: wakeMinute != null ? Value(wakeMinute) : const Value.absent(),
      sleepHour: sleepHour != null ? Value(sleepHour) : const Value.absent(),
      sleepMinute: sleepMinute != null ? Value(sleepMinute) : const Value.absent(),
      studyBlockMinutes: studyBlockMinutes != null ? Value(studyBlockMinutes) : const Value.absent(),
      restBlockMinutes: restBlockMinutes != null ? Value(restBlockMinutes) : const Value.absent(),
      semesterStartDate: Value(semesterStartDate),
    ));
    _ref.invalidate(settingsProvider);
  }
}
