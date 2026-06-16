// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CyclesTable extends Cycles with TableInfo<$CyclesTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleLengthMeta = const VerificationMeta(
    'cycleLength',
  );
  @override
  late final GeneratedColumn<int> cycleLength = GeneratedColumn<int>(
    'cycle_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodLengthMeta = const VerificationMeta(
    'periodLength',
  );
  @override
  late final GeneratedColumn<int> periodLength = GeneratedColumn<int>(
    'period_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    startDate,
    endDate,
    cycleLength,
    periodLength,
    notes,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('cycle_length')) {
      context.handle(
        _cycleLengthMeta,
        cycleLength.isAcceptableOrUnknown(
          data['cycle_length']!,
          _cycleLengthMeta,
        ),
      );
    }
    if (data.containsKey('period_length')) {
      context.handle(
        _periodLengthMeta,
        periodLength.isAcceptableOrUnknown(
          data['period_length']!,
          _periodLengthMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      cycleLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_length'],
      ),
      periodLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_length'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? cycleLength;
  final int? periodLength;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Cycle({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.cycleLength,
    this.periodLength,
    this.notes,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || cycleLength != null) {
      map['cycle_length'] = Variable<int>(cycleLength);
    }
    if (!nullToAbsent || periodLength != null) {
      map['period_length'] = Variable<int>(periodLength);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      userId: Value(userId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      cycleLength: cycleLength == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleLength),
      periodLength: periodLength == null && nullToAbsent
          ? const Value.absent()
          : Value(periodLength),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      cycleLength: serializer.fromJson<int?>(json['cycleLength']),
      periodLength: serializer.fromJson<int?>(json['periodLength']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'cycleLength': serializer.toJson<int?>(cycleLength),
      'periodLength': serializer.toJson<int?>(periodLength),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Cycle copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<int?> cycleLength = const Value.absent(),
    Value<int?> periodLength = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Cycle(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    cycleLength: cycleLength.present ? cycleLength.value : this.cycleLength,
    periodLength: periodLength.present ? periodLength.value : this.periodLength,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Cycle copyWithCompanion(CyclesCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      cycleLength: data.cycleLength.present
          ? data.cycleLength.value
          : this.cycleLength,
      periodLength: data.periodLength.present
          ? data.periodLength.value
          : this.periodLength,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('cycleLength: $cycleLength, ')
          ..write('periodLength: $periodLength, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    startDate,
    endDate,
    cycleLength,
    periodLength,
    notes,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.cycleLength == this.cycleLength &&
          other.periodLength == this.periodLength &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CyclesCompanion extends UpdateCompanion<Cycle> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> cycleLength;
  final Value<int?> periodLength;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.cycleLength = const Value.absent(),
    this.periodLength = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CyclesCompanion.insert({
    required String id,
    required String userId,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.cycleLength = const Value.absent(),
    this.periodLength = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Cycle> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? cycleLength,
    Expression<int>? periodLength,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (cycleLength != null) 'cycle_length': cycleLength,
      if (periodLength != null) 'period_length': periodLength,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CyclesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int?>? cycleLength,
    Value<int?>? periodLength,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (cycleLength.present) {
      map['cycle_length'] = Variable<int>(cycleLength.value);
    }
    if (periodLength.present) {
      map['period_length'] = Variable<int>(periodLength.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('cycleLength: $cycleLength, ')
          ..write('periodLength: $periodLength, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CycleDaysTable extends CycleDays
    with TableInfo<$CycleDaysTable, CycleDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CycleDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flowIntensityMeta = const VerificationMeta(
    'flowIntensity',
  );
  @override
  late final GeneratedColumn<int> flowIntensity = GeneratedColumn<int>(
    'flow_intensity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spottingMeta = const VerificationMeta(
    'spotting',
  );
  @override
  late final GeneratedColumn<bool> spotting = GeneratedColumn<bool>(
    'spotting',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("spotting" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _clottingMeta = const VerificationMeta(
    'clotting',
  );
  @override
  late final GeneratedColumn<bool> clotting = GeneratedColumn<bool>(
    'clotting',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("clotting" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _symptomsJsonMeta = const VerificationMeta(
    'symptomsJson',
  );
  @override
  late final GeneratedColumn<String> symptomsJson = GeneratedColumn<String>(
    'symptoms_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cervicalMucusMeta = const VerificationMeta(
    'cervicalMucus',
  );
  @override
  late final GeneratedColumn<String> cervicalMucus = GeneratedColumn<String>(
    'cervical_mucus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cervicalPositionMeta = const VerificationMeta(
    'cervicalPosition',
  );
  @override
  late final GeneratedColumn<String> cervicalPosition = GeneratedColumn<String>(
    'cervical_position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opkResultMeta = const VerificationMeta(
    'opkResult',
  );
  @override
  late final GeneratedColumn<String> opkResult = GeneratedColumn<String>(
    'opk_result',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    date,
    flowIntensity,
    spotting,
    clotting,
    symptomsJson,
    temperature,
    cervicalMucus,
    cervicalPosition,
    opkResult,
    notes,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<CycleDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('flow_intensity')) {
      context.handle(
        _flowIntensityMeta,
        flowIntensity.isAcceptableOrUnknown(
          data['flow_intensity']!,
          _flowIntensityMeta,
        ),
      );
    }
    if (data.containsKey('spotting')) {
      context.handle(
        _spottingMeta,
        spotting.isAcceptableOrUnknown(data['spotting']!, _spottingMeta),
      );
    }
    if (data.containsKey('clotting')) {
      context.handle(
        _clottingMeta,
        clotting.isAcceptableOrUnknown(data['clotting']!, _clottingMeta),
      );
    }
    if (data.containsKey('symptoms_json')) {
      context.handle(
        _symptomsJsonMeta,
        symptomsJson.isAcceptableOrUnknown(
          data['symptoms_json']!,
          _symptomsJsonMeta,
        ),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('cervical_mucus')) {
      context.handle(
        _cervicalMucusMeta,
        cervicalMucus.isAcceptableOrUnknown(
          data['cervical_mucus']!,
          _cervicalMucusMeta,
        ),
      );
    }
    if (data.containsKey('cervical_position')) {
      context.handle(
        _cervicalPositionMeta,
        cervicalPosition.isAcceptableOrUnknown(
          data['cervical_position']!,
          _cervicalPositionMeta,
        ),
      );
    }
    if (data.containsKey('opk_result')) {
      context.handle(
        _opkResultMeta,
        opkResult.isAcceptableOrUnknown(data['opk_result']!, _opkResultMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CycleDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      flowIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flow_intensity'],
      ),
      spotting: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}spotting'],
      )!,
      clotting: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}clotting'],
      )!,
      symptomsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms_json'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      cervicalMucus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cervical_mucus'],
      ),
      cervicalPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cervical_position'],
      ),
      opkResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opk_result'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CycleDaysTable createAlias(String alias) {
    return $CycleDaysTable(attachedDatabase, alias);
  }
}

class CycleDay extends DataClass implements Insertable<CycleDay> {
  final String id;
  final String cycleId;
  final DateTime date;
  final int? flowIntensity;
  final bool spotting;
  final bool clotting;
  final String? symptomsJson;
  final double? temperature;
  final String? cervicalMucus;
  final String? cervicalPosition;
  final String? opkResult;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CycleDay({
    required this.id,
    required this.cycleId,
    required this.date,
    this.flowIntensity,
    required this.spotting,
    required this.clotting,
    this.symptomsJson,
    this.temperature,
    this.cervicalMucus,
    this.cervicalPosition,
    this.opkResult,
    this.notes,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cycle_id'] = Variable<String>(cycleId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || flowIntensity != null) {
      map['flow_intensity'] = Variable<int>(flowIntensity);
    }
    map['spotting'] = Variable<bool>(spotting);
    map['clotting'] = Variable<bool>(clotting);
    if (!nullToAbsent || symptomsJson != null) {
      map['symptoms_json'] = Variable<String>(symptomsJson);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || cervicalMucus != null) {
      map['cervical_mucus'] = Variable<String>(cervicalMucus);
    }
    if (!nullToAbsent || cervicalPosition != null) {
      map['cervical_position'] = Variable<String>(cervicalPosition);
    }
    if (!nullToAbsent || opkResult != null) {
      map['opk_result'] = Variable<String>(opkResult);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CycleDaysCompanion toCompanion(bool nullToAbsent) {
    return CycleDaysCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      date: Value(date),
      flowIntensity: flowIntensity == null && nullToAbsent
          ? const Value.absent()
          : Value(flowIntensity),
      spotting: Value(spotting),
      clotting: Value(clotting),
      symptomsJson: symptomsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(symptomsJson),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      cervicalMucus: cervicalMucus == null && nullToAbsent
          ? const Value.absent()
          : Value(cervicalMucus),
      cervicalPosition: cervicalPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(cervicalPosition),
      opkResult: opkResult == null && nullToAbsent
          ? const Value.absent()
          : Value(opkResult),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CycleDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleDay(
      id: serializer.fromJson<String>(json['id']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      flowIntensity: serializer.fromJson<int?>(json['flowIntensity']),
      spotting: serializer.fromJson<bool>(json['spotting']),
      clotting: serializer.fromJson<bool>(json['clotting']),
      symptomsJson: serializer.fromJson<String?>(json['symptomsJson']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      cervicalMucus: serializer.fromJson<String?>(json['cervicalMucus']),
      cervicalPosition: serializer.fromJson<String?>(json['cervicalPosition']),
      opkResult: serializer.fromJson<String?>(json['opkResult']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleId': serializer.toJson<String>(cycleId),
      'date': serializer.toJson<DateTime>(date),
      'flowIntensity': serializer.toJson<int?>(flowIntensity),
      'spotting': serializer.toJson<bool>(spotting),
      'clotting': serializer.toJson<bool>(clotting),
      'symptomsJson': serializer.toJson<String?>(symptomsJson),
      'temperature': serializer.toJson<double?>(temperature),
      'cervicalMucus': serializer.toJson<String?>(cervicalMucus),
      'cervicalPosition': serializer.toJson<String?>(cervicalPosition),
      'opkResult': serializer.toJson<String?>(opkResult),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CycleDay copyWith({
    String? id,
    String? cycleId,
    DateTime? date,
    Value<int?> flowIntensity = const Value.absent(),
    bool? spotting,
    bool? clotting,
    Value<String?> symptomsJson = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<String?> cervicalMucus = const Value.absent(),
    Value<String?> cervicalPosition = const Value.absent(),
    Value<String?> opkResult = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CycleDay(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    date: date ?? this.date,
    flowIntensity: flowIntensity.present
        ? flowIntensity.value
        : this.flowIntensity,
    spotting: spotting ?? this.spotting,
    clotting: clotting ?? this.clotting,
    symptomsJson: symptomsJson.present ? symptomsJson.value : this.symptomsJson,
    temperature: temperature.present ? temperature.value : this.temperature,
    cervicalMucus: cervicalMucus.present
        ? cervicalMucus.value
        : this.cervicalMucus,
    cervicalPosition: cervicalPosition.present
        ? cervicalPosition.value
        : this.cervicalPosition,
    opkResult: opkResult.present ? opkResult.value : this.opkResult,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CycleDay copyWithCompanion(CycleDaysCompanion data) {
    return CycleDay(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      date: data.date.present ? data.date.value : this.date,
      flowIntensity: data.flowIntensity.present
          ? data.flowIntensity.value
          : this.flowIntensity,
      spotting: data.spotting.present ? data.spotting.value : this.spotting,
      clotting: data.clotting.present ? data.clotting.value : this.clotting,
      symptomsJson: data.symptomsJson.present
          ? data.symptomsJson.value
          : this.symptomsJson,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      cervicalMucus: data.cervicalMucus.present
          ? data.cervicalMucus.value
          : this.cervicalMucus,
      cervicalPosition: data.cervicalPosition.present
          ? data.cervicalPosition.value
          : this.cervicalPosition,
      opkResult: data.opkResult.present ? data.opkResult.value : this.opkResult,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleDay(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('spotting: $spotting, ')
          ..write('clotting: $clotting, ')
          ..write('symptomsJson: $symptomsJson, ')
          ..write('temperature: $temperature, ')
          ..write('cervicalMucus: $cervicalMucus, ')
          ..write('cervicalPosition: $cervicalPosition, ')
          ..write('opkResult: $opkResult, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleId,
    date,
    flowIntensity,
    spotting,
    clotting,
    symptomsJson,
    temperature,
    cervicalMucus,
    cervicalPosition,
    opkResult,
    notes,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleDay &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.date == this.date &&
          other.flowIntensity == this.flowIntensity &&
          other.spotting == this.spotting &&
          other.clotting == this.clotting &&
          other.symptomsJson == this.symptomsJson &&
          other.temperature == this.temperature &&
          other.cervicalMucus == this.cervicalMucus &&
          other.cervicalPosition == this.cervicalPosition &&
          other.opkResult == this.opkResult &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CycleDaysCompanion extends UpdateCompanion<CycleDay> {
  final Value<String> id;
  final Value<String> cycleId;
  final Value<DateTime> date;
  final Value<int?> flowIntensity;
  final Value<bool> spotting;
  final Value<bool> clotting;
  final Value<String?> symptomsJson;
  final Value<double?> temperature;
  final Value<String?> cervicalMucus;
  final Value<String?> cervicalPosition;
  final Value<String?> opkResult;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CycleDaysCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.date = const Value.absent(),
    this.flowIntensity = const Value.absent(),
    this.spotting = const Value.absent(),
    this.clotting = const Value.absent(),
    this.symptomsJson = const Value.absent(),
    this.temperature = const Value.absent(),
    this.cervicalMucus = const Value.absent(),
    this.cervicalPosition = const Value.absent(),
    this.opkResult = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CycleDaysCompanion.insert({
    required String id,
    required String cycleId,
    required DateTime date,
    this.flowIntensity = const Value.absent(),
    this.spotting = const Value.absent(),
    this.clotting = const Value.absent(),
    this.symptomsJson = const Value.absent(),
    this.temperature = const Value.absent(),
    this.cervicalMucus = const Value.absent(),
    this.cervicalPosition = const Value.absent(),
    this.opkResult = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cycleId = Value(cycleId),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CycleDay> custom({
    Expression<String>? id,
    Expression<String>? cycleId,
    Expression<DateTime>? date,
    Expression<int>? flowIntensity,
    Expression<bool>? spotting,
    Expression<bool>? clotting,
    Expression<String>? symptomsJson,
    Expression<double>? temperature,
    Expression<String>? cervicalMucus,
    Expression<String>? cervicalPosition,
    Expression<String>? opkResult,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (date != null) 'date': date,
      if (flowIntensity != null) 'flow_intensity': flowIntensity,
      if (spotting != null) 'spotting': spotting,
      if (clotting != null) 'clotting': clotting,
      if (symptomsJson != null) 'symptoms_json': symptomsJson,
      if (temperature != null) 'temperature': temperature,
      if (cervicalMucus != null) 'cervical_mucus': cervicalMucus,
      if (cervicalPosition != null) 'cervical_position': cervicalPosition,
      if (opkResult != null) 'opk_result': opkResult,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CycleDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? cycleId,
    Value<DateTime>? date,
    Value<int?>? flowIntensity,
    Value<bool>? spotting,
    Value<bool>? clotting,
    Value<String?>? symptomsJson,
    Value<double?>? temperature,
    Value<String?>? cervicalMucus,
    Value<String?>? cervicalPosition,
    Value<String?>? opkResult,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CycleDaysCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      date: date ?? this.date,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      spotting: spotting ?? this.spotting,
      clotting: clotting ?? this.clotting,
      symptomsJson: symptomsJson ?? this.symptomsJson,
      temperature: temperature ?? this.temperature,
      cervicalMucus: cervicalMucus ?? this.cervicalMucus,
      cervicalPosition: cervicalPosition ?? this.cervicalPosition,
      opkResult: opkResult ?? this.opkResult,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (flowIntensity.present) {
      map['flow_intensity'] = Variable<int>(flowIntensity.value);
    }
    if (spotting.present) {
      map['spotting'] = Variable<bool>(spotting.value);
    }
    if (clotting.present) {
      map['clotting'] = Variable<bool>(clotting.value);
    }
    if (symptomsJson.present) {
      map['symptoms_json'] = Variable<String>(symptomsJson.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (cervicalMucus.present) {
      map['cervical_mucus'] = Variable<String>(cervicalMucus.value);
    }
    if (cervicalPosition.present) {
      map['cervical_position'] = Variable<String>(cervicalPosition.value);
    }
    if (opkResult.present) {
      map['opk_result'] = Variable<String>(opkResult.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CycleDaysCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('spotting: $spotting, ')
          ..write('clotting: $clotting, ')
          ..write('symptomsJson: $symptomsJson, ')
          ..write('temperature: $temperature, ')
          ..write('cervicalMucus: $cervicalMucus, ')
          ..write('cervicalPosition: $cervicalPosition, ')
          ..write('opkResult: $opkResult, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomsTable extends Symptoms with TableInfo<$SymptomsTable, Symptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _predefinedOptionsMeta = const VerificationMeta(
    'predefinedOptions',
  );
  @override
  late final GeneratedColumn<String> predefinedOptions =
      GeneratedColumn<String>(
        'predefined_options',
        aliasedName,
        false,
        type: DriftSqlType.string,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    iconName,
    colorHex,
    predefinedOptions,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Symptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('predefined_options')) {
      context.handle(
        _predefinedOptionsMeta,
        predefinedOptions.isAcceptableOrUnknown(
          data['predefined_options']!,
          _predefinedOptionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predefinedOptionsMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Symptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Symptom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      predefinedOptions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}predefined_options'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SymptomsTable createAlias(String alias) {
    return $SymptomsTable(attachedDatabase, alias);
  }
}

class Symptom extends DataClass implements Insertable<Symptom> {
  final String id;
  final String name;
  final String category;
  final String iconName;
  final String colorHex;
  final String predefinedOptions;
  final bool isActive;
  final DateTime createdAt;
  const Symptom({
    required this.id,
    required this.name,
    required this.category,
    required this.iconName,
    required this.colorHex,
    required this.predefinedOptions,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['predefined_options'] = Variable<String>(predefinedOptions);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SymptomsCompanion toCompanion(bool nullToAbsent) {
    return SymptomsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      predefinedOptions: Value(predefinedOptions),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Symptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Symptom(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      predefinedOptions: serializer.fromJson<String>(json['predefinedOptions']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'predefinedOptions': serializer.toJson<String>(predefinedOptions),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Symptom copyWith({
    String? id,
    String? name,
    String? category,
    String? iconName,
    String? colorHex,
    String? predefinedOptions,
    bool? isActive,
    DateTime? createdAt,
  }) => Symptom(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    iconName: iconName ?? this.iconName,
    colorHex: colorHex ?? this.colorHex,
    predefinedOptions: predefinedOptions ?? this.predefinedOptions,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Symptom copyWithCompanion(SymptomsCompanion data) {
    return Symptom(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      predefinedOptions: data.predefinedOptions.present
          ? data.predefinedOptions.value
          : this.predefinedOptions,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Symptom(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('predefinedOptions: $predefinedOptions, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    iconName,
    colorHex,
    predefinedOptions,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Symptom &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.predefinedOptions == this.predefinedOptions &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class SymptomsCompanion extends UpdateCompanion<Symptom> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<String> predefinedOptions;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SymptomsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.predefinedOptions = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required String iconName,
    required String colorHex,
    required String predefinedOptions,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       iconName = Value(iconName),
       colorHex = Value(colorHex),
       predefinedOptions = Value(predefinedOptions),
       createdAt = Value(createdAt);
  static Insertable<Symptom> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<String>? predefinedOptions,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (predefinedOptions != null) 'predefined_options': predefinedOptions,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? iconName,
    Value<String>? colorHex,
    Value<String>? predefinedOptions,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SymptomsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      predefinedOptions: predefinedOptions ?? this.predefinedOptions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (predefinedOptions.present) {
      map['predefined_options'] = Variable<String>(predefinedOptions.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('predefinedOptions: $predefinedOptions, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomLogsTable extends SymptomLogs
    with TableInfo<$SymptomLogsTable, SymptomLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleDayIdMeta = const VerificationMeta(
    'cycleDayId',
  );
  @override
  late final GeneratedColumn<String> cycleDayId = GeneratedColumn<String>(
    'cycle_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycle_days (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES symptoms (id)',
    ),
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleDayId,
    date,
    symptomId,
    severity,
    timestamp,
    notes,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_day_id')) {
      context.handle(
        _cycleDayIdMeta,
        cycleDayId.isAcceptableOrUnknown(
          data['cycle_day_id']!,
          _cycleDayIdMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_day_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SymptomLogsTable createAlias(String alias) {
    return $SymptomLogsTable(attachedDatabase, alias);
  }
}

class SymptomLog extends DataClass implements Insertable<SymptomLog> {
  final String id;
  final String? cycleDayId;
  final DateTime date;
  final String symptomId;
  final int severity;
  final DateTime timestamp;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  const SymptomLog({
    required this.id,
    this.cycleDayId,
    required this.date,
    required this.symptomId,
    required this.severity,
    required this.timestamp,
    this.notes,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || cycleDayId != null) {
      map['cycle_day_id'] = Variable<String>(cycleDayId);
    }
    map['date'] = Variable<DateTime>(date);
    map['symptom_id'] = Variable<String>(symptomId);
    map['severity'] = Variable<int>(severity);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SymptomLogsCompanion toCompanion(bool nullToAbsent) {
    return SymptomLogsCompanion(
      id: Value(id),
      cycleDayId: cycleDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleDayId),
      date: Value(date),
      symptomId: Value(symptomId),
      severity: Value(severity),
      timestamp: Value(timestamp),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory SymptomLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomLog(
      id: serializer.fromJson<String>(json['id']),
      cycleDayId: serializer.fromJson<String?>(json['cycleDayId']),
      date: serializer.fromJson<DateTime>(json['date']),
      symptomId: serializer.fromJson<String>(json['symptomId']),
      severity: serializer.fromJson<int>(json['severity']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleDayId': serializer.toJson<String?>(cycleDayId),
      'date': serializer.toJson<DateTime>(date),
      'symptomId': serializer.toJson<String>(symptomId),
      'severity': serializer.toJson<int>(severity),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SymptomLog copyWith({
    String? id,
    Value<String?> cycleDayId = const Value.absent(),
    DateTime? date,
    String? symptomId,
    int? severity,
    DateTime? timestamp,
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => SymptomLog(
    id: id ?? this.id,
    cycleDayId: cycleDayId.present ? cycleDayId.value : this.cycleDayId,
    date: date ?? this.date,
    symptomId: symptomId ?? this.symptomId,
    severity: severity ?? this.severity,
    timestamp: timestamp ?? this.timestamp,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  SymptomLog copyWithCompanion(SymptomLogsCompanion data) {
    return SymptomLog(
      id: data.id.present ? data.id.value : this.id,
      cycleDayId: data.cycleDayId.present
          ? data.cycleDayId.value
          : this.cycleDayId,
      date: data.date.present ? data.date.value : this.date,
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      severity: data.severity.present ? data.severity.value : this.severity,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLog(')
          ..write('id: $id, ')
          ..write('cycleDayId: $cycleDayId, ')
          ..write('date: $date, ')
          ..write('symptomId: $symptomId, ')
          ..write('severity: $severity, ')
          ..write('timestamp: $timestamp, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleDayId,
    date,
    symptomId,
    severity,
    timestamp,
    notes,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomLog &&
          other.id == this.id &&
          other.cycleDayId == this.cycleDayId &&
          other.date == this.date &&
          other.symptomId == this.symptomId &&
          other.severity == this.severity &&
          other.timestamp == this.timestamp &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class SymptomLogsCompanion extends UpdateCompanion<SymptomLog> {
  final Value<String> id;
  final Value<String?> cycleDayId;
  final Value<DateTime> date;
  final Value<String> symptomId;
  final Value<int> severity;
  final Value<DateTime> timestamp;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SymptomLogsCompanion({
    this.id = const Value.absent(),
    this.cycleDayId = const Value.absent(),
    this.date = const Value.absent(),
    this.symptomId = const Value.absent(),
    this.severity = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomLogsCompanion.insert({
    required String id,
    this.cycleDayId = const Value.absent(),
    required DateTime date,
    required String symptomId,
    required int severity,
    required DateTime timestamp,
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       symptomId = Value(symptomId),
       severity = Value(severity),
       timestamp = Value(timestamp),
       createdAt = Value(createdAt);
  static Insertable<SymptomLog> custom({
    Expression<String>? id,
    Expression<String>? cycleDayId,
    Expression<DateTime>? date,
    Expression<String>? symptomId,
    Expression<int>? severity,
    Expression<DateTime>? timestamp,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleDayId != null) 'cycle_day_id': cycleDayId,
      if (date != null) 'date': date,
      if (symptomId != null) 'symptom_id': symptomId,
      if (severity != null) 'severity': severity,
      if (timestamp != null) 'timestamp': timestamp,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomLogsCompanion copyWith({
    Value<String>? id,
    Value<String?>? cycleDayId,
    Value<DateTime>? date,
    Value<String>? symptomId,
    Value<int>? severity,
    Value<DateTime>? timestamp,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SymptomLogsCompanion(
      id: id ?? this.id,
      cycleDayId: cycleDayId ?? this.cycleDayId,
      date: date ?? this.date,
      symptomId: symptomId ?? this.symptomId,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleDayId.present) {
      map['cycle_day_id'] = Variable<String>(cycleDayId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLogsCompanion(')
          ..write('id: $id, ')
          ..write('cycleDayId: $cycleDayId, ')
          ..write('date: $date, ')
          ..write('symptomId: $symptomId, ')
          ..write('severity: $severity, ')
          ..write('timestamp: $timestamp, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BbtRecordsTable extends BbtRecords
    with TableInfo<$BbtRecordsTable, BbtRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BbtRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementMethodMeta = const VerificationMeta(
    'measurementMethod',
  );
  @override
  late final GeneratedColumn<String> measurementMethod =
      GeneratedColumn<String>(
        'measurement_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _timeOfDayMeta = const VerificationMeta(
    'timeOfDay',
  );
  @override
  late final GeneratedColumn<String> timeOfDay = GeneratedColumn<String>(
    'time_of_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEstimatedMeta = const VerificationMeta(
    'isEstimated',
  );
  @override
  late final GeneratedColumn<bool> isEstimated = GeneratedColumn<bool>(
    'is_estimated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_estimated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    date,
    temperature,
    measurementMethod,
    timeOfDay,
    isEstimated,
    notes,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bbt_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<BbtRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('measurement_method')) {
      context.handle(
        _measurementMethodMeta,
        measurementMethod.isAcceptableOrUnknown(
          data['measurement_method']!,
          _measurementMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementMethodMeta);
    }
    if (data.containsKey('time_of_day')) {
      context.handle(
        _timeOfDayMeta,
        timeOfDay.isAcceptableOrUnknown(data['time_of_day']!, _timeOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_timeOfDayMeta);
    }
    if (data.containsKey('is_estimated')) {
      context.handle(
        _isEstimatedMeta,
        isEstimated.isAcceptableOrUnknown(
          data['is_estimated']!,
          _isEstimatedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BbtRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BbtRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      )!,
      measurementMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_method'],
      )!,
      timeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_day'],
      )!,
      isEstimated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_estimated'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BbtRecordsTable createAlias(String alias) {
    return $BbtRecordsTable(attachedDatabase, alias);
  }
}

class BbtRecord extends DataClass implements Insertable<BbtRecord> {
  final String id;
  final String userId;
  final DateTime date;
  final double temperature;
  final String measurementMethod;
  final String timeOfDay;
  final bool isEstimated;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  const BbtRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.temperature,
    required this.measurementMethod,
    required this.timeOfDay,
    required this.isEstimated,
    this.notes,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['temperature'] = Variable<double>(temperature);
    map['measurement_method'] = Variable<String>(measurementMethod);
    map['time_of_day'] = Variable<String>(timeOfDay);
    map['is_estimated'] = Variable<bool>(isEstimated);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BbtRecordsCompanion toCompanion(bool nullToAbsent) {
    return BbtRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      temperature: Value(temperature),
      measurementMethod: Value(measurementMethod),
      timeOfDay: Value(timeOfDay),
      isEstimated: Value(isEstimated),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory BbtRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BbtRecord(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      temperature: serializer.fromJson<double>(json['temperature']),
      measurementMethod: serializer.fromJson<String>(json['measurementMethod']),
      timeOfDay: serializer.fromJson<String>(json['timeOfDay']),
      isEstimated: serializer.fromJson<bool>(json['isEstimated']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'temperature': serializer.toJson<double>(temperature),
      'measurementMethod': serializer.toJson<String>(measurementMethod),
      'timeOfDay': serializer.toJson<String>(timeOfDay),
      'isEstimated': serializer.toJson<bool>(isEstimated),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BbtRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? temperature,
    String? measurementMethod,
    String? timeOfDay,
    bool? isEstimated,
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => BbtRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    temperature: temperature ?? this.temperature,
    measurementMethod: measurementMethod ?? this.measurementMethod,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    isEstimated: isEstimated ?? this.isEstimated,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  BbtRecord copyWithCompanion(BbtRecordsCompanion data) {
    return BbtRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      measurementMethod: data.measurementMethod.present
          ? data.measurementMethod.value
          : this.measurementMethod,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      isEstimated: data.isEstimated.present
          ? data.isEstimated.value
          : this.isEstimated,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BbtRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('temperature: $temperature, ')
          ..write('measurementMethod: $measurementMethod, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('isEstimated: $isEstimated, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    date,
    temperature,
    measurementMethod,
    timeOfDay,
    isEstimated,
    notes,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BbtRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.temperature == this.temperature &&
          other.measurementMethod == this.measurementMethod &&
          other.timeOfDay == this.timeOfDay &&
          other.isEstimated == this.isEstimated &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class BbtRecordsCompanion extends UpdateCompanion<BbtRecord> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<double> temperature;
  final Value<String> measurementMethod;
  final Value<String> timeOfDay;
  final Value<bool> isEstimated;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BbtRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.temperature = const Value.absent(),
    this.measurementMethod = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.isEstimated = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BbtRecordsCompanion.insert({
    required String id,
    required String userId,
    required DateTime date,
    required double temperature,
    required String measurementMethod,
    required String timeOfDay,
    this.isEstimated = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       date = Value(date),
       temperature = Value(temperature),
       measurementMethod = Value(measurementMethod),
       timeOfDay = Value(timeOfDay),
       createdAt = Value(createdAt);
  static Insertable<BbtRecord> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<double>? temperature,
    Expression<String>? measurementMethod,
    Expression<String>? timeOfDay,
    Expression<bool>? isEstimated,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (temperature != null) 'temperature': temperature,
      if (measurementMethod != null) 'measurement_method': measurementMethod,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (isEstimated != null) 'is_estimated': isEstimated,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BbtRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? date,
    Value<double>? temperature,
    Value<String>? measurementMethod,
    Value<String>? timeOfDay,
    Value<bool>? isEstimated,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BbtRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      temperature: temperature ?? this.temperature,
      measurementMethod: measurementMethod ?? this.measurementMethod,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      isEstimated: isEstimated ?? this.isEstimated,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (measurementMethod.present) {
      map['measurement_method'] = Variable<String>(measurementMethod.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<String>(timeOfDay.value);
    }
    if (isEstimated.present) {
      map['is_estimated'] = Variable<bool>(isEstimated.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BbtRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('temperature: $temperature, ')
          ..write('measurementMethod: $measurementMethod, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('isEstimated: $isEstimated, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OvulationTestsTable extends OvulationTests
    with TableInfo<$OvulationTestsTable, OvulationTest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OvulationTestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeOfDayMeta = const VerificationMeta(
    'timeOfDay',
  );
  @override
  late final GeneratedColumn<String> timeOfDay = GeneratedColumn<String>(
    'time_of_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    date,
    result,
    timeOfDay,
    brand,
    photoPath,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ovulation_tests';
  @override
  VerificationContext validateIntegrity(
    Insertable<OvulationTest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('time_of_day')) {
      context.handle(
        _timeOfDayMeta,
        timeOfDay.isAcceptableOrUnknown(data['time_of_day']!, _timeOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_timeOfDayMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OvulationTest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OvulationTest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      timeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_day'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OvulationTestsTable createAlias(String alias) {
    return $OvulationTestsTable(attachedDatabase, alias);
  }
}

class OvulationTest extends DataClass implements Insertable<OvulationTest> {
  final String id;
  final String userId;
  final DateTime date;
  final String result;
  final String timeOfDay;
  final String? brand;
  final String? photoPath;
  final bool isSynced;
  final DateTime createdAt;
  const OvulationTest({
    required this.id,
    required this.userId,
    required this.date,
    required this.result,
    required this.timeOfDay,
    this.brand,
    this.photoPath,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['result'] = Variable<String>(result);
    map['time_of_day'] = Variable<String>(timeOfDay);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OvulationTestsCompanion toCompanion(bool nullToAbsent) {
    return OvulationTestsCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      result: Value(result),
      timeOfDay: Value(timeOfDay),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory OvulationTest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OvulationTest(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      result: serializer.fromJson<String>(json['result']),
      timeOfDay: serializer.fromJson<String>(json['timeOfDay']),
      brand: serializer.fromJson<String?>(json['brand']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'result': serializer.toJson<String>(result),
      'timeOfDay': serializer.toJson<String>(timeOfDay),
      'brand': serializer.toJson<String?>(brand),
      'photoPath': serializer.toJson<String?>(photoPath),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OvulationTest copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? result,
    String? timeOfDay,
    Value<String?> brand = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => OvulationTest(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    result: result ?? this.result,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    brand: brand.present ? brand.value : this.brand,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  OvulationTest copyWithCompanion(OvulationTestsCompanion data) {
    return OvulationTest(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      result: data.result.present ? data.result.value : this.result,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      brand: data.brand.present ? data.brand.value : this.brand,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OvulationTest(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('result: $result, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('brand: $brand, ')
          ..write('photoPath: $photoPath, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    date,
    result,
    timeOfDay,
    brand,
    photoPath,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OvulationTest &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.result == this.result &&
          other.timeOfDay == this.timeOfDay &&
          other.brand == this.brand &&
          other.photoPath == this.photoPath &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class OvulationTestsCompanion extends UpdateCompanion<OvulationTest> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<String> result;
  final Value<String> timeOfDay;
  final Value<String?> brand;
  final Value<String?> photoPath;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OvulationTestsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.result = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.brand = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OvulationTestsCompanion.insert({
    required String id,
    required String userId,
    required DateTime date,
    required String result,
    required String timeOfDay,
    this.brand = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       date = Value(date),
       result = Value(result),
       timeOfDay = Value(timeOfDay),
       createdAt = Value(createdAt);
  static Insertable<OvulationTest> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<String>? result,
    Expression<String>? timeOfDay,
    Expression<String>? brand,
    Expression<String>? photoPath,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (result != null) 'result': result,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (brand != null) 'brand': brand,
      if (photoPath != null) 'photo_path': photoPath,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OvulationTestsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? date,
    Value<String>? result,
    Value<String>? timeOfDay,
    Value<String?>? brand,
    Value<String?>? photoPath,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OvulationTestsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      result: result ?? this.result,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      brand: brand ?? this.brand,
      photoPath: photoPath ?? this.photoPath,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<String>(timeOfDay.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OvulationTestsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('result: $result, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('brand: $brand, ')
          ..write('photoPath: $photoPath, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CervicalMucusObservationsTable extends CervicalMucusObservations
    with TableInfo<$CervicalMucusObservationsTable, CervicalMucusObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CervicalMucusObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleDayIdMeta = const VerificationMeta(
    'cycleDayId',
  );
  @override
  late final GeneratedColumn<String> cycleDayId = GeneratedColumn<String>(
    'cycle_day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycle_days (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consistencyMeta = const VerificationMeta(
    'consistency',
  );
  @override
  late final GeneratedColumn<String> consistency = GeneratedColumn<String>(
    'consistency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleDayId,
    type,
    consistency,
    color,
    amount,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cervical_mucus_observations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CervicalMucusObservation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_day_id')) {
      context.handle(
        _cycleDayIdMeta,
        cycleDayId.isAcceptableOrUnknown(
          data['cycle_day_id']!,
          _cycleDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cycleDayIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('consistency')) {
      context.handle(
        _consistencyMeta,
        consistency.isAcceptableOrUnknown(
          data['consistency']!,
          _consistencyMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CervicalMucusObservation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CervicalMucusObservation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_day_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      consistency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consistency'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CervicalMucusObservationsTable createAlias(String alias) {
    return $CervicalMucusObservationsTable(attachedDatabase, alias);
  }
}

class CervicalMucusObservation extends DataClass
    implements Insertable<CervicalMucusObservation> {
  final String id;
  final String cycleDayId;
  final String type;
  final String? consistency;
  final String? color;
  final String amount;
  final bool isSynced;
  final DateTime createdAt;
  const CervicalMucusObservation({
    required this.id,
    required this.cycleDayId,
    required this.type,
    this.consistency,
    this.color,
    required this.amount,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cycle_day_id'] = Variable<String>(cycleDayId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || consistency != null) {
      map['consistency'] = Variable<String>(consistency);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['amount'] = Variable<String>(amount);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CervicalMucusObservationsCompanion toCompanion(bool nullToAbsent) {
    return CervicalMucusObservationsCompanion(
      id: Value(id),
      cycleDayId: Value(cycleDayId),
      type: Value(type),
      consistency: consistency == null && nullToAbsent
          ? const Value.absent()
          : Value(consistency),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      amount: Value(amount),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory CervicalMucusObservation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CervicalMucusObservation(
      id: serializer.fromJson<String>(json['id']),
      cycleDayId: serializer.fromJson<String>(json['cycleDayId']),
      type: serializer.fromJson<String>(json['type']),
      consistency: serializer.fromJson<String?>(json['consistency']),
      color: serializer.fromJson<String?>(json['color']),
      amount: serializer.fromJson<String>(json['amount']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleDayId': serializer.toJson<String>(cycleDayId),
      'type': serializer.toJson<String>(type),
      'consistency': serializer.toJson<String?>(consistency),
      'color': serializer.toJson<String?>(color),
      'amount': serializer.toJson<String>(amount),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CervicalMucusObservation copyWith({
    String? id,
    String? cycleDayId,
    String? type,
    Value<String?> consistency = const Value.absent(),
    Value<String?> color = const Value.absent(),
    String? amount,
    bool? isSynced,
    DateTime? createdAt,
  }) => CervicalMucusObservation(
    id: id ?? this.id,
    cycleDayId: cycleDayId ?? this.cycleDayId,
    type: type ?? this.type,
    consistency: consistency.present ? consistency.value : this.consistency,
    color: color.present ? color.value : this.color,
    amount: amount ?? this.amount,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  CervicalMucusObservation copyWithCompanion(
    CervicalMucusObservationsCompanion data,
  ) {
    return CervicalMucusObservation(
      id: data.id.present ? data.id.value : this.id,
      cycleDayId: data.cycleDayId.present
          ? data.cycleDayId.value
          : this.cycleDayId,
      type: data.type.present ? data.type.value : this.type,
      consistency: data.consistency.present
          ? data.consistency.value
          : this.consistency,
      color: data.color.present ? data.color.value : this.color,
      amount: data.amount.present ? data.amount.value : this.amount,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CervicalMucusObservation(')
          ..write('id: $id, ')
          ..write('cycleDayId: $cycleDayId, ')
          ..write('type: $type, ')
          ..write('consistency: $consistency, ')
          ..write('color: $color, ')
          ..write('amount: $amount, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleDayId,
    type,
    consistency,
    color,
    amount,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CervicalMucusObservation &&
          other.id == this.id &&
          other.cycleDayId == this.cycleDayId &&
          other.type == this.type &&
          other.consistency == this.consistency &&
          other.color == this.color &&
          other.amount == this.amount &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class CervicalMucusObservationsCompanion
    extends UpdateCompanion<CervicalMucusObservation> {
  final Value<String> id;
  final Value<String> cycleDayId;
  final Value<String> type;
  final Value<String?> consistency;
  final Value<String?> color;
  final Value<String> amount;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CervicalMucusObservationsCompanion({
    this.id = const Value.absent(),
    this.cycleDayId = const Value.absent(),
    this.type = const Value.absent(),
    this.consistency = const Value.absent(),
    this.color = const Value.absent(),
    this.amount = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CervicalMucusObservationsCompanion.insert({
    required String id,
    required String cycleDayId,
    required String type,
    this.consistency = const Value.absent(),
    this.color = const Value.absent(),
    required String amount,
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cycleDayId = Value(cycleDayId),
       type = Value(type),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<CervicalMucusObservation> custom({
    Expression<String>? id,
    Expression<String>? cycleDayId,
    Expression<String>? type,
    Expression<String>? consistency,
    Expression<String>? color,
    Expression<String>? amount,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleDayId != null) 'cycle_day_id': cycleDayId,
      if (type != null) 'type': type,
      if (consistency != null) 'consistency': consistency,
      if (color != null) 'color': color,
      if (amount != null) 'amount': amount,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CervicalMucusObservationsCompanion copyWith({
    Value<String>? id,
    Value<String>? cycleDayId,
    Value<String>? type,
    Value<String?>? consistency,
    Value<String?>? color,
    Value<String>? amount,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CervicalMucusObservationsCompanion(
      id: id ?? this.id,
      cycleDayId: cycleDayId ?? this.cycleDayId,
      type: type ?? this.type,
      consistency: consistency ?? this.consistency,
      color: color ?? this.color,
      amount: amount ?? this.amount,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleDayId.present) {
      map['cycle_day_id'] = Variable<String>(cycleDayId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (consistency.present) {
      map['consistency'] = Variable<String>(consistency.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CervicalMucusObservationsCompanion(')
          ..write('id: $id, ')
          ..write('cycleDayId: $cycleDayId, ')
          ..write('type: $type, ')
          ..write('consistency: $consistency, ')
          ..write('color: $color, ')
          ..write('amount: $amount, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PregnanciesTable extends Pregnancies
    with TableInfo<$PregnanciesTable, Pregnancy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PregnanciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conceptionDateMeta = const VerificationMeta(
    'conceptionDate',
  );
  @override
  late final GeneratedColumn<DateTime> conceptionDate =
      GeneratedColumn<DateTime>(
        'conception_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentWeekMeta = const VerificationMeta(
    'currentWeek',
  );
  @override
  late final GeneratedColumn<int> currentWeek = GeneratedColumn<int>(
    'current_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentTrimesterMeta = const VerificationMeta(
    'currentTrimester',
  );
  @override
  late final GeneratedColumn<int> currentTrimester = GeneratedColumn<int>(
    'current_trimester',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    conceptionDate,
    dueDate,
    currentWeek,
    currentTrimester,
    notes,
    isActive,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pregnancies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pregnancy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('conception_date')) {
      context.handle(
        _conceptionDateMeta,
        conceptionDate.isAcceptableOrUnknown(
          data['conception_date']!,
          _conceptionDateMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('current_week')) {
      context.handle(
        _currentWeekMeta,
        currentWeek.isAcceptableOrUnknown(
          data['current_week']!,
          _currentWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentWeekMeta);
    }
    if (data.containsKey('current_trimester')) {
      context.handle(
        _currentTrimesterMeta,
        currentTrimester.isAcceptableOrUnknown(
          data['current_trimester']!,
          _currentTrimesterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentTrimesterMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pregnancy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pregnancy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      conceptionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}conception_date'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      currentWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_week'],
      )!,
      currentTrimester: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_trimester'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PregnanciesTable createAlias(String alias) {
    return $PregnanciesTable(attachedDatabase, alias);
  }
}

class Pregnancy extends DataClass implements Insertable<Pregnancy> {
  final String id;
  final String userId;
  final DateTime? conceptionDate;
  final DateTime dueDate;
  final int currentWeek;
  final int currentTrimester;
  final String? notes;
  final bool isActive;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Pregnancy({
    required this.id,
    required this.userId,
    this.conceptionDate,
    required this.dueDate,
    required this.currentWeek,
    required this.currentTrimester,
    this.notes,
    required this.isActive,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || conceptionDate != null) {
      map['conception_date'] = Variable<DateTime>(conceptionDate);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    map['current_week'] = Variable<int>(currentWeek);
    map['current_trimester'] = Variable<int>(currentTrimester);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PregnanciesCompanion toCompanion(bool nullToAbsent) {
    return PregnanciesCompanion(
      id: Value(id),
      userId: Value(userId),
      conceptionDate: conceptionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(conceptionDate),
      dueDate: Value(dueDate),
      currentWeek: Value(currentWeek),
      currentTrimester: Value(currentTrimester),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Pregnancy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pregnancy(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      conceptionDate: serializer.fromJson<DateTime?>(json['conceptionDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      currentWeek: serializer.fromJson<int>(json['currentWeek']),
      currentTrimester: serializer.fromJson<int>(json['currentTrimester']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'conceptionDate': serializer.toJson<DateTime?>(conceptionDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'currentWeek': serializer.toJson<int>(currentWeek),
      'currentTrimester': serializer.toJson<int>(currentTrimester),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Pregnancy copyWith({
    String? id,
    String? userId,
    Value<DateTime?> conceptionDate = const Value.absent(),
    DateTime? dueDate,
    int? currentWeek,
    int? currentTrimester,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Pregnancy(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    conceptionDate: conceptionDate.present
        ? conceptionDate.value
        : this.conceptionDate,
    dueDate: dueDate ?? this.dueDate,
    currentWeek: currentWeek ?? this.currentWeek,
    currentTrimester: currentTrimester ?? this.currentTrimester,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Pregnancy copyWithCompanion(PregnanciesCompanion data) {
    return Pregnancy(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      conceptionDate: data.conceptionDate.present
          ? data.conceptionDate.value
          : this.conceptionDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      currentWeek: data.currentWeek.present
          ? data.currentWeek.value
          : this.currentWeek,
      currentTrimester: data.currentTrimester.present
          ? data.currentTrimester.value
          : this.currentTrimester,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pregnancy(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conceptionDate: $conceptionDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentTrimester: $currentTrimester, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    conceptionDate,
    dueDate,
    currentWeek,
    currentTrimester,
    notes,
    isActive,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pregnancy &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.conceptionDate == this.conceptionDate &&
          other.dueDate == this.dueDate &&
          other.currentWeek == this.currentWeek &&
          other.currentTrimester == this.currentTrimester &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PregnanciesCompanion extends UpdateCompanion<Pregnancy> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime?> conceptionDate;
  final Value<DateTime> dueDate;
  final Value<int> currentWeek;
  final Value<int> currentTrimester;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PregnanciesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.conceptionDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.currentWeek = const Value.absent(),
    this.currentTrimester = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PregnanciesCompanion.insert({
    required String id,
    required String userId,
    this.conceptionDate = const Value.absent(),
    required DateTime dueDate,
    required int currentWeek,
    required int currentTrimester,
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       dueDate = Value(dueDate),
       currentWeek = Value(currentWeek),
       currentTrimester = Value(currentTrimester),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Pregnancy> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? conceptionDate,
    Expression<DateTime>? dueDate,
    Expression<int>? currentWeek,
    Expression<int>? currentTrimester,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (conceptionDate != null) 'conception_date': conceptionDate,
      if (dueDate != null) 'due_date': dueDate,
      if (currentWeek != null) 'current_week': currentWeek,
      if (currentTrimester != null) 'current_trimester': currentTrimester,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PregnanciesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime?>? conceptionDate,
    Value<DateTime>? dueDate,
    Value<int>? currentWeek,
    Value<int>? currentTrimester,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PregnanciesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      conceptionDate: conceptionDate ?? this.conceptionDate,
      dueDate: dueDate ?? this.dueDate,
      currentWeek: currentWeek ?? this.currentWeek,
      currentTrimester: currentTrimester ?? this.currentTrimester,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (conceptionDate.present) {
      map['conception_date'] = Variable<DateTime>(conceptionDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (currentWeek.present) {
      map['current_week'] = Variable<int>(currentWeek.value);
    }
    if (currentTrimester.present) {
      map['current_trimester'] = Variable<int>(currentTrimester.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PregnanciesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conceptionDate: $conceptionDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentTrimester: $currentTrimester, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FetalMeasurementsTable extends FetalMeasurements
    with TableInfo<$FetalMeasurementsTable, FetalMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FetalMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pregnancyIdMeta = const VerificationMeta(
    'pregnancyId',
  );
  @override
  late final GeneratedColumn<String> pregnancyId = GeneratedColumn<String>(
    'pregnancy_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pregnancies (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodPressureSystolicMeta =
      const VerificationMeta('bloodPressureSystolic');
  @override
  late final GeneratedColumn<int> bloodPressureSystolic = GeneratedColumn<int>(
    'blood_pressure_systolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodPressureDiastolicMeta =
      const VerificationMeta('bloodPressureDiastolic');
  @override
  late final GeneratedColumn<int> bloodPressureDiastolic = GeneratedColumn<int>(
    'blood_pressure_diastolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _glucoseLevelMeta = const VerificationMeta(
    'glucoseLevel',
  );
  @override
  late final GeneratedColumn<double> glucoseLevel = GeneratedColumn<double>(
    'glucose_level',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kicksCountMeta = const VerificationMeta(
    'kicksCount',
  );
  @override
  late final GeneratedColumn<int> kicksCount = GeneratedColumn<int>(
    'kicks_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractionsJsonMeta = const VerificationMeta(
    'contractionsJson',
  );
  @override
  late final GeneratedColumn<String> contractionsJson = GeneratedColumn<String>(
    'contractions_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pregnancyId,
    date,
    weight,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    glucoseLevel,
    kicksCount,
    contractionsJson,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fetal_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<FetalMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pregnancy_id')) {
      context.handle(
        _pregnancyIdMeta,
        pregnancyId.isAcceptableOrUnknown(
          data['pregnancy_id']!,
          _pregnancyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pregnancyIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('blood_pressure_systolic')) {
      context.handle(
        _bloodPressureSystolicMeta,
        bloodPressureSystolic.isAcceptableOrUnknown(
          data['blood_pressure_systolic']!,
          _bloodPressureSystolicMeta,
        ),
      );
    }
    if (data.containsKey('blood_pressure_diastolic')) {
      context.handle(
        _bloodPressureDiastolicMeta,
        bloodPressureDiastolic.isAcceptableOrUnknown(
          data['blood_pressure_diastolic']!,
          _bloodPressureDiastolicMeta,
        ),
      );
    }
    if (data.containsKey('glucose_level')) {
      context.handle(
        _glucoseLevelMeta,
        glucoseLevel.isAcceptableOrUnknown(
          data['glucose_level']!,
          _glucoseLevelMeta,
        ),
      );
    }
    if (data.containsKey('kicks_count')) {
      context.handle(
        _kicksCountMeta,
        kicksCount.isAcceptableOrUnknown(data['kicks_count']!, _kicksCountMeta),
      );
    }
    if (data.containsKey('contractions_json')) {
      context.handle(
        _contractionsJsonMeta,
        contractionsJson.isAcceptableOrUnknown(
          data['contractions_json']!,
          _contractionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FetalMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FetalMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pregnancyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pregnancy_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      bloodPressureSystolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}blood_pressure_systolic'],
      ),
      bloodPressureDiastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}blood_pressure_diastolic'],
      ),
      glucoseLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}glucose_level'],
      ),
      kicksCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kicks_count'],
      ),
      contractionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contractions_json'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FetalMeasurementsTable createAlias(String alias) {
    return $FetalMeasurementsTable(attachedDatabase, alias);
  }
}

class FetalMeasurement extends DataClass
    implements Insertable<FetalMeasurement> {
  final String id;
  final String pregnancyId;
  final DateTime date;
  final double? weight;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final double? glucoseLevel;
  final int? kicksCount;
  final String? contractionsJson;
  final bool isSynced;
  final DateTime createdAt;
  const FetalMeasurement({
    required this.id,
    required this.pregnancyId,
    required this.date,
    this.weight,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.glucoseLevel,
    this.kicksCount,
    this.contractionsJson,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pregnancy_id'] = Variable<String>(pregnancyId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || bloodPressureSystolic != null) {
      map['blood_pressure_systolic'] = Variable<int>(bloodPressureSystolic);
    }
    if (!nullToAbsent || bloodPressureDiastolic != null) {
      map['blood_pressure_diastolic'] = Variable<int>(bloodPressureDiastolic);
    }
    if (!nullToAbsent || glucoseLevel != null) {
      map['glucose_level'] = Variable<double>(glucoseLevel);
    }
    if (!nullToAbsent || kicksCount != null) {
      map['kicks_count'] = Variable<int>(kicksCount);
    }
    if (!nullToAbsent || contractionsJson != null) {
      map['contractions_json'] = Variable<String>(contractionsJson);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FetalMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return FetalMeasurementsCompanion(
      id: Value(id),
      pregnancyId: Value(pregnancyId),
      date: Value(date),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      bloodPressureSystolic: bloodPressureSystolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodPressureSystolic),
      bloodPressureDiastolic: bloodPressureDiastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodPressureDiastolic),
      glucoseLevel: glucoseLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(glucoseLevel),
      kicksCount: kicksCount == null && nullToAbsent
          ? const Value.absent()
          : Value(kicksCount),
      contractionsJson: contractionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(contractionsJson),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory FetalMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FetalMeasurement(
      id: serializer.fromJson<String>(json['id']),
      pregnancyId: serializer.fromJson<String>(json['pregnancyId']),
      date: serializer.fromJson<DateTime>(json['date']),
      weight: serializer.fromJson<double?>(json['weight']),
      bloodPressureSystolic: serializer.fromJson<int?>(
        json['bloodPressureSystolic'],
      ),
      bloodPressureDiastolic: serializer.fromJson<int?>(
        json['bloodPressureDiastolic'],
      ),
      glucoseLevel: serializer.fromJson<double?>(json['glucoseLevel']),
      kicksCount: serializer.fromJson<int?>(json['kicksCount']),
      contractionsJson: serializer.fromJson<String?>(json['contractionsJson']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pregnancyId': serializer.toJson<String>(pregnancyId),
      'date': serializer.toJson<DateTime>(date),
      'weight': serializer.toJson<double?>(weight),
      'bloodPressureSystolic': serializer.toJson<int?>(bloodPressureSystolic),
      'bloodPressureDiastolic': serializer.toJson<int?>(bloodPressureDiastolic),
      'glucoseLevel': serializer.toJson<double?>(glucoseLevel),
      'kicksCount': serializer.toJson<int?>(kicksCount),
      'contractionsJson': serializer.toJson<String?>(contractionsJson),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FetalMeasurement copyWith({
    String? id,
    String? pregnancyId,
    DateTime? date,
    Value<double?> weight = const Value.absent(),
    Value<int?> bloodPressureSystolic = const Value.absent(),
    Value<int?> bloodPressureDiastolic = const Value.absent(),
    Value<double?> glucoseLevel = const Value.absent(),
    Value<int?> kicksCount = const Value.absent(),
    Value<String?> contractionsJson = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => FetalMeasurement(
    id: id ?? this.id,
    pregnancyId: pregnancyId ?? this.pregnancyId,
    date: date ?? this.date,
    weight: weight.present ? weight.value : this.weight,
    bloodPressureSystolic: bloodPressureSystolic.present
        ? bloodPressureSystolic.value
        : this.bloodPressureSystolic,
    bloodPressureDiastolic: bloodPressureDiastolic.present
        ? bloodPressureDiastolic.value
        : this.bloodPressureDiastolic,
    glucoseLevel: glucoseLevel.present ? glucoseLevel.value : this.glucoseLevel,
    kicksCount: kicksCount.present ? kicksCount.value : this.kicksCount,
    contractionsJson: contractionsJson.present
        ? contractionsJson.value
        : this.contractionsJson,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  FetalMeasurement copyWithCompanion(FetalMeasurementsCompanion data) {
    return FetalMeasurement(
      id: data.id.present ? data.id.value : this.id,
      pregnancyId: data.pregnancyId.present
          ? data.pregnancyId.value
          : this.pregnancyId,
      date: data.date.present ? data.date.value : this.date,
      weight: data.weight.present ? data.weight.value : this.weight,
      bloodPressureSystolic: data.bloodPressureSystolic.present
          ? data.bloodPressureSystolic.value
          : this.bloodPressureSystolic,
      bloodPressureDiastolic: data.bloodPressureDiastolic.present
          ? data.bloodPressureDiastolic.value
          : this.bloodPressureDiastolic,
      glucoseLevel: data.glucoseLevel.present
          ? data.glucoseLevel.value
          : this.glucoseLevel,
      kicksCount: data.kicksCount.present
          ? data.kicksCount.value
          : this.kicksCount,
      contractionsJson: data.contractionsJson.present
          ? data.contractionsJson.value
          : this.contractionsJson,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FetalMeasurement(')
          ..write('id: $id, ')
          ..write('pregnancyId: $pregnancyId, ')
          ..write('date: $date, ')
          ..write('weight: $weight, ')
          ..write('bloodPressureSystolic: $bloodPressureSystolic, ')
          ..write('bloodPressureDiastolic: $bloodPressureDiastolic, ')
          ..write('glucoseLevel: $glucoseLevel, ')
          ..write('kicksCount: $kicksCount, ')
          ..write('contractionsJson: $contractionsJson, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pregnancyId,
    date,
    weight,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    glucoseLevel,
    kicksCount,
    contractionsJson,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FetalMeasurement &&
          other.id == this.id &&
          other.pregnancyId == this.pregnancyId &&
          other.date == this.date &&
          other.weight == this.weight &&
          other.bloodPressureSystolic == this.bloodPressureSystolic &&
          other.bloodPressureDiastolic == this.bloodPressureDiastolic &&
          other.glucoseLevel == this.glucoseLevel &&
          other.kicksCount == this.kicksCount &&
          other.contractionsJson == this.contractionsJson &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class FetalMeasurementsCompanion extends UpdateCompanion<FetalMeasurement> {
  final Value<String> id;
  final Value<String> pregnancyId;
  final Value<DateTime> date;
  final Value<double?> weight;
  final Value<int?> bloodPressureSystolic;
  final Value<int?> bloodPressureDiastolic;
  final Value<double?> glucoseLevel;
  final Value<int?> kicksCount;
  final Value<String?> contractionsJson;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FetalMeasurementsCompanion({
    this.id = const Value.absent(),
    this.pregnancyId = const Value.absent(),
    this.date = const Value.absent(),
    this.weight = const Value.absent(),
    this.bloodPressureSystolic = const Value.absent(),
    this.bloodPressureDiastolic = const Value.absent(),
    this.glucoseLevel = const Value.absent(),
    this.kicksCount = const Value.absent(),
    this.contractionsJson = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FetalMeasurementsCompanion.insert({
    required String id,
    required String pregnancyId,
    required DateTime date,
    this.weight = const Value.absent(),
    this.bloodPressureSystolic = const Value.absent(),
    this.bloodPressureDiastolic = const Value.absent(),
    this.glucoseLevel = const Value.absent(),
    this.kicksCount = const Value.absent(),
    this.contractionsJson = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pregnancyId = Value(pregnancyId),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<FetalMeasurement> custom({
    Expression<String>? id,
    Expression<String>? pregnancyId,
    Expression<DateTime>? date,
    Expression<double>? weight,
    Expression<int>? bloodPressureSystolic,
    Expression<int>? bloodPressureDiastolic,
    Expression<double>? glucoseLevel,
    Expression<int>? kicksCount,
    Expression<String>? contractionsJson,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pregnancyId != null) 'pregnancy_id': pregnancyId,
      if (date != null) 'date': date,
      if (weight != null) 'weight': weight,
      if (bloodPressureSystolic != null)
        'blood_pressure_systolic': bloodPressureSystolic,
      if (bloodPressureDiastolic != null)
        'blood_pressure_diastolic': bloodPressureDiastolic,
      if (glucoseLevel != null) 'glucose_level': glucoseLevel,
      if (kicksCount != null) 'kicks_count': kicksCount,
      if (contractionsJson != null) 'contractions_json': contractionsJson,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FetalMeasurementsCompanion copyWith({
    Value<String>? id,
    Value<String>? pregnancyId,
    Value<DateTime>? date,
    Value<double?>? weight,
    Value<int?>? bloodPressureSystolic,
    Value<int?>? bloodPressureDiastolic,
    Value<double?>? glucoseLevel,
    Value<int?>? kicksCount,
    Value<String?>? contractionsJson,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FetalMeasurementsCompanion(
      id: id ?? this.id,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bloodPressureSystolic:
          bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic:
          bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      glucoseLevel: glucoseLevel ?? this.glucoseLevel,
      kicksCount: kicksCount ?? this.kicksCount,
      contractionsJson: contractionsJson ?? this.contractionsJson,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pregnancyId.present) {
      map['pregnancy_id'] = Variable<String>(pregnancyId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (bloodPressureSystolic.present) {
      map['blood_pressure_systolic'] = Variable<int>(
        bloodPressureSystolic.value,
      );
    }
    if (bloodPressureDiastolic.present) {
      map['blood_pressure_diastolic'] = Variable<int>(
        bloodPressureDiastolic.value,
      );
    }
    if (glucoseLevel.present) {
      map['glucose_level'] = Variable<double>(glucoseLevel.value);
    }
    if (kicksCount.present) {
      map['kicks_count'] = Variable<int>(kicksCount.value);
    }
    if (contractionsJson.present) {
      map['contractions_json'] = Variable<String>(contractionsJson.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FetalMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('pregnancyId: $pregnancyId, ')
          ..write('date: $date, ')
          ..write('weight: $weight, ')
          ..write('bloodPressureSystolic: $bloodPressureSystolic, ')
          ..write('bloodPressureDiastolic: $bloodPressureDiastolic, ')
          ..write('glucoseLevel: $glucoseLevel, ')
          ..write('kicksCount: $kicksCount, ')
          ..write('contractionsJson: $contractionsJson, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleDayIdMeta = const VerificationMeta(
    'cycleDayId',
  );
  @override
  late final GeneratedColumn<String> cycleDayId = GeneratedColumn<String>(
    'cycle_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycle_days (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathsMeta = const VerificationMeta(
    'photoPaths',
  );
  @override
  late final GeneratedColumn<String> photoPaths = GeneratedColumn<String>(
    'photo_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voiceNotePathMeta = const VerificationMeta(
    'voiceNotePath',
  );
  @override
  late final GeneratedColumn<String> voiceNotePath = GeneratedColumn<String>(
    'voice_note_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodRatingMeta = const VerificationMeta(
    'moodRating',
  );
  @override
  late final GeneratedColumn<int> moodRating = GeneratedColumn<int>(
    'mood_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleDayId,
    date,
    title,
    content,
    photoPaths,
    voiceNotePath,
    moodRating,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_day_id')) {
      context.handle(
        _cycleDayIdMeta,
        cycleDayId.isAcceptableOrUnknown(
          data['cycle_day_id']!,
          _cycleDayIdMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('photo_paths')) {
      context.handle(
        _photoPathsMeta,
        photoPaths.isAcceptableOrUnknown(data['photo_paths']!, _photoPathsMeta),
      );
    }
    if (data.containsKey('voice_note_path')) {
      context.handle(
        _voiceNotePathMeta,
        voiceNotePath.isAcceptableOrUnknown(
          data['voice_note_path']!,
          _voiceNotePathMeta,
        ),
      );
    }
    if (data.containsKey('mood_rating')) {
      context.handle(
        _moodRatingMeta,
        moodRating.isAcceptableOrUnknown(data['mood_rating']!, _moodRatingMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_day_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      photoPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_paths'],
      ),
      voiceNotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_note_path'],
      ),
      moodRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_rating'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final String id;
  final String? cycleDayId;
  final DateTime date;
  final String? title;
  final String? content;
  final String? photoPaths;
  final String? voiceNotePath;
  final int? moodRating;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntry({
    required this.id,
    this.cycleDayId,
    required this.date,
    this.title,
    this.content,
    this.photoPaths,
    this.voiceNotePath,
    this.moodRating,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || cycleDayId != null) {
      map['cycle_day_id'] = Variable<String>(cycleDayId);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || photoPaths != null) {
      map['photo_paths'] = Variable<String>(photoPaths);
    }
    if (!nullToAbsent || voiceNotePath != null) {
      map['voice_note_path'] = Variable<String>(voiceNotePath);
    }
    if (!nullToAbsent || moodRating != null) {
      map['mood_rating'] = Variable<int>(moodRating);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      cycleDayId: cycleDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleDayId),
      date: Value(date),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      photoPaths: photoPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPaths),
      voiceNotePath: voiceNotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceNotePath),
      moodRating: moodRating == null && nullToAbsent
          ? const Value.absent()
          : Value(moodRating),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<String>(json['id']),
      cycleDayId: serializer.fromJson<String?>(json['cycleDayId']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      photoPaths: serializer.fromJson<String?>(json['photoPaths']),
      voiceNotePath: serializer.fromJson<String?>(json['voiceNotePath']),
      moodRating: serializer.fromJson<int?>(json['moodRating']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleDayId': serializer.toJson<String?>(cycleDayId),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String?>(content),
      'photoPaths': serializer.toJson<String?>(photoPaths),
      'voiceNotePath': serializer.toJson<String?>(voiceNotePath),
      'moodRating': serializer.toJson<int?>(moodRating),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntry copyWith({
    String? id,
    Value<String?> cycleDayId = const Value.absent(),
    DateTime? date,
    Value<String?> title = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<String?> photoPaths = const Value.absent(),
    Value<String?> voiceNotePath = const Value.absent(),
    Value<int?> moodRating = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JournalEntry(
    id: id ?? this.id,
    cycleDayId: cycleDayId.present ? cycleDayId.value : this.cycleDayId,
    date: date ?? this.date,
    title: title.present ? title.value : this.title,
    content: content.present ? content.value : this.content,
    photoPaths: photoPaths.present ? photoPaths.value : this.photoPaths,
    voiceNotePath: voiceNotePath.present
        ? voiceNotePath.value
        : this.voiceNotePath,
    moodRating: moodRating.present ? moodRating.value : this.moodRating,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      cycleDayId: data.cycleDayId.present
          ? data.cycleDayId.value
          : this.cycleDayId,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      photoPaths: data.photoPaths.present
          ? data.photoPaths.value
          : this.photoPaths,
      voiceNotePath: data.voiceNotePath.present
          ? data.voiceNotePath.value
          : this.voiceNotePath,
      moodRating: data.moodRating.present
          ? data.moodRating.value
          : this.moodRating,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('cycleDayId: $cycleDayId, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('moodRating: $moodRating, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleDayId,
    date,
    title,
    content,
    photoPaths,
    voiceNotePath,
    moodRating,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.cycleDayId == this.cycleDayId &&
          other.date == this.date &&
          other.title == this.title &&
          other.content == this.content &&
          other.photoPaths == this.photoPaths &&
          other.voiceNotePath == this.voiceNotePath &&
          other.moodRating == this.moodRating &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<String> id;
  final Value<String?> cycleDayId;
  final Value<DateTime> date;
  final Value<String?> title;
  final Value<String?> content;
  final Value<String?> photoPaths;
  final Value<String?> voiceNotePath;
  final Value<int?> moodRating;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.cycleDayId = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.moodRating = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    required String id,
    this.cycleDayId = const Value.absent(),
    required DateTime date,
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.moodRating = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<JournalEntry> custom({
    Expression<String>? id,
    Expression<String>? cycleDayId,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? photoPaths,
    Expression<String>? voiceNotePath,
    Expression<int>? moodRating,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleDayId != null) 'cycle_day_id': cycleDayId,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (voiceNotePath != null) 'voice_note_path': voiceNotePath,
      if (moodRating != null) 'mood_rating': moodRating,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? cycleDayId,
    Value<DateTime>? date,
    Value<String?>? title,
    Value<String?>? content,
    Value<String?>? photoPaths,
    Value<String?>? voiceNotePath,
    Value<int?>? moodRating,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      cycleDayId: cycleDayId ?? this.cycleDayId,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      photoPaths: photoPaths ?? this.photoPaths,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      moodRating: moodRating ?? this.moodRating,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleDayId.present) {
      map['cycle_day_id'] = Variable<String>(cycleDayId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(photoPaths.value);
    }
    if (voiceNotePath.present) {
      map['voice_note_path'] = Variable<String>(voiceNotePath.value);
    }
    if (moodRating.present) {
      map['mood_rating'] = Variable<int>(moodRating.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('cycleDayId: $cycleDayId, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('moodRating: $moodRating, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserConditionsTable extends UserConditions
    with TableInfo<$UserConditionsTable, UserCondition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionTypeMeta = const VerificationMeta(
    'conditionType',
  );
  @override
  late final GeneratedColumn<String> conditionType = GeneratedColumn<String>(
    'condition_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diagnosisDateMeta = const VerificationMeta(
    'diagnosisDate',
  );
  @override
  late final GeneratedColumn<DateTime> diagnosisDate =
      GeneratedColumn<DateTime>(
        'diagnosis_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    conditionType,
    diagnosisDate,
    isActive,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCondition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('condition_type')) {
      context.handle(
        _conditionTypeMeta,
        conditionType.isAcceptableOrUnknown(
          data['condition_type']!,
          _conditionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionTypeMeta);
    }
    if (data.containsKey('diagnosis_date')) {
      context.handle(
        _diagnosisDateMeta,
        diagnosisDate.isAcceptableOrUnknown(
          data['diagnosis_date']!,
          _diagnosisDateMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCondition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCondition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      conditionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_type'],
      )!,
      diagnosisDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diagnosis_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserConditionsTable createAlias(String alias) {
    return $UserConditionsTable(attachedDatabase, alias);
  }
}

class UserCondition extends DataClass implements Insertable<UserCondition> {
  final String id;
  final String userId;
  final String conditionType;
  final DateTime? diagnosisDate;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserCondition({
    required this.id,
    required this.userId,
    required this.conditionType,
    this.diagnosisDate,
    required this.isActive,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['condition_type'] = Variable<String>(conditionType);
    if (!nullToAbsent || diagnosisDate != null) {
      map['diagnosis_date'] = Variable<DateTime>(diagnosisDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserConditionsCompanion toCompanion(bool nullToAbsent) {
    return UserConditionsCompanion(
      id: Value(id),
      userId: Value(userId),
      conditionType: Value(conditionType),
      diagnosisDate: diagnosisDate == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosisDate),
      isActive: Value(isActive),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserCondition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCondition(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      conditionType: serializer.fromJson<String>(json['conditionType']),
      diagnosisDate: serializer.fromJson<DateTime?>(json['diagnosisDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'conditionType': serializer.toJson<String>(conditionType),
      'diagnosisDate': serializer.toJson<DateTime?>(diagnosisDate),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserCondition copyWith({
    String? id,
    String? userId,
    String? conditionType,
    Value<DateTime?> diagnosisDate = const Value.absent(),
    bool? isActive,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserCondition(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    conditionType: conditionType ?? this.conditionType,
    diagnosisDate: diagnosisDate.present
        ? diagnosisDate.value
        : this.diagnosisDate,
    isActive: isActive ?? this.isActive,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserCondition copyWithCompanion(UserConditionsCompanion data) {
    return UserCondition(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      conditionType: data.conditionType.present
          ? data.conditionType.value
          : this.conditionType,
      diagnosisDate: data.diagnosisDate.present
          ? data.diagnosisDate.value
          : this.diagnosisDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCondition(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conditionType: $conditionType, ')
          ..write('diagnosisDate: $diagnosisDate, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    conditionType,
    diagnosisDate,
    isActive,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCondition &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.conditionType == this.conditionType &&
          other.diagnosisDate == this.diagnosisDate &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserConditionsCompanion extends UpdateCompanion<UserCondition> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> conditionType;
  final Value<DateTime?> diagnosisDate;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserConditionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.conditionType = const Value.absent(),
    this.diagnosisDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserConditionsCompanion.insert({
    required String id,
    required String userId,
    required String conditionType,
    this.diagnosisDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       conditionType = Value(conditionType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserCondition> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? conditionType,
    Expression<DateTime>? diagnosisDate,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (conditionType != null) 'condition_type': conditionType,
      if (diagnosisDate != null) 'diagnosis_date': diagnosisDate,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserConditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? conditionType,
    Value<DateTime?>? diagnosisDate,
    Value<bool>? isActive,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserConditionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      conditionType: conditionType ?? this.conditionType,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (conditionType.present) {
      map['condition_type'] = Variable<String>(conditionType.value);
    }
    if (diagnosisDate.present) {
      map['diagnosis_date'] = Variable<DateTime>(diagnosisDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserConditionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conditionType: $conditionType, ')
          ..write('diagnosisDate: $diagnosisDate, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WearableSourcesTable extends WearableSources
    with TableInfo<$WearableSourcesTable, WearableSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WearableSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isConnectedMeta = const VerificationMeta(
    'isConnected',
  );
  @override
  late final GeneratedColumn<bool> isConnected = GeneratedColumn<bool>(
    'is_connected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_connected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settingsJsonMeta = const VerificationMeta(
    'settingsJson',
  );
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
    'settings_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sourceType,
    isConnected,
    lastSyncAt,
    settingsJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wearable_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<WearableSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('is_connected')) {
      context.handle(
        _isConnectedMeta,
        isConnected.isAcceptableOrUnknown(
          data['is_connected']!,
          _isConnectedMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('settings_json')) {
      context.handle(
        _settingsJsonMeta,
        settingsJson.isAcceptableOrUnknown(
          data['settings_json']!,
          _settingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WearableSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WearableSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      isConnected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_connected'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      settingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WearableSourcesTable createAlias(String alias) {
    return $WearableSourcesTable(attachedDatabase, alias);
  }
}

class WearableSource extends DataClass implements Insertable<WearableSource> {
  final String id;
  final String userId;
  final String sourceType;
  final bool isConnected;
  final DateTime? lastSyncAt;
  final String? settingsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WearableSource({
    required this.id,
    required this.userId,
    required this.sourceType,
    required this.isConnected,
    this.lastSyncAt,
    this.settingsJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['source_type'] = Variable<String>(sourceType);
    map['is_connected'] = Variable<bool>(isConnected);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    if (!nullToAbsent || settingsJson != null) {
      map['settings_json'] = Variable<String>(settingsJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WearableSourcesCompanion toCompanion(bool nullToAbsent) {
    return WearableSourcesCompanion(
      id: Value(id),
      userId: Value(userId),
      sourceType: Value(sourceType),
      isConnected: Value(isConnected),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      settingsJson: settingsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(settingsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WearableSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WearableSource(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      isConnected: serializer.fromJson<bool>(json['isConnected']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      settingsJson: serializer.fromJson<String?>(json['settingsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sourceType': serializer.toJson<String>(sourceType),
      'isConnected': serializer.toJson<bool>(isConnected),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'settingsJson': serializer.toJson<String?>(settingsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WearableSource copyWith({
    String? id,
    String? userId,
    String? sourceType,
    bool? isConnected,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    Value<String?> settingsJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WearableSource(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sourceType: sourceType ?? this.sourceType,
    isConnected: isConnected ?? this.isConnected,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    settingsJson: settingsJson.present ? settingsJson.value : this.settingsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WearableSource copyWithCompanion(WearableSourcesCompanion data) {
    return WearableSource(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      isConnected: data.isConnected.present
          ? data.isConnected.value
          : this.isConnected,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      settingsJson: data.settingsJson.present
          ? data.settingsJson.value
          : this.settingsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WearableSource(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceType: $sourceType, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    sourceType,
    isConnected,
    lastSyncAt,
    settingsJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WearableSource &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sourceType == this.sourceType &&
          other.isConnected == this.isConnected &&
          other.lastSyncAt == this.lastSyncAt &&
          other.settingsJson == this.settingsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WearableSourcesCompanion extends UpdateCompanion<WearableSource> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sourceType;
  final Value<bool> isConnected;
  final Value<DateTime?> lastSyncAt;
  final Value<String?> settingsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WearableSourcesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.isConnected = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WearableSourcesCompanion.insert({
    required String id,
    required String userId,
    required String sourceType,
    this.isConnected = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.settingsJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       sourceType = Value(sourceType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WearableSource> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sourceType,
    Expression<bool>? isConnected,
    Expression<DateTime>? lastSyncAt,
    Expression<String>? settingsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sourceType != null) 'source_type': sourceType,
      if (isConnected != null) 'is_connected': isConnected,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (settingsJson != null) 'settings_json': settingsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WearableSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? sourceType,
    Value<bool>? isConnected,
    Value<DateTime?>? lastSyncAt,
    Value<String?>? settingsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WearableSourcesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceType: sourceType ?? this.sourceType,
      isConnected: isConnected ?? this.isConnected,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      settingsJson: settingsJson ?? this.settingsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (isConnected.present) {
      map['is_connected'] = Variable<bool>(isConnected.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WearableSourcesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceType: $sourceType, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EducationArticlesTable extends EducationArticles
    with TableInfo<$EducationArticlesTable, EducationArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EducationArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOfflineAvailableMeta =
      const VerificationMeta('isOfflineAvailable');
  @override
  late final GeneratedColumn<bool> isOfflineAvailable = GeneratedColumn<bool>(
    'is_offline_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_offline_available" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _medicalReviewDateMeta = const VerificationMeta(
    'medicalReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> medicalReviewDate =
      GeneratedColumn<DateTime>(
        'medical_review_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reviewAuthorMeta = const VerificationMeta(
    'reviewAuthor',
  );
  @override
  late final GeneratedColumn<String> reviewAuthor = GeneratedColumn<String>(
    'review_author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readTimeMinutesMeta = const VerificationMeta(
    'readTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> readTimeMinutes = GeneratedColumn<int>(
    'read_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    category,
    summary,
    isOfflineAvailable,
    medicalReviewDate,
    reviewAuthor,
    readTimeMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'education_articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<EducationArticle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('is_offline_available')) {
      context.handle(
        _isOfflineAvailableMeta,
        isOfflineAvailable.isAcceptableOrUnknown(
          data['is_offline_available']!,
          _isOfflineAvailableMeta,
        ),
      );
    }
    if (data.containsKey('medical_review_date')) {
      context.handle(
        _medicalReviewDateMeta,
        medicalReviewDate.isAcceptableOrUnknown(
          data['medical_review_date']!,
          _medicalReviewDateMeta,
        ),
      );
    }
    if (data.containsKey('review_author')) {
      context.handle(
        _reviewAuthorMeta,
        reviewAuthor.isAcceptableOrUnknown(
          data['review_author']!,
          _reviewAuthorMeta,
        ),
      );
    }
    if (data.containsKey('read_time_minutes')) {
      context.handle(
        _readTimeMinutesMeta,
        readTimeMinutes.isAcceptableOrUnknown(
          data['read_time_minutes']!,
          _readTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EducationArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EducationArticle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      isOfflineAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_offline_available'],
      )!,
      medicalReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}medical_review_date'],
      ),
      reviewAuthor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_author'],
      ),
      readTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}read_time_minutes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EducationArticlesTable createAlias(String alias) {
    return $EducationArticlesTable(attachedDatabase, alias);
  }
}

class EducationArticle extends DataClass
    implements Insertable<EducationArticle> {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? summary;
  final bool isOfflineAvailable;
  final DateTime? medicalReviewDate;
  final String? reviewAuthor;
  final int? readTimeMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EducationArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.summary,
    required this.isOfflineAvailable,
    this.medicalReviewDate,
    this.reviewAuthor,
    this.readTimeMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['is_offline_available'] = Variable<bool>(isOfflineAvailable);
    if (!nullToAbsent || medicalReviewDate != null) {
      map['medical_review_date'] = Variable<DateTime>(medicalReviewDate);
    }
    if (!nullToAbsent || reviewAuthor != null) {
      map['review_author'] = Variable<String>(reviewAuthor);
    }
    if (!nullToAbsent || readTimeMinutes != null) {
      map['read_time_minutes'] = Variable<int>(readTimeMinutes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EducationArticlesCompanion toCompanion(bool nullToAbsent) {
    return EducationArticlesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      isOfflineAvailable: Value(isOfflineAvailable),
      medicalReviewDate: medicalReviewDate == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalReviewDate),
      reviewAuthor: reviewAuthor == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewAuthor),
      readTimeMinutes: readTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(readTimeMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EducationArticle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EducationArticle(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      summary: serializer.fromJson<String?>(json['summary']),
      isOfflineAvailable: serializer.fromJson<bool>(json['isOfflineAvailable']),
      medicalReviewDate: serializer.fromJson<DateTime?>(
        json['medicalReviewDate'],
      ),
      reviewAuthor: serializer.fromJson<String?>(json['reviewAuthor']),
      readTimeMinutes: serializer.fromJson<int?>(json['readTimeMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'summary': serializer.toJson<String?>(summary),
      'isOfflineAvailable': serializer.toJson<bool>(isOfflineAvailable),
      'medicalReviewDate': serializer.toJson<DateTime?>(medicalReviewDate),
      'reviewAuthor': serializer.toJson<String?>(reviewAuthor),
      'readTimeMinutes': serializer.toJson<int?>(readTimeMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EducationArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    Value<String?> summary = const Value.absent(),
    bool? isOfflineAvailable,
    Value<DateTime?> medicalReviewDate = const Value.absent(),
    Value<String?> reviewAuthor = const Value.absent(),
    Value<int?> readTimeMinutes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EducationArticle(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    category: category ?? this.category,
    summary: summary.present ? summary.value : this.summary,
    isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
    medicalReviewDate: medicalReviewDate.present
        ? medicalReviewDate.value
        : this.medicalReviewDate,
    reviewAuthor: reviewAuthor.present ? reviewAuthor.value : this.reviewAuthor,
    readTimeMinutes: readTimeMinutes.present
        ? readTimeMinutes.value
        : this.readTimeMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EducationArticle copyWithCompanion(EducationArticlesCompanion data) {
    return EducationArticle(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      summary: data.summary.present ? data.summary.value : this.summary,
      isOfflineAvailable: data.isOfflineAvailable.present
          ? data.isOfflineAvailable.value
          : this.isOfflineAvailable,
      medicalReviewDate: data.medicalReviewDate.present
          ? data.medicalReviewDate.value
          : this.medicalReviewDate,
      reviewAuthor: data.reviewAuthor.present
          ? data.reviewAuthor.value
          : this.reviewAuthor,
      readTimeMinutes: data.readTimeMinutes.present
          ? data.readTimeMinutes.value
          : this.readTimeMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EducationArticle(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('isOfflineAvailable: $isOfflineAvailable, ')
          ..write('medicalReviewDate: $medicalReviewDate, ')
          ..write('reviewAuthor: $reviewAuthor, ')
          ..write('readTimeMinutes: $readTimeMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    content,
    category,
    summary,
    isOfflineAvailable,
    medicalReviewDate,
    reviewAuthor,
    readTimeMinutes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EducationArticle &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.summary == this.summary &&
          other.isOfflineAvailable == this.isOfflineAvailable &&
          other.medicalReviewDate == this.medicalReviewDate &&
          other.reviewAuthor == this.reviewAuthor &&
          other.readTimeMinutes == this.readTimeMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EducationArticlesCompanion extends UpdateCompanion<EducationArticle> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> category;
  final Value<String?> summary;
  final Value<bool> isOfflineAvailable;
  final Value<DateTime?> medicalReviewDate;
  final Value<String?> reviewAuthor;
  final Value<int?> readTimeMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EducationArticlesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.summary = const Value.absent(),
    this.isOfflineAvailable = const Value.absent(),
    this.medicalReviewDate = const Value.absent(),
    this.reviewAuthor = const Value.absent(),
    this.readTimeMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EducationArticlesCompanion.insert({
    required String id,
    required String title,
    required String content,
    required String category,
    this.summary = const Value.absent(),
    this.isOfflineAvailable = const Value.absent(),
    this.medicalReviewDate = const Value.absent(),
    this.reviewAuthor = const Value.absent(),
    this.readTimeMinutes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       category = Value(category),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EducationArticle> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? category,
    Expression<String>? summary,
    Expression<bool>? isOfflineAvailable,
    Expression<DateTime>? medicalReviewDate,
    Expression<String>? reviewAuthor,
    Expression<int>? readTimeMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (isOfflineAvailable != null)
        'is_offline_available': isOfflineAvailable,
      if (medicalReviewDate != null) 'medical_review_date': medicalReviewDate,
      if (reviewAuthor != null) 'review_author': reviewAuthor,
      if (readTimeMinutes != null) 'read_time_minutes': readTimeMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EducationArticlesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<String>? category,
    Value<String?>? summary,
    Value<bool>? isOfflineAvailable,
    Value<DateTime?>? medicalReviewDate,
    Value<String?>? reviewAuthor,
    Value<int?>? readTimeMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EducationArticlesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      medicalReviewDate: medicalReviewDate ?? this.medicalReviewDate,
      reviewAuthor: reviewAuthor ?? this.reviewAuthor,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (isOfflineAvailable.present) {
      map['is_offline_available'] = Variable<bool>(isOfflineAvailable.value);
    }
    if (medicalReviewDate.present) {
      map['medical_review_date'] = Variable<DateTime>(medicalReviewDate.value);
    }
    if (reviewAuthor.present) {
      map['review_author'] = Variable<String>(reviewAuthor.value);
    }
    if (readTimeMinutes.present) {
      map['read_time_minutes'] = Variable<int>(readTimeMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EducationArticlesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('isOfflineAvailable: $isOfflineAvailable, ')
          ..write('medicalReviewDate: $medicalReviewDate, ')
          ..write('reviewAuthor: $reviewAuthor, ')
          ..write('readTimeMinutes: $readTimeMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommunityPostsTable extends CommunityPosts
    with TableInfo<$CommunityPostsTable, CommunityPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommunityPostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAnonymousMeta = const VerificationMeta(
    'isAnonymous',
  );
  @override
  late final GeneratedColumn<bool> isAnonymous = GeneratedColumn<bool>(
    'is_anonymous',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_anonymous" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isModeratedMeta = const VerificationMeta(
    'isModerated',
  );
  @override
  late final GeneratedColumn<bool> isModerated = GeneratedColumn<bool>(
    'is_moderated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_moderated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _moderationActionMeta = const VerificationMeta(
    'moderationAction',
  );
  @override
  late final GeneratedColumn<String> moderationAction = GeneratedColumn<String>(
    'moderation_action',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    topicId,
    content,
    isAnonymous,
    isModerated,
    moderationAction,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommunityPost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_anonymous')) {
      context.handle(
        _isAnonymousMeta,
        isAnonymous.isAcceptableOrUnknown(
          data['is_anonymous']!,
          _isAnonymousMeta,
        ),
      );
    }
    if (data.containsKey('is_moderated')) {
      context.handle(
        _isModeratedMeta,
        isModerated.isAcceptableOrUnknown(
          data['is_moderated']!,
          _isModeratedMeta,
        ),
      );
    }
    if (data.containsKey('moderation_action')) {
      context.handle(
        _moderationActionMeta,
        moderationAction.isAcceptableOrUnknown(
          data['moderation_action']!,
          _moderationActionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommunityPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityPost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isAnonymous: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_anonymous'],
      )!,
      isModerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_moderated'],
      )!,
      moderationAction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moderation_action'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CommunityPostsTable createAlias(String alias) {
    return $CommunityPostsTable(attachedDatabase, alias);
  }
}

class CommunityPost extends DataClass implements Insertable<CommunityPost> {
  final String id;
  final String userId;
  final String topicId;
  final String content;
  final bool isAnonymous;
  final bool isModerated;
  final String? moderationAction;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CommunityPost({
    required this.id,
    required this.userId,
    required this.topicId,
    required this.content,
    required this.isAnonymous,
    required this.isModerated,
    this.moderationAction,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['topic_id'] = Variable<String>(topicId);
    map['content'] = Variable<String>(content);
    map['is_anonymous'] = Variable<bool>(isAnonymous);
    map['is_moderated'] = Variable<bool>(isModerated);
    if (!nullToAbsent || moderationAction != null) {
      map['moderation_action'] = Variable<String>(moderationAction);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CommunityPostsCompanion toCompanion(bool nullToAbsent) {
    return CommunityPostsCompanion(
      id: Value(id),
      userId: Value(userId),
      topicId: Value(topicId),
      content: Value(content),
      isAnonymous: Value(isAnonymous),
      isModerated: Value(isModerated),
      moderationAction: moderationAction == null && nullToAbsent
          ? const Value.absent()
          : Value(moderationAction),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CommunityPost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityPost(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      topicId: serializer.fromJson<String>(json['topicId']),
      content: serializer.fromJson<String>(json['content']),
      isAnonymous: serializer.fromJson<bool>(json['isAnonymous']),
      isModerated: serializer.fromJson<bool>(json['isModerated']),
      moderationAction: serializer.fromJson<String?>(json['moderationAction']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'topicId': serializer.toJson<String>(topicId),
      'content': serializer.toJson<String>(content),
      'isAnonymous': serializer.toJson<bool>(isAnonymous),
      'isModerated': serializer.toJson<bool>(isModerated),
      'moderationAction': serializer.toJson<String?>(moderationAction),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CommunityPost copyWith({
    String? id,
    String? userId,
    String? topicId,
    String? content,
    bool? isAnonymous,
    bool? isModerated,
    Value<String?> moderationAction = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CommunityPost(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    topicId: topicId ?? this.topicId,
    content: content ?? this.content,
    isAnonymous: isAnonymous ?? this.isAnonymous,
    isModerated: isModerated ?? this.isModerated,
    moderationAction: moderationAction.present
        ? moderationAction.value
        : this.moderationAction,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CommunityPost copyWithCompanion(CommunityPostsCompanion data) {
    return CommunityPost(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      content: data.content.present ? data.content.value : this.content,
      isAnonymous: data.isAnonymous.present
          ? data.isAnonymous.value
          : this.isAnonymous,
      isModerated: data.isModerated.present
          ? data.isModerated.value
          : this.isModerated,
      moderationAction: data.moderationAction.present
          ? data.moderationAction.value
          : this.moderationAction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityPost(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('topicId: $topicId, ')
          ..write('content: $content, ')
          ..write('isAnonymous: $isAnonymous, ')
          ..write('isModerated: $isModerated, ')
          ..write('moderationAction: $moderationAction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    topicId,
    content,
    isAnonymous,
    isModerated,
    moderationAction,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityPost &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.topicId == this.topicId &&
          other.content == this.content &&
          other.isAnonymous == this.isAnonymous &&
          other.isModerated == this.isModerated &&
          other.moderationAction == this.moderationAction &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CommunityPostsCompanion extends UpdateCompanion<CommunityPost> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> topicId;
  final Value<String> content;
  final Value<bool> isAnonymous;
  final Value<bool> isModerated;
  final Value<String?> moderationAction;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CommunityPostsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.content = const Value.absent(),
    this.isAnonymous = const Value.absent(),
    this.isModerated = const Value.absent(),
    this.moderationAction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommunityPostsCompanion.insert({
    required String id,
    required String userId,
    required String topicId,
    required String content,
    this.isAnonymous = const Value.absent(),
    this.isModerated = const Value.absent(),
    this.moderationAction = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       topicId = Value(topicId),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CommunityPost> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? topicId,
    Expression<String>? content,
    Expression<bool>? isAnonymous,
    Expression<bool>? isModerated,
    Expression<String>? moderationAction,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (topicId != null) 'topic_id': topicId,
      if (content != null) 'content': content,
      if (isAnonymous != null) 'is_anonymous': isAnonymous,
      if (isModerated != null) 'is_moderated': isModerated,
      if (moderationAction != null) 'moderation_action': moderationAction,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommunityPostsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? topicId,
    Value<String>? content,
    Value<bool>? isAnonymous,
    Value<bool>? isModerated,
    Value<String?>? moderationAction,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CommunityPostsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      topicId: topicId ?? this.topicId,
      content: content ?? this.content,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isModerated: isModerated ?? this.isModerated,
      moderationAction: moderationAction ?? this.moderationAction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isAnonymous.present) {
      map['is_anonymous'] = Variable<bool>(isAnonymous.value);
    }
    if (isModerated.present) {
      map['is_moderated'] = Variable<bool>(isModerated.value);
    }
    if (moderationAction.present) {
      map['moderation_action'] = Variable<String>(moderationAction.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunityPostsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('topicId: $topicId, ')
          ..write('content: $content, ')
          ..write('isAnonymous: $isAnonymous, ')
          ..write('isModerated: $isModerated, ')
          ..write('moderationAction: $moderationAction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthReportsTable extends HealthReports
    with TableInfo<$HealthReportsTable, HealthReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportTypeMeta = const VerificationMeta(
    'reportType',
  );
  @override
  late final GeneratedColumn<String> reportType = GeneratedColumn<String>(
    'report_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateRangeStartMeta = const VerificationMeta(
    'dateRangeStart',
  );
  @override
  late final GeneratedColumn<DateTime> dateRangeStart =
      GeneratedColumn<DateTime>(
        'date_range_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dateRangeEndMeta = const VerificationMeta(
    'dateRangeEnd',
  );
  @override
  late final GeneratedColumn<DateTime> dateRangeEnd = GeneratedColumn<DateTime>(
    'date_range_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    reportType,
    dateRangeStart,
    dateRangeEnd,
    filePath,
    fileSize,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('report_type')) {
      context.handle(
        _reportTypeMeta,
        reportType.isAcceptableOrUnknown(data['report_type']!, _reportTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_reportTypeMeta);
    }
    if (data.containsKey('date_range_start')) {
      context.handle(
        _dateRangeStartMeta,
        dateRangeStart.isAcceptableOrUnknown(
          data['date_range_start']!,
          _dateRangeStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateRangeStartMeta);
    }
    if (data.containsKey('date_range_end')) {
      context.handle(
        _dateRangeEndMeta,
        dateRangeEnd.isAcceptableOrUnknown(
          data['date_range_end']!,
          _dateRangeEndMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateRangeEndMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      reportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_type'],
      )!,
      dateRangeStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_range_start'],
      )!,
      dateRangeEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_range_end'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HealthReportsTable createAlias(String alias) {
    return $HealthReportsTable(attachedDatabase, alias);
  }
}

class HealthReport extends DataClass implements Insertable<HealthReport> {
  final String id;
  final String userId;
  final String reportType;
  final DateTime dateRangeStart;
  final DateTime dateRangeEnd;
  final String? filePath;
  final int? fileSize;
  final bool isSynced;
  final DateTime createdAt;
  const HealthReport({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.dateRangeStart,
    required this.dateRangeEnd,
    this.filePath,
    this.fileSize,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['report_type'] = Variable<String>(reportType);
    map['date_range_start'] = Variable<DateTime>(dateRangeStart);
    map['date_range_end'] = Variable<DateTime>(dateRangeEnd);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HealthReportsCompanion toCompanion(bool nullToAbsent) {
    return HealthReportsCompanion(
      id: Value(id),
      userId: Value(userId),
      reportType: Value(reportType),
      dateRangeStart: Value(dateRangeStart),
      dateRangeEnd: Value(dateRangeEnd),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory HealthReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthReport(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      reportType: serializer.fromJson<String>(json['reportType']),
      dateRangeStart: serializer.fromJson<DateTime>(json['dateRangeStart']),
      dateRangeEnd: serializer.fromJson<DateTime>(json['dateRangeEnd']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'reportType': serializer.toJson<String>(reportType),
      'dateRangeStart': serializer.toJson<DateTime>(dateRangeStart),
      'dateRangeEnd': serializer.toJson<DateTime>(dateRangeEnd),
      'filePath': serializer.toJson<String?>(filePath),
      'fileSize': serializer.toJson<int?>(fileSize),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HealthReport copyWith({
    String? id,
    String? userId,
    String? reportType,
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
    Value<String?> filePath = const Value.absent(),
    Value<int?> fileSize = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => HealthReport(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    reportType: reportType ?? this.reportType,
    dateRangeStart: dateRangeStart ?? this.dateRangeStart,
    dateRangeEnd: dateRangeEnd ?? this.dateRangeEnd,
    filePath: filePath.present ? filePath.value : this.filePath,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  HealthReport copyWithCompanion(HealthReportsCompanion data) {
    return HealthReport(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      reportType: data.reportType.present
          ? data.reportType.value
          : this.reportType,
      dateRangeStart: data.dateRangeStart.present
          ? data.dateRangeStart.value
          : this.dateRangeStart,
      dateRangeEnd: data.dateRangeEnd.present
          ? data.dateRangeEnd.value
          : this.dateRangeEnd,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthReport(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('reportType: $reportType, ')
          ..write('dateRangeStart: $dateRangeStart, ')
          ..write('dateRangeEnd: $dateRangeEnd, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    reportType,
    dateRangeStart,
    dateRangeEnd,
    filePath,
    fileSize,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthReport &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.reportType == this.reportType &&
          other.dateRangeStart == this.dateRangeStart &&
          other.dateRangeEnd == this.dateRangeEnd &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class HealthReportsCompanion extends UpdateCompanion<HealthReport> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> reportType;
  final Value<DateTime> dateRangeStart;
  final Value<DateTime> dateRangeEnd;
  final Value<String?> filePath;
  final Value<int?> fileSize;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HealthReportsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.reportType = const Value.absent(),
    this.dateRangeStart = const Value.absent(),
    this.dateRangeEnd = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthReportsCompanion.insert({
    required String id,
    required String userId,
    required String reportType,
    required DateTime dateRangeStart,
    required DateTime dateRangeEnd,
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       reportType = Value(reportType),
       dateRangeStart = Value(dateRangeStart),
       dateRangeEnd = Value(dateRangeEnd),
       createdAt = Value(createdAt);
  static Insertable<HealthReport> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? reportType,
    Expression<DateTime>? dateRangeStart,
    Expression<DateTime>? dateRangeEnd,
    Expression<String>? filePath,
    Expression<int>? fileSize,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (reportType != null) 'report_type': reportType,
      if (dateRangeStart != null) 'date_range_start': dateRangeStart,
      if (dateRangeEnd != null) 'date_range_end': dateRangeEnd,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? reportType,
    Value<DateTime>? dateRangeStart,
    Value<DateTime>? dateRangeEnd,
    Value<String?>? filePath,
    Value<int?>? fileSize,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HealthReportsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reportType: reportType ?? this.reportType,
      dateRangeStart: dateRangeStart ?? this.dateRangeStart,
      dateRangeEnd: dateRangeEnd ?? this.dateRangeEnd,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (reportType.present) {
      map['report_type'] = Variable<String>(reportType.value);
    }
    if (dateRangeStart.present) {
      map['date_range_start'] = Variable<DateTime>(dateRangeStart.value);
    }
    if (dateRangeEnd.present) {
      map['date_range_end'] = Variable<DateTime>(dateRangeEnd.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthReportsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('reportType: $reportType, ')
          ..write('dateRangeStart: $dateRangeStart, ')
          ..write('dateRangeEnd: $dateRangeEnd, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String id;
  final String? userId;
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.id,
    this.userId,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => AppSetting(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $CycleDaysTable cycleDays = $CycleDaysTable(this);
  late final $SymptomsTable symptoms = $SymptomsTable(this);
  late final $SymptomLogsTable symptomLogs = $SymptomLogsTable(this);
  late final $BbtRecordsTable bbtRecords = $BbtRecordsTable(this);
  late final $OvulationTestsTable ovulationTests = $OvulationTestsTable(this);
  late final $CervicalMucusObservationsTable cervicalMucusObservations =
      $CervicalMucusObservationsTable(this);
  late final $PregnanciesTable pregnancies = $PregnanciesTable(this);
  late final $FetalMeasurementsTable fetalMeasurements =
      $FetalMeasurementsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $UserConditionsTable userConditions = $UserConditionsTable(this);
  late final $WearableSourcesTable wearableSources = $WearableSourcesTable(
    this,
  );
  late final $EducationArticlesTable educationArticles =
      $EducationArticlesTable(this);
  late final $CommunityPostsTable communityPosts = $CommunityPostsTable(this);
  late final $HealthReportsTable healthReports = $HealthReportsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cycles,
    cycleDays,
    symptoms,
    symptomLogs,
    bbtRecords,
    ovulationTests,
    cervicalMucusObservations,
    pregnancies,
    fetalMeasurements,
    journalEntries,
    userConditions,
    wearableSources,
    educationArticles,
    communityPosts,
    healthReports,
    appSettings,
  ];
}

typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      required String id,
      required String userId,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<int?> cycleLength,
      Value<int?> periodLength,
      Value<String?> notes,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int?> cycleLength,
      Value<int?> periodLength,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CyclesTableReferences
    extends BaseReferences<_$AppDatabase, $CyclesTable, Cycle> {
  $$CyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CycleDaysTable, List<CycleDay>>
  _cycleDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cycleDays,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.cycleDays.cycleId),
  );

  $$CycleDaysTableProcessedTableManager get cycleDaysRefs {
    final manager = $$CycleDaysTableTableManager(
      $_db,
      $_db.cycleDays,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cycleDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CyclesTableFilterComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cycleDaysRefs(
    Expression<bool> Function($$CycleDaysTableFilterComposer f) f,
  ) {
    final $$CycleDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableFilterComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> cycleDaysRefs<T extends Object>(
    Expression<T> Function($$CycleDaysTableAnnotationComposer a) f,
  ) {
    final $$CycleDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclesTable,
          Cycle,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (Cycle, $$CyclesTableReferences),
          Cycle,
          PrefetchHooks Function({bool cycleDaysRefs})
        > {
  $$CyclesTableTableManager(_$AppDatabase db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> cycleLength = const Value.absent(),
                Value<int?> periodLength = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                cycleLength: cycleLength,
                periodLength: periodLength,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> cycleLength = const Value.absent(),
                Value<int?> periodLength = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion.insert(
                id: id,
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                cycleLength: cycleLength,
                periodLength: periodLength,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CyclesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({cycleDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cycleDaysRefs) db.cycleDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cycleDaysRefs)
                    await $_getPrefetchedData<Cycle, $CyclesTable, CycleDay>(
                      currentTable: table,
                      referencedTable: $$CyclesTableReferences
                          ._cycleDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CyclesTableReferences(db, table, p0).cycleDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cycleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclesTable,
      Cycle,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (Cycle, $$CyclesTableReferences),
      Cycle,
      PrefetchHooks Function({bool cycleDaysRefs})
    >;
typedef $$CycleDaysTableCreateCompanionBuilder =
    CycleDaysCompanion Function({
      required String id,
      required String cycleId,
      required DateTime date,
      Value<int?> flowIntensity,
      Value<bool> spotting,
      Value<bool> clotting,
      Value<String?> symptomsJson,
      Value<double?> temperature,
      Value<String?> cervicalMucus,
      Value<String?> cervicalPosition,
      Value<String?> opkResult,
      Value<String?> notes,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CycleDaysTableUpdateCompanionBuilder =
    CycleDaysCompanion Function({
      Value<String> id,
      Value<String> cycleId,
      Value<DateTime> date,
      Value<int?> flowIntensity,
      Value<bool> spotting,
      Value<bool> clotting,
      Value<String?> symptomsJson,
      Value<double?> temperature,
      Value<String?> cervicalMucus,
      Value<String?> cervicalPosition,
      Value<String?> opkResult,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CycleDaysTableReferences
    extends BaseReferences<_$AppDatabase, $CycleDaysTable, CycleDay> {
  $$CycleDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclesTable _cycleIdTable(_$AppDatabase db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.cycleDays.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<String>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SymptomLogsTable, List<SymptomLog>>
  _symptomLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomLogs,
    aliasName: $_aliasNameGenerator(db.cycleDays.id, db.symptomLogs.cycleDayId),
  );

  $$SymptomLogsTableProcessedTableManager get symptomLogsRefs {
    final manager = $$SymptomLogsTableTableManager(
      $_db,
      $_db.symptomLogs,
    ).filter((f) => f.cycleDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CervicalMucusObservationsTable,
    List<CervicalMucusObservation>
  >
  _cervicalMucusObservationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cervicalMucusObservations,
        aliasName: $_aliasNameGenerator(
          db.cycleDays.id,
          db.cervicalMucusObservations.cycleDayId,
        ),
      );

  $$CervicalMucusObservationsTableProcessedTableManager
  get cervicalMucusObservationsRefs {
    final manager = $$CervicalMucusObservationsTableTableManager(
      $_db,
      $_db.cervicalMucusObservations,
    ).filter((f) => f.cycleDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cervicalMucusObservationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalEntriesTable, List<JournalEntry>>
  _journalEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntries,
    aliasName: $_aliasNameGenerator(
      db.cycleDays.id,
      db.journalEntries.cycleDayId,
    ),
  );

  $$JournalEntriesTableProcessedTableManager get journalEntriesRefs {
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.cycleDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CycleDaysTableFilterComposer
    extends Composer<_$AppDatabase, $CycleDaysTable> {
  $$CycleDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flowIntensity => $composableBuilder(
    column: $table.flowIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get spotting => $composableBuilder(
    column: $table.spotting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get clotting => $composableBuilder(
    column: $table.clotting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomsJson => $composableBuilder(
    column: $table.symptomsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cervicalMucus => $composableBuilder(
    column: $table.cervicalMucus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cervicalPosition => $composableBuilder(
    column: $table.cervicalPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opkResult => $composableBuilder(
    column: $table.opkResult,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> symptomLogsRefs(
    Expression<bool> Function($$SymptomLogsTableFilterComposer f) f,
  ) {
    final $$SymptomLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.cycleDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableFilterComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cervicalMucusObservationsRefs(
    Expression<bool> Function($$CervicalMucusObservationsTableFilterComposer f)
    f,
  ) {
    final $$CervicalMucusObservationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cervicalMucusObservations,
          getReferencedColumn: (t) => t.cycleDayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CervicalMucusObservationsTableFilterComposer(
                $db: $db,
                $table: $db.cervicalMucusObservations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($$JournalEntriesTableFilterComposer f) f,
  ) {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.cycleDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CycleDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $CycleDaysTable> {
  $$CycleDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flowIntensity => $composableBuilder(
    column: $table.flowIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get spotting => $composableBuilder(
    column: $table.spotting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get clotting => $composableBuilder(
    column: $table.clotting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomsJson => $composableBuilder(
    column: $table.symptomsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cervicalMucus => $composableBuilder(
    column: $table.cervicalMucus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cervicalPosition => $composableBuilder(
    column: $table.cervicalPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opkResult => $composableBuilder(
    column: $table.opkResult,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CycleDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $CycleDaysTable> {
  $$CycleDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get flowIntensity => $composableBuilder(
    column: $table.flowIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get spotting =>
      $composableBuilder(column: $table.spotting, builder: (column) => column);

  GeneratedColumn<bool> get clotting =>
      $composableBuilder(column: $table.clotting, builder: (column) => column);

  GeneratedColumn<String> get symptomsJson => $composableBuilder(
    column: $table.symptomsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cervicalMucus => $composableBuilder(
    column: $table.cervicalMucus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cervicalPosition => $composableBuilder(
    column: $table.cervicalPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get opkResult =>
      $composableBuilder(column: $table.opkResult, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> symptomLogsRefs<T extends Object>(
    Expression<T> Function($$SymptomLogsTableAnnotationComposer a) f,
  ) {
    final $$SymptomLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.cycleDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cervicalMucusObservationsRefs<T extends Object>(
    Expression<T> Function($$CervicalMucusObservationsTableAnnotationComposer a)
    f,
  ) {
    final $$CervicalMucusObservationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cervicalMucusObservations,
          getReferencedColumn: (t) => t.cycleDayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CervicalMucusObservationsTableAnnotationComposer(
                $db: $db,
                $table: $db.cervicalMucusObservations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($$JournalEntriesTableAnnotationComposer a) f,
  ) {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.cycleDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CycleDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CycleDaysTable,
          CycleDay,
          $$CycleDaysTableFilterComposer,
          $$CycleDaysTableOrderingComposer,
          $$CycleDaysTableAnnotationComposer,
          $$CycleDaysTableCreateCompanionBuilder,
          $$CycleDaysTableUpdateCompanionBuilder,
          (CycleDay, $$CycleDaysTableReferences),
          CycleDay,
          PrefetchHooks Function({
            bool cycleId,
            bool symptomLogsRefs,
            bool cervicalMucusObservationsRefs,
            bool journalEntriesRefs,
          })
        > {
  $$CycleDaysTableTableManager(_$AppDatabase db, $CycleDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CycleDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CycleDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CycleDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> flowIntensity = const Value.absent(),
                Value<bool> spotting = const Value.absent(),
                Value<bool> clotting = const Value.absent(),
                Value<String?> symptomsJson = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<String?> cervicalMucus = const Value.absent(),
                Value<String?> cervicalPosition = const Value.absent(),
                Value<String?> opkResult = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CycleDaysCompanion(
                id: id,
                cycleId: cycleId,
                date: date,
                flowIntensity: flowIntensity,
                spotting: spotting,
                clotting: clotting,
                symptomsJson: symptomsJson,
                temperature: temperature,
                cervicalMucus: cervicalMucus,
                cervicalPosition: cervicalPosition,
                opkResult: opkResult,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cycleId,
                required DateTime date,
                Value<int?> flowIntensity = const Value.absent(),
                Value<bool> spotting = const Value.absent(),
                Value<bool> clotting = const Value.absent(),
                Value<String?> symptomsJson = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<String?> cervicalMucus = const Value.absent(),
                Value<String?> cervicalPosition = const Value.absent(),
                Value<String?> opkResult = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CycleDaysCompanion.insert(
                id: id,
                cycleId: cycleId,
                date: date,
                flowIntensity: flowIntensity,
                spotting: spotting,
                clotting: clotting,
                symptomsJson: symptomsJson,
                temperature: temperature,
                cervicalMucus: cervicalMucus,
                cervicalPosition: cervicalPosition,
                opkResult: opkResult,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CycleDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cycleId = false,
                symptomLogsRefs = false,
                cervicalMucusObservationsRefs = false,
                journalEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (symptomLogsRefs) db.symptomLogs,
                    if (cervicalMucusObservationsRefs)
                      db.cervicalMucusObservations,
                    if (journalEntriesRefs) db.journalEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cycleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cycleId,
                                    referencedTable: $$CycleDaysTableReferences
                                        ._cycleIdTable(db),
                                    referencedColumn: $$CycleDaysTableReferences
                                        ._cycleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (symptomLogsRefs)
                        await $_getPrefetchedData<
                          CycleDay,
                          $CycleDaysTable,
                          SymptomLog
                        >(
                          currentTable: table,
                          referencedTable: $$CycleDaysTableReferences
                              ._symptomLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CycleDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cervicalMucusObservationsRefs)
                        await $_getPrefetchedData<
                          CycleDay,
                          $CycleDaysTable,
                          CervicalMucusObservation
                        >(
                          currentTable: table,
                          referencedTable: $$CycleDaysTableReferences
                              ._cervicalMucusObservationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CycleDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).cervicalMucusObservationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journalEntriesRefs)
                        await $_getPrefetchedData<
                          CycleDay,
                          $CycleDaysTable,
                          JournalEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CycleDaysTableReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CycleDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CycleDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CycleDaysTable,
      CycleDay,
      $$CycleDaysTableFilterComposer,
      $$CycleDaysTableOrderingComposer,
      $$CycleDaysTableAnnotationComposer,
      $$CycleDaysTableCreateCompanionBuilder,
      $$CycleDaysTableUpdateCompanionBuilder,
      (CycleDay, $$CycleDaysTableReferences),
      CycleDay,
      PrefetchHooks Function({
        bool cycleId,
        bool symptomLogsRefs,
        bool cervicalMucusObservationsRefs,
        bool journalEntriesRefs,
      })
    >;
typedef $$SymptomsTableCreateCompanionBuilder =
    SymptomsCompanion Function({
      required String id,
      required String name,
      required String category,
      required String iconName,
      required String colorHex,
      required String predefinedOptions,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SymptomsTableUpdateCompanionBuilder =
    SymptomsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String> iconName,
      Value<String> colorHex,
      Value<String> predefinedOptions,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SymptomsTableReferences
    extends BaseReferences<_$AppDatabase, $SymptomsTable, Symptom> {
  $$SymptomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SymptomLogsTable, List<SymptomLog>>
  _symptomLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomLogs,
    aliasName: $_aliasNameGenerator(db.symptoms.id, db.symptomLogs.symptomId),
  );

  $$SymptomLogsTableProcessedTableManager get symptomLogsRefs {
    final manager = $$SymptomLogsTableTableManager(
      $_db,
      $_db.symptomLogs,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomsTable> {
  $$SymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predefinedOptions => $composableBuilder(
    column: $table.predefinedOptions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> symptomLogsRefs(
    Expression<bool> Function($$SymptomLogsTableFilterComposer f) f,
  ) {
    final $$SymptomLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableFilterComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomsTable> {
  $$SymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predefinedOptions => $composableBuilder(
    column: $table.predefinedOptions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomsTable> {
  $$SymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get predefinedOptions => $composableBuilder(
    column: $table.predefinedOptions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> symptomLogsRefs<T extends Object>(
    Expression<T> Function($$SymptomLogsTableAnnotationComposer a) f,
  ) {
    final $$SymptomLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomLogs,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomsTable,
          Symptom,
          $$SymptomsTableFilterComposer,
          $$SymptomsTableOrderingComposer,
          $$SymptomsTableAnnotationComposer,
          $$SymptomsTableCreateCompanionBuilder,
          $$SymptomsTableUpdateCompanionBuilder,
          (Symptom, $$SymptomsTableReferences),
          Symptom,
          PrefetchHooks Function({bool symptomLogsRefs})
        > {
  $$SymptomsTableTableManager(_$AppDatabase db, $SymptomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> predefinedOptions = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomsCompanion(
                id: id,
                name: name,
                category: category,
                iconName: iconName,
                colorHex: colorHex,
                predefinedOptions: predefinedOptions,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required String iconName,
                required String colorHex,
                required String predefinedOptions,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SymptomsCompanion.insert(
                id: id,
                name: name,
                category: category,
                iconName: iconName,
                colorHex: colorHex,
                predefinedOptions: predefinedOptions,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (symptomLogsRefs) db.symptomLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (symptomLogsRefs)
                    await $_getPrefetchedData<
                      Symptom,
                      $SymptomsTable,
                      SymptomLog
                    >(
                      currentTable: table,
                      referencedTable: $$SymptomsTableReferences
                          ._symptomLogsRefsTable(db),
                      managerFromTypedResult: (p0) => $$SymptomsTableReferences(
                        db,
                        table,
                        p0,
                      ).symptomLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.symptomId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomsTable,
      Symptom,
      $$SymptomsTableFilterComposer,
      $$SymptomsTableOrderingComposer,
      $$SymptomsTableAnnotationComposer,
      $$SymptomsTableCreateCompanionBuilder,
      $$SymptomsTableUpdateCompanionBuilder,
      (Symptom, $$SymptomsTableReferences),
      Symptom,
      PrefetchHooks Function({bool symptomLogsRefs})
    >;
typedef $$SymptomLogsTableCreateCompanionBuilder =
    SymptomLogsCompanion Function({
      required String id,
      Value<String?> cycleDayId,
      required DateTime date,
      required String symptomId,
      required int severity,
      required DateTime timestamp,
      Value<String?> notes,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SymptomLogsTableUpdateCompanionBuilder =
    SymptomLogsCompanion Function({
      Value<String> id,
      Value<String?> cycleDayId,
      Value<DateTime> date,
      Value<String> symptomId,
      Value<int> severity,
      Value<DateTime> timestamp,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SymptomLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SymptomLogsTable, SymptomLog> {
  $$SymptomLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CycleDaysTable _cycleDayIdTable(_$AppDatabase db) =>
      db.cycleDays.createAlias(
        $_aliasNameGenerator(db.symptomLogs.cycleDayId, db.cycleDays.id),
      );

  $$CycleDaysTableProcessedTableManager? get cycleDayId {
    final $_column = $_itemColumn<String>('cycle_day_id');
    if ($_column == null) return null;
    final manager = $$CycleDaysTableTableManager(
      $_db,
      $_db.cycleDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.symptoms.createAlias(
        $_aliasNameGenerator(db.symptomLogs.symptomId, db.symptoms.id),
      );

  $$SymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$SymptomsTableTableManager(
      $_db,
      $_db.symptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CycleDaysTableFilterComposer get cycleDayId {
    final $$CycleDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableFilterComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SymptomsTableFilterComposer get symptomId {
    final $$SymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableFilterComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CycleDaysTableOrderingComposer get cycleDayId {
    final $$CycleDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableOrderingComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SymptomsTableOrderingComposer get symptomId {
    final $$SymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CycleDaysTableAnnotationComposer get cycleDayId {
    final $$CycleDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SymptomsTableAnnotationComposer get symptomId {
    final $$SymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomLogsTable,
          SymptomLog,
          $$SymptomLogsTableFilterComposer,
          $$SymptomLogsTableOrderingComposer,
          $$SymptomLogsTableAnnotationComposer,
          $$SymptomLogsTableCreateCompanionBuilder,
          $$SymptomLogsTableUpdateCompanionBuilder,
          (SymptomLog, $$SymptomLogsTableReferences),
          SymptomLog,
          PrefetchHooks Function({bool cycleDayId, bool symptomId})
        > {
  $$SymptomLogsTableTableManager(_$AppDatabase db, $SymptomLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> cycleDayId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> symptomId = const Value.absent(),
                Value<int> severity = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomLogsCompanion(
                id: id,
                cycleDayId: cycleDayId,
                date: date,
                symptomId: symptomId,
                severity: severity,
                timestamp: timestamp,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> cycleDayId = const Value.absent(),
                required DateTime date,
                required String symptomId,
                required int severity,
                required DateTime timestamp,
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SymptomLogsCompanion.insert(
                id: id,
                cycleDayId: cycleDayId,
                date: date,
                symptomId: symptomId,
                severity: severity,
                timestamp: timestamp,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleDayId = false, symptomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cycleDayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleDayId,
                                referencedTable: $$SymptomLogsTableReferences
                                    ._cycleDayIdTable(db),
                                referencedColumn: $$SymptomLogsTableReferences
                                    ._cycleDayIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (symptomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomId,
                                referencedTable: $$SymptomLogsTableReferences
                                    ._symptomIdTable(db),
                                referencedColumn: $$SymptomLogsTableReferences
                                    ._symptomIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SymptomLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomLogsTable,
      SymptomLog,
      $$SymptomLogsTableFilterComposer,
      $$SymptomLogsTableOrderingComposer,
      $$SymptomLogsTableAnnotationComposer,
      $$SymptomLogsTableCreateCompanionBuilder,
      $$SymptomLogsTableUpdateCompanionBuilder,
      (SymptomLog, $$SymptomLogsTableReferences),
      SymptomLog,
      PrefetchHooks Function({bool cycleDayId, bool symptomId})
    >;
typedef $$BbtRecordsTableCreateCompanionBuilder =
    BbtRecordsCompanion Function({
      required String id,
      required String userId,
      required DateTime date,
      required double temperature,
      required String measurementMethod,
      required String timeOfDay,
      Value<bool> isEstimated,
      Value<String?> notes,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BbtRecordsTableUpdateCompanionBuilder =
    BbtRecordsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> date,
      Value<double> temperature,
      Value<String> measurementMethod,
      Value<String> timeOfDay,
      Value<bool> isEstimated,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BbtRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $BbtRecordsTable> {
  $$BbtRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementMethod => $composableBuilder(
    column: $table.measurementMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEstimated => $composableBuilder(
    column: $table.isEstimated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BbtRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $BbtRecordsTable> {
  $$BbtRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementMethod => $composableBuilder(
    column: $table.measurementMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEstimated => $composableBuilder(
    column: $table.isEstimated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BbtRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BbtRecordsTable> {
  $$BbtRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementMethod => $composableBuilder(
    column: $table.measurementMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<bool> get isEstimated => $composableBuilder(
    column: $table.isEstimated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BbtRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BbtRecordsTable,
          BbtRecord,
          $$BbtRecordsTableFilterComposer,
          $$BbtRecordsTableOrderingComposer,
          $$BbtRecordsTableAnnotationComposer,
          $$BbtRecordsTableCreateCompanionBuilder,
          $$BbtRecordsTableUpdateCompanionBuilder,
          (
            BbtRecord,
            BaseReferences<_$AppDatabase, $BbtRecordsTable, BbtRecord>,
          ),
          BbtRecord,
          PrefetchHooks Function()
        > {
  $$BbtRecordsTableTableManager(_$AppDatabase db, $BbtRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BbtRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BbtRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BbtRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> temperature = const Value.absent(),
                Value<String> measurementMethod = const Value.absent(),
                Value<String> timeOfDay = const Value.absent(),
                Value<bool> isEstimated = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BbtRecordsCompanion(
                id: id,
                userId: userId,
                date: date,
                temperature: temperature,
                measurementMethod: measurementMethod,
                timeOfDay: timeOfDay,
                isEstimated: isEstimated,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime date,
                required double temperature,
                required String measurementMethod,
                required String timeOfDay,
                Value<bool> isEstimated = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BbtRecordsCompanion.insert(
                id: id,
                userId: userId,
                date: date,
                temperature: temperature,
                measurementMethod: measurementMethod,
                timeOfDay: timeOfDay,
                isEstimated: isEstimated,
                notes: notes,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BbtRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BbtRecordsTable,
      BbtRecord,
      $$BbtRecordsTableFilterComposer,
      $$BbtRecordsTableOrderingComposer,
      $$BbtRecordsTableAnnotationComposer,
      $$BbtRecordsTableCreateCompanionBuilder,
      $$BbtRecordsTableUpdateCompanionBuilder,
      (BbtRecord, BaseReferences<_$AppDatabase, $BbtRecordsTable, BbtRecord>),
      BbtRecord,
      PrefetchHooks Function()
    >;
typedef $$OvulationTestsTableCreateCompanionBuilder =
    OvulationTestsCompanion Function({
      required String id,
      required String userId,
      required DateTime date,
      required String result,
      required String timeOfDay,
      Value<String?> brand,
      Value<String?> photoPath,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$OvulationTestsTableUpdateCompanionBuilder =
    OvulationTestsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> date,
      Value<String> result,
      Value<String> timeOfDay,
      Value<String?> brand,
      Value<String?> photoPath,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$OvulationTestsTableFilterComposer
    extends Composer<_$AppDatabase, $OvulationTestsTable> {
  $$OvulationTestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OvulationTestsTableOrderingComposer
    extends Composer<_$AppDatabase, $OvulationTestsTable> {
  $$OvulationTestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OvulationTestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OvulationTestsTable> {
  $$OvulationTestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OvulationTestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OvulationTestsTable,
          OvulationTest,
          $$OvulationTestsTableFilterComposer,
          $$OvulationTestsTableOrderingComposer,
          $$OvulationTestsTableAnnotationComposer,
          $$OvulationTestsTableCreateCompanionBuilder,
          $$OvulationTestsTableUpdateCompanionBuilder,
          (
            OvulationTest,
            BaseReferences<_$AppDatabase, $OvulationTestsTable, OvulationTest>,
          ),
          OvulationTest,
          PrefetchHooks Function()
        > {
  $$OvulationTestsTableTableManager(
    _$AppDatabase db,
    $OvulationTestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OvulationTestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OvulationTestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OvulationTestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> timeOfDay = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvulationTestsCompanion(
                id: id,
                userId: userId,
                date: date,
                result: result,
                timeOfDay: timeOfDay,
                brand: brand,
                photoPath: photoPath,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime date,
                required String result,
                required String timeOfDay,
                Value<String?> brand = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OvulationTestsCompanion.insert(
                id: id,
                userId: userId,
                date: date,
                result: result,
                timeOfDay: timeOfDay,
                brand: brand,
                photoPath: photoPath,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OvulationTestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OvulationTestsTable,
      OvulationTest,
      $$OvulationTestsTableFilterComposer,
      $$OvulationTestsTableOrderingComposer,
      $$OvulationTestsTableAnnotationComposer,
      $$OvulationTestsTableCreateCompanionBuilder,
      $$OvulationTestsTableUpdateCompanionBuilder,
      (
        OvulationTest,
        BaseReferences<_$AppDatabase, $OvulationTestsTable, OvulationTest>,
      ),
      OvulationTest,
      PrefetchHooks Function()
    >;
typedef $$CervicalMucusObservationsTableCreateCompanionBuilder =
    CervicalMucusObservationsCompanion Function({
      required String id,
      required String cycleDayId,
      required String type,
      Value<String?> consistency,
      Value<String?> color,
      required String amount,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CervicalMucusObservationsTableUpdateCompanionBuilder =
    CervicalMucusObservationsCompanion Function({
      Value<String> id,
      Value<String> cycleDayId,
      Value<String> type,
      Value<String?> consistency,
      Value<String?> color,
      Value<String> amount,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CervicalMucusObservationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CervicalMucusObservationsTable,
          CervicalMucusObservation
        > {
  $$CervicalMucusObservationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CycleDaysTable _cycleDayIdTable(_$AppDatabase db) =>
      db.cycleDays.createAlias(
        $_aliasNameGenerator(
          db.cervicalMucusObservations.cycleDayId,
          db.cycleDays.id,
        ),
      );

  $$CycleDaysTableProcessedTableManager get cycleDayId {
    final $_column = $_itemColumn<String>('cycle_day_id')!;

    final manager = $$CycleDaysTableTableManager(
      $_db,
      $_db.cycleDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CervicalMucusObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $CervicalMucusObservationsTable> {
  $$CervicalMucusObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consistency => $composableBuilder(
    column: $table.consistency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CycleDaysTableFilterComposer get cycleDayId {
    final $$CycleDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableFilterComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CervicalMucusObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CervicalMucusObservationsTable> {
  $$CervicalMucusObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consistency => $composableBuilder(
    column: $table.consistency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CycleDaysTableOrderingComposer get cycleDayId {
    final $$CycleDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableOrderingComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CervicalMucusObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CervicalMucusObservationsTable> {
  $$CervicalMucusObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get consistency => $composableBuilder(
    column: $table.consistency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CycleDaysTableAnnotationComposer get cycleDayId {
    final $$CycleDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CervicalMucusObservationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CervicalMucusObservationsTable,
          CervicalMucusObservation,
          $$CervicalMucusObservationsTableFilterComposer,
          $$CervicalMucusObservationsTableOrderingComposer,
          $$CervicalMucusObservationsTableAnnotationComposer,
          $$CervicalMucusObservationsTableCreateCompanionBuilder,
          $$CervicalMucusObservationsTableUpdateCompanionBuilder,
          (
            CervicalMucusObservation,
            $$CervicalMucusObservationsTableReferences,
          ),
          CervicalMucusObservation,
          PrefetchHooks Function({bool cycleDayId})
        > {
  $$CervicalMucusObservationsTableTableManager(
    _$AppDatabase db,
    $CervicalMucusObservationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CervicalMucusObservationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CervicalMucusObservationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CervicalMucusObservationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cycleDayId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> consistency = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String> amount = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CervicalMucusObservationsCompanion(
                id: id,
                cycleDayId: cycleDayId,
                type: type,
                consistency: consistency,
                color: color,
                amount: amount,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cycleDayId,
                required String type,
                Value<String?> consistency = const Value.absent(),
                Value<String?> color = const Value.absent(),
                required String amount,
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CervicalMucusObservationsCompanion.insert(
                id: id,
                cycleDayId: cycleDayId,
                type: type,
                consistency: consistency,
                color: color,
                amount: amount,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CervicalMucusObservationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cycleDayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleDayId,
                                referencedTable:
                                    $$CervicalMucusObservationsTableReferences
                                        ._cycleDayIdTable(db),
                                referencedColumn:
                                    $$CervicalMucusObservationsTableReferences
                                        ._cycleDayIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CervicalMucusObservationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CervicalMucusObservationsTable,
      CervicalMucusObservation,
      $$CervicalMucusObservationsTableFilterComposer,
      $$CervicalMucusObservationsTableOrderingComposer,
      $$CervicalMucusObservationsTableAnnotationComposer,
      $$CervicalMucusObservationsTableCreateCompanionBuilder,
      $$CervicalMucusObservationsTableUpdateCompanionBuilder,
      (CervicalMucusObservation, $$CervicalMucusObservationsTableReferences),
      CervicalMucusObservation,
      PrefetchHooks Function({bool cycleDayId})
    >;
typedef $$PregnanciesTableCreateCompanionBuilder =
    PregnanciesCompanion Function({
      required String id,
      required String userId,
      Value<DateTime?> conceptionDate,
      required DateTime dueDate,
      required int currentWeek,
      required int currentTrimester,
      Value<String?> notes,
      Value<bool> isActive,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PregnanciesTableUpdateCompanionBuilder =
    PregnanciesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime?> conceptionDate,
      Value<DateTime> dueDate,
      Value<int> currentWeek,
      Value<int> currentTrimester,
      Value<String?> notes,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PregnanciesTableReferences
    extends BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy> {
  $$PregnanciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FetalMeasurementsTable, List<FetalMeasurement>>
  _fetalMeasurementsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.fetalMeasurements,
        aliasName: $_aliasNameGenerator(
          db.pregnancies.id,
          db.fetalMeasurements.pregnancyId,
        ),
      );

  $$FetalMeasurementsTableProcessedTableManager get fetalMeasurementsRefs {
    final manager = $$FetalMeasurementsTableTableManager(
      $_db,
      $_db.fetalMeasurements,
    ).filter((f) => f.pregnancyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fetalMeasurementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PregnanciesTableFilterComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get conceptionDate => $composableBuilder(
    column: $table.conceptionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentWeek => $composableBuilder(
    column: $table.currentWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentTrimester => $composableBuilder(
    column: $table.currentTrimester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fetalMeasurementsRefs(
    Expression<bool> Function($$FetalMeasurementsTableFilterComposer f) f,
  ) {
    final $$FetalMeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fetalMeasurements,
      getReferencedColumn: (t) => t.pregnancyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FetalMeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.fetalMeasurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PregnanciesTableOrderingComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get conceptionDate => $composableBuilder(
    column: $table.conceptionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentWeek => $composableBuilder(
    column: $table.currentWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentTrimester => $composableBuilder(
    column: $table.currentTrimester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PregnanciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get conceptionDate => $composableBuilder(
    column: $table.conceptionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get currentWeek => $composableBuilder(
    column: $table.currentWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentTrimester => $composableBuilder(
    column: $table.currentTrimester,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> fetalMeasurementsRefs<T extends Object>(
    Expression<T> Function($$FetalMeasurementsTableAnnotationComposer a) f,
  ) {
    final $$FetalMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.fetalMeasurements,
          getReferencedColumn: (t) => t.pregnancyId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FetalMeasurementsTableAnnotationComposer(
                $db: $db,
                $table: $db.fetalMeasurements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PregnanciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PregnanciesTable,
          Pregnancy,
          $$PregnanciesTableFilterComposer,
          $$PregnanciesTableOrderingComposer,
          $$PregnanciesTableAnnotationComposer,
          $$PregnanciesTableCreateCompanionBuilder,
          $$PregnanciesTableUpdateCompanionBuilder,
          (Pregnancy, $$PregnanciesTableReferences),
          Pregnancy,
          PrefetchHooks Function({bool fetalMeasurementsRefs})
        > {
  $$PregnanciesTableTableManager(_$AppDatabase db, $PregnanciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PregnanciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PregnanciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PregnanciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> conceptionDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> currentWeek = const Value.absent(),
                Value<int> currentTrimester = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PregnanciesCompanion(
                id: id,
                userId: userId,
                conceptionDate: conceptionDate,
                dueDate: dueDate,
                currentWeek: currentWeek,
                currentTrimester: currentTrimester,
                notes: notes,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<DateTime?> conceptionDate = const Value.absent(),
                required DateTime dueDate,
                required int currentWeek,
                required int currentTrimester,
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PregnanciesCompanion.insert(
                id: id,
                userId: userId,
                conceptionDate: conceptionDate,
                dueDate: dueDate,
                currentWeek: currentWeek,
                currentTrimester: currentTrimester,
                notes: notes,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PregnanciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fetalMeasurementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (fetalMeasurementsRefs) db.fetalMeasurements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (fetalMeasurementsRefs)
                    await $_getPrefetchedData<
                      Pregnancy,
                      $PregnanciesTable,
                      FetalMeasurement
                    >(
                      currentTable: table,
                      referencedTable: $$PregnanciesTableReferences
                          ._fetalMeasurementsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PregnanciesTableReferences(
                            db,
                            table,
                            p0,
                          ).fetalMeasurementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.pregnancyId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PregnanciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PregnanciesTable,
      Pregnancy,
      $$PregnanciesTableFilterComposer,
      $$PregnanciesTableOrderingComposer,
      $$PregnanciesTableAnnotationComposer,
      $$PregnanciesTableCreateCompanionBuilder,
      $$PregnanciesTableUpdateCompanionBuilder,
      (Pregnancy, $$PregnanciesTableReferences),
      Pregnancy,
      PrefetchHooks Function({bool fetalMeasurementsRefs})
    >;
typedef $$FetalMeasurementsTableCreateCompanionBuilder =
    FetalMeasurementsCompanion Function({
      required String id,
      required String pregnancyId,
      required DateTime date,
      Value<double?> weight,
      Value<int?> bloodPressureSystolic,
      Value<int?> bloodPressureDiastolic,
      Value<double?> glucoseLevel,
      Value<int?> kicksCount,
      Value<String?> contractionsJson,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$FetalMeasurementsTableUpdateCompanionBuilder =
    FetalMeasurementsCompanion Function({
      Value<String> id,
      Value<String> pregnancyId,
      Value<DateTime> date,
      Value<double?> weight,
      Value<int?> bloodPressureSystolic,
      Value<int?> bloodPressureDiastolic,
      Value<double?> glucoseLevel,
      Value<int?> kicksCount,
      Value<String?> contractionsJson,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$FetalMeasurementsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FetalMeasurementsTable,
          FetalMeasurement
        > {
  $$FetalMeasurementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PregnanciesTable _pregnancyIdTable(_$AppDatabase db) =>
      db.pregnancies.createAlias(
        $_aliasNameGenerator(
          db.fetalMeasurements.pregnancyId,
          db.pregnancies.id,
        ),
      );

  $$PregnanciesTableProcessedTableManager get pregnancyId {
    final $_column = $_itemColumn<String>('pregnancy_id')!;

    final manager = $$PregnanciesTableTableManager(
      $_db,
      $_db.pregnancies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pregnancyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FetalMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $FetalMeasurementsTable> {
  $$FetalMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bloodPressureSystolic => $composableBuilder(
    column: $table.bloodPressureSystolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bloodPressureDiastolic => $composableBuilder(
    column: $table.bloodPressureDiastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get glucoseLevel => $composableBuilder(
    column: $table.glucoseLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kicksCount => $composableBuilder(
    column: $table.kicksCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractionsJson => $composableBuilder(
    column: $table.contractionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PregnanciesTableFilterComposer get pregnancyId {
    final $$PregnanciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pregnancyId,
      referencedTable: $db.pregnancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PregnanciesTableFilterComposer(
            $db: $db,
            $table: $db.pregnancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FetalMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $FetalMeasurementsTable> {
  $$FetalMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bloodPressureSystolic => $composableBuilder(
    column: $table.bloodPressureSystolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bloodPressureDiastolic => $composableBuilder(
    column: $table.bloodPressureDiastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get glucoseLevel => $composableBuilder(
    column: $table.glucoseLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kicksCount => $composableBuilder(
    column: $table.kicksCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractionsJson => $composableBuilder(
    column: $table.contractionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PregnanciesTableOrderingComposer get pregnancyId {
    final $$PregnanciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pregnancyId,
      referencedTable: $db.pregnancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PregnanciesTableOrderingComposer(
            $db: $db,
            $table: $db.pregnancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FetalMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FetalMeasurementsTable> {
  $$FetalMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get bloodPressureSystolic => $composableBuilder(
    column: $table.bloodPressureSystolic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bloodPressureDiastolic => $composableBuilder(
    column: $table.bloodPressureDiastolic,
    builder: (column) => column,
  );

  GeneratedColumn<double> get glucoseLevel => $composableBuilder(
    column: $table.glucoseLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kicksCount => $composableBuilder(
    column: $table.kicksCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contractionsJson => $composableBuilder(
    column: $table.contractionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PregnanciesTableAnnotationComposer get pregnancyId {
    final $$PregnanciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pregnancyId,
      referencedTable: $db.pregnancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PregnanciesTableAnnotationComposer(
            $db: $db,
            $table: $db.pregnancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FetalMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FetalMeasurementsTable,
          FetalMeasurement,
          $$FetalMeasurementsTableFilterComposer,
          $$FetalMeasurementsTableOrderingComposer,
          $$FetalMeasurementsTableAnnotationComposer,
          $$FetalMeasurementsTableCreateCompanionBuilder,
          $$FetalMeasurementsTableUpdateCompanionBuilder,
          (FetalMeasurement, $$FetalMeasurementsTableReferences),
          FetalMeasurement,
          PrefetchHooks Function({bool pregnancyId})
        > {
  $$FetalMeasurementsTableTableManager(
    _$AppDatabase db,
    $FetalMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FetalMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FetalMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FetalMeasurementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pregnancyId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<int?> bloodPressureSystolic = const Value.absent(),
                Value<int?> bloodPressureDiastolic = const Value.absent(),
                Value<double?> glucoseLevel = const Value.absent(),
                Value<int?> kicksCount = const Value.absent(),
                Value<String?> contractionsJson = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FetalMeasurementsCompanion(
                id: id,
                pregnancyId: pregnancyId,
                date: date,
                weight: weight,
                bloodPressureSystolic: bloodPressureSystolic,
                bloodPressureDiastolic: bloodPressureDiastolic,
                glucoseLevel: glucoseLevel,
                kicksCount: kicksCount,
                contractionsJson: contractionsJson,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pregnancyId,
                required DateTime date,
                Value<double?> weight = const Value.absent(),
                Value<int?> bloodPressureSystolic = const Value.absent(),
                Value<int?> bloodPressureDiastolic = const Value.absent(),
                Value<double?> glucoseLevel = const Value.absent(),
                Value<int?> kicksCount = const Value.absent(),
                Value<String?> contractionsJson = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FetalMeasurementsCompanion.insert(
                id: id,
                pregnancyId: pregnancyId,
                date: date,
                weight: weight,
                bloodPressureSystolic: bloodPressureSystolic,
                bloodPressureDiastolic: bloodPressureDiastolic,
                glucoseLevel: glucoseLevel,
                kicksCount: kicksCount,
                contractionsJson: contractionsJson,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FetalMeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pregnancyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pregnancyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pregnancyId,
                                referencedTable:
                                    $$FetalMeasurementsTableReferences
                                        ._pregnancyIdTable(db),
                                referencedColumn:
                                    $$FetalMeasurementsTableReferences
                                        ._pregnancyIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FetalMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FetalMeasurementsTable,
      FetalMeasurement,
      $$FetalMeasurementsTableFilterComposer,
      $$FetalMeasurementsTableOrderingComposer,
      $$FetalMeasurementsTableAnnotationComposer,
      $$FetalMeasurementsTableCreateCompanionBuilder,
      $$FetalMeasurementsTableUpdateCompanionBuilder,
      (FetalMeasurement, $$FetalMeasurementsTableReferences),
      FetalMeasurement,
      PrefetchHooks Function({bool pregnancyId})
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      required String id,
      Value<String?> cycleDayId,
      required DateTime date,
      Value<String?> title,
      Value<String?> content,
      Value<String?> photoPaths,
      Value<String?> voiceNotePath,
      Value<int?> moodRating,
      Value<bool> isSynced,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      Value<String?> cycleDayId,
      Value<DateTime> date,
      Value<String?> title,
      Value<String?> content,
      Value<String?> photoPaths,
      Value<String?> voiceNotePath,
      Value<int?> moodRating,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$JournalEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CycleDaysTable _cycleDayIdTable(_$AppDatabase db) =>
      db.cycleDays.createAlias(
        $_aliasNameGenerator(db.journalEntries.cycleDayId, db.cycleDays.id),
      );

  $$CycleDaysTableProcessedTableManager? get cycleDayId {
    final $_column = $_itemColumn<String>('cycle_day_id');
    if ($_column == null) return null;
    final manager = $$CycleDaysTableTableManager(
      $_db,
      $_db.cycleDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CycleDaysTableFilterComposer get cycleDayId {
    final $$CycleDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableFilterComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CycleDaysTableOrderingComposer get cycleDayId {
    final $$CycleDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableOrderingComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CycleDaysTableAnnotationComposer get cycleDayId {
    final $$CycleDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleDayId,
      referencedTable: $db.cycleDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CycleDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.cycleDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (JournalEntry, $$JournalEntriesTableReferences),
          JournalEntry,
          PrefetchHooks Function({bool cycleDayId})
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> cycleDayId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                Value<int?> moodRating = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                cycleDayId: cycleDayId,
                date: date,
                title: title,
                content: content,
                photoPaths: photoPaths,
                voiceNotePath: voiceNotePath,
                moodRating: moodRating,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> cycleDayId = const Value.absent(),
                required DateTime date,
                Value<String?> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                Value<int?> moodRating = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                cycleDayId: cycleDayId,
                date: date,
                title: title,
                content: content,
                photoPaths: photoPaths,
                voiceNotePath: voiceNotePath,
                moodRating: moodRating,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cycleDayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleDayId,
                                referencedTable: $$JournalEntriesTableReferences
                                    ._cycleDayIdTable(db),
                                referencedColumn:
                                    $$JournalEntriesTableReferences
                                        ._cycleDayIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (JournalEntry, $$JournalEntriesTableReferences),
      JournalEntry,
      PrefetchHooks Function({bool cycleDayId})
    >;
typedef $$UserConditionsTableCreateCompanionBuilder =
    UserConditionsCompanion Function({
      required String id,
      required String userId,
      required String conditionType,
      Value<DateTime?> diagnosisDate,
      Value<bool> isActive,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserConditionsTableUpdateCompanionBuilder =
    UserConditionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> conditionType,
      Value<DateTime?> diagnosisDate,
      Value<bool> isActive,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserConditionsTable> {
  $$UserConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionType => $composableBuilder(
    column: $table.conditionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diagnosisDate => $composableBuilder(
    column: $table.diagnosisDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserConditionsTable> {
  $$UserConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionType => $composableBuilder(
    column: $table.conditionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diagnosisDate => $composableBuilder(
    column: $table.diagnosisDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserConditionsTable> {
  $$UserConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get conditionType => $composableBuilder(
    column: $table.conditionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diagnosisDate => $composableBuilder(
    column: $table.diagnosisDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserConditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserConditionsTable,
          UserCondition,
          $$UserConditionsTableFilterComposer,
          $$UserConditionsTableOrderingComposer,
          $$UserConditionsTableAnnotationComposer,
          $$UserConditionsTableCreateCompanionBuilder,
          $$UserConditionsTableUpdateCompanionBuilder,
          (
            UserCondition,
            BaseReferences<_$AppDatabase, $UserConditionsTable, UserCondition>,
          ),
          UserCondition,
          PrefetchHooks Function()
        > {
  $$UserConditionsTableTableManager(
    _$AppDatabase db,
    $UserConditionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> conditionType = const Value.absent(),
                Value<DateTime?> diagnosisDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserConditionsCompanion(
                id: id,
                userId: userId,
                conditionType: conditionType,
                diagnosisDate: diagnosisDate,
                isActive: isActive,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String conditionType,
                Value<DateTime?> diagnosisDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserConditionsCompanion.insert(
                id: id,
                userId: userId,
                conditionType: conditionType,
                diagnosisDate: diagnosisDate,
                isActive: isActive,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserConditionsTable,
      UserCondition,
      $$UserConditionsTableFilterComposer,
      $$UserConditionsTableOrderingComposer,
      $$UserConditionsTableAnnotationComposer,
      $$UserConditionsTableCreateCompanionBuilder,
      $$UserConditionsTableUpdateCompanionBuilder,
      (
        UserCondition,
        BaseReferences<_$AppDatabase, $UserConditionsTable, UserCondition>,
      ),
      UserCondition,
      PrefetchHooks Function()
    >;
typedef $$WearableSourcesTableCreateCompanionBuilder =
    WearableSourcesCompanion Function({
      required String id,
      required String userId,
      required String sourceType,
      Value<bool> isConnected,
      Value<DateTime?> lastSyncAt,
      Value<String?> settingsJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WearableSourcesTableUpdateCompanionBuilder =
    WearableSourcesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> sourceType,
      Value<bool> isConnected,
      Value<DateTime?> lastSyncAt,
      Value<String?> settingsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WearableSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $WearableSourcesTable> {
  $$WearableSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConnected => $composableBuilder(
    column: $table.isConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WearableSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $WearableSourcesTable> {
  $$WearableSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConnected => $composableBuilder(
    column: $table.isConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WearableSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WearableSourcesTable> {
  $$WearableSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isConnected => $composableBuilder(
    column: $table.isConnected,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WearableSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WearableSourcesTable,
          WearableSource,
          $$WearableSourcesTableFilterComposer,
          $$WearableSourcesTableOrderingComposer,
          $$WearableSourcesTableAnnotationComposer,
          $$WearableSourcesTableCreateCompanionBuilder,
          $$WearableSourcesTableUpdateCompanionBuilder,
          (
            WearableSource,
            BaseReferences<
              _$AppDatabase,
              $WearableSourcesTable,
              WearableSource
            >,
          ),
          WearableSource,
          PrefetchHooks Function()
        > {
  $$WearableSourcesTableTableManager(
    _$AppDatabase db,
    $WearableSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WearableSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WearableSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WearableSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<bool> isConnected = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String?> settingsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WearableSourcesCompanion(
                id: id,
                userId: userId,
                sourceType: sourceType,
                isConnected: isConnected,
                lastSyncAt: lastSyncAt,
                settingsJson: settingsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String sourceType,
                Value<bool> isConnected = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String?> settingsJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WearableSourcesCompanion.insert(
                id: id,
                userId: userId,
                sourceType: sourceType,
                isConnected: isConnected,
                lastSyncAt: lastSyncAt,
                settingsJson: settingsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WearableSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WearableSourcesTable,
      WearableSource,
      $$WearableSourcesTableFilterComposer,
      $$WearableSourcesTableOrderingComposer,
      $$WearableSourcesTableAnnotationComposer,
      $$WearableSourcesTableCreateCompanionBuilder,
      $$WearableSourcesTableUpdateCompanionBuilder,
      (
        WearableSource,
        BaseReferences<_$AppDatabase, $WearableSourcesTable, WearableSource>,
      ),
      WearableSource,
      PrefetchHooks Function()
    >;
typedef $$EducationArticlesTableCreateCompanionBuilder =
    EducationArticlesCompanion Function({
      required String id,
      required String title,
      required String content,
      required String category,
      Value<String?> summary,
      Value<bool> isOfflineAvailable,
      Value<DateTime?> medicalReviewDate,
      Value<String?> reviewAuthor,
      Value<int?> readTimeMinutes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EducationArticlesTableUpdateCompanionBuilder =
    EducationArticlesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<String> category,
      Value<String?> summary,
      Value<bool> isOfflineAvailable,
      Value<DateTime?> medicalReviewDate,
      Value<String?> reviewAuthor,
      Value<int?> readTimeMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$EducationArticlesTableFilterComposer
    extends Composer<_$AppDatabase, $EducationArticlesTable> {
  $$EducationArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOfflineAvailable => $composableBuilder(
    column: $table.isOfflineAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get medicalReviewDate => $composableBuilder(
    column: $table.medicalReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewAuthor => $composableBuilder(
    column: $table.reviewAuthor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readTimeMinutes => $composableBuilder(
    column: $table.readTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EducationArticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $EducationArticlesTable> {
  $$EducationArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOfflineAvailable => $composableBuilder(
    column: $table.isOfflineAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get medicalReviewDate => $composableBuilder(
    column: $table.medicalReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewAuthor => $composableBuilder(
    column: $table.reviewAuthor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readTimeMinutes => $composableBuilder(
    column: $table.readTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EducationArticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EducationArticlesTable> {
  $$EducationArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<bool> get isOfflineAvailable => $composableBuilder(
    column: $table.isOfflineAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get medicalReviewDate => $composableBuilder(
    column: $table.medicalReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewAuthor => $composableBuilder(
    column: $table.reviewAuthor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get readTimeMinutes => $composableBuilder(
    column: $table.readTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EducationArticlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EducationArticlesTable,
          EducationArticle,
          $$EducationArticlesTableFilterComposer,
          $$EducationArticlesTableOrderingComposer,
          $$EducationArticlesTableAnnotationComposer,
          $$EducationArticlesTableCreateCompanionBuilder,
          $$EducationArticlesTableUpdateCompanionBuilder,
          (
            EducationArticle,
            BaseReferences<
              _$AppDatabase,
              $EducationArticlesTable,
              EducationArticle
            >,
          ),
          EducationArticle,
          PrefetchHooks Function()
        > {
  $$EducationArticlesTableTableManager(
    _$AppDatabase db,
    $EducationArticlesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EducationArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EducationArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EducationArticlesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<bool> isOfflineAvailable = const Value.absent(),
                Value<DateTime?> medicalReviewDate = const Value.absent(),
                Value<String?> reviewAuthor = const Value.absent(),
                Value<int?> readTimeMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EducationArticlesCompanion(
                id: id,
                title: title,
                content: content,
                category: category,
                summary: summary,
                isOfflineAvailable: isOfflineAvailable,
                medicalReviewDate: medicalReviewDate,
                reviewAuthor: reviewAuthor,
                readTimeMinutes: readTimeMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String content,
                required String category,
                Value<String?> summary = const Value.absent(),
                Value<bool> isOfflineAvailable = const Value.absent(),
                Value<DateTime?> medicalReviewDate = const Value.absent(),
                Value<String?> reviewAuthor = const Value.absent(),
                Value<int?> readTimeMinutes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EducationArticlesCompanion.insert(
                id: id,
                title: title,
                content: content,
                category: category,
                summary: summary,
                isOfflineAvailable: isOfflineAvailable,
                medicalReviewDate: medicalReviewDate,
                reviewAuthor: reviewAuthor,
                readTimeMinutes: readTimeMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EducationArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EducationArticlesTable,
      EducationArticle,
      $$EducationArticlesTableFilterComposer,
      $$EducationArticlesTableOrderingComposer,
      $$EducationArticlesTableAnnotationComposer,
      $$EducationArticlesTableCreateCompanionBuilder,
      $$EducationArticlesTableUpdateCompanionBuilder,
      (
        EducationArticle,
        BaseReferences<
          _$AppDatabase,
          $EducationArticlesTable,
          EducationArticle
        >,
      ),
      EducationArticle,
      PrefetchHooks Function()
    >;
typedef $$CommunityPostsTableCreateCompanionBuilder =
    CommunityPostsCompanion Function({
      required String id,
      required String userId,
      required String topicId,
      required String content,
      Value<bool> isAnonymous,
      Value<bool> isModerated,
      Value<String?> moderationAction,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CommunityPostsTableUpdateCompanionBuilder =
    CommunityPostsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> topicId,
      Value<String> content,
      Value<bool> isAnonymous,
      Value<bool> isModerated,
      Value<String?> moderationAction,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CommunityPostsTableFilterComposer
    extends Composer<_$AppDatabase, $CommunityPostsTable> {
  $$CommunityPostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAnonymous => $composableBuilder(
    column: $table.isAnonymous,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isModerated => $composableBuilder(
    column: $table.isModerated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moderationAction => $composableBuilder(
    column: $table.moderationAction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CommunityPostsTableOrderingComposer
    extends Composer<_$AppDatabase, $CommunityPostsTable> {
  $$CommunityPostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAnonymous => $composableBuilder(
    column: $table.isAnonymous,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isModerated => $composableBuilder(
    column: $table.isModerated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moderationAction => $composableBuilder(
    column: $table.moderationAction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommunityPostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommunityPostsTable> {
  $$CommunityPostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isAnonymous => $composableBuilder(
    column: $table.isAnonymous,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isModerated => $composableBuilder(
    column: $table.isModerated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moderationAction => $composableBuilder(
    column: $table.moderationAction,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CommunityPostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommunityPostsTable,
          CommunityPost,
          $$CommunityPostsTableFilterComposer,
          $$CommunityPostsTableOrderingComposer,
          $$CommunityPostsTableAnnotationComposer,
          $$CommunityPostsTableCreateCompanionBuilder,
          $$CommunityPostsTableUpdateCompanionBuilder,
          (
            CommunityPost,
            BaseReferences<_$AppDatabase, $CommunityPostsTable, CommunityPost>,
          ),
          CommunityPost,
          PrefetchHooks Function()
        > {
  $$CommunityPostsTableTableManager(
    _$AppDatabase db,
    $CommunityPostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommunityPostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommunityPostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommunityPostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isAnonymous = const Value.absent(),
                Value<bool> isModerated = const Value.absent(),
                Value<String?> moderationAction = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommunityPostsCompanion(
                id: id,
                userId: userId,
                topicId: topicId,
                content: content,
                isAnonymous: isAnonymous,
                isModerated: isModerated,
                moderationAction: moderationAction,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String topicId,
                required String content,
                Value<bool> isAnonymous = const Value.absent(),
                Value<bool> isModerated = const Value.absent(),
                Value<String?> moderationAction = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CommunityPostsCompanion.insert(
                id: id,
                userId: userId,
                topicId: topicId,
                content: content,
                isAnonymous: isAnonymous,
                isModerated: isModerated,
                moderationAction: moderationAction,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CommunityPostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommunityPostsTable,
      CommunityPost,
      $$CommunityPostsTableFilterComposer,
      $$CommunityPostsTableOrderingComposer,
      $$CommunityPostsTableAnnotationComposer,
      $$CommunityPostsTableCreateCompanionBuilder,
      $$CommunityPostsTableUpdateCompanionBuilder,
      (
        CommunityPost,
        BaseReferences<_$AppDatabase, $CommunityPostsTable, CommunityPost>,
      ),
      CommunityPost,
      PrefetchHooks Function()
    >;
typedef $$HealthReportsTableCreateCompanionBuilder =
    HealthReportsCompanion Function({
      required String id,
      required String userId,
      required String reportType,
      required DateTime dateRangeStart,
      required DateTime dateRangeEnd,
      Value<String?> filePath,
      Value<int?> fileSize,
      Value<bool> isSynced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$HealthReportsTableUpdateCompanionBuilder =
    HealthReportsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> reportType,
      Value<DateTime> dateRangeStart,
      Value<DateTime> dateRangeEnd,
      Value<String?> filePath,
      Value<int?> fileSize,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HealthReportsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthReportsTable> {
  $$HealthReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateRangeStart => $composableBuilder(
    column: $table.dateRangeStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateRangeEnd => $composableBuilder(
    column: $table.dateRangeEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthReportsTable> {
  $$HealthReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateRangeStart => $composableBuilder(
    column: $table.dateRangeStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateRangeEnd => $composableBuilder(
    column: $table.dateRangeEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthReportsTable> {
  $$HealthReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateRangeStart => $composableBuilder(
    column: $table.dateRangeStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateRangeEnd => $composableBuilder(
    column: $table.dateRangeEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HealthReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthReportsTable,
          HealthReport,
          $$HealthReportsTableFilterComposer,
          $$HealthReportsTableOrderingComposer,
          $$HealthReportsTableAnnotationComposer,
          $$HealthReportsTableCreateCompanionBuilder,
          $$HealthReportsTableUpdateCompanionBuilder,
          (
            HealthReport,
            BaseReferences<_$AppDatabase, $HealthReportsTable, HealthReport>,
          ),
          HealthReport,
          PrefetchHooks Function()
        > {
  $$HealthReportsTableTableManager(_$AppDatabase db, $HealthReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> reportType = const Value.absent(),
                Value<DateTime> dateRangeStart = const Value.absent(),
                Value<DateTime> dateRangeEnd = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthReportsCompanion(
                id: id,
                userId: userId,
                reportType: reportType,
                dateRangeStart: dateRangeStart,
                dateRangeEnd: dateRangeEnd,
                filePath: filePath,
                fileSize: fileSize,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String reportType,
                required DateTime dateRangeStart,
                required DateTime dateRangeEnd,
                Value<String?> filePath = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => HealthReportsCompanion.insert(
                id: id,
                userId: userId,
                reportType: reportType,
                dateRangeStart: dateRangeStart,
                dateRangeEnd: dateRangeEnd,
                filePath: filePath,
                fileSize: fileSize,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthReportsTable,
      HealthReport,
      $$HealthReportsTableFilterComposer,
      $$HealthReportsTableOrderingComposer,
      $$HealthReportsTableAnnotationComposer,
      $$HealthReportsTableCreateCompanionBuilder,
      $$HealthReportsTableUpdateCompanionBuilder,
      (
        HealthReport,
        BaseReferences<_$AppDatabase, $HealthReportsTable, HealthReport>,
      ),
      HealthReport,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String id,
      Value<String?> userId,
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                userId: userId,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                userId: userId,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$CycleDaysTableTableManager get cycleDays =>
      $$CycleDaysTableTableManager(_db, _db.cycleDays);
  $$SymptomsTableTableManager get symptoms =>
      $$SymptomsTableTableManager(_db, _db.symptoms);
  $$SymptomLogsTableTableManager get symptomLogs =>
      $$SymptomLogsTableTableManager(_db, _db.symptomLogs);
  $$BbtRecordsTableTableManager get bbtRecords =>
      $$BbtRecordsTableTableManager(_db, _db.bbtRecords);
  $$OvulationTestsTableTableManager get ovulationTests =>
      $$OvulationTestsTableTableManager(_db, _db.ovulationTests);
  $$CervicalMucusObservationsTableTableManager get cervicalMucusObservations =>
      $$CervicalMucusObservationsTableTableManager(
        _db,
        _db.cervicalMucusObservations,
      );
  $$PregnanciesTableTableManager get pregnancies =>
      $$PregnanciesTableTableManager(_db, _db.pregnancies);
  $$FetalMeasurementsTableTableManager get fetalMeasurements =>
      $$FetalMeasurementsTableTableManager(_db, _db.fetalMeasurements);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$UserConditionsTableTableManager get userConditions =>
      $$UserConditionsTableTableManager(_db, _db.userConditions);
  $$WearableSourcesTableTableManager get wearableSources =>
      $$WearableSourcesTableTableManager(_db, _db.wearableSources);
  $$EducationArticlesTableTableManager get educationArticles =>
      $$EducationArticlesTableTableManager(_db, _db.educationArticles);
  $$CommunityPostsTableTableManager get communityPosts =>
      $$CommunityPostsTableTableManager(_db, _db.communityPosts);
  $$HealthReportsTableTableManager get healthReports =>
      $$HealthReportsTableTableManager(_db, _db.healthReports);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'68c9ad772c198d1a34d2dcccc0a6a35f43092fd5';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
