import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../main.dart';

final subjectListProvider = StreamProvider<List<Subject>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllSubjects();
});

final subjectActionsProvider = Provider((ref) => SubjectActions(ref));

class SubjectActions {
  final Ref _ref;
  SubjectActions(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<void> addSubject({
    required String name,
    required int dailyMinutes,
    required int priority,
    required int color,
    bool isFragmented = false,
    bool usesPomodoro = true,
  }) async {
    await _db.insertSubject(SubjectsCompanion(
      name: Value(name),
      dailyMinutes: Value(dailyMinutes),
      priority: Value(priority),
      color: Value(color),
      isFragmented: Value(isFragmented),
      usesPomodoro: Value(usesPomodoro),
    ));
    _ref.invalidate(subjectListProvider);
  }

  Future<void> updateSubject({
    required int id,
    required String name,
    required int dailyMinutes,
    required int priority,
    required int color,
    bool isFragmented = false,
    bool usesPomodoro = true,
  }) async {
    await _db.updateSubject(SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      dailyMinutes: Value(dailyMinutes),
      priority: Value(priority),
      color: Value(color),
      isFragmented: Value(isFragmented),
      usesPomodoro: Value(usesPomodoro),
    ));
    _ref.invalidate(subjectListProvider);
  }

  Future<void> deleteSubject(int id) async {
    await _db.deleteSubject(id);
    _ref.invalidate(subjectListProvider);
  }
}
