// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyMinutesMeta = const VerificationMeta(
    'dailyMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyMinutes = GeneratedColumn<int>(
    'daily_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF2196F3),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dailyMinutes,
    priority,
    color,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('daily_minutes')) {
      context.handle(
        _dailyMinutesMeta,
        dailyMinutes.isAcceptableOrUnknown(
          data['daily_minutes']!,
          _dailyMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyMinutesMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      dailyMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}daily_minutes'],
          )!,
      priority:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}priority'],
          )!,
      color:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}color'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String name;
  final int dailyMinutes;
  final int priority;
  final int color;
  final DateTime createdAt;
  const Subject({
    required this.id,
    required this.name,
    required this.dailyMinutes,
    required this.priority,
    required this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['daily_minutes'] = Variable<int>(dailyMinutes);
    map['priority'] = Variable<int>(priority);
    map['color'] = Variable<int>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      dailyMinutes: Value(dailyMinutes),
      priority: Value(priority),
      color: Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dailyMinutes: serializer.fromJson<int>(json['dailyMinutes']),
      priority: serializer.fromJson<int>(json['priority']),
      color: serializer.fromJson<int>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dailyMinutes': serializer.toJson<int>(dailyMinutes),
      'priority': serializer.toJson<int>(priority),
      'color': serializer.toJson<int>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Subject copyWith({
    int? id,
    String? name,
    int? dailyMinutes,
    int? priority,
    int? color,
    DateTime? createdAt,
  }) => Subject(
    id: id ?? this.id,
    name: name ?? this.name,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    priority: priority ?? this.priority,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dailyMinutes:
          data.dailyMinutes.present
              ? data.dailyMinutes.value
              : this.dailyMinutes,
      priority: data.priority.present ? data.priority.value : this.priority,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, dailyMinutes, priority, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.dailyMinutes == this.dailyMinutes &&
          other.priority == this.priority &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> dailyMinutes;
  final Value<int> priority;
  final Value<int> color;
  final Value<DateTime> createdAt;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dailyMinutes = const Value.absent(),
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int dailyMinutes,
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       dailyMinutes = Value(dailyMinutes);
  static Insertable<Subject> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? dailyMinutes,
    Expression<int>? priority,
    Expression<int>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dailyMinutes != null) 'daily_minutes': dailyMinutes,
      if (priority != null) 'priority': priority,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SubjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? dailyMinutes,
    Value<int>? priority,
    Value<int>? color,
    Value<DateTime>? createdAt,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dailyMinutes.present) {
      map['daily_minutes'] = Variable<int>(dailyMinutes.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FixedEventsTable extends FixedEvents
    with TableInfo<$FixedEventsTable, FixedEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FixedEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startHourMeta = const VerificationMeta(
    'startHour',
  );
  @override
  late final GeneratedColumn<int> startHour = GeneratedColumn<int>(
    'start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endHourMeta = const VerificationMeta(
    'endHour',
  );
  @override
  late final GeneratedColumn<int> endHour = GeneratedColumn<int>(
    'end_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startHour,
    startMinute,
    endHour,
    endMinute,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fixed_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<FixedEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_hour')) {
      context.handle(
        _startHourMeta,
        startHour.isAcceptableOrUnknown(data['start_hour']!, _startHourMeta),
      );
    } else if (isInserting) {
      context.missing(_startHourMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_hour')) {
      context.handle(
        _endHourMeta,
        endHour.isAcceptableOrUnknown(data['end_hour']!, _endHourMeta),
      );
    } else if (isInserting) {
      context.missing(_endHourMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FixedEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FixedEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      startHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_hour'],
          )!,
      startMinute:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_minute'],
          )!,
      endHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}end_hour'],
          )!,
      endMinute:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}end_minute'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $FixedEventsTable createAlias(String alias) {
    return $FixedEventsTable(attachedDatabase, alias);
  }
}

class FixedEvent extends DataClass implements Insertable<FixedEvent> {
  final int id;
  final String name;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final bool isActive;
  const FixedEvent({
    required this.id,
    required this.name,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_hour'] = Variable<int>(startHour);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_hour'] = Variable<int>(endHour);
    map['end_minute'] = Variable<int>(endMinute);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  FixedEventsCompanion toCompanion(bool nullToAbsent) {
    return FixedEventsCompanion(
      id: Value(id),
      name: Value(name),
      startHour: Value(startHour),
      startMinute: Value(startMinute),
      endHour: Value(endHour),
      endMinute: Value(endMinute),
      isActive: Value(isActive),
    );
  }

  factory FixedEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FixedEvent(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startHour: serializer.fromJson<int>(json['startHour']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endHour: serializer.fromJson<int>(json['endHour']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startHour': serializer.toJson<int>(startHour),
      'startMinute': serializer.toJson<int>(startMinute),
      'endHour': serializer.toJson<int>(endHour),
      'endMinute': serializer.toJson<int>(endMinute),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  FixedEvent copyWith({
    int? id,
    String? name,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    bool? isActive,
  }) => FixedEvent(
    id: id ?? this.id,
    name: name ?? this.name,
    startHour: startHour ?? this.startHour,
    startMinute: startMinute ?? this.startMinute,
    endHour: endHour ?? this.endHour,
    endMinute: endMinute ?? this.endMinute,
    isActive: isActive ?? this.isActive,
  );
  FixedEvent copyWithCompanion(FixedEventsCompanion data) {
    return FixedEvent(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startHour: data.startHour.present ? data.startHour.value : this.startHour,
      startMinute:
          data.startMinute.present ? data.startMinute.value : this.startMinute,
      endHour: data.endHour.present ? data.endHour.value : this.endHour,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FixedEvent(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startHour,
    startMinute,
    endHour,
    endMinute,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FixedEvent &&
          other.id == this.id &&
          other.name == this.name &&
          other.startHour == this.startHour &&
          other.startMinute == this.startMinute &&
          other.endHour == this.endHour &&
          other.endMinute == this.endMinute &&
          other.isActive == this.isActive);
}

class FixedEventsCompanion extends UpdateCompanion<FixedEvent> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> startHour;
  final Value<int> startMinute;
  final Value<int> endHour;
  final Value<int> endMinute;
  final Value<bool> isActive;
  const FixedEventsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endHour = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  FixedEventsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       startHour = Value(startHour),
       startMinute = Value(startMinute),
       endHour = Value(endHour),
       endMinute = Value(endMinute);
  static Insertable<FixedEvent> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? startHour,
    Expression<int>? startMinute,
    Expression<int>? endHour,
    Expression<int>? endMinute,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startHour != null) 'start_hour': startHour,
      if (startMinute != null) 'start_minute': startMinute,
      if (endHour != null) 'end_hour': endHour,
      if (endMinute != null) 'end_minute': endMinute,
      if (isActive != null) 'is_active': isActive,
    });
  }

  FixedEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? startHour,
    Value<int>? startMinute,
    Value<int>? endHour,
    Value<int>? endMinute,
    Value<bool>? isActive,
  }) {
    return FixedEventsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startHour.present) {
      map['start_hour'] = Variable<int>(startHour.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endHour.present) {
      map['end_hour'] = Variable<int>(endHour.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FixedEventsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TimetableEventsTable extends TimetableEvents
    with TableInfo<$TimetableEventsTable, TimetableEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetableEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _courseNameMeta = const VerificationMeta(
    'courseName',
  );
  @override
  late final GeneratedColumn<String> courseName = GeneratedColumn<String>(
    'course_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startHourMeta = const VerificationMeta(
    'startHour',
  );
  @override
  late final GeneratedColumn<int> startHour = GeneratedColumn<int>(
    'start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endHourMeta = const VerificationMeta(
    'endHour',
  );
  @override
  late final GeneratedColumn<int> endHour = GeneratedColumn<int>(
    'end_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekTypeMeta = const VerificationMeta(
    'weekType',
  );
  @override
  late final GeneratedColumn<String> weekType = GeneratedColumn<String>(
    'week_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('all'),
  );
  static const VerificationMeta _startWeekMeta = const VerificationMeta(
    'startWeek',
  );
  @override
  late final GeneratedColumn<int> startWeek = GeneratedColumn<int>(
    'start_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _endWeekMeta = const VerificationMeta(
    'endWeek',
  );
  @override
  late final GeneratedColumn<int> endWeek = GeneratedColumn<int>(
    'end_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseName,
    dayOfWeek,
    startHour,
    startMinute,
    endHour,
    endMinute,
    weekType,
    startWeek,
    endWeek,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetable_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('course_name')) {
      context.handle(
        _courseNameMeta,
        courseName.isAcceptableOrUnknown(data['course_name']!, _courseNameMeta),
      );
    } else if (isInserting) {
      context.missing(_courseNameMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_hour')) {
      context.handle(
        _startHourMeta,
        startHour.isAcceptableOrUnknown(data['start_hour']!, _startHourMeta),
      );
    } else if (isInserting) {
      context.missing(_startHourMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_hour')) {
      context.handle(
        _endHourMeta,
        endHour.isAcceptableOrUnknown(data['end_hour']!, _endHourMeta),
      );
    } else if (isInserting) {
      context.missing(_endHourMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    if (data.containsKey('week_type')) {
      context.handle(
        _weekTypeMeta,
        weekType.isAcceptableOrUnknown(data['week_type']!, _weekTypeMeta),
      );
    }
    if (data.containsKey('start_week')) {
      context.handle(
        _startWeekMeta,
        startWeek.isAcceptableOrUnknown(data['start_week']!, _startWeekMeta),
      );
    }
    if (data.containsKey('end_week')) {
      context.handle(
        _endWeekMeta,
        endWeek.isAcceptableOrUnknown(data['end_week']!, _endWeekMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      courseName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}course_name'],
          )!,
      dayOfWeek:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}day_of_week'],
          )!,
      startHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_hour'],
          )!,
      startMinute:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_minute'],
          )!,
      endHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}end_hour'],
          )!,
      endMinute:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}end_minute'],
          )!,
      weekType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}week_type'],
          )!,
      startWeek:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_week'],
          )!,
      endWeek:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}end_week'],
          )!,
    );
  }

  @override
  $TimetableEventsTable createAlias(String alias) {
    return $TimetableEventsTable(attachedDatabase, alias);
  }
}

