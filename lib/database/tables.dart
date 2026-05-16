import 'package:drift/drift.dart';

// 科目表
class Subjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get dailyMinutes => integer()();
  IntColumn get priority => integer().withDefault(const Constant(3))();
  IntColumn get color => integer().withDefault(const Constant(0xFF2196F3))();
  BoolColumn get isFragmented => boolean().withDefault(const Constant(false))();
  BoolColumn get usesPomodoro => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 固定事件表（吃饭/睡觉/运动）
class FixedEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get startHour => integer()();
  IntColumn get startMinute => integer()();
  IntColumn get endHour => integer()();
  IntColumn get endMinute => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get supportsFragmented => boolean().withDefault(const Constant(false))();
}

// 课表事件表
class TimetableEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get courseName => text().withLength(min: 1, max: 100)();
  IntColumn get dayOfWeek => integer()(); // 1=周一, 7=周日
  IntColumn get startHour => integer()();
  IntColumn get startMinute => integer()();
  IntColumn get endHour => integer()();
  IntColumn get endMinute => integer()();
  TextColumn get weekType => text().withDefault(const Constant('all'))(); // all/odd/even
  IntColumn get startWeek => integer().withDefault(const Constant(1))();
  IntColumn get endWeek => integer().withDefault(const Constant(20))();
}

// 生成的计划项
class PlanItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()(); // yyyy-MM-dd
  IntColumn get subjectId => integer().nullable()();
  TextColumn get customName => text().nullable()(); // 自定义活动名称（如"休闲娱乐"）
  IntColumn get startMinutes => integer()(); // 从00:00起的分钟偏移
  IntColumn get durationMinutes => integer()();
  BoolColumn get isRest => boolean().withDefault(const Constant(false))();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer()();
}

// 顺延记录表
class DeferredRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subjectId => integer()();
  IntColumn get deferredMinutes => integer()();
  TextColumn get fromDate => text()(); // 被顺延的日期
  TextColumn get weekStart => text()(); // 本周一日期
}

// 用户设置表（单行）
class UserSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wakeHour => integer().withDefault(const Constant(7))();
  IntColumn get wakeMinute => integer().withDefault(const Constant(0))();
  IntColumn get sleepHour => integer().withDefault(const Constant(23))();
  IntColumn get sleepMinute => integer().withDefault(const Constant(30))();
  IntColumn get studyBlockMinutes => integer().withDefault(const Constant(50))();
  IntColumn get restBlockMinutes => integer().withDefault(const Constant(10))();
  DateTimeColumn get semesterStartDate => dateTime().nullable()();
}

// 每周/每月目标表
class UserGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'weekly' or 'monthly'
  TextColumn get targetDate => text()(); // 周: yyyy-MM-dd (周一), 月: yyyy-MM
  IntColumn get studyMinutes => integer()(); // 目标学习分钟数
}
