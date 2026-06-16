// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fertility_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IntercourseLog _$IntercourseLogFromJson(Map<String, dynamic> json) {
  return _IntercourseLog.fromJson(json);
}

/// @nodoc
mixin _$IntercourseLog {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  bool get unprotected => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this IntercourseLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IntercourseLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntercourseLogCopyWith<IntercourseLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntercourseLogCopyWith<$Res> {
  factory $IntercourseLogCopyWith(
    IntercourseLog value,
    $Res Function(IntercourseLog) then,
  ) = _$IntercourseLogCopyWithImpl<$Res, IntercourseLog>;
  @useResult
  $Res call({String id, DateTime date, bool unprotected, String? notes});
}

/// @nodoc
class _$IntercourseLogCopyWithImpl<$Res, $Val extends IntercourseLog>
    implements $IntercourseLogCopyWith<$Res> {
  _$IntercourseLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IntercourseLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? unprotected = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            unprotected: null == unprotected
                ? _value.unprotected
                : unprotected // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$IntercourseLogImplCopyWith<$Res>
    implements $IntercourseLogCopyWith<$Res> {
  factory _$$IntercourseLogImplCopyWith(
    _$IntercourseLogImpl value,
    $Res Function(_$IntercourseLogImpl) then,
  ) = __$$IntercourseLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime date, bool unprotected, String? notes});
}

/// @nodoc
class __$$IntercourseLogImplCopyWithImpl<$Res>
    extends _$IntercourseLogCopyWithImpl<$Res, _$IntercourseLogImpl>
    implements _$$IntercourseLogImplCopyWith<$Res> {
  __$$IntercourseLogImplCopyWithImpl(
    _$IntercourseLogImpl _value,
    $Res Function(_$IntercourseLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IntercourseLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? unprotected = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$IntercourseLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        unprotected: null == unprotected
            ? _value.unprotected
            : unprotected // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$IntercourseLogImpl implements _IntercourseLog {
  const _$IntercourseLogImpl({
    required this.id,
    required this.date,
    this.unprotected = false,
    this.notes,
  });

  factory _$IntercourseLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntercourseLogImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final bool unprotected;
  @override
  final String? notes;

  @override
  String toString() {
    return 'IntercourseLog(id: $id, date: $date, unprotected: $unprotected, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntercourseLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.unprotected, unprotected) ||
                other.unprotected == unprotected) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, unprotected, notes);

  /// Create a copy of IntercourseLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntercourseLogImplCopyWith<_$IntercourseLogImpl> get copyWith =>
      __$$IntercourseLogImplCopyWithImpl<_$IntercourseLogImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IntercourseLogImplToJson(this);
  }
}

abstract class _IntercourseLog implements IntercourseLog {
  const factory _IntercourseLog({
    required final String id,
    required final DateTime date,
    final bool unprotected,
    final String? notes,
  }) = _$IntercourseLogImpl;

  factory _IntercourseLog.fromJson(Map<String, dynamic> json) =
      _$IntercourseLogImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  bool get unprotected;
  @override
  String? get notes;

  /// Create a copy of IntercourseLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntercourseLogImplCopyWith<_$IntercourseLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FertilityStatus _$FertilityStatusFromJson(Map<String, dynamic> json) {
  return _FertilityStatus.fromJson(json);
}

/// @nodoc
mixin _$FertilityStatus {
  int get cycleDay => throw _privateConstructorUsedError;
  FertilityDayType get dayType => throw _privateConstructorUsedError;
  double get conceptionProbability => throw _privateConstructorUsedError;
  String? get recommendation => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;

  /// Serializes this FertilityStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FertilityStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FertilityStatusCopyWith<FertilityStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FertilityStatusCopyWith<$Res> {
  factory $FertilityStatusCopyWith(
    FertilityStatus value,
    $Res Function(FertilityStatus) then,
  ) = _$FertilityStatusCopyWithImpl<$Res, FertilityStatus>;
  @useResult
  $Res call({
    int cycleDay,
    FertilityDayType dayType,
    double conceptionProbability,
    String? recommendation,
    String? explanation,
  });
}