class TimetableEvent extends DataClass implements Insertable<TimetableEvent> {
  final int id;
  final String courseName;
  final int dayOfWeek;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String weekType;
  final int startWeek;
  final int endWeek;
  const TimetableEvent({
    required this.id,
    required this.courseName,
    required this.dayOfWeek,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.weekType,
    required this.startWeek,
    required this.endWeek,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['course_name'] = Variable<String>(courseName);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['start_hour'] = Variable<int>(startHour);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_hour'] = Variable<int>(endHour);
    map['end_minute'] = Variable<int>(endMinute);
    map['week_type'] = Variable<String>(weekType);
    map['start_week'] = Variable<int>(startWeek);
    map['end_week'] = Variable<int>(endWeek);
    return map;
  }

  TimetableEventsCompanion toCompanion(bool nullToAbsent) {
    return TimetableEventsCompanion(
      id: Value(id),
      courseName: Value(courseName),
      dayOfWeek: Value(dayOfWeek),
      startHour: Value(startHour),
      startMinute: Value(startMinute),
      endHour: Value(endHour),
      endMinute: Value(endMinute),
      weekType: Value(weekType),
      startWeek: Value(startWeek),
      endWeek: Value(endWeek),
    );
  }

  factory TimetableEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableEvent(
      id: serializer.fromJson<int>(json['id']),
      courseName: serializer.fromJson<String>(json['courseName']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      startHour: serializer.fromJson<int>(json['startHour']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endHour: serializer.fromJson<int>(json['endHour']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      weekType: serializer.fromJson<String>(json['weekType']),
      startWeek: serializer.fromJson<int>(json['startWeek']),
      endWeek: serializer.fromJson<int>(json['endWeek']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseName': serializer.toJson<String>(courseName),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'startHour': serializer.toJson<int>(startHour),
      'startMinute': serializer.toJson<int>(startMinute),
      'endHour': serializer.toJson<int>(endHour),
      'endMinute': serializer.toJson<int>(endMinute),
      'weekType': serializer.toJson<String>(weekType),
      'startWeek': serializer.toJson<int>(startWeek),
      'endWeek': serializer.toJson<int>(endWeek),
    };
  }

  TimetableEvent copyWith({
    int? id,
    String? courseName,
    int? dayOfWeek,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    String? weekType,
    int? startWeek,
    int? endWeek,
  }) => TimetableEvent(
    id: id ?? this.id,
    courseName: courseName ?? this.courseName,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    startHour: startHour ?? this.startHour,
    startMinute: startMinute ?? this.startMinute,
    endHour: endHour ?? this.endHour,
    endMinute: endMinute ?? this.endMinute,
    weekType: weekType ?? this.weekType,
    startWeek: startWeek ?? this.startWeek,
    endWeek: endWeek ?? this.endWeek,
  );
  TimetableEvent copyWithCompanion(TimetableEventsCompanion data) {
    return TimetableEvent(
      id: data.id.present ? data.id.value : this.id,
      courseName:
          data.courseName.present ? data.courseName.value : this.courseName,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startHour: data.startHour.present ? data.startHour.value : this.startHour,
      startMinute:
          data.startMinute.present ? data.startMinute.value : this.startMinute,
      endHour: data.endHour.present ? data.endHour.value : this.endHour,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      weekType: data.weekType.present ? data.weekType.value : this.weekType,
      startWeek: data.startWeek.present ? data.startWeek.value : this.startWeek,
      endWeek: data.endWeek.present ? data.endWeek.value : this.endWeek,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableEvent(')
          ..write('id: $id, ')
          ..write('courseName: $courseName, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute, ')
          ..write('weekType: $weekType, ')
          ..write('startWeek: $startWeek, ')
          ..write('endWeek: $endWeek')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseName,
    dayOfWeek,
    startHour,
    startMinute,
    endHour,
    endMinute,
    weekType,
    startWeek,
    endWeek,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableEvent &&
          other.id == this.id &&
          other.courseName == this.courseName &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startHour == this.startHour &&
          other.startMinute == this.startMinute &&
          other.endHour == this.endHour &&
          other.endMinute == this.endMinute &&
          other.weekType == this.weekType &&
          other.startWeek == this.startWeek &&
          other.endWeek == this.endWeek);
}

class TimetableEventsCompanion extends UpdateCompanion<TimetableEvent> {
  final Value<int> id;
  final Value<String> courseName;
  final Value<int> dayOfWeek;
  final Value<int> startHour;
  final Value<int> startMinute;
  final Value<int> endHour;
  final Value<int> endMinute;
  final Value<String> weekType;
  final Value<int> startWeek;
  final Value<int> endWeek;
  const TimetableEventsCompanion({
    this.id = const Value.absent(),
    this.courseName = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endHour = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.weekType = const Value.absent(),
    this.startWeek = const Value.absent(),
    this.endWeek = const Value.absent(),
  });
  TimetableEventsCompanion.insert({
    this.id = const Value.absent(),
    required String courseName,
    required int dayOfWeek,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    this.weekType = const Value.absent(),
    this.startWeek = const Value.absent(),
    this.endWeek = const Value.absent(),
  }) : courseName = Value(courseName),
       dayOfWeek = Value(dayOfWeek),
       startHour = Value(startHour),
       startMinute = Value(startMinute),
       endHour = Value(endHour),
       endMinute = Value(endMinute);
  static Insertable<TimetableEvent> custom({
    Expression<int>? id,
    Expression<String>? courseName,
    Expression<int>? dayOfWeek,
    Expression<int>? startHour,
    Expression<int>? startMinute,
    Expression<int>? endHour,
    Expression<int>? endMinute,
    Expression<String>? weekType,
    Expression<int>? startWeek,
    Expression<int>? endWeek,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseName != null) 'course_name': courseName,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startHour != null) 'start_hour': startHour,
      if (startMinute != null) 'start_minute': startMinute,
      if (endHour != null) 'end_hour': endHour,
      if (endMinute != null) 'end_minute': endMinute,
      if (weekType != null) 'week_type': weekType,
      if (startWeek != null) 'start_week': startWeek,
      if (endWeek != null) 'end_week': endWeek,
    });
  }

  TimetableEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? courseName,
    Value<int>? dayOfWeek,
    Value<int>? startHour,
    Value<int>? startMinute,
    Value<int>? endHour,
    Value<int>? endMinute,
    Value<String>? weekType,
    Value<int>? startWeek,
    Value<int>? endWeek,
  }) {
    return TimetableEventsCompanion(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      weekType: weekType ?? this.weekType,
      startWeek: startWeek ?? this.startWeek,
      endWeek: endWeek ?? this.endWeek,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseName.present) {
      map['course_name'] = Variable<String>(courseName.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startHour.present) {
      map['start_hour'] = Variable<int>(startHour.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endHour.present) {
      map['end_hour'] = Variable<int>(endHour.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (weekType.present) {
      map['week_type'] = Variable<String>(weekType.value);
    }
    if (startWeek.present) {
      map['start_week'] = Variable<int>(startWeek.value);
    }
    if (endWeek.present) {
      map['end_week'] = Variable<int>(endWeek.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableEventsCompanion(')
          ..write('id: $id, ')
          ..write('courseName: $courseName, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute, ')
          ..write('weekType: $weekType, ')
          ..write('startWeek: $startWeek, ')
          ..write('endWeek: $endWeek')
          ..write(')'))
        .toString();
  }
}

class $PlanItemsTable extends PlanItems
    with TableInfo<$PlanItemsTable, PlanItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRestMeta = const VerificationMeta('isRest');
  @override
  late final GeneratedColumn<bool> isRest = GeneratedColumn<bool>(
    'is_rest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isManualMeta = const VerificationMeta(
    'isManual',
  );
  @override
  late final GeneratedColumn<bool> isManual = GeneratedColumn<bool>(
    'is_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    subjectId,
    startMinutes,
    durationMinutes,
    isRest,
    isManual,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('is_rest')) {
      context.handle(
        _isRestMeta,
        isRest.isAcceptableOrUnknown(data['is_rest']!, _isRestMeta),
      );
    }
    if (data.containsKey('is_manual')) {
      context.handle(
        _isManualMeta,
        isManual.isAcceptableOrUnknown(data['is_manual']!, _isManualMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date'],
          )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      ),
      startMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_minutes'],
          )!,
      durationMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_minutes'],
          )!,
      isRest:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_rest'],
          )!,
      isManual:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_manual'],
          )!,
      orderIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}order_index'],
          )!,
    );
  }

  @override
  $PlanItemsTable createAlias(String alias) {
    return $PlanItemsTable(attachedDatabase, alias);
  }
}

