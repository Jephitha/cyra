// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Cycle _$CycleFromJson(Map<String, dynamic> json) {
  return _Cycle.fromJson(json);
}

/// @nodoc
mixin _$Cycle {
  String get id => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  int get cycleLength => throw _privateConstructorUsedError;
  int get periodLength => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<CycleDay> get days => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Cycle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cycle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CycleCopyWith<Cycle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CycleCopyWith<$Res> {
  factory $CycleCopyWith(Cycle value, $Res Function(Cycle) then) =
      _$CycleCopyWithImpl<$Res, Cycle>;
  @useResult
  $Res call({
    String id,
    DateTime startDate,
    DateTime? endDate,
    int cycleLength,
    int periodLength,
    String? notes,
    List<CycleDay> days,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CycleCopyWithImpl<$Res, $Val extends Cycle>
    implements $CycleCopyWith<$Res> {
  _$CycleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cycle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? cycleLength = null,
    Object? periodLength = null,
    Object? notes = freezed,
    Object? days = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cycleLength: null == cycleLength
                ? _value.cycleLength
                : cycleLength // ignore: cast_nullable_to_non_nullable
                      as int,
            periodLength: null == periodLength
                ? _value.periodLength
                : periodLength // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as List<CycleDay>,
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
abstract class _$$CycleImplCopyWith<$Res> implements $CycleCopyWith<$Res> {
  factory _$$CycleImplCopyWith(
    _$CycleImpl value,
    $Res Function(_$CycleImpl) then,
  ) = __$$CycleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime startDate,
    DateTime? endDate,
    int cycleLength,
    int periodLength,
    String? notes,
    List<CycleDay> days,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CycleImplCopyWithImpl<$Res>
    extends _$CycleCopyWithImpl<$Res, _$CycleImpl>
    implements _$$CycleImplCopyWith<$Res> {
  __$$CycleImplCopyWithImpl(
    _$CycleImpl _value,
    $Res Function(_$CycleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Cycle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? cycleLength = null,
    Object? periodLength = null,
    Object? notes = freezed,
    Object? days = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CycleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cycleLength: null == cycleLength
            ? _value.cycleLength
            : cycleLength // ignore: cast_nullable_to_non_nullable
                  as int,
        periodLength: null == periodLength
            ? _value.periodLength
            : periodLength // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        days: null == days
            ? _value._days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<CycleDay>,
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
class _$CycleImpl implements _Cycle {
  const _$CycleImpl({
    required this.id,
    required this.startDate,
    this.endDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.notes,
    final List<CycleDay> days = const [],
    this.createdAt,
    this.updatedAt,
  }) : _days = days;

  factory _$CycleImpl.fromJson(Map<String, dynamic> json) =>
      _$$CycleImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final int cycleLength;
  @override
  @JsonKey()
  final int periodLength;
  @override
  final String? notes;
  final List<CycleDay> _days;
  @override
  @JsonKey()
  List<CycleDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Cycle(id: $id, startDate: $startDate, endDate: $endDate, cycleLength: $cycleLength, periodLength: $periodLength, notes: $notes, days: $days, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CycleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.cycleLength, cycleLength) ||
                other.cycleLength == cycleLength) &&
            (identical(other.periodLength, periodLength) ||
                other.periodLength == periodLength) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
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
    startDate,
    endDate,
    cycleLength,
    periodLength,
    notes,
    const DeepCollectionEquality().hash(_days),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Cycle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CycleImplCopyWith<_$CycleImpl> get copyWith =>
      __$$CycleImplCopyWithImpl<_$CycleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CycleImplToJson(this);
  }
}

abstract class _Cycle implements Cycle {
  const factory _Cycle({
    required final String id,
    required final DateTime startDate,
    final DateTime? endDate,
    final int cycleLength,
    final int periodLength,
    final String? notes,
    final List<CycleDay> days,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CycleImpl;

  factory _Cycle.fromJson(Map<String, dynamic> json) = _$CycleImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  int get cycleLength;
  @override
  int get periodLength;
  @override
  String? get notes;
  @override
  List<CycleDay> get days;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Cycle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CycleImplCopyWith<_$CycleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CycleDay _$CycleDayFromJson(Map<String, dynamic> json) {
  return _CycleDay.fromJson(json);
}

/// @nodoc
mixin _$CycleDay {
  String get id => throw _privateConstructorUsedError;
  String get cycleId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get flowIntensity => throw _privateConstructorUsedError;
  bool get spotting => throw _privateConstructorUsedError;
  bool get clotting => throw _privateConstructorUsedError;
  String? get symptomsJson => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  String? get cervicalMucus => throw _privateConstructorUsedError;
  String? get cervicalPosition => throw _privateConstructorUsedError;
  String? get opkResult => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CycleDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CycleDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CycleDayCopyWith<CycleDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CycleDayCopyWith<$Res> {
  factory $CycleDayCopyWith(CycleDay value, $Res Function(CycleDay) then) =
      _$CycleDayCopyWithImpl<$Res, CycleDay>;
  @useResult
  $Res call({
    String id,
    String cycleId,
    DateTime date,
    int flowIntensity,
    bool spotting,
    bool clotting,
    String? symptomsJson,
    double? temperature,
    String? cervicalMucus,
    String? cervicalPosition,
    String? opkResult,
    String? notes,
  });
}

/// @nodoc
class _$CycleDayCopyWithImpl<$Res, $Val extends CycleDay>
    implements $CycleDayCopyWith<$Res> {
  _$CycleDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CycleDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cycleId = null,
    Object? date = null,
    Object? flowIntensity = null,
    Object? spotting = null,
    Object? clotting = null,
    Object? symptomsJson = freezed,
    Object? temperature = freezed,
    Object? cervicalMucus = freezed,
    Object? cervicalPosition = freezed,
    Object? opkResult = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cycleId: null == cycleId
                ? _value.cycleId
                : cycleId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            flowIntensity: null == flowIntensity
                ? _value.flowIntensity
                : flowIntensity // ignore: cast_nullable_to_non_nullable
                      as int,
            spotting: null == spotting
                ? _value.spotting
                : spotting // ignore: cast_nullable_to_non_nullable
                      as bool,
            clotting: null == clotting
                ? _value.clotting
                : clotting // ignore: cast_nullable_to_non_nullable
                      as bool,
            symptomsJson: freezed == symptomsJson
                ? _value.symptomsJson
                : symptomsJson // ignore: cast_nullable_to_non_nullable
                      as String?,
            temperature: freezed == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            cervicalMucus: freezed == cervicalMucus
                ? _value.cervicalMucus
                : cervicalMucus // ignore: cast_nullable_to_non_nullable
                      as String?,
            cervicalPosition: freezed == cervicalPosition
                ? _value.cervicalPosition
                : cervicalPosition // ignore: cast_nullable_to_non_nullable
                      as String?,
            opkResult: freezed == opkResult
                ? _value.opkResult
                : opkResult // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CycleDayImplCopyWith<$Res>
    implements $CycleDayCopyWith<$Res> {
  factory _$$CycleDayImplCopyWith(
    _$CycleDayImpl value,
    $Res Function(_$CycleDayImpl) then,
  ) = __$$CycleDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String cycleId,
    DateTime date,
    int flowIntensity,
    bool spotting,
    bool clotting,
    String? symptomsJson,
    double? temperature,
    String? cervicalMucus,
    String? cervicalPosition,
    String? opkResult,
    String? notes,
  });
}

/// @nodoc
class __$$CycleDayImplCopyWithImpl<$Res>
    extends _$CycleDayCopyWithImpl<$Res, _$CycleDayImpl>
    implements _$$CycleDayImplCopyWith<$Res> {
  __$$CycleDayImplCopyWithImpl(
    _$CycleDayImpl _value,
    $Res Function(_$CycleDayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CycleDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cycleId = null,
    Object? date = null,
    Object? flowIntensity = null,
    Object? spotting = null,
    Object? clotting = null,
    Object? symptomsJson = freezed,
    Object? temperature = freezed,
    Object? cervicalMucus = freezed,
    Object? cervicalPosition = freezed,
    Object? opkResult = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$CycleDayImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cycleId: null == cycleId
            ? _value.cycleId
            : cycleId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        flowIntensity: null == flowIntensity
            ? _value.flowIntensity
            : flowIntensity // ignore: cast_nullable_to_non_nullable
                  as int,
        spotting: null == spotting
            ? _value.spotting
            : spotting // ignore: cast_nullable_to_non_nullable
                  as bool,
        clotting: null == clotting
            ? _value.clotting
            : clotting // ignore: cast_nullable_to_non_nullable
                  as bool,
        symptomsJson: freezed == symptomsJson
            ? _value.symptomsJson
            : symptomsJson // ignore: cast_nullable_to_non_nullable
                  as String?,
        temperature: freezed == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        cervicalMucus: freezed == cervicalMucus
            ? _value.cervicalMucus
            : cervicalMucus // ignore: cast_nullable_to_non_nullable
                  as String?,
        cervicalPosition: freezed == cervicalPosition
            ? _value.cervicalPosition
            : cervicalPosition // ignore: cast_nullable_to_non_nullable
                  as String?,
        opkResult: freezed == opkResult
            ? _value.opkResult
            : opkResult // ignore: cast_nullable_to_non_nullable
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
class _$CycleDayImpl implements _CycleDay {
  const _$CycleDayImpl({
    required this.id,
    required this.cycleId,
    required this.date,
    this.flowIntensity = 0,
    this.spotting = false,
    this.clotting = false,
    this.symptomsJson,
    this.temperature,
    this.cervicalMucus,
    this.cervicalPosition,
    this.opkResult,
    this.notes,
  });

  factory _$CycleDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$CycleDayImplFromJson(json);

  @override
  final String id;
  @override
  final String cycleId;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final int flowIntensity;
  @override
  @JsonKey()
  final bool spotting;
  @override
  @JsonKey()
  final bool clotting;
  @override
  final String? symptomsJson;
  @override
  final double? temperature;
  @override
  final String? cervicalMucus;
  @override
  final String? cervicalPosition;
  @override
  final String? opkResult;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CycleDay(id: $id, cycleId: $cycleId, date: $date, flowIntensity: $flowIntensity, spotting: $spotting, clotting: $clotting, symptomsJson: $symptomsJson, temperature: $temperature, cervicalMucus: $cervicalMucus, cervicalPosition: $cervicalPosition, opkResult: $opkResult, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CycleDayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cycleId, cycleId) || other.cycleId == cycleId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.flowIntensity, flowIntensity) ||
                other.flowIntensity == flowIntensity) &&
            (identical(other.spotting, spotting) ||
                other.spotting == spotting) &&
            (identical(other.clotting, clotting) ||
                other.clotting == clotting) &&
            (identical(other.symptomsJson, symptomsJson) ||
                other.symptomsJson == symptomsJson) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.cervicalMucus, cervicalMucus) ||
                other.cervicalMucus == cervicalMucus) &&
            (identical(other.cervicalPosition, cervicalPosition) ||
                other.cervicalPosition == cervicalPosition) &&
            (identical(other.opkResult, opkResult) ||
                other.opkResult == opkResult) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
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
  );

  /// Create a copy of CycleDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CycleDayImplCopyWith<_$CycleDayImpl> get copyWith =>
      __$$CycleDayImplCopyWithImpl<_$CycleDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CycleDayImplToJson(this);
  }
}

abstract class _CycleDay implements CycleDay {
  const factory _CycleDay({
    required final String id,
    required final String cycleId,
    required final DateTime date,
    final int flowIntensity,
    final bool spotting,
    final bool clotting,
    final String? symptomsJson,
    final double? temperature,
    final String? cervicalMucus,
    final String? cervicalPosition,
    final String? opkResult,
    final String? notes,
  }) = _$CycleDayImpl;

  factory _CycleDay.fromJson(Map<String, dynamic> json) =
      _$CycleDayImpl.fromJson;

  @override
  String get id;
  @override
  String get cycleId;
  @override
  DateTime get date;
  @override
  int get flowIntensity;
  @override
  bool get spotting;
  @override
  bool get clotting;
  @override
  String? get symptomsJson;
  @override
  double? get temperature;
  @override
  String? get cervicalMucus;
  @override
  String? get cervicalPosition;
  @override
  String? get opkResult;
  @override
  String? get notes;

  /// Create a copy of CycleDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CycleDayImplCopyWith<_$CycleDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CycleSummary _$CycleSummaryFromJson(Map<String, dynamic> json) {
  return _CycleSummary.fromJson(json);
}

/// @nodoc
mixin _$CycleSummary {
  int get cycleCount => throw _privateConstructorUsedError;
  double get averageLength => throw _privateConstructorUsedError;
  int get minLength => throw _privateConstructorUsedError;
  int get maxLength => throw _privateConstructorUsedError;
  double get variabilityScore => throw _privateConstructorUsedError;
  double get averagePeriodLength => throw _privateConstructorUsedError;
  DateTime? get lastPeriodStart => throw _privateConstructorUsedError;
  DateTime? get nextPredictedPeriodStart => throw _privateConstructorUsedError;

  /// Serializes this CycleSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CycleSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CycleSummaryCopyWith<CycleSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CycleSummaryCopyWith<$Res> {
  factory $CycleSummaryCopyWith(
    CycleSummary value,
    $Res Function(CycleSummary) then,
  ) = _$CycleSummaryCopyWithImpl<$Res, CycleSummary>;
  @useResult
  $Res call({
    int cycleCount,
    double averageLength,
    int minLength,
    int maxLength,
    double variabilityScore,
    double averagePeriodLength,
    DateTime? lastPeriodStart,
    DateTime? nextPredictedPeriodStart,
  });
}

/// @nodoc
class _$CycleSummaryCopyWithImpl<$Res, $Val extends CycleSummary>
    implements $CycleSummaryCopyWith<$Res> {
  _$CycleSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CycleSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cycleCount = null,
    Object? averageLength = null,
    Object? minLength = null,
    Object? maxLength = null,
    Object? variabilityScore = null,
    Object? averagePeriodLength = null,
    Object? lastPeriodStart = freezed,
    Object? nextPredictedPeriodStart = freezed,
  }) {
    return _then(
      _value.copyWith(
            cycleCount: null == cycleCount
                ? _value.cycleCount
                : cycleCount // ignore: cast_nullable_to_non_nullable
                      as int,
            averageLength: null == averageLength
                ? _value.averageLength
                : averageLength // ignore: cast_nullable_to_non_nullable
                      as double,
            minLength: null == minLength
                ? _value.minLength
                : minLength // ignore: cast_nullable_to_non_nullable
                      as int,
            maxLength: null == maxLength
                ? _value.maxLength
                : maxLength // ignore: cast_nullable_to_non_nullable
                      as int,
            variabilityScore: null == variabilityScore
                ? _value.variabilityScore
                : variabilityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            averagePeriodLength: null == averagePeriodLength
                ? _value.averagePeriodLength
                : averagePeriodLength // ignore: cast_nullable_to_non_nullable
                      as double,
            lastPeriodStart: freezed == lastPeriodStart
                ? _value.lastPeriodStart
                : lastPeriodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            nextPredictedPeriodStart: freezed == nextPredictedPeriodStart
                ? _value.nextPredictedPeriodStart
                : nextPredictedPeriodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CycleSummaryImplCopyWith<$Res>
    implements $CycleSummaryCopyWith<$Res> {
  factory _$$CycleSummaryImplCopyWith(
    _$CycleSummaryImpl value,
    $Res Function(_$CycleSummaryImpl) then,
  ) = __$$CycleSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int cycleCount,
    double averageLength,
    int minLength,
    int maxLength,
    double variabilityScore,
    double averagePeriodLength,
    DateTime? lastPeriodStart,
    DateTime? nextPredictedPeriodStart,
  });
}

/// @nodoc
class __$$CycleSummaryImplCopyWithImpl<$Res>
    extends _$CycleSummaryCopyWithImpl<$Res, _$CycleSummaryImpl>
    implements _$$CycleSummaryImplCopyWith<$Res> {
  __$$CycleSummaryImplCopyWithImpl(
    _$CycleSummaryImpl _value,
    $Res Function(_$CycleSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CycleSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cycleCount = null,
    Object? averageLength = null,
    Object? minLength = null,
    Object? maxLength = null,
    Object? variabilityScore = null,
    Object? averagePeriodLength = null,
    Object? lastPeriodStart = freezed,
    Object? nextPredictedPeriodStart = freezed,
  }) {
    return _then(
      _$CycleSummaryImpl(
        cycleCount: null == cycleCount
            ? _value.cycleCount
            : cycleCount // ignore: cast_nullable_to_non_nullable
                  as int,
        averageLength: null == averageLength
            ? _value.averageLength
            : averageLength // ignore: cast_nullable_to_non_nullable
                  as double,
        minLength: null == minLength
            ? _value.minLength
            : minLength // ignore: cast_nullable_to_non_nullable
                  as int,
        maxLength: null == maxLength
            ? _value.maxLength
            : maxLength // ignore: cast_nullable_to_non_nullable
                  as int,
        variabilityScore: null == variabilityScore
            ? _value.variabilityScore
            : variabilityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        averagePeriodLength: null == averagePeriodLength
            ? _value.averagePeriodLength
            : averagePeriodLength // ignore: cast_nullable_to_non_nullable
                  as double,
        lastPeriodStart: freezed == lastPeriodStart
            ? _value.lastPeriodStart
            : lastPeriodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        nextPredictedPeriodStart: freezed == nextPredictedPeriodStart
            ? _value.nextPredictedPeriodStart
            : nextPredictedPeriodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CycleSummaryImpl implements _CycleSummary {
  const _$CycleSummaryImpl({
    required this.cycleCount,
    required this.averageLength,
    required this.minLength,
    required this.maxLength,
    required this.variabilityScore,
    required this.averagePeriodLength,
    required this.lastPeriodStart,
    required this.nextPredictedPeriodStart,
  });

  factory _$CycleSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CycleSummaryImplFromJson(json);

  @override
  final int cycleCount;
  @override
  final double averageLength;
  @override
  final int minLength;
  @override
  final int maxLength;
  @override
  final double variabilityScore;
  @override
  final double averagePeriodLength;
  @override
  final DateTime? lastPeriodStart;
  @override
  final DateTime? nextPredictedPeriodStart;

  @override
  String toString() {
    return 'CycleSummary(cycleCount: $cycleCount, averageLength: $averageLength, minLength: $minLength, maxLength: $maxLength, variabilityScore: $variabilityScore, averagePeriodLength: $averagePeriodLength, lastPeriodStart: $lastPeriodStart, nextPredictedPeriodStart: $nextPredictedPeriodStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CycleSummaryImpl &&
            (identical(other.cycleCount, cycleCount) ||
                other.cycleCount == cycleCount) &&
            (identical(other.averageLength, averageLength) ||
                other.averageLength == averageLength) &&
            (identical(other.minLength, minLength) ||
                other.minLength == minLength) &&
            (identical(other.maxLength, maxLength) ||
                other.maxLength == maxLength) &&
            (identical(other.variabilityScore, variabilityScore) ||
                other.variabilityScore == variabilityScore) &&
            (identical(other.averagePeriodLength, averagePeriodLength) ||
                other.averagePeriodLength == averagePeriodLength) &&
            (identical(other.lastPeriodStart, lastPeriodStart) ||
                other.lastPeriodStart == lastPeriodStart) &&
            (identical(
                  other.nextPredictedPeriodStart,
                  nextPredictedPeriodStart,
                ) ||
                other.nextPredictedPeriodStart == nextPredictedPeriodStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cycleCount,
    averageLength,
    minLength,
    maxLength,
    variabilityScore,
    averagePeriodLength,
    lastPeriodStart,
    nextPredictedPeriodStart,
  );

  /// Create a copy of CycleSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CycleSummaryImplCopyWith<_$CycleSummaryImpl> get copyWith =>
      __$$CycleSummaryImplCopyWithImpl<_$CycleSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CycleSummaryImplToJson(this);
  }
}

abstract class _CycleSummary implements CycleSummary {
  const factory _CycleSummary({
    required final int cycleCount,
    required final double averageLength,
    required final int minLength,
    required final int maxLength,
    required final double variabilityScore,
    required final double averagePeriodLength,
    required final DateTime? lastPeriodStart,
    required final DateTime? nextPredictedPeriodStart,
  }) = _$CycleSummaryImpl;

  factory _CycleSummary.fromJson(Map<String, dynamic> json) =
      _$CycleSummaryImpl.fromJson;

  @override
  int get cycleCount;
  @override
  double get averageLength;
  @override
  int get minLength;
  @override
  int get maxLength;
  @override
  double get variabilityScore;
  @override
  double get averagePeriodLength;
  @override
  DateTime? get lastPeriodStart;
  @override
  DateTime? get nextPredictedPeriodStart;

  /// Create a copy of CycleSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CycleSummaryImplCopyWith<_$CycleSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PredictionResult _$PredictionResultFromJson(Map<String, dynamic> json) {
  return _PredictionResult.fromJson(json);
}

/// @nodoc
mixin _$PredictionResult {
  DateTime get predictedDate => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  double get variabilityScore => throw _privateConstructorUsedError;
  DateTime get predictionRangeStart => throw _privateConstructorUsedError;
  DateTime get predictionRangeEnd => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;

  /// Serializes this PredictionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionResultCopyWith<PredictionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionResultCopyWith<$Res> {
  factory $PredictionResultCopyWith(
    PredictionResult value,
    $Res Function(PredictionResult) then,
  ) = _$PredictionResultCopyWithImpl<$Res, PredictionResult>;
  @useResult
  $Res call({
    DateTime predictedDate,
    double confidenceScore,
    double variabilityScore,
    DateTime predictionRangeStart,
    DateTime predictionRangeEnd,
    String explanation,
  });
}

/// @nodoc
class _$PredictionResultCopyWithImpl<$Res, $Val extends PredictionResult>
    implements $PredictionResultCopyWith<$Res> {
  _$PredictionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictedDate = null,
    Object? confidenceScore = null,
    Object? variabilityScore = null,
    Object? predictionRangeStart = null,
    Object? predictionRangeEnd = null,
    Object? explanation = null,
  }) {
    return _then(
      _value.copyWith(
            predictedDate: null == predictedDate
                ? _value.predictedDate
                : predictedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            variabilityScore: null == variabilityScore
                ? _value.variabilityScore
                : variabilityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            predictionRangeStart: null == predictionRangeStart
                ? _value.predictionRangeStart
                : predictionRangeStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            predictionRangeEnd: null == predictionRangeEnd
                ? _value.predictionRangeEnd
                : predictionRangeEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PredictionResultImplCopyWith<$Res>
    implements $PredictionResultCopyWith<$Res> {
  factory _$$PredictionResultImplCopyWith(
    _$PredictionResultImpl value,
    $Res Function(_$PredictionResultImpl) then,
  ) = __$$PredictionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime predictedDate,
    double confidenceScore,
    double variabilityScore,
    DateTime predictionRangeStart,
    DateTime predictionRangeEnd,
    String explanation,
  });
}

/// @nodoc
class __$$PredictionResultImplCopyWithImpl<$Res>
    extends _$PredictionResultCopyWithImpl<$Res, _$PredictionResultImpl>
    implements _$$PredictionResultImplCopyWith<$Res> {
  __$$PredictionResultImplCopyWithImpl(
    _$PredictionResultImpl _value,
    $Res Function(_$PredictionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictedDate = null,
    Object? confidenceScore = null,
    Object? variabilityScore = null,
    Object? predictionRangeStart = null,
    Object? predictionRangeEnd = null,
    Object? explanation = null,
  }) {
    return _then(
      _$PredictionResultImpl(
        predictedDate: null == predictedDate
            ? _value.predictedDate
            : predictedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        variabilityScore: null == variabilityScore
            ? _value.variabilityScore
            : variabilityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        predictionRangeStart: null == predictionRangeStart
            ? _value.predictionRangeStart
            : predictionRangeStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        predictionRangeEnd: null == predictionRangeEnd
            ? _value.predictionRangeEnd
            : predictionRangeEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictionResultImpl implements _PredictionResult {
  const _$PredictionResultImpl({
    required this.predictedDate,
    required this.confidenceScore,
    required this.variabilityScore,
    required this.predictionRangeStart,
    required this.predictionRangeEnd,
    required this.explanation,
  });

  factory _$PredictionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionResultImplFromJson(json);

  @override
  final DateTime predictedDate;
  @override
  final double confidenceScore;
  @override
  final double variabilityScore;
  @override
  final DateTime predictionRangeStart;
  @override
  final DateTime predictionRangeEnd;
  @override
  final String explanation;

  @override
  String toString() {
    return 'PredictionResult(predictedDate: $predictedDate, confidenceScore: $confidenceScore, variabilityScore: $variabilityScore, predictionRangeStart: $predictionRangeStart, predictionRangeEnd: $predictionRangeEnd, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionResultImpl &&
            (identical(other.predictedDate, predictedDate) ||
                other.predictedDate == predictedDate) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.variabilityScore, variabilityScore) ||
                other.variabilityScore == variabilityScore) &&
            (identical(other.predictionRangeStart, predictionRangeStart) ||
                other.predictionRangeStart == predictionRangeStart) &&
            (identical(other.predictionRangeEnd, predictionRangeEnd) ||
                other.predictionRangeEnd == predictionRangeEnd) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    predictedDate,
    confidenceScore,
    variabilityScore,
    predictionRangeStart,
    predictionRangeEnd,
    explanation,
  );

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionResultImplCopyWith<_$PredictionResultImpl> get copyWith =>
      __$$PredictionResultImplCopyWithImpl<_$PredictionResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionResultImplToJson(this);
  }
}

abstract class _PredictionResult implements PredictionResult {
  const factory _PredictionResult({
    required final DateTime predictedDate,
    required final double confidenceScore,
    required final double variabilityScore,
    required final DateTime predictionRangeStart,
    required final DateTime predictionRangeEnd,
    required final String explanation,
  }) = _$PredictionResultImpl;

  factory _PredictionResult.fromJson(Map<String, dynamic> json) =
      _$PredictionResultImpl.fromJson;

  @override
  DateTime get predictedDate;
  @override
  double get confidenceScore;
  @override
  double get variabilityScore;
  @override
  DateTime get predictionRangeStart;
  @override
  DateTime get predictionRangeEnd;
  @override
  String get explanation;

  /// Create a copy of PredictionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionResultImplCopyWith<_$PredictionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