/// @nodoc
class _$FertilityStatusCopyWithImpl<$Res, $Val extends FertilityStatus>
    implements $FertilityStatusCopyWith<$Res> {
  _$FertilityStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FertilityStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cycleDay = null,
    Object? dayType = null,
    Object? conceptionProbability = null,
    Object? recommendation = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _value.copyWith(
            cycleDay: null == cycleDay
                ? _value.cycleDay
                : cycleDay // ignore: cast_nullable_to_non_nullable
                      as int,
            dayType: null == dayType
                ? _value.dayType
                : dayType // ignore: cast_nullable_to_non_nullable
                      as FertilityDayType,
            conceptionProbability: null == conceptionProbability
                ? _value.conceptionProbability
                : conceptionProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            recommendation: freezed == recommendation
                ? _value.recommendation
                : recommendation // ignore: cast_nullable_to_non_nullable
                      as String?,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FertilityStatusImplCopyWith<$Res>
    implements $FertilityStatusCopyWith<$Res> {
  factory _$$FertilityStatusImplCopyWith(
    _$FertilityStatusImpl value,
    $Res Function(_$FertilityStatusImpl) then,
  ) = __$$FertilityStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int cycleDay,
    FertilityDayType dayType,
    double conceptionProbability,
    String? recommendation,
    String? explanation,
  });
}

/// @nodoc
class __$$FertilityStatusImplCopyWithImpl<$Res>
    extends _$FertilityStatusCopyWithImpl<$Res, _$FertilityStatusImpl>
    implements _$$FertilityStatusImplCopyWith<$Res> {
  __$$FertilityStatusImplCopyWithImpl(
    _$FertilityStatusImpl _value,
    $Res Function(_$FertilityStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FertilityStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cycleDay = null,
    Object? dayType = null,
    Object? conceptionProbability = null,
    Object? recommendation = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _$FertilityStatusImpl(
        cycleDay: null == cycleDay
            ? _value.cycleDay
            : cycleDay // ignore: cast_nullable_to_non_nullable
                  as int,
        dayType: null == dayType
            ? _value.dayType
            : dayType // ignore: cast_nullable_to_non_nullable
                  as FertilityDayType,
        conceptionProbability: null == conceptionProbability
            ? _value.conceptionProbability
            : conceptionProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        recommendation: freezed == recommendation
            ? _value.recommendation
            : recommendation // ignore: cast_nullable_to_non_nullable
                  as String?,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FertilityStatusImpl implements _FertilityStatus {
  const _$FertilityStatusImpl({
    required this.cycleDay,
    required this.dayType,
    this.conceptionProbability = 0.0,
    this.recommendation,
    this.explanation,
  });

  factory _$FertilityStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$FertilityStatusImplFromJson(json);

  @override
  final int cycleDay;
  @override
  final FertilityDayType dayType;
  @override
  @JsonKey()
  final double conceptionProbability;
  @override
  final String? recommendation;
  @override
  final String? explanation;

  @override
  String toString() {
    return 'FertilityStatus(cycleDay: $cycleDay, dayType: $dayType, conceptionProbability: $conceptionProbability, recommendation: $recommendation, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FertilityStatusImpl &&
            (identical(other.cycleDay, cycleDay) ||
                other.cycleDay == cycleDay) &&
            (identical(other.dayType, dayType) || other.dayType == dayType) &&
            (identical(other.conceptionProbability, conceptionProbability) ||
                other.conceptionProbability == conceptionProbability) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cycleDay,
    dayType,
    conceptionProbability,
    recommendation,
    explanation,
  );

  /// Create a copy of FertilityStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FertilityStatusImplCopyWith<_$FertilityStatusImpl> get copyWith =>
      __$$FertilityStatusImplCopyWithImpl<_$FertilityStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FertilityStatusImplToJson(this);
  }
}

abstract class _FertilityStatus implements FertilityStatus {
  const factory _FertilityStatus({
    required final int cycleDay,
    required final FertilityDayType dayType,
    final double conceptionProbability,
    final String? recommendation,
    final String? explanation,
  }) = _$FertilityStatusImpl;

  factory _FertilityStatus.fromJson(Map<String, dynamic> json) =
      _$FertilityStatusImpl.fromJson;

  @override
  int get cycleDay;
  @override
  FertilityDayType get dayType;
  @override
  double get conceptionProbability;
  @override
  String? get recommendation;
  @override
  String? get explanation;

  /// Create a copy of FertilityStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FertilityStatusImplCopyWith<_$FertilityStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