class PlanItem extends DataClass implements Insertable<PlanItem> {
  final int id;
  final String date;
  final int? subjectId;
  final int startMinutes;
  final int durationMinutes;
  final bool isRest;
  final bool isManual;
  final int orderIndex;
  const PlanItem({
    required this.id,
    required this.date,
    this.subjectId,
    required this.startMinutes,
    required this.durationMinutes,
    required this.isRest,
    required this.isManual,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    map['start_minutes'] = Variable<int>(startMinutes);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['is_rest'] = Variable<bool>(isRest);
    map['is_manual'] = Variable<bool>(isManual);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  PlanItemsCompanion toCompanion(bool nullToAbsent) {
    return PlanItemsCompanion(
      id: Value(id),
      date: Value(date),
      subjectId:
          subjectId == null && nullToAbsent
              ? const Value.absent()
              : Value(subjectId),
      startMinutes: Value(startMinutes),
      durationMinutes: Value(durationMinutes),
      isRest: Value(isRest),
      isManual: Value(isManual),
      orderIndex: Value(orderIndex),
    );
  }

  factory PlanItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      subjectId: serializer.fromJson<int?>(json['subjectId']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      isRest: serializer.fromJson<bool>(json['isRest']),
      isManual: serializer.fromJson<bool>(json['isManual']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'subjectId': serializer.toJson<int?>(subjectId),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'isRest': serializer.toJson<bool>(isRest),
      'isManual': serializer.toJson<bool>(isManual),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  PlanItem copyWith({
    int? id,
    String? date,
    Value<int?> subjectId = const Value.absent(),
    int? startMinutes,
    int? durationMinutes,
    bool? isRest,
    bool? isManual,
    int? orderIndex,
  }) => PlanItem(
    id: id ?? this.id,
    date: date ?? this.date,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    startMinutes: startMinutes ?? this.startMinutes,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    isRest: isRest ?? this.isRest,
    isManual: isManual ?? this.isManual,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  PlanItem copyWithCompanion(PlanItemsCompanion data) {
    return PlanItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      startMinutes:
          data.startMinutes.present
              ? data.startMinutes.value
              : this.startMinutes,
      durationMinutes:
          data.durationMinutes.present
              ? data.durationMinutes.value
              : this.durationMinutes,
      isRest: data.isRest.present ? data.isRest.value : this.isRest,
      isManual: data.isManual.present ? data.isManual.value : this.isManual,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('subjectId: $subjectId, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isRest: $isRest, ')
          ..write('isManual: $isManual, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    subjectId,
    startMinutes,
    durationMinutes,
    isRest,
    isManual,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.subjectId == this.subjectId &&
          other.startMinutes == this.startMinutes &&
          other.durationMinutes == this.durationMinutes &&
          other.isRest == this.isRest &&
          other.isManual == this.isManual &&
          other.orderIndex == this.orderIndex);
}

class PlanItemsCompanion extends UpdateCompanion<PlanItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<int?> subjectId;
  final Value<int> startMinutes;
  final Value<int> durationMinutes;
  final Value<bool> isRest;
  final Value<bool> isManual;
  final Value<int> orderIndex;
  const PlanItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.isRest = const Value.absent(),
    this.isManual = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  PlanItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.subjectId = const Value.absent(),
    required int startMinutes,
    required int durationMinutes,
    this.isRest = const Value.absent(),
    this.isManual = const Value.absent(),
    required int orderIndex,
  }) : date = Value(date),
       startMinutes = Value(startMinutes),
       durationMinutes = Value(durationMinutes),
       orderIndex = Value(orderIndex);
  static Insertable<PlanItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? subjectId,
    Expression<int>? startMinutes,
    Expression<int>? durationMinutes,
    Expression<bool>? isRest,
    Expression<bool>? isManual,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (subjectId != null) 'subject_id': subjectId,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (isRest != null) 'is_rest': isRest,
      if (isManual != null) 'is_manual': isManual,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  PlanItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int?>? subjectId,
    Value<int>? startMinutes,
    Value<int>? durationMinutes,
    Value<bool>? isRest,
    Value<bool>? isManual,
    Value<int>? orderIndex,
  }) {
    return PlanItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      subjectId: subjectId ?? this.subjectId,
      startMinutes: startMinutes ?? this.startMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isRest: isRest ?? this.isRest,
      isManual: isManual ?? this.isManual,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (isRest.present) {
      map['is_rest'] = Variable<bool>(isRest.value);
    }
    if (isManual.present) {
      map['is_manual'] = Variable<bool>(isManual.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('subjectId: $subjectId, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isRest: $isRest, ')
          ..write('isManual: $isManual, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $DeferredRecordsTable extends DeferredRecords
    with TableInfo<$DeferredRecordsTable, DeferredRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeferredRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deferredMinutesMeta = const VerificationMeta(
    'deferredMinutes',
  );
  @override
  late final GeneratedColumn<int> deferredMinutes = GeneratedColumn<int>(
    'deferred_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromDateMeta = const VerificationMeta(
    'fromDate',
  );
  @override
  late final GeneratedColumn<String> fromDate = GeneratedColumn<String>(
    'from_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<String> weekStart = GeneratedColumn<String>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    deferredMinutes,
    fromDate,
    weekStart,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deferred_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeferredRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('deferred_minutes')) {
      context.handle(
        _deferredMinutesMeta,
        deferredMinutes.isAcceptableOrUnknown(
          data['deferred_minutes']!,
          _deferredMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deferredMinutesMeta);
    }
    if (data.containsKey('from_date')) {
      context.handle(
        _fromDateMeta,
        fromDate.isAcceptableOrUnknown(data['from_date']!, _fromDateMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDateMeta);
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeferredRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeferredRecord(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      subjectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}subject_id'],
          )!,
      deferredMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}deferred_minutes'],
          )!,
      fromDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}from_date'],
          )!,
      weekStart:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}week_start'],
          )!,
    );
  }

  @override
  $DeferredRecordsTable createAlias(String alias) {
    return $DeferredRecordsTable(attachedDatabase, alias);
  }
}

