// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pregnancy_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Pregnancy _$PregnancyFromJson(Map<String, dynamic> json) {
  return _Pregnancy.fromJson(json);
}

/// @nodoc
mixin _$Pregnancy {
  String get id => throw _privateConstructorUsedError;
  DateTime? get conceptionDate => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  int get currentWeek => throw _privateConstructorUsedError;
  int get currentTrimester => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Pregnancy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pregnancy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PregnancyCopyWith<Pregnancy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PregnancyCopyWith<$Res> {
  factory $PregnancyCopyWith(Pregnancy value, $Res Function(Pregnancy) then) =
      _$PregnancyCopyWithImpl<$Res, Pregnancy>;
  @useResult
  $Res call({
    String id,
    DateTime? conceptionDate,
    DateTime dueDate,
    int currentWeek,
    int currentTrimester,
    bool isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$PregnancyCopyWithImpl<$Res, $Val extends Pregnancy>
    implements $PregnancyCopyWith<$Res> {
  _$PregnancyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pregnancy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptionDate = freezed,
    Object? dueDate = null,
    Object? currentWeek = null,
    Object? currentTrimester = null,
    Object? isActive = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conceptionDate: freezed == conceptionDate
                ? _value.conceptionDate
                : conceptionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            currentWeek: null == currentWeek
                ? _value.currentWeek
                : currentWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            currentTrimester: null == currentTrimester
                ? _value.currentTrimester
                : currentTrimester // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PregnancyImplCopyWith<$Res>
    implements $PregnancyCopyWith<$Res> {
  factory _$$PregnancyImplCopyWith(
    _$PregnancyImpl value,
    $Res Function(_$PregnancyImpl) then,
  ) = __$$PregnancyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime? conceptionDate,
    DateTime dueDate,
    int currentWeek,
    int currentTrimester,
    bool isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PregnancyImplCopyWithImpl<$Res>
    extends _$PregnancyCopyWithImpl<$Res, _$PregnancyImpl>
    implements _$$PregnancyImplCopyWith<$Res> {
  __$$PregnancyImplCopyWithImpl(
    _$PregnancyImpl _value,
    $Res Function(_$PregnancyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Pregnancy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptionDate = freezed,
    Object? dueDate = null,
    Object? currentWeek = null,
    Object? currentTrimester = null,
    Object? isActive = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PregnancyImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptionDate: freezed == conceptionDate
            ? _value.conceptionDate
            : conceptionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        currentWeek: null == currentWeek
            ? _value.currentWeek
            : currentWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        currentTrimester: null == currentTrimester
            ? _value.currentTrimester
            : currentTrimester // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PregnancyImpl extends _Pregnancy {
  const _$PregnancyImpl({
    required this.id,
    this.conceptionDate,
    required this.dueDate,
    required this.currentWeek,
    required this.currentTrimester,
    this.isActive = true,
    this.notes,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$PregnancyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PregnancyImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime? conceptionDate;
  @override
  final DateTime dueDate;
  @override
  final int currentWeek;
  @override
  final int currentTrimester;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Pregnancy(id: $id, conceptionDate: $conceptionDate, dueDate: $dueDate, currentWeek: $currentWeek, currentTrimester: $currentTrimester, isActive: $isActive, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PregnancyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conceptionDate, conceptionDate) ||
                other.conceptionDate == conceptionDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.currentWeek, currentWeek) ||
                other.currentWeek == currentWeek) &&
            (identical(other.currentTrimester, currentTrimester) ||
                other.currentTrimester == currentTrimester) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conceptionDate,
    dueDate,
    currentWeek,
    currentTrimester,
    isActive,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Pregnancy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PregnancyImplCopyWith<_$PregnancyImpl> get copyWith =>
      __$$PregnancyImplCopyWithImpl<_$PregnancyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PregnancyImplToJson(this);
  }
}

abstract class _Pregnancy extends Pregnancy {
  const factory _Pregnancy({
    required final String id,
    final DateTime? conceptionDate,
    required final DateTime dueDate,
    required final int currentWeek,
    required final int currentTrimester,
    final bool isActive,
    final String? notes,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$PregnancyImpl;
  const _Pregnancy._() : super._();

  factory _Pregnancy.fromJson(Map<String, dynamic> json) =
      _$PregnancyImpl.fromJson;

  @override
  String get id;
  @override
  DateTime? get conceptionDate;
  @override
  DateTime get dueDate;
  @override
  int get currentWeek;
  @override
  int get currentTrimester;
  @override
  bool get isActive;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Pregnancy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PregnancyImplCopyWith<_$PregnancyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FetalMeasurement _$FetalMeasurementFromJson(Map<String, dynamic> json) {
  return _FetalMeasurement.fromJson(json);
}

/// @nodoc
mixin _$FetalMeasurement {
  String get id => throw _privateConstructorUsedError;
  String get pregnancyId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get weightPercentile => throw _privateConstructorUsedError;
  int? get bloodPressureSystolic => throw _privateConstructorUsedError;
  int? get bloodPressureDiastolic => throw _privateConstructorUsedError;
  double? get glucoseLevel => throw _privateConstructorUsedError;
  int? get kicksCount => throw _privateConstructorUsedError;
  int? get kicksDurationMinutes => throw _privateConstructorUsedError;
  String? get contractionsJson => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this FetalMeasurement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FetalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FetalMeasurementCopyWith<FetalMeasurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FetalMeasurementCopyWith<$Res> {
  factory $FetalMeasurementCopyWith(
    FetalMeasurement value,
    $Res Function(FetalMeasurement) then,
  ) = _$FetalMeasurementCopyWithImpl<$Res, FetalMeasurement>;
  @useResult
  $Res call({
    String id,
    String pregnancyId,
    DateTime date,
    double? weight,
    double? weightPercentile,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    double? glucoseLevel,
    int? kicksCount,
    int? kicksDurationMinutes,
    String? contractionsJson,
    String? notes,
  });
}

/// @nodoc
class _$FetalMeasurementCopyWithImpl<$Res, $Val extends FetalMeasurement>
    implements $FetalMeasurementCopyWith<$Res> {
  _$FetalMeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FetalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pregnancyId = null,
    Object? date = null,
    Object? weight = freezed,
    Object? weightPercentile = freezed,
    Object? bloodPressureSystolic = freezed,
    Object? bloodPressureDiastolic = freezed,
    Object? glucoseLevel = freezed,
    Object? kicksCount = freezed,
    Object? kicksDurationMinutes = freezed,
    Object? contractionsJson = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            pregnancyId: null == pregnancyId
                ? _value.pregnancyId
                : pregnancyId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
            weightPercentile: freezed == weightPercentile
                ? _value.weightPercentile
                : weightPercentile // ignore: cast_nullable_to_non_nullable
                      as double?,
            bloodPressureSystolic: freezed == bloodPressureSystolic
                ? _value.bloodPressureSystolic
                : bloodPressureSystolic // ignore: cast_nullable_to_non_nullable
                      as int?,
            bloodPressureDiastolic: freezed == bloodPressureDiastolic
                ? _value.bloodPressureDiastolic
                : bloodPressureDiastolic // ignore: cast_nullable_to_non_nullable
                      as int?,
            glucoseLevel: freezed == glucoseLevel
                ? _value.glucoseLevel
                : glucoseLevel // ignore: cast_nullable_to_non_nullable
                      as double?,
            kicksCount: freezed == kicksCount
                ? _value.kicksCount
                : kicksCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            kicksDurationMinutes: freezed == kicksDurationMinutes
                ? _value.kicksDurationMinutes
                : kicksDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            contractionsJson: freezed == contractionsJson
                ? _value.contractionsJson
                : contractionsJson // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FetalMeasurementImplCopyWith<$Res>
    implements $FetalMeasurementCopyWith<$Res> {
  factory _$$FetalMeasurementImplCopyWith(
    _$FetalMeasurementImpl value,
    $Res Function(_$FetalMeasurementImpl) then,
  ) = __$$FetalMeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String pregnancyId,
    DateTime date,
    double? weight,
    double? weightPercentile,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    double? glucoseLevel,
    int? kicksCount,
    int? kicksDurationMinutes,
    String? contractionsJson,
    String? notes,
  });
}

/// @nodoc
class __$$FetalMeasurementImplCopyWithImpl<$Res>
    extends _$FetalMeasurementCopyWithImpl<$Res, _$FetalMeasurementImpl>
    implements _$$FetalMeasurementImplCopyWith<$Res> {
  __$$FetalMeasurementImplCopyWithImpl(
    _$FetalMeasurementImpl _value,
    $Res Function(_$FetalMeasurementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FetalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pregnancyId = null,
    Object? date = null,
    Object? weight = freezed,
    Object? weightPercentile = freezed,
    Object? bloodPressureSystolic = freezed,
    Object? bloodPressureDiastolic = freezed,
    Object? glucoseLevel = freezed,
    Object? kicksCount = freezed,
    Object? kicksDurationMinutes = freezed,
    Object? contractionsJson = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$FetalMeasurementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        pregnancyId: null == pregnancyId
            ? _value.pregnancyId
            : pregnancyId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
        weightPercentile: freezed == weightPercentile
            ? _value.weightPercentile
            : weightPercentile // ignore: cast_nullable_to_non_nullable
                  as double?,
        bloodPressureSystolic: freezed == bloodPressureSystolic
            ? _value.bloodPressureSystolic
            : bloodPressureSystolic // ignore: cast_nullable_to_non_nullable
                  as int?,
        bloodPressureDiastolic: freezed == bloodPressureDiastolic
            ? _value.bloodPressureDiastolic
            : bloodPressureDiastolic // ignore: cast_nullable_to_non_nullable
                  as int?,
        glucoseLevel: freezed == glucoseLevel
            ? _value.glucoseLevel
            : glucoseLevel // ignore: cast_nullable_to_non_nullable
                  as double?,
        kicksCount: freezed == kicksCount
            ? _value.kicksCount
            : kicksCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        kicksDurationMinutes: freezed == kicksDurationMinutes
            ? _value.kicksDurationMinutes
            : kicksDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        contractionsJson: freezed == contractionsJson
            ? _value.contractionsJson
            : contractionsJson // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FetalMeasurementImpl implements _FetalMeasurement {
  const _$FetalMeasurementImpl({
    required this.id,
    required this.pregnancyId,
    required this.date,
    this.weight,
    this.weightPercentile,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.glucoseLevel,
    this.kicksCount,
    this.kicksDurationMinutes,
    this.contractionsJson,
    this.notes,
  });

  factory _$FetalMeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$FetalMeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final String pregnancyId;
  @override
  final DateTime date;
  @override
  final double? weight;
  @override
  final double? weightPercentile;
  @override
  final int? bloodPressureSystolic;
  @override
  final int? bloodPressureDiastolic;
  @override
  final double? glucoseLevel;
  @override
  final int? kicksCount;
  @override
  final int? kicksDurationMinutes;
  @override
  final String? contractionsJson;
  @override
  final String? notes;

  @override
  String toString() {
    return 'FetalMeasurement(id: $id, pregnancyId: $pregnancyId, date: $date, weight: $weight, weightPercentile: $weightPercentile, bloodPressureSystolic: $bloodPressureSystolic, bloodPressureDiastolic: $bloodPressureDiastolic, glucoseLevel: $glucoseLevel, kicksCount: $kicksCount, kicksDurationMinutes: $kicksDurationMinutes, contractionsJson: $contractionsJson, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetalMeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pregnancyId, pregnancyId) ||
                other.pregnancyId == pregnancyId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.weightPercentile, weightPercentile) ||
                other.weightPercentile == weightPercentile) &&
            (identical(other.bloodPressureSystolic, bloodPressureSystolic) ||
                other.bloodPressureSystolic == bloodPressureSystolic) &&
            (identical(other.bloodPressureDiastolic, bloodPressureDiastolic) ||
                other.bloodPressureDiastolic == bloodPressureDiastolic) &&
            (identical(other.glucoseLevel, glucoseLevel) ||
                other.glucoseLevel == glucoseLevel) &&
            (identical(other.kicksCount, kicksCount) ||
                other.kicksCount == kicksCount) &&
            (identical(other.kicksDurationMinutes, kicksDurationMinutes) ||
                other.kicksDurationMinutes == kicksDurationMinutes) &&
            (identical(other.contractionsJson, contractionsJson) ||
                other.contractionsJson == contractionsJson) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pregnancyId,
    date,
    weight,
    weightPercentile,
    bloodPressureSystolic,
    bloodPressureDiastolic,
    glucoseLevel,
    kicksCount,
    kicksDurationMinutes,
    contractionsJson,
    notes,
  );

  /// Create a copy of FetalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetalMeasurementImplCopyWith<_$FetalMeasurementImpl> get copyWith =>
      __$$FetalMeasurementImplCopyWithImpl<_$FetalMeasurementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FetalMeasurementImplToJson(this);
  }
}

abstract class _FetalMeasurement implements FetalMeasurement {
  const factory _FetalMeasurement({
    required final String id,
    required final String pregnancyId,
    required final DateTime date,
    final double? weight,
    final double? weightPercentile,
    final int? bloodPressureSystolic,
    final int? bloodPressureDiastolic,
    final double? glucoseLevel,
    final int? kicksCount,
    final int? kicksDurationMinutes,
    final String? contractionsJson,
    final String? notes,
  }) = _$FetalMeasurementImpl;

  factory _FetalMeasurement.fromJson(Map<String, dynamic> json) =
      _$FetalMeasurementImpl.fromJson;

  @override
  String get id;
  @override
  String get pregnancyId;
  @override
  DateTime get date;
  @override
  double? get weight;
  @override
  double? get weightPercentile;
  @override
  int? get bloodPressureSystolic;
  @override
  int? get bloodPressureDiastolic;
  @override
  double? get glucoseLevel;
  @override
  int? get kicksCount;
  @override
  int? get kicksDurationMinutes;
  @override
  String? get contractionsJson;
  @override
  String? get notes;

  /// Create a copy of FetalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetalMeasurementImplCopyWith<_$FetalMeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeeklyMilestone {
  int get week => throw _privateConstructorUsedError;
  String get babySizeComparison => throw _privateConstructorUsedError;
  double get babyLengthCm => throw _privateConstructorUsedError;
  double get babyWeightG => throw _privateConstructorUsedError;
  String get developmentSummary => throw _privateConstructorUsedError;
  String get maternalChanges => throw _privateConstructorUsedError;
  List<String> get symptoms => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;
  String? get imageAsset => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyMilestoneCopyWith<WeeklyMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyMilestoneCopyWith<$Res> {
  factory $WeeklyMilestoneCopyWith(
    WeeklyMilestone value,
    $Res Function(WeeklyMilestone) then,
  ) = _$WeeklyMilestoneCopyWithImpl<$Res, WeeklyMilestone>;
  @useResult
  $Res call({
    int week,
    String babySizeComparison,
    double babyLengthCm,
    double babyWeightG,
    String developmentSummary,
    String maternalChanges,
    List<String> symptoms,
    List<String> tips,
    String? imageAsset,
  });
}

/// @nodoc
class _$WeeklyMilestoneCopyWithImpl<$Res, $Val extends WeeklyMilestone>
    implements $WeeklyMilestoneCopyWith<$Res> {
  _$WeeklyMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? week = null,
    Object? babySizeComparison = null,
    Object? babyLengthCm = null,
    Object? babyWeightG = null,
    Object? developmentSummary = null,
    Object? maternalChanges = null,
    Object? symptoms = null,
    Object? tips = null,
    Object? imageAsset = freezed,
  }) {
    return _then(
      _value.copyWith(
            week: null == week
                ? _value.week
                : week // ignore: cast_nullable_to_non_nullable
                      as int,
            babySizeComparison: null == babySizeComparison
                ? _value.babySizeComparison
                : babySizeComparison // ignore: cast_nullable_to_non_nullable
                      as String,
            babyLengthCm: null == babyLengthCm
                ? _value.babyLengthCm
                : babyLengthCm // ignore: cast_nullable_to_non_nullable
                      as double,
            babyWeightG: null == babyWeightG
                ? _value.babyWeightG
                : babyWeightG // ignore: cast_nullable_to_non_nullable
                      as double,
            developmentSummary: null == developmentSummary
                ? _value.developmentSummary
                : developmentSummary // ignore: cast_nullable_to_non_nullable
                      as String,
            maternalChanges: null == maternalChanges
                ? _value.maternalChanges
                : maternalChanges // ignore: cast_nullable_to_non_nullable
                      as String,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tips: null == tips
                ? _value.tips
                : tips // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            imageAsset: freezed == imageAsset
                ? _value.imageAsset
                : imageAsset // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklyMilestoneImplCopyWith<$Res>
    implements $WeeklyMilestoneCopyWith<$Res> {
  factory _$$WeeklyMilestoneImplCopyWith(
    _$WeeklyMilestoneImpl value,
    $Res Function(_$WeeklyMilestoneImpl) then,
  ) = __$$WeeklyMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int week,
    String babySizeComparison,
    double babyLengthCm,
    double babyWeightG,
    String developmentSummary,
    String maternalChanges,
    List<String> symptoms,
    List<String> tips,
    String? imageAsset,
  });
}

/// @nodoc
class __$$WeeklyMilestoneImplCopyWithImpl<$Res>
    extends _$WeeklyMilestoneCopyWithImpl<$Res, _$WeeklyMilestoneImpl>
    implements _$$WeeklyMilestoneImplCopyWith<$Res> {
  __$$WeeklyMilestoneImplCopyWithImpl(
    _$WeeklyMilestoneImpl _value,
    $Res Function(_$WeeklyMilestoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? week = null,
    Object? babySizeComparison = null,
    Object? babyLengthCm = null,
    Object? babyWeightG = null,
    Object? developmentSummary = null,
    Object? maternalChanges = null,
    Object? symptoms = null,
    Object? tips = null,
    Object? imageAsset = freezed,
  }) {
    return _then(
      _$WeeklyMilestoneImpl(
        week: null == week
            ? _value.week
            : week // ignore: cast_nullable_to_non_nullable
                  as int,
        babySizeComparison: null == babySizeComparison
            ? _value.babySizeComparison
            : babySizeComparison // ignore: cast_nullable_to_non_nullable
                  as String,
        babyLengthCm: null == babyLengthCm
            ? _value.babyLengthCm
            : babyLengthCm // ignore: cast_nullable_to_non_nullable
                  as double,
        babyWeightG: null == babyWeightG
            ? _value.babyWeightG
            : babyWeightG // ignore: cast_nullable_to_non_nullable
                  as double,
        developmentSummary: null == developmentSummary
            ? _value.developmentSummary
            : developmentSummary // ignore: cast_nullable_to_non_nullable
                  as String,
        maternalChanges: null == maternalChanges
            ? _value.maternalChanges
            : maternalChanges // ignore: cast_nullable_to_non_nullable
                  as String,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tips: null == tips
            ? _value._tips
            : tips // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        imageAsset: freezed == imageAsset
            ? _value.imageAsset
            : imageAsset // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$WeeklyMilestoneImpl implements _WeeklyMilestone {
  const _$WeeklyMilestoneImpl({
    required this.week,
    required this.babySizeComparison,
    required this.babyLengthCm,
    required this.babyWeightG,
    required this.developmentSummary,
    required this.maternalChanges,
    required final List<String> symptoms,
    required final List<String> tips,
    this.imageAsset,
  }) : _symptoms = symptoms,
       _tips = tips;

  @override
  final int week;
  @override
  final String babySizeComparison;
  @override
  final double babyLengthCm;
  @override
  final double babyWeightG;
  @override
  final String developmentSummary;
  @override
  final String maternalChanges;
  final List<String> _symptoms;
  @override
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  final List<String> _tips;
  @override
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  @override
  final String? imageAsset;

  @override
  String toString() {
    return 'WeeklyMilestone(week: $week, babySizeComparison: $babySizeComparison, babyLengthCm: $babyLengthCm, babyWeightG: $babyWeightG, developmentSummary: $developmentSummary, maternalChanges: $maternalChanges, symptoms: $symptoms, tips: $tips, imageAsset: $imageAsset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyMilestoneImpl &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.babySizeComparison, babySizeComparison) ||
                other.babySizeComparison == babySizeComparison) &&
            (identical(other.babyLengthCm, babyLengthCm) ||
                other.babyLengthCm == babyLengthCm) &&
            (identical(other.babyWeightG, babyWeightG) ||
                other.babyWeightG == babyWeightG) &&
            (identical(other.developmentSummary, developmentSummary) ||
                other.developmentSummary == developmentSummary) &&
            (identical(other.maternalChanges, maternalChanges) ||
                other.maternalChanges == maternalChanges) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            (identical(other.imageAsset, imageAsset) ||
                other.imageAsset == imageAsset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    week,
    babySizeComparison,
    babyLengthCm,
    babyWeightG,
    developmentSummary,
    maternalChanges,
    const DeepCollectionEquality().hash(_symptoms),
    const DeepCollectionEquality().hash(_tips),
    imageAsset,
  );

  /// Create a copy of WeeklyMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyMilestoneImplCopyWith<_$WeeklyMilestoneImpl> get copyWith =>
      __$$WeeklyMilestoneImplCopyWithImpl<_$WeeklyMilestoneImpl>(
        this,
        _$identity,
      );
}

abstract class _WeeklyMilestone implements WeeklyMilestone {
  const factory _WeeklyMilestone({
    required final int week,
    required final String babySizeComparison,
    required final double babyLengthCm,
    required final double babyWeightG,
    required final String developmentSummary,
    required final String maternalChanges,
    required final List<String> symptoms,
    required final List<String> tips,
    final String? imageAsset,
  }) = _$WeeklyMilestoneImpl;

  @override
  int get week;
  @override
  String get babySizeComparison;
  @override
  double get babyLengthCm;
  @override
  double get babyWeightG;
  @override
  String get developmentSummary;
  @override
  String get maternalChanges;
  @override
  List<String> get symptoms;
  @override
  List<String> get tips;
  @override
  String? get imageAsset;

  /// Create a copy of WeeklyMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyMilestoneImplCopyWith<_$WeeklyMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Contraction {
  DateTime get startTime => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  double get intensity => throw _privateConstructorUsedError;

  /// Create a copy of Contraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContractionCopyWith<Contraction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContractionCopyWith<$Res> {
  factory $ContractionCopyWith(
    Contraction value,
    $Res Function(Contraction) then,
  ) = _$ContractionCopyWithImpl<$Res, Contraction>;
  @useResult
  $Res call({DateTime startTime, Duration duration, double intensity});
}

/// @nodoc
class _$ContractionCopyWithImpl<$Res, $Val extends Contraction>
    implements $ContractionCopyWith<$Res> {
  _$ContractionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Contraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? duration = null,
    Object? intensity = null,
  }) {
    return _then(
      _value.copyWith(
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            intensity: null == intensity
                ? _value.intensity
                : intensity // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContractionImplCopyWith<$Res>
    implements $ContractionCopyWith<$Res> {
  factory _$$ContractionImplCopyWith(
    _$ContractionImpl value,
    $Res Function(_$ContractionImpl) then,
  ) = __$$ContractionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startTime, Duration duration, double intensity});
}

/// @nodoc
class __$$ContractionImplCopyWithImpl<$Res>
    extends _$ContractionCopyWithImpl<$Res, _$ContractionImpl>
    implements _$$ContractionImplCopyWith<$Res> {
  __$$ContractionImplCopyWithImpl(
    _$ContractionImpl _value,
    $Res Function(_$ContractionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Contraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? duration = null,
    Object? intensity = null,
  }) {
    return _then(
      _$ContractionImpl(
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        intensity: null == intensity
            ? _value.intensity
            : intensity // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$ContractionImpl implements _Contraction {
  const _$ContractionImpl({
    required this.startTime,
    required this.duration,
    this.intensity = 1.0,
  });

  @override
  final DateTime startTime;
  @override
  final Duration duration;
  @override
  @JsonKey()
  final double intensity;

  @override
  String toString() {
    return 'Contraction(startTime: $startTime, duration: $duration, intensity: $intensity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContractionImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startTime, duration, intensity);

  /// Create a copy of Contraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContractionImplCopyWith<_$ContractionImpl> get copyWith =>
      __$$ContractionImplCopyWithImpl<_$ContractionImpl>(this, _$identity);
}

abstract class _Contraction implements Contraction {
  const factory _Contraction({
    required final DateTime startTime,
    required final Duration duration,
    final double intensity,
  }) = _$ContractionImpl;

  @override
  DateTime get startTime;
  @override
  Duration get duration;
  @override
  double get intensity;

  /// Create a copy of Contraction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContractionImplCopyWith<_$ContractionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KickLog _$KickLogFromJson(Map<String, dynamic> json) {
  return _KickLog.fromJson(json);
}

/// @nodoc
mixin _$KickLog {
  String get id => throw _privateConstructorUsedError;
  String get pregnancyId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get kickCount => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  bool? get isNormal => throw _privateConstructorUsedError;

  /// Serializes this KickLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KickLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KickLogCopyWith<KickLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KickLogCopyWith<$Res> {
  factory $KickLogCopyWith(KickLog value, $Res Function(KickLog) then) =
      _$KickLogCopyWithImpl<$Res, KickLog>;
  @useResult
  $Res call({
    String id,
    String pregnancyId,
    DateTime date,
    int kickCount,
    int durationMinutes,
    bool? isNormal,
  });
}

/// @nodoc
class _$KickLogCopyWithImpl<$Res, $Val extends KickLog>
    implements $KickLogCopyWith<$Res> {
  _$KickLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KickLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pregnancyId = null,
    Object? date = null,
    Object? kickCount = null,
    Object? durationMinutes = null,
    Object? isNormal = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            pregnancyId: null == pregnancyId
                ? _value.pregnancyId
                : pregnancyId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            kickCount: null == kickCount
                ? _value.kickCount
                : kickCount // ignore: cast_nullable_to_non_nullable
                      as int,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            isNormal: freezed == isNormal
                ? _value.isNormal
                : isNormal // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KickLogImplCopyWith<$Res> implements $KickLogCopyWith<$Res> {
  factory _$$KickLogImplCopyWith(
    _$KickLogImpl value,
    $Res Function(_$KickLogImpl) then,
  ) = __$$KickLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String pregnancyId,
    DateTime date,
    int kickCount,
    int durationMinutes,
    bool? isNormal,
  });
}

/// @nodoc
class __$$KickLogImplCopyWithImpl<$Res>
    extends _$KickLogCopyWithImpl<$Res, _$KickLogImpl>
    implements _$$KickLogImplCopyWith<$Res> {
  __$$KickLogImplCopyWithImpl(
    _$KickLogImpl _value,
    $Res Function(_$KickLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KickLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pregnancyId = null,
    Object? date = null,
    Object? kickCount = null,
    Object? durationMinutes = null,
    Object? isNormal = freezed,
  }) {
    return _then(
      _$KickLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        pregnancyId: null == pregnancyId
            ? _value.pregnancyId
            : pregnancyId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        kickCount: null == kickCount
            ? _value.kickCount
            : kickCount // ignore: cast_nullable_to_non_nullable
                  as int,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        isNormal: freezed == isNormal
            ? _value.isNormal
            : isNormal // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KickLogImpl implements _KickLog {
  const _$KickLogImpl({
    required this.id,
    required this.pregnancyId,
    required this.date,
    required this.kickCount,
    required this.durationMinutes,
    this.isNormal,
  });

  factory _$KickLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$KickLogImplFromJson(json);

  @override
  final String id;
  @override
  final String pregnancyId;
  @override
  final DateTime date;
  @override
  final int kickCount;
  @override
  final int durationMinutes;
  @override
  final bool? isNormal;

  @override
  String toString() {
    return 'KickLog(id: $id, pregnancyId: $pregnancyId, date: $date, kickCount: $kickCount, durationMinutes: $durationMinutes, isNormal: $isNormal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KickLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pregnancyId, pregnancyId) ||
                other.pregnancyId == pregnancyId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.kickCount, kickCount) ||
                other.kickCount == kickCount) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isNormal, isNormal) ||
                other.isNormal == isNormal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pregnancyId,
    date,
    kickCount,
    durationMinutes,
    isNormal,
  );

  /// Create a copy of KickLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KickLogImplCopyWith<_$KickLogImpl> get copyWith =>
      __$$KickLogImplCopyWithImpl<_$KickLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KickLogImplToJson(this);
  }
}

abstract class _KickLog implements KickLog {
  const factory _KickLog({
    required final String id,
    required final String pregnancyId,
    required final DateTime date,
    required final int kickCount,
    required final int durationMinutes,
    final bool? isNormal,
  }) = _$KickLogImpl;

  factory _KickLog.fromJson(Map<String, dynamic> json) = _$KickLogImpl.fromJson;

  @override
  String get id;
  @override
  String get pregnancyId;
  @override
  DateTime get date;
  @override
  int get kickCount;
  @override
  int get durationMinutes;
  @override
  bool? get isNormal;

  /// Create a copy of KickLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KickLogImplCopyWith<_$KickLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
