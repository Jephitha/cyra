// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'correlation_engine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CorrelationResult _$CorrelationResultFromJson(Map<String, dynamic> json) {
  return _CorrelationResult.fromJson(json);
}

/// @nodoc
mixin _$CorrelationResult {
  String get featureA => throw _privateConstructorUsedError;
  String get featureB => throw _privateConstructorUsedError;
  double get correlationCoefficient => throw _privateConstructorUsedError;
  bool get isSignificant => throw _privateConstructorUsedError;
  String get mostCommonPhase => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;

  /// Serializes this CorrelationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CorrelationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CorrelationResultCopyWith<CorrelationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CorrelationResultCopyWith<$Res> {
  factory $CorrelationResultCopyWith(
    CorrelationResult value,
    $Res Function(CorrelationResult) then,
  ) = _$CorrelationResultCopyWithImpl<$Res, CorrelationResult>;
  @useResult
  $Res call({
    String featureA,
    String featureB,
    double correlationCoefficient,
    bool isSignificant,
    String mostCommonPhase,
    String explanation,
  });
}

/// @nodoc
class _$CorrelationResultCopyWithImpl<$Res, $Val extends CorrelationResult>
    implements $CorrelationResultCopyWith<$Res> {
  _$CorrelationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CorrelationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureA = null,
    Object? featureB = null,
    Object? correlationCoefficient = null,
    Object? isSignificant = null,
    Object? mostCommonPhase = null,
    Object? explanation = null,
  }) {
    return _then(
      _value.copyWith(
            featureA: null == featureA
                ? _value.featureA
                : featureA // ignore: cast_nullable_to_non_nullable
                      as String,
            featureB: null == featureB
                ? _value.featureB
                : featureB // ignore: cast_nullable_to_non_nullable
                      as String,
            correlationCoefficient: null == correlationCoefficient
                ? _value.correlationCoefficient
                : correlationCoefficient // ignore: cast_nullable_to_non_nullable
                      as double,
            isSignificant: null == isSignificant
                ? _value.isSignificant
                : isSignificant // ignore: cast_nullable_to_non_nullable
                      as bool,
            mostCommonPhase: null == mostCommonPhase
                ? _value.mostCommonPhase
                : mostCommonPhase // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$CorrelationResultImplCopyWith<$Res>
    implements $CorrelationResultCopyWith<$Res> {
  factory _$$CorrelationResultImplCopyWith(
    _$CorrelationResultImpl value,
    $Res Function(_$CorrelationResultImpl) then,
  ) = __$$CorrelationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String featureA,
    String featureB,
    double correlationCoefficient,
    bool isSignificant,
    String mostCommonPhase,
    String explanation,
  });
}

/// @nodoc
class __$$CorrelationResultImplCopyWithImpl<$Res>
    extends _$CorrelationResultCopyWithImpl<$Res, _$CorrelationResultImpl>
    implements _$$CorrelationResultImplCopyWith<$Res> {
  __$$CorrelationResultImplCopyWithImpl(
    _$CorrelationResultImpl _value,
    $Res Function(_$CorrelationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CorrelationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featureA = null,
    Object? featureB = null,
    Object? correlationCoefficient = null,
    Object? isSignificant = null,
    Object? mostCommonPhase = null,
    Object? explanation = null,
  }) {
    return _then(
      _$CorrelationResultImpl(
        featureA: null == featureA
            ? _value.featureA
            : featureA // ignore: cast_nullable_to_non_nullable
                  as String,
        featureB: null == featureB
            ? _value.featureB
            : featureB // ignore: cast_nullable_to_non_nullable
                  as String,
        correlationCoefficient: null == correlationCoefficient
            ? _value.correlationCoefficient
            : correlationCoefficient // ignore: cast_nullable_to_non_nullable
                  as double,
        isSignificant: null == isSignificant
            ? _value.isSignificant
            : isSignificant // ignore: cast_nullable_to_non_nullable
                  as bool,
        mostCommonPhase: null == mostCommonPhase
            ? _value.mostCommonPhase
            : mostCommonPhase // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$CorrelationResultImpl implements _CorrelationResult {
  const _$CorrelationResultImpl({
    required this.featureA,
    required this.featureB,
    required this.correlationCoefficient,
    required this.isSignificant,
    this.mostCommonPhase = '',
    this.explanation = '',
  });

  factory _$CorrelationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$CorrelationResultImplFromJson(json);

  @override
  final String featureA;
  @override
  final String featureB;
  @override
  final double correlationCoefficient;
  @override
  final bool isSignificant;
  @override
  @JsonKey()
  final String mostCommonPhase;
  @override
  @JsonKey()
  final String explanation;

  @override
  String toString() {
    return 'CorrelationResult(featureA: $featureA, featureB: $featureB, correlationCoefficient: $correlationCoefficient, isSignificant: $isSignificant, mostCommonPhase: $mostCommonPhase, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CorrelationResultImpl &&
            (identical(other.featureA, featureA) ||
                other.featureA == featureA) &&
            (identical(other.featureB, featureB) ||
                other.featureB == featureB) &&
            (identical(other.correlationCoefficient, correlationCoefficient) ||
                other.correlationCoefficient == correlationCoefficient) &&
            (identical(other.isSignificant, isSignificant) ||
                other.isSignificant == isSignificant) &&
            (identical(other.mostCommonPhase, mostCommonPhase) ||
                other.mostCommonPhase == mostCommonPhase) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    featureA,
    featureB,
    correlationCoefficient,
    isSignificant,
    mostCommonPhase,
    explanation,
  );

  /// Create a copy of CorrelationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CorrelationResultImplCopyWith<_$CorrelationResultImpl> get copyWith =>
      __$$CorrelationResultImplCopyWithImpl<_$CorrelationResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CorrelationResultImplToJson(this);
  }
}

abstract class _CorrelationResult implements CorrelationResult {
  const factory _CorrelationResult({
    required final String featureA,
    required final String featureB,
    required final double correlationCoefficient,
    required final bool isSignificant,
    final String mostCommonPhase,
    final String explanation,
  }) = _$CorrelationResultImpl;

  factory _CorrelationResult.fromJson(Map<String, dynamic> json) =
      _$CorrelationResultImpl.fromJson;

  @override
  String get featureA;
  @override
  String get featureB;
  @override
  double get correlationCoefficient;
  @override
  bool get isSignificant;
  @override
  String get mostCommonPhase;
  @override
  String get explanation;

  /// Create a copy of CorrelationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CorrelationResultImplCopyWith<_$CorrelationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CycleRegularityResult _$CycleRegularityResultFromJson(
  Map<String, dynamic> json,
) {
  return _CycleRegularityResult.fromJson(json);
}

/// @nodoc
mixin _$CycleRegularityResult {
  CycleRegularity get regularity => throw _privateConstructorUsedError;
  double get coefficientOfVariation => throw _privateConstructorUsedError;
  double get standardDeviation => throw _privateConstructorUsedError;
  String? get trend => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;

  /// Serializes this CycleRegularityResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CycleRegularityResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CycleRegularityResultCopyWith<CycleRegularityResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CycleRegularityResultCopyWith<$Res> {
  factory $CycleRegularityResultCopyWith(
    CycleRegularityResult value,
    $Res Function(CycleRegularityResult) then,
  ) = _$CycleRegularityResultCopyWithImpl<$Res, CycleRegularityResult>;
  @useResult
  $Res call({
    CycleRegularity regularity,
    double coefficientOfVariation,
    double standardDeviation,
    String? trend,
    String? explanation,
  });
}

/// @nodoc
class _$CycleRegularityResultCopyWithImpl<
  $Res,
  $Val extends CycleRegularityResult
>
    implements $CycleRegularityResultCopyWith<$Res> {
  _$CycleRegularityResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CycleRegularityResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regularity = null,
    Object? coefficientOfVariation = null,
    Object? standardDeviation = null,
    Object? trend = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _value.copyWith(
            regularity: null == regularity
                ? _value.regularity
                : regularity // ignore: cast_nullable_to_non_nullable
                      as CycleRegularity,
            coefficientOfVariation: null == coefficientOfVariation
                ? _value.coefficientOfVariation
                : coefficientOfVariation // ignore: cast_nullable_to_non_nullable
                      as double,
            standardDeviation: null == standardDeviation
                ? _value.standardDeviation
                : standardDeviation // ignore: cast_nullable_to_non_nullable
                      as double,
            trend: freezed == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CycleRegularityResultImplCopyWith<$Res>
    implements $CycleRegularityResultCopyWith<$Res> {
  factory _$$CycleRegularityResultImplCopyWith(
    _$CycleRegularityResultImpl value,
    $Res Function(_$CycleRegularityResultImpl) then,
  ) = __$$CycleRegularityResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CycleRegularity regularity,
    double coefficientOfVariation,
    double standardDeviation,
    String? trend,
    String? explanation,
  });
}

/// @nodoc
class __$$CycleRegularityResultImplCopyWithImpl<$Res>
    extends
        _$CycleRegularityResultCopyWithImpl<$Res, _$CycleRegularityResultImpl>
    implements _$$CycleRegularityResultImplCopyWith<$Res> {
  __$$CycleRegularityResultImplCopyWithImpl(
    _$CycleRegularityResultImpl _value,
    $Res Function(_$CycleRegularityResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CycleRegularityResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regularity = null,
    Object? coefficientOfVariation = null,
    Object? standardDeviation = null,
    Object? trend = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _$CycleRegularityResultImpl(
        regularity: null == regularity
            ? _value.regularity
            : regularity // ignore: cast_nullable_to_non_nullable
                  as CycleRegularity,
        coefficientOfVariation: null == coefficientOfVariation
            ? _value.coefficientOfVariation
            : coefficientOfVariation // ignore: cast_nullable_to_non_nullable
                  as double,
        standardDeviation: null == standardDeviation
            ? _value.standardDeviation
            : standardDeviation // ignore: cast_nullable_to_non_nullable
                  as double,
        trend: freezed == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
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
class _$CycleRegularityResultImpl implements _CycleRegularityResult {
  const _$CycleRegularityResultImpl({
    required this.regularity,
    required this.coefficientOfVariation,
    required this.standardDeviation,
    this.trend,
    this.explanation,
  });

  factory _$CycleRegularityResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$CycleRegularityResultImplFromJson(json);

  @override
  final CycleRegularity regularity;
  @override
  final double coefficientOfVariation;
  @override
  final double standardDeviation;
  @override
  final String? trend;
  @override
  final String? explanation;

  @override
  String toString() {
    return 'CycleRegularityResult(regularity: $regularity, coefficientOfVariation: $coefficientOfVariation, standardDeviation: $standardDeviation, trend: $trend, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CycleRegularityResultImpl &&
            (identical(other.regularity, regularity) ||
                other.regularity == regularity) &&
            (identical(other.coefficientOfVariation, coefficientOfVariation) ||
                other.coefficientOfVariation == coefficientOfVariation) &&
            (identical(other.standardDeviation, standardDeviation) ||
                other.standardDeviation == standardDeviation) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    regularity,
    coefficientOfVariation,
    standardDeviation,
    trend,
    explanation,
  );

  /// Create a copy of CycleRegularityResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CycleRegularityResultImplCopyWith<_$CycleRegularityResultImpl>
  get copyWith =>
      __$$CycleRegularityResultImplCopyWithImpl<_$CycleRegularityResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CycleRegularityResultImplToJson(this);
  }
}

abstract class _CycleRegularityResult implements CycleRegularityResult {
  const factory _CycleRegularityResult({
    required final CycleRegularity regularity,
    required final double coefficientOfVariation,
    required final double standardDeviation,
    final String? trend,
    final String? explanation,
  }) = _$CycleRegularityResultImpl;

  factory _CycleRegularityResult.fromJson(Map<String, dynamic> json) =
      _$CycleRegularityResultImpl.fromJson;

  @override
  CycleRegularity get regularity;
  @override
  double get coefficientOfVariation;
  @override
  double get standardDeviation;
  @override
  String? get trend;
  @override
  String? get explanation;

  /// Create a copy of CycleRegularityResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CycleRegularityResultImplCopyWith<_$CycleRegularityResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SeverityTrend _$SeverityTrendFromJson(Map<String, dynamic> json) {
  return _SeverityTrend.fromJson(json);
}

/// @nodoc
mixin _$SeverityTrend {
  TrendDirection get direction => throw _privateConstructorUsedError;
  double get slope => throw _privateConstructorUsedError;

  /// Serializes this SeverityTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeverityTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeverityTrendCopyWith<SeverityTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeverityTrendCopyWith<$Res> {
  factory $SeverityTrendCopyWith(
    SeverityTrend value,
    $Res Function(SeverityTrend) then,
  ) = _$SeverityTrendCopyWithImpl<$Res, SeverityTrend>;
  @useResult
  $Res call({TrendDirection direction, double slope});
}

/// @nodoc
class _$SeverityTrendCopyWithImpl<$Res, $Val extends SeverityTrend>
    implements $SeverityTrendCopyWith<$Res> {
  _$SeverityTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeverityTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? direction = null, Object? slope = null}) {
    return _then(
      _value.copyWith(
            direction: null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as TrendDirection,
            slope: null == slope
                ? _value.slope
                : slope // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeverityTrendImplCopyWith<$Res>
    implements $SeverityTrendCopyWith<$Res> {
  factory _$$SeverityTrendImplCopyWith(
    _$SeverityTrendImpl value,
    $Res Function(_$SeverityTrendImpl) then,
  ) = __$$SeverityTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TrendDirection direction, double slope});
}

/// @nodoc
class __$$SeverityTrendImplCopyWithImpl<$Res>
    extends _$SeverityTrendCopyWithImpl<$Res, _$SeverityTrendImpl>
    implements _$$SeverityTrendImplCopyWith<$Res> {
  __$$SeverityTrendImplCopyWithImpl(
    _$SeverityTrendImpl _value,
    $Res Function(_$SeverityTrendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeverityTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? direction = null, Object? slope = null}) {
    return _then(
      _$SeverityTrendImpl(
        direction: null == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as TrendDirection,
        slope: null == slope
            ? _value.slope
            : slope // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeverityTrendImpl implements _SeverityTrend {
  const _$SeverityTrendImpl({required this.direction, required this.slope});

  factory _$SeverityTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeverityTrendImplFromJson(json);

  @override
  final TrendDirection direction;
  @override
  final double slope;

  @override
  String toString() {
    return 'SeverityTrend(direction: $direction, slope: $slope)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeverityTrendImpl &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.slope, slope) || other.slope == slope));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, direction, slope);

  /// Create a copy of SeverityTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeverityTrendImplCopyWith<_$SeverityTrendImpl> get copyWith =>
      __$$SeverityTrendImplCopyWithImpl<_$SeverityTrendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeverityTrendImplToJson(this);
  }
}

abstract class _SeverityTrend implements SeverityTrend {
  const factory _SeverityTrend({
    required final TrendDirection direction,
    required final double slope,
  }) = _$SeverityTrendImpl;

  factory _SeverityTrend.fromJson(Map<String, dynamic> json) =
      _$SeverityTrendImpl.fromJson;

  @override
  TrendDirection get direction;
  @override
  double get slope;

  /// Create a copy of SeverityTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeverityTrendImplCopyWith<_$SeverityTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImpactfulSymptom _$ImpactfulSymptomFromJson(Map<String, dynamic> json) {
  return _ImpactfulSymptom.fromJson(json);
}

/// @nodoc
mixin _$ImpactfulSymptom {
  String get symptomId => throw _privateConstructorUsedError;
  String get symptomName => throw _privateConstructorUsedError;
  double get impactScore => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;
  double get averageSeverity => throw _privateConstructorUsedError;
  String get insight => throw _privateConstructorUsedError;

  /// Serializes this ImpactfulSymptom to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImpactfulSymptom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImpactfulSymptomCopyWith<ImpactfulSymptom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImpactfulSymptomCopyWith<$Res> {
  factory $ImpactfulSymptomCopyWith(
    ImpactfulSymptom value,
    $Res Function(ImpactfulSymptom) then,
  ) = _$ImpactfulSymptomCopyWithImpl<$Res, ImpactfulSymptom>;
  @useResult
  $Res call({
    String symptomId,
    String symptomName,
    double impactScore,
    int frequency,
    double averageSeverity,
    String insight,
  });
}

/// @nodoc
class _$ImpactfulSymptomCopyWithImpl<$Res, $Val extends ImpactfulSymptom>
    implements $ImpactfulSymptomCopyWith<$Res> {
  _$ImpactfulSymptomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImpactfulSymptom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomName = null,
    Object? impactScore = null,
    Object? frequency = null,
    Object? averageSeverity = null,
    Object? insight = null,
  }) {
    return _then(
      _value.copyWith(
            symptomId: null == symptomId
                ? _value.symptomId
                : symptomId // ignore: cast_nullable_to_non_nullable
                      as String,
            symptomName: null == symptomName
                ? _value.symptomName
                : symptomName // ignore: cast_nullable_to_non_nullable
                      as String,
            impactScore: null == impactScore
                ? _value.impactScore
                : impactScore // ignore: cast_nullable_to_non_nullable
                      as double,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as int,
            averageSeverity: null == averageSeverity
                ? _value.averageSeverity
                : averageSeverity // ignore: cast_nullable_to_non_nullable
                      as double,
            insight: null == insight
                ? _value.insight
                : insight // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImpactfulSymptomImplCopyWith<$Res>
    implements $ImpactfulSymptomCopyWith<$Res> {
  factory _$$ImpactfulSymptomImplCopyWith(
    _$ImpactfulSymptomImpl value,
    $Res Function(_$ImpactfulSymptomImpl) then,
  ) = __$$ImpactfulSymptomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symptomId,
    String symptomName,
    double impactScore,
    int frequency,
    double averageSeverity,
    String insight,
  });
}

/// @nodoc
class __$$ImpactfulSymptomImplCopyWithImpl<$Res>
    extends _$ImpactfulSymptomCopyWithImpl<$Res, _$ImpactfulSymptomImpl>
    implements _$$ImpactfulSymptomImplCopyWith<$Res> {
  __$$ImpactfulSymptomImplCopyWithImpl(
    _$ImpactfulSymptomImpl _value,
    $Res Function(_$ImpactfulSymptomImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImpactfulSymptom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomName = null,
    Object? impactScore = null,
    Object? frequency = null,
    Object? averageSeverity = null,
    Object? insight = null,
  }) {
    return _then(
      _$ImpactfulSymptomImpl(
        symptomId: null == symptomId
            ? _value.symptomId
            : symptomId // ignore: cast_nullable_to_non_nullable
                  as String,
        symptomName: null == symptomName
            ? _value.symptomName
            : symptomName // ignore: cast_nullable_to_non_nullable
                  as String,
        impactScore: null == impactScore
            ? _value.impactScore
            : impactScore // ignore: cast_nullable_to_non_nullable
                  as double,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as int,
        averageSeverity: null == averageSeverity
            ? _value.averageSeverity
            : averageSeverity // ignore: cast_nullable_to_non_nullable
                  as double,
        insight: null == insight
            ? _value.insight
            : insight // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImpactfulSymptomImpl implements _ImpactfulSymptom {
  const _$ImpactfulSymptomImpl({
    required this.symptomId,
    required this.symptomName,
    required this.impactScore,
    required this.frequency,
    required this.averageSeverity,
    this.insight = '',
  });

  factory _$ImpactfulSymptomImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImpactfulSymptomImplFromJson(json);

  @override
  final String symptomId;
  @override
  final String symptomName;
  @override
  final double impactScore;
  @override
  final int frequency;
  @override
  final double averageSeverity;
  @override
  @JsonKey()
  final String insight;

  @override
  String toString() {
    return 'ImpactfulSymptom(symptomId: $symptomId, symptomName: $symptomName, impactScore: $impactScore, frequency: $frequency, averageSeverity: $averageSeverity, insight: $insight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImpactfulSymptomImpl &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomName, symptomName) ||
                other.symptomName == symptomName) &&
            (identical(other.impactScore, impactScore) ||
                other.impactScore == impactScore) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.averageSeverity, averageSeverity) ||
                other.averageSeverity == averageSeverity) &&
            (identical(other.insight, insight) || other.insight == insight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symptomId,
    symptomName,
    impactScore,
    frequency,
    averageSeverity,
    insight,
  );

  /// Create a copy of ImpactfulSymptom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImpactfulSymptomImplCopyWith<_$ImpactfulSymptomImpl> get copyWith =>
      __$$ImpactfulSymptomImplCopyWithImpl<_$ImpactfulSymptomImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ImpactfulSymptomImplToJson(this);
  }
}

abstract class _ImpactfulSymptom implements ImpactfulSymptom {
  const factory _ImpactfulSymptom({
    required final String symptomId,
    required final String symptomName,
    required final double impactScore,
    required final int frequency,
    required final double averageSeverity,
    final String insight,
  }) = _$ImpactfulSymptomImpl;

  factory _ImpactfulSymptom.fromJson(Map<String, dynamic> json) =
      _$ImpactfulSymptomImpl.fromJson;

  @override
  String get symptomId;
  @override
  String get symptomName;
  @override
  double get impactScore;
  @override
  int get frequency;
  @override
  double get averageSeverity;
  @override
  String get insight;

  /// Create a copy of ImpactfulSymptom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImpactfulSymptomImplCopyWith<_$ImpactfulSymptomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