class DeferredRecord extends DataClass implements Insertable<DeferredRecord> {
  final int id;
  final int subjectId;
  final int deferredMinutes;
  final String fromDate;
  final String weekStart;
  const DeferredRecord({
    required this.id,
    required this.subjectId,
    required this.deferredMinutes,
    required this.fromDate,
    required this.weekStart,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<int>(subjectId);
    map['deferred_minutes'] = Variable<int>(deferredMinutes);
    map['from_date'] = Variable<String>(fromDate);
    map['week_start'] = Variable<String>(weekStart);
    return map;
  }

  DeferredRecordsCompanion toCompanion(bool nullToAbsent) {
    return DeferredRecordsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      deferredMinutes: Value(deferredMinutes),
      fromDate: Value(fromDate),
      weekStart: Value(weekStart),
    );
  }

  factory DeferredRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeferredRecord(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      deferredMinutes: serializer.fromJson<int>(json['deferredMinutes']),
      fromDate: serializer.fromJson<String>(json['fromDate']),
      weekStart: serializer.fromJson<String>(json['weekStart']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'deferredMinutes': serializer.toJson<int>(deferredMinutes),
      'fromDate': serializer.toJson<String>(fromDate),
      'weekStart': serializer.toJson<String>(weekStart),
    };
  }

  DeferredRecord copyWith({
    int? id,
    int? subjectId,
    int? deferredMinutes,
    String? fromDate,
    String? weekStart,
  }) => DeferredRecord(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    deferredMinutes: deferredMinutes ?? this.deferredMinutes,
    fromDate: fromDate ?? this.fromDate,
    weekStart: weekStart ?? this.weekStart,
  );
  DeferredRecord copyWithCompanion(DeferredRecordsCompanion data) {
    return DeferredRecord(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      deferredMinutes:
          data.deferredMinutes.present
              ? data.deferredMinutes.value
              : this.deferredMinutes,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeferredRecord(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('deferredMinutes: $deferredMinutes, ')
          ..write('fromDate: $fromDate, ')
          ..write('weekStart: $weekStart')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, subjectId, deferredMinutes, fromDate, weekStart);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeferredRecord &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.deferredMinutes == this.deferredMinutes &&
          other.fromDate == this.fromDate &&
          other.weekStart == this.weekStart);
}

class DeferredRecordsCompanion extends UpdateCompanion<DeferredRecord> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<int> deferredMinutes;
  final Value<String> fromDate;
  final Value<String> weekStart;
  const DeferredRecordsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.deferredMinutes = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.weekStart = const Value.absent(),
  });
  DeferredRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int subjectId,
    required int deferredMinutes,
    required String fromDate,
    required String weekStart,
  }) : subjectId = Value(subjectId),
       deferredMinutes = Value(deferredMinutes),
       fromDate = Value(fromDate),
       weekStart = Value(weekStart);
  static Insertable<DeferredRecord> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<int>? deferredMinutes,
    Expression<String>? fromDate,
    Expression<String>? weekStart,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (deferredMinutes != null) 'deferred_minutes': deferredMinutes,
      if (fromDate != null) 'from_date': fromDate,
      if (weekStart != null) 'week_start': weekStart,
    });
  }

  DeferredRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? subjectId,
    Value<int>? deferredMinutes,
    Value<String>? fromDate,
    Value<String>? weekStart,
  }) {
    return DeferredRecordsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      deferredMinutes: deferredMinutes ?? this.deferredMinutes,
      fromDate: fromDate ?? this.fromDate,
      weekStart: weekStart ?? this.weekStart,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (deferredMinutes.present) {
      map['deferred_minutes'] = Variable<int>(deferredMinutes.value);
    }
    if (fromDate.present) {
      map['from_date'] = Variable<String>(fromDate.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<String>(weekStart.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeferredRecordsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('deferredMinutes: $deferredMinutes, ')
          ..write('fromDate: $fromDate, ')
          ..write('weekStart: $weekStart')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wakeHourMeta = const VerificationMeta(
    'wakeHour',
  );
  @override
  late final GeneratedColumn<int> wakeHour = GeneratedColumn<int>(
    'wake_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _wakeMinuteMeta = const VerificationMeta(
    'wakeMinute',
  );
  @override
  late final GeneratedColumn<int> wakeMinute = GeneratedColumn<int>(
    'wake_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sleepHourMeta = const VerificationMeta(
    'sleepHour',
  );
  @override
  late final GeneratedColumn<int> sleepHour = GeneratedColumn<int>(
    'sleep_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(23),
  );
  static const VerificationMeta _sleepMinuteMeta = const VerificationMeta(
    'sleepMinute',
  );
  @override
  late final GeneratedColumn<int> sleepMinute = GeneratedColumn<int>(
    'sleep_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _studyBlockMinutesMeta = const VerificationMeta(
    'studyBlockMinutes',
  );
  @override
  late final GeneratedColumn<int> studyBlockMinutes = GeneratedColumn<int>(
    'study_block_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _restBlockMinutesMeta = const VerificationMeta(
    'restBlockMinutes',
  );
  @override
  late final GeneratedColumn<int> restBlockMinutes = GeneratedColumn<int>(
    'rest_block_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _semesterStartDateMeta = const VerificationMeta(
    'semesterStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> semesterStartDate =
      GeneratedColumn<DateTime>(
        'semester_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeHour,
    wakeMinute,
    sleepHour,
    sleepMinute,
    studyBlockMinutes,
    restBlockMinutes,
    semesterStartDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wake_hour')) {
      context.handle(
        _wakeHourMeta,
        wakeHour.isAcceptableOrUnknown(data['wake_hour']!, _wakeHourMeta),
      );
    }
    if (data.containsKey('wake_minute')) {
      context.handle(
        _wakeMinuteMeta,
        wakeMinute.isAcceptableOrUnknown(data['wake_minute']!, _wakeMinuteMeta),
      );
    }
    if (data.containsKey('sleep_hour')) {
      context.handle(
        _sleepHourMeta,
        sleepHour.isAcceptableOrUnknown(data['sleep_hour']!, _sleepHourMeta),
      );
    }
    if (data.containsKey('sleep_minute')) {
      context.handle(
        _sleepMinuteMeta,
        sleepMinute.isAcceptableOrUnknown(
          data['sleep_minute']!,
          _sleepMinuteMeta,
        ),
      );
    }
    if (data.containsKey('study_block_minutes')) {
      context.handle(
        _studyBlockMinutesMeta,
        studyBlockMinutes.isAcceptableOrUnknown(
          data['study_block_minutes']!,
          _studyBlockMinutesMeta,
        ),
      );
    }
    if (data.containsKey('rest_block_minutes')) {
      context.handle(
        _restBlockMinutesMeta,
        restBlockMinutes.isAcceptableOrUnknown(
          data['rest_block_minutes']!,
          _restBlockMinutesMeta,
        ),
      );
    }
    if (data.containsKey('semester_start_date')) {
      context.handle(
        _semesterStartDateMeta,
        semesterStartDate.isAcceptableOrUnknown(
          data['semester_start_date']!,
          _semesterStartDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      wakeHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}wake_hour'],
          )!,
      wakeMinute:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}wake_minute'],
          )!,
      sleepHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sleep_hour'],
          )!,
      sleepMinute:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sleep_minute'],
          )!,
      studyBlockMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}study_block_minutes'],
          )!,
      restBlockMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rest_block_minutes'],
          )!,
      semesterStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}semester_start_date'],
      ),
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsTableData extends DataClass
    implements Insertable<UserSettingsTableData> {
  final int id;
  final int wakeHour;
  final int wakeMinute;
  final int sleepHour;
  final int sleepMinute;
  final int studyBlockMinutes;
  final int restBlockMinutes;
  final DateTime? semesterStartDate;
  const UserSettingsTableData({
    required this.id,
    required this.wakeHour,
    required this.wakeMinute,
    required this.sleepHour,
    required this.sleepMinute,
    required this.studyBlockMinutes,
    required this.restBlockMinutes,
    this.semesterStartDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wake_hour'] = Variable<int>(wakeHour);
    map['wake_minute'] = Variable<int>(wakeMinute);
    map['sleep_hour'] = Variable<int>(sleepHour);
    map['sleep_minute'] = Variable<int>(sleepMinute);
    map['study_block_minutes'] = Variable<int>(studyBlockMinutes);
    map['rest_block_minutes'] = Variable<int>(restBlockMinutes);
    if (!nullToAbsent || semesterStartDate != null) {
      map['semester_start_date'] = Variable<DateTime>(semesterStartDate);
    }
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      wakeHour: Value(wakeHour),
      wakeMinute: Value(wakeMinute),
      sleepHour: Value(sleepHour),
      sleepMinute: Value(sleepMinute),
      studyBlockMinutes: Value(studyBlockMinutes),
      restBlockMinutes: Value(restBlockMinutes),
      semesterStartDate:
          semesterStartDate == null && nullToAbsent
              ? const Value.absent()
              : Value(semesterStartDate),
    );
  }

  factory UserSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      wakeHour: serializer.fromJson<int>(json['wakeHour']),
      wakeMinute: serializer.fromJson<int>(json['wakeMinute']),
      sleepHour: serializer.fromJson<int>(json['sleepHour']),
      sleepMinute: serializer.fromJson<int>(json['sleepMinute']),
      studyBlockMinutes: serializer.fromJson<int>(json['studyBlockMinutes']),
      restBlockMinutes: serializer.fromJson<int>(json['restBlockMinutes']),
      semesterStartDate: serializer.fromJson<DateTime?>(
        json['semesterStartDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wakeHour': serializer.toJson<int>(wakeHour),
      'wakeMinute': serializer.toJson<int>(wakeMinute),
      'sleepHour': serializer.toJson<int>(sleepHour),
      'sleepMinute': serializer.toJson<int>(sleepMinute),
      'studyBlockMinutes': serializer.toJson<int>(studyBlockMinutes),
      'restBlockMinutes': serializer.toJson<int>(restBlockMinutes),
      'semesterStartDate': serializer.toJson<DateTime?>(semesterStartDate),
    };
  }

  UserSettingsTableData copyWith({
    int? id,
    int? wakeHour,
    int? wakeMinute,
    int? sleepHour,
    int? sleepMinute,
    int? studyBlockMinutes,
    int? restBlockMinutes,
    Value<DateTime?> semesterStartDate = const Value.absent(),
  }) => UserSettingsTableData(
    id: id ?? this.id,
    wakeHour: wakeHour ?? this.wakeHour,
    wakeMinute: wakeMinute ?? this.wakeMinute,
    sleepHour: sleepHour ?? this.sleepHour,
    sleepMinute: sleepMinute ?? this.sleepMinute,
    studyBlockMinutes: studyBlockMinutes ?? this.studyBlockMinutes,
    restBlockMinutes: restBlockMinutes ?? this.restBlockMinutes,
    semesterStartDate:
        semesterStartDate.present
            ? semesterStartDate.value
            : this.semesterStartDate,
  );
  UserSettingsTableData copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      wakeHour: data.wakeHour.present ? data.wakeHour.value : this.wakeHour,
      wakeMinute:
          data.wakeMinute.present ? data.wakeMinute.value : this.wakeMinute,
      sleepHour: data.sleepHour.present ? data.sleepHour.value : this.sleepHour,
      sleepMinute:
          data.sleepMinute.present ? data.sleepMinute.value : this.sleepMinute,
      studyBlockMinutes:
          data.studyBlockMinutes.present
              ? data.studyBlockMinutes.value
              : this.studyBlockMinutes,
      restBlockMinutes:
          data.restBlockMinutes.present
              ? data.restBlockMinutes.value
              : this.restBlockMinutes,
      semesterStartDate:
          data.semesterStartDate.present
              ? data.semesterStartDate.value
              : this.semesterStartDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableData(')
          ..write('id: $id, ')
          ..write('wakeHour: $wakeHour, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('sleepHour: $sleepHour, ')
          ..write('sleepMinute: $sleepMinute, ')
          ..write('studyBlockMinutes: $studyBlockMinutes, ')
          ..write('restBlockMinutes: $restBlockMinutes, ')
          ..write('semesterStartDate: $semesterStartDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeHour,
    wakeMinute,
    sleepHour,
    sleepMinute,
    studyBlockMinutes,
    restBlockMinutes,
    semesterStartDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsTableData &&
          other.id == this.id &&
          other.wakeHour == this.wakeHour &&
          other.wakeMinute == this.wakeMinute &&
          other.sleepHour == this.sleepHour &&
          other.sleepMinute == this.sleepMinute &&
          other.studyBlockMinutes == this.studyBlockMinutes &&
          other.restBlockMinutes == this.restBlockMinutes &&
          other.semesterStartDate == this.semesterStartDate);
}

class UserSettingsTableCompanion
    extends UpdateCompanion<UserSettingsTableData> {
  final Value<int> id;
  final Value<int> wakeHour;
  final Value<int> wakeMinute;
  final Value<int> sleepHour;
  final Value<int> sleepMinute;
  final Value<int> studyBlockMinutes;
  final Value<int> restBlockMinutes;
  final Value<DateTime?> semesterStartDate;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.wakeHour = const Value.absent(),
    this.wakeMinute = const Value.absent(),
    this.sleepHour = const Value.absent(),
    this.sleepMinute = const Value.absent(),
    this.studyBlockMinutes = const Value.absent(),
    this.restBlockMinutes = const Value.absent(),
    this.semesterStartDate = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.wakeHour = const Value.absent(),
    this.wakeMinute = const Value.absent(),
    this.sleepHour = const Value.absent(),
    this.sleepMinute = const Value.absent(),
    this.studyBlockMinutes = const Value.absent(),
    this.restBlockMinutes = const Value.absent(),
    this.semesterStartDate = const Value.absent(),
  });
  static Insertable<UserSettingsTableData> custom({
    Expression<int>? id,
    Expression<int>? wakeHour,
    Expression<int>? wakeMinute,
    Expression<int>? sleepHour,
    Expression<int>? sleepMinute,
    Expression<int>? studyBlockMinutes,
    Expression<int>? restBlockMinutes,
    Expression<DateTime>? semesterStartDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeHour != null) 'wake_hour': wakeHour,
      if (wakeMinute != null) 'wake_minute': wakeMinute,
      if (sleepHour != null) 'sleep_hour': sleepHour,
      if (sleepMinute != null) 'sleep_minute': sleepMinute,
      if (studyBlockMinutes != null) 'study_block_minutes': studyBlockMinutes,
      if (restBlockMinutes != null) 'rest_block_minutes': restBlockMinutes,
      if (semesterStartDate != null) 'semester_start_date': semesterStartDate,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? wakeHour,
    Value<int>? wakeMinute,
    Value<int>? sleepHour,
    Value<int>? sleepMinute,
    Value<int>? studyBlockMinutes,
    Value<int>? restBlockMinutes,
    Value<DateTime?>? semesterStartDate,
  }) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      wakeHour: wakeHour ?? this.wakeHour,
      wakeMinute: wakeMinute ?? this.wakeMinute,
      sleepHour: sleepHour ?? this.sleepHour,
      sleepMinute: sleepMinute ?? this.sleepMinute,
      studyBlockMinutes: studyBlockMinutes ?? this.studyBlockMinutes,
      restBlockMinutes: restBlockMinutes ?? this.restBlockMinutes,
      semesterStartDate: semesterStartDate ?? this.semesterStartDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wakeHour.present) {
      map['wake_hour'] = Variable<int>(wakeHour.value);
    }
    if (wakeMinute.present) {
      map['wake_minute'] = Variable<int>(wakeMinute.value);
    }
    if (sleepHour.present) {
      map['sleep_hour'] = Variable<int>(sleepHour.value);
    }
    if (sleepMinute.present) {
      map['sleep_minute'] = Variable<int>(sleepMinute.value);
    }
    if (studyBlockMinutes.present) {
      map['study_block_minutes'] = Variable<int>(studyBlockMinutes.value);
    }
    if (restBlockMinutes.present) {
      map['rest_block_minutes'] = Variable<int>(restBlockMinutes.value);
    }
    if (semesterStartDate.present) {
      map['semester_start_date'] = Variable<DateTime>(semesterStartDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('wakeHour: $wakeHour, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('sleepHour: $sleepHour, ')
          ..write('sleepMinute: $sleepMinute, ')
          ..write('studyBlockMinutes: $studyBlockMinutes, ')
          ..write('restBlockMinutes: $restBlockMinutes, ')
          ..write('semesterStartDate: $semesterStartDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $FixedEventsTable fixedEvents = $FixedEventsTable(this);
  late final $TimetableEventsTable timetableEvents = $TimetableEventsTable(
    this,
  );
  late final $PlanItemsTable planItems = $PlanItemsTable(this);
  late final $DeferredRecordsTable deferredRecords = $DeferredRecordsTable(
    this,
  );
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    fixedEvents,
    timetableEvents,
    planItems,
    deferredRecords,
    userSettingsTable,
  ];
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      required String name,
      required int dailyMinutes,
      Value<int> priority,
      Value<int> color,
      Value<DateTime> createdAt,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> dailyMinutes,
      Value<int> priority,
      Value<int> color,
      Value<DateTime> createdAt,
    });

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
          Subject,
          PrefetchHooks Function()
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> dailyMinutes = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                name: name,
                dailyMinutes: dailyMinutes,
                priority: priority,
                color: color,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int dailyMinutes,
                Value<int> priority = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                name: name,
                dailyMinutes: dailyMinutes,
                priority: priority,
                color: color,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
      Subject,
      PrefetchHooks Function()
    >;
typedef $$FixedEventsTableCreateCompanionBuilder =
    FixedEventsCompanion Function({
      Value<int> id,
      required String name,
      required int startHour,
      required int startMinute,
      required int endHour,
      required int endMinute,
      Value<bool> isActive,
    });
typedef $$FixedEventsTableUpdateCompanionBuilder =
    FixedEventsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> startHour,
      Value<int> startMinute,
      Value<int> endHour,
      Value<int> endMinute,
      Value<bool> isActive,
    });

class $$FixedEventsTableFilterComposer
    extends Composer<_$AppDatabase, $FixedEventsTable> {
  $$FixedEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FixedEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $FixedEventsTable> {
  $$FixedEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FixedEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FixedEventsTable> {
  $$FixedEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get startHour =>
      $composableBuilder(column: $table.startHour, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endHour =>
      $composableBuilder(column: $table.endHour, builder: (column) => column);

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$FixedEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FixedEventsTable,
          FixedEvent,
          $$FixedEventsTableFilterComposer,
          $$FixedEventsTableOrderingComposer,
          $$FixedEventsTableAnnotationComposer,
          $$FixedEventsTableCreateCompanionBuilder,
          $$FixedEventsTableUpdateCompanionBuilder,
          (
            FixedEvent,
            BaseReferences<_$AppDatabase, $FixedEventsTable, FixedEvent>,
          ),
          FixedEvent,
          PrefetchHooks Function()
        > {
  $$FixedEventsTableTableManager(_$AppDatabase db, $FixedEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FixedEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FixedEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$FixedEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> startHour = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endHour = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => FixedEventsCompanion(
                id: id,
                name: name,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int startHour,
                required int startMinute,
                required int endHour,
                required int endMinute,
                Value<bool> isActive = const Value.absent(),
              }) => FixedEventsCompanion.insert(
                id: id,
                name: name,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
                isActive: isActive,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FixedEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FixedEventsTable,
      FixedEvent,
      $$FixedEventsTableFilterComposer,
      $$FixedEventsTableOrderingComposer,
      $$FixedEventsTableAnnotationComposer,
      $$FixedEventsTableCreateCompanionBuilder,
      $$FixedEventsTableUpdateCompanionBuilder,
      (
        FixedEvent,
        BaseReferences<_$AppDatabase, $FixedEventsTable, FixedEvent>,
      ),
      FixedEvent,
      PrefetchHooks Function()
    >;
typedef $$TimetableEventsTableCreateCompanionBuilder =
    TimetableEventsCompanion Function({
      Value<int> id,
      required String courseName,
      required int dayOfWeek,
      required int startHour,
      required int startMinute,
      required int endHour,
      required int endMinute,
      Value<String> weekType,
      Value<int> startWeek,
      Value<int> endWeek,
    });
typedef $$TimetableEventsTableUpdateCompanionBuilder =
    TimetableEventsCompanion Function({
      Value<int> id,
      Value<String> courseName,
      Value<int> dayOfWeek,
      Value<int> startHour,
      Value<int> startMinute,
      Value<int> endHour,
      Value<int> endMinute,
      Value<String> weekType,
      Value<int> startWeek,
      Value<int> endWeek,
    });

class $$TimetableEventsTableFilterComposer
    extends Composer<_$AppDatabase, $TimetableEventsTable> {
  $$TimetableEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseName => $composableBuilder(
    column: $table.courseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekType => $composableBuilder(
    column: $table.weekType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startWeek => $composableBuilder(
    column: $table.startWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endWeek => $composableBuilder(
    column: $table.endWeek,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimetableEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimetableEventsTable> {
  $$TimetableEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseName => $composableBuilder(
    column: $table.courseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekType => $composableBuilder(
    column: $table.weekType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startWeek => $composableBuilder(
    column: $table.startWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endWeek => $composableBuilder(
    column: $table.endWeek,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimetableEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimetableEventsTable> {
  $$TimetableEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseName => $composableBuilder(
    column: $table.courseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get startHour =>
      $composableBuilder(column: $table.startHour, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endHour =>
      $composableBuilder(column: $table.endHour, builder: (column) => column);

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<String> get weekType =>
      $composableBuilder(column: $table.weekType, builder: (column) => column);

  GeneratedColumn<int> get startWeek =>
      $composableBuilder(column: $table.startWeek, builder: (column) => column);

  GeneratedColumn<int> get endWeek =>
      $composableBuilder(column: $table.endWeek, builder: (column) => column);
}

class $$TimetableEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimetableEventsTable,
          TimetableEvent,
          $$TimetableEventsTableFilterComposer,
          $$TimetableEventsTableOrderingComposer,
          $$TimetableEventsTableAnnotationComposer,
          $$TimetableEventsTableCreateCompanionBuilder,
          $$TimetableEventsTableUpdateCompanionBuilder,
          (
            TimetableEvent,
            BaseReferences<
              _$AppDatabase,
              $TimetableEventsTable,
              TimetableEvent
            >,
          ),
          TimetableEvent,
          PrefetchHooks Function()
        > {
  $$TimetableEventsTableTableManager(
    _$AppDatabase db,
    $TimetableEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$TimetableEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TimetableEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TimetableEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> courseName = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<int> startHour = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endHour = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<String> weekType = const Value.absent(),
                Value<int> startWeek = const Value.absent(),
                Value<int> endWeek = const Value.absent(),
              }) => TimetableEventsCompanion(
                id: id,
                courseName: courseName,
                dayOfWeek: dayOfWeek,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
                weekType: weekType,
                startWeek: startWeek,
                endWeek: endWeek,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String courseName,
                required int dayOfWeek,
                required int startHour,
                required int startMinute,
                required int endHour,
                required int endMinute,
                Value<String> weekType = const Value.absent(),
                Value<int> startWeek = const Value.absent(),
                Value<int> endWeek = const Value.absent(),
              }) => TimetableEventsCompanion.insert(
                id: id,
                courseName: courseName,
                dayOfWeek: dayOfWeek,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
                weekType: weekType,
                startWeek: startWeek,
                endWeek: endWeek,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimetableEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimetableEventsTable,
      TimetableEvent,
      $$TimetableEventsTableFilterComposer,
      $$TimetableEventsTableOrderingComposer,
      $$TimetableEventsTableAnnotationComposer,
      $$TimetableEventsTableCreateCompanionBuilder,
      $$TimetableEventsTableUpdateCompanionBuilder,
      (
        TimetableEvent,
        BaseReferences<_$AppDatabase, $TimetableEventsTable, TimetableEvent>,
      ),
      TimetableEvent,
      PrefetchHooks Function()
    >;
typedef $$PlanItemsTableCreateCompanionBuilder =
    PlanItemsCompanion Function({
      Value<int> id,
      required String date,
      Value<int?> subjectId,
      required int startMinutes,
      required int durationMinutes,
      Value<bool> isRest,
      Value<bool> isManual,
      required int orderIndex,
    });
typedef $$PlanItemsTableUpdateCompanionBuilder =
    PlanItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int?> subjectId,
      Value<int> startMinutes,
      Value<int> durationMinutes,
      Value<bool> isRest,
      Value<bool> isManual,
      Value<int> orderIndex,
    });

class $$PlanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanItemsTable> {
  $$PlanItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRest => $composableBuilder(
    column: $table.isRest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanItemsTable> {
  $$PlanItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRest => $composableBuilder(
    column: $table.isRest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanItemsTable> {
  $$PlanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRest =>
      $composableBuilder(column: $table.isRest, builder: (column) => column);

  GeneratedColumn<bool> get isManual =>
      $composableBuilder(column: $table.isManual, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$PlanItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanItemsTable,
          PlanItem,
          $$PlanItemsTableFilterComposer,
          $$PlanItemsTableOrderingComposer,
          $$PlanItemsTableAnnotationComposer,
          $$PlanItemsTableCreateCompanionBuilder,
          $$PlanItemsTableUpdateCompanionBuilder,
          (PlanItem, BaseReferences<_$AppDatabase, $PlanItemsTable, PlanItem>),
          PlanItem,
          PrefetchHooks Function()
        > {
  $$PlanItemsTableTableManager(_$AppDatabase db, $PlanItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlanItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<bool> isRest = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => PlanItemsCompanion(
                id: id,
                date: date,
                subjectId: subjectId,
                startMinutes: startMinutes,
                durationMinutes: durationMinutes,
                isRest: isRest,
                isManual: isManual,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                Value<int?> subjectId = const Value.absent(),
                required int startMinutes,
                required int durationMinutes,
                Value<bool> isRest = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                required int orderIndex,
              }) => PlanItemsCompanion.insert(
                id: id,
                date: date,
                subjectId: subjectId,
                startMinutes: startMinutes,
                durationMinutes: durationMinutes,
                isRest: isRest,
                isManual: isManual,
                orderIndex: orderIndex,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanItemsTable,
      PlanItem,
      $$PlanItemsTableFilterComposer,
      $$PlanItemsTableOrderingComposer,
      $$PlanItemsTableAnnotationComposer,
      $$PlanItemsTableCreateCompanionBuilder,
      $$PlanItemsTableUpdateCompanionBuilder,
      (PlanItem, BaseReferences<_$AppDatabase, $PlanItemsTable, PlanItem>),
      PlanItem,
      PrefetchHooks Function()
    >;
typedef $$DeferredRecordsTableCreateCompanionBuilder =
    DeferredRecordsCompanion Function({
      Value<int> id,
      required int subjectId,
      required int deferredMinutes,
      required String fromDate,
      required String weekStart,
    });
typedef $$DeferredRecordsTableUpdateCompanionBuilder =
    DeferredRecordsCompanion Function({
      Value<int> id,
      Value<int> subjectId,
      Value<int> deferredMinutes,
      Value<String> fromDate,
      Value<String> weekStart,
    });

class $$DeferredRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DeferredRecordsTable> {
  $$DeferredRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deferredMinutes => $composableBuilder(
    column: $table.deferredMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeferredRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeferredRecordsTable> {
  $$DeferredRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deferredMinutes => $composableBuilder(
    column: $table.deferredMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeferredRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeferredRecordsTable> {
  $$DeferredRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get deferredMinutes => $composableBuilder(
    column: $table.deferredMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<String> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);
}

class $$DeferredRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeferredRecordsTable,
          DeferredRecord,
          $$DeferredRecordsTableFilterComposer,
          $$DeferredRecordsTableOrderingComposer,
          $$DeferredRecordsTableAnnotationComposer,
          $$DeferredRecordsTableCreateCompanionBuilder,
          $$DeferredRecordsTableUpdateCompanionBuilder,
          (
            DeferredRecord,
            BaseReferences<
              _$AppDatabase,
              $DeferredRecordsTable,
              DeferredRecord
            >,
          ),
          DeferredRecord,
          PrefetchHooks Function()
        > {
  $$DeferredRecordsTableTableManager(
    _$AppDatabase db,
    $DeferredRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$DeferredRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DeferredRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$DeferredRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<int> deferredMinutes = const Value.absent(),
                Value<String> fromDate = const Value.absent(),
                Value<String> weekStart = const Value.absent(),
              }) => DeferredRecordsCompanion(
                id: id,
                subjectId: subjectId,
                deferredMinutes: deferredMinutes,
                fromDate: fromDate,
                weekStart: weekStart,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subjectId,
                required int deferredMinutes,
                required String fromDate,
                required String weekStart,
              }) => DeferredRecordsCompanion.insert(
                id: id,
                subjectId: subjectId,
                deferredMinutes: deferredMinutes,
                fromDate: fromDate,
                weekStart: weekStart,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeferredRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeferredRecordsTable,
      DeferredRecord,
      $$DeferredRecordsTableFilterComposer,
      $$DeferredRecordsTableOrderingComposer,
      $$DeferredRecordsTableAnnotationComposer,
      $$DeferredRecordsTableCreateCompanionBuilder,
      $$DeferredRecordsTableUpdateCompanionBuilder,
      (
        DeferredRecord,
        BaseReferences<_$AppDatabase, $DeferredRecordsTable, DeferredRecord>,
      ),
      DeferredRecord,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<int> wakeHour,
      Value<int> wakeMinute,
      Value<int> sleepHour,
      Value<int> sleepMinute,
      Value<int> studyBlockMinutes,
      Value<int> restBlockMinutes,
      Value<DateTime?> semesterStartDate,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<int> wakeHour,
      Value<int> wakeMinute,
      Value<int> sleepHour,
      Value<int> sleepMinute,
      Value<int> studyBlockMinutes,
      Value<int> restBlockMinutes,
      Value<DateTime?> semesterStartDate,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeHour => $composableBuilder(
    column: $table.wakeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepHour => $composableBuilder(
    column: $table.sleepHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepMinute => $composableBuilder(
    column: $table.sleepMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get studyBlockMinutes => $composableBuilder(
    column: $table.studyBlockMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restBlockMinutes => $composableBuilder(
    column: $table.restBlockMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get semesterStartDate => $composableBuilder(
    column: $table.semesterStartDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeHour => $composableBuilder(
    column: $table.wakeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepHour => $composableBuilder(
    column: $table.sleepHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepMinute => $composableBuilder(
    column: $table.sleepMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get studyBlockMinutes => $composableBuilder(
    column: $table.studyBlockMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restBlockMinutes => $composableBuilder(
    column: $table.restBlockMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get semesterStartDate => $composableBuilder(
    column: $table.semesterStartDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wakeHour =>
      $composableBuilder(column: $table.wakeHour, builder: (column) => column);

  GeneratedColumn<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepHour =>
      $composableBuilder(column: $table.sleepHour, builder: (column) => column);

  GeneratedColumn<int> get sleepMinute => $composableBuilder(
    column: $table.sleepMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get studyBlockMinutes => $composableBuilder(
    column: $table.studyBlockMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restBlockMinutes => $composableBuilder(
    column: $table.restBlockMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get semesterStartDate => $composableBuilder(
    column: $table.semesterStartDate,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsTableData,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsTableData
            >,
          ),
          UserSettingsTableData,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserSettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$UserSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wakeHour = const Value.absent(),
                Value<int> wakeMinute = const Value.absent(),
                Value<int> sleepHour = const Value.absent(),
                Value<int> sleepMinute = const Value.absent(),
                Value<int> studyBlockMinutes = const Value.absent(),
                Value<int> restBlockMinutes = const Value.absent(),
                Value<DateTime?> semesterStartDate = const Value.absent(),
              }) => UserSettingsTableCompanion(
                id: id,
                wakeHour: wakeHour,
                wakeMinute: wakeMinute,
                sleepHour: sleepHour,
                sleepMinute: sleepMinute,
                studyBlockMinutes: studyBlockMinutes,
                restBlockMinutes: restBlockMinutes,
                semesterStartDate: semesterStartDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wakeHour = const Value.absent(),
                Value<int> wakeMinute = const Value.absent(),
                Value<int> sleepHour = const Value.absent(),
                Value<int> sleepMinute = const Value.absent(),
                Value<int> studyBlockMinutes = const Value.absent(),
                Value<int> restBlockMinutes = const Value.absent(),
                Value<DateTime?> semesterStartDate = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                id: id,
                wakeHour: wakeHour,
                wakeMinute: wakeMinute,
                sleepHour: sleepHour,
                sleepMinute: sleepMinute,
                studyBlockMinutes: studyBlockMinutes,
                restBlockMinutes: restBlockMinutes,
                semesterStartDate: semesterStartDate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsTableData,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsTableData
        >,
      ),
      UserSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$FixedEventsTableTableManager get fixedEvents =>
      $$FixedEventsTableTableManager(_db, _db.fixedEvents);
  $$TimetableEventsTableTableManager get timetableEvents =>
      $$TimetableEventsTableTableManager(_db, _db.timetableEvents);
  $$PlanItemsTableTableManager get planItems =>
      $$PlanItemsTableTableManager(_db, _db.planItems);
  $$DeferredRecordsTableTableManager get deferredRecords =>
      $$DeferredRecordsTableTableManager(_db, _db.deferredRecords);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
}
