// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ovulation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FertileWindow _$FertileWindowFromJson(Map<String, dynamic> json) {
  return _FertileWindow.fromJson(json);
}

/// @nodoc
mixin _$FertileWindow {
  DateTime get windowStart => throw _privateConstructorUsedError;
  DateTime get windowEnd => throw _privateConstructorUsedError;
  DateTime? get ovulationDate => throw _privateConstructorUsedError;
  double get ovulationProbability => throw _privateConstructorUsedError;
  bool get isInWindow => throw _privateConstructorUsedError;
  int? get currentDayOfWindow => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;

  /// Serializes this FertileWindow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FertileWindow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FertileWindowCopyWith<FertileWindow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FertileWindowCopyWith<$Res> {
  factory $FertileWindowCopyWith(
    FertileWindow value,
    $Res Function(FertileWindow) then,
  ) = _$FertileWindowCopyWithImpl<$Res, FertileWindow>;
  @useResult
  $Res call({
    DateTime windowStart,
    DateTime windowEnd,
    DateTime? ovulationDate,
    double ovulationProbability,
    bool isInWindow,
    int? currentDayOfWindow,
    String? explanation,
  });
}

/// @nodoc
class _$FertileWindowCopyWithImpl<$Res, $Val extends FertileWindow>
    implements $FertileWindowCopyWith<$Res> {
  _$FertileWindowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FertileWindow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? windowStart = null,
    Object? windowEnd = null,
    Object? ovulationDate = freezed,
    Object? ovulationProbability = null,
    Object? isInWindow = null,
    Object? currentDayOfWindow = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _value.copyWith(
            windowStart: null == windowStart
                ? _value.windowStart
                : windowStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            windowEnd: null == windowEnd
                ? _value.windowEnd
                : windowEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            ovulationDate: freezed == ovulationDate
                ? _value.ovulationDate
                : ovulationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            ovulationProbability: null == ovulationProbability
                ? _value.ovulationProbability
                : ovulationProbability // ignore: cast_nullable_to_non_nullable
                      as double,
            isInWindow: null == isInWindow
                ? _value.isInWindow
                : isInWindow // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentDayOfWindow: freezed == currentDayOfWindow
                ? _value.currentDayOfWindow
                : currentDayOfWindow // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$FertileWindowImplCopyWith<$Res>
    implements $FertileWindowCopyWith<$Res> {
  factory _$$FertileWindowImplCopyWith(
    _$FertileWindowImpl value,
    $Res Function(_$FertileWindowImpl) then,
  ) = __$$FertileWindowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime windowStart,
    DateTime windowEnd,
    DateTime? ovulationDate,
    double ovulationProbability,
    bool isInWindow,
    int? currentDayOfWindow,
    String? explanation,
  });
}

/// @nodoc
class __$$FertileWindowImplCopyWithImpl<$Res>
    extends _$FertileWindowCopyWithImpl<$Res, _$FertileWindowImpl>
    implements _$$FertileWindowImplCopyWith<$Res> {
  __$$FertileWindowImplCopyWithImpl(
    _$FertileWindowImpl _value,
    $Res Function(_$FertileWindowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FertileWindow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? windowStart = null,
    Object? windowEnd = null,
    Object? ovulationDate = freezed,
    Object? ovulationProbability = null,
    Object? isInWindow = null,
    Object? currentDayOfWindow = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _$FertileWindowImpl(
        windowStart: null == windowStart
            ? _value.windowStart
            : windowStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        windowEnd: null == windowEnd
            ? _value.windowEnd
            : windowEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        ovulationDate: freezed == ovulationDate
            ? _value.ovulationDate
            : ovulationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        ovulationProbability: null == ovulationProbability
            ? _value.ovulationProbability
            : ovulationProbability // ignore: cast_nullable_to_non_nullable
                  as double,
        isInWindow: null == isInWindow
            ? _value.isInWindow
            : isInWindow // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentDayOfWindow: freezed == currentDayOfWindow
            ? _value.currentDayOfWindow
            : currentDayOfWindow // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$FertileWindowImpl implements _FertileWindow {
  const _$FertileWindowImpl({
    required this.windowStart,
    required this.windowEnd,
    this.ovulationDate,
    this.ovulationProbability = 0.0,
    this.isInWindow = false,
    this.currentDayOfWindow,
    this.explanation,
  });

  factory _$FertileWindowImpl.fromJson(Map<String, dynamic> json) =>
      _$$FertileWindowImplFromJson(json);

  @override
  final DateTime windowStart;
  @override
  final DateTime windowEnd;
  @override
  final DateTime? ovulationDate;
  @override
  @JsonKey()
  final double ovulationProbability;
  @override
  @JsonKey()
  final bool isInWindow;
  @override
  final int? currentDayOfWindow;
  @override
  final String? explanation;

  @override
  String toString() {
    return 'FertileWindow(windowStart: $windowStart, windowEnd: $windowEnd, ovulationDate: $ovulationDate, ovulationProbability: $ovulationProbability, isInWindow: $isInWindow, currentDayOfWindow: $currentDayOfWindow, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FertileWindowImpl &&
            (identical(other.windowStart, windowStart) ||
                other.windowStart == windowStart) &&
            (identical(other.windowEnd, windowEnd) ||
                other.windowEnd == windowEnd) &&
            (identical(other.ovulationDate, ovulationDate) ||
                other.ovulationDate == ovulationDate) &&
            (identical(other.ovulationProbability, ovulationProbability) ||
                other.ovulationProbability == ovulationProbability) &&
            (identical(other.isInWindow, isInWindow) ||
                other.isInWindow == isInWindow) &&
            (identical(other.currentDayOfWindow, currentDayOfWindow) ||
                other.currentDayOfWindow == currentDayOfWindow) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    windowStart,
    windowEnd,
    ovulationDate,
    ovulationProbability,
    isInWindow,
    currentDayOfWindow,
    explanation,
  );

  /// Create a copy of FertileWindow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FertileWindowImplCopyWith<_$FertileWindowImpl> get copyWith =>
      __$$FertileWindowImplCopyWithImpl<_$FertileWindowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FertileWindowImplToJson(this);
  }
}

abstract class _FertileWindow implements FertileWindow {
  const factory _FertileWindow({
    required final DateTime windowStart,
    required final DateTime windowEnd,
    final DateTime? ovulationDate,
    final double ovulationProbability,
    final bool isInWindow,
    final int? currentDayOfWindow,
    final String? explanation,
  }) = _$FertileWindowImpl;

  factory _FertileWindow.fromJson(Map<String, dynamic> json) =
      _$FertileWindowImpl.fromJson;

  @override
  DateTime get windowStart;
  @override
  DateTime get windowEnd;
  @override
  DateTime? get ovulationDate;
  @override
  double get ovulationProbability;
  @override
  bool get isInWindow;
  @override
  int? get currentDayOfWindow;
  @override
  String? get explanation;

  /// Create a copy of FertileWindow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FertileWindowImplCopyWith<_$FertileWindowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OvulationResult _$OvulationResultFromJson(Map<String, dynamic> json) {
  return _OvulationResult.fromJson(json);
}

/// @nodoc
mixin _$OvulationResult {
  DateTime? get confirmedOvulationDate => throw _privateConstructorUsedError;
  DateTime? get estimatedOvulationDate => throw _privateConstructorUsedError;
  bool get isConfirmed => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String? get method => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;

  /// Serializes this OvulationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OvulationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OvulationResultCopyWith<OvulationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OvulationResultCopyWith<$Res> {
  factory $OvulationResultCopyWith(
    OvulationResult value,
    $Res Function(OvulationResult) then,
  ) = _$OvulationResultCopyWithImpl<$Res, OvulationResult>;
  @useResult
  $Res call({
    DateTime? confirmedOvulationDate,
    DateTime? estimatedOvulationDate,
    bool isConfirmed,
    double confidence,
    String? method,
    String? explanation,
  });
}

/// @nodoc
class _$OvulationResultCopyWithImpl<$Res, $Val extends OvulationResult>
    implements $OvulationResultCopyWith<$Res> {
  _$OvulationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OvulationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmedOvulationDate = freezed,
    Object? estimatedOvulationDate = freezed,
    Object? isConfirmed = null,
    Object? confidence = null,
    Object? method = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _value.copyWith(
            confirmedOvulationDate: freezed == confirmedOvulationDate
                ? _value.confirmedOvulationDate
                : confirmedOvulationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            estimatedOvulationDate: freezed == estimatedOvulationDate
                ? _value.estimatedOvulationDate
                : estimatedOvulationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isConfirmed: null == isConfirmed
                ? _value.isConfirmed
                : isConfirmed // ignore: cast_nullable_to_non_nullable
                      as bool,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            method: freezed == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
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
abstract class _$$OvulationResultImplCopyWith<$Res>
    implements $OvulationResultCopyWith<$Res> {
  factory _$$OvulationResultImplCopyWith(
    _$OvulationResultImpl value,
    $Res Function(_$OvulationResultImpl) then,
  ) = __$$OvulationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime? confirmedOvulationDate,
    DateTime? estimatedOvulationDate,
    bool isConfirmed,
    double confidence,
    String? method,
    String? explanation,
  });
}

/// @nodoc
class __$$OvulationResultImplCopyWithImpl<$Res>
    extends _$OvulationResultCopyWithImpl<$Res, _$OvulationResultImpl>
    implements _$$OvulationResultImplCopyWith<$Res> {
  __$$OvulationResultImplCopyWithImpl(
    _$OvulationResultImpl _value,
    $Res Function(_$OvulationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OvulationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmedOvulationDate = freezed,
    Object? estimatedOvulationDate = freezed,
    Object? isConfirmed = null,
    Object? confidence = null,
    Object? method = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _$OvulationResultImpl(
        confirmedOvulationDate: freezed == confirmedOvulationDate
            ? _value.confirmedOvulationDate
            : confirmedOvulationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        estimatedOvulationDate: freezed == estimatedOvulationDate
            ? _value.estimatedOvulationDate
            : estimatedOvulationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isConfirmed: null == isConfirmed
            ? _value.isConfirmed
            : isConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        method: freezed == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
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
class _$OvulationResultImpl implements _OvulationResult {
  const _$OvulationResultImpl({
    this.confirmedOvulationDate,
    this.estimatedOvulationDate,
    this.isConfirmed = false,
    this.confidence = 0.0,
    this.method,
    this.explanation,
  });

  factory _$OvulationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OvulationResultImplFromJson(json);

  @override
  final DateTime? confirmedOvulationDate;
  @override
  final DateTime? estimatedOvulationDate;
  @override
  @JsonKey()
  final bool isConfirmed;
  @override
  @JsonKey()
  final double confidence;
  @override
  final String? method;
  @override
  final String? explanation;

  @override
  String toString() {
    return 'OvulationResult(confirmedOvulationDate: $confirmedOvulationDate, estimatedOvulationDate: $estimatedOvulationDate, isConfirmed: $isConfirmed, confidence: $confidence, method: $method, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OvulationResultImpl &&
            (identical(other.confirmedOvulationDate, confirmedOvulationDate) ||
                other.confirmedOvulationDate == confirmedOvulationDate) &&
            (identical(other.estimatedOvulationDate, estimatedOvulationDate) ||
                other.estimatedOvulationDate == estimatedOvulationDate) &&
            (identical(other.isConfirmed, isConfirmed) ||
                other.isConfirmed == isConfirmed) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    confirmedOvulationDate,
    estimatedOvulationDate,
    isConfirmed,
    confidence,
    method,
    explanation,
  );

  /// Create a copy of OvulationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OvulationResultImplCopyWith<_$OvulationResultImpl> get copyWith =>
      __$$OvulationResultImplCopyWithImpl<_$OvulationResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OvulationResultImplToJson(this);
  }
}

abstract class _OvulationResult implements OvulationResult {
  const factory _OvulationResult({
    final DateTime? confirmedOvulationDate,
    final DateTime? estimatedOvulationDate,
    final bool isConfirmed,
    final double confidence,
    final String? method,
    final String? explanation,
  }) = _$OvulationResultImpl;

  factory _OvulationResult.fromJson(Map<String, dynamic> json) =
      _$OvulationResultImpl.fromJson;

  @override
  DateTime? get confirmedOvulationDate;
  @override
  DateTime? get estimatedOvulationDate;
  @override
  bool get isConfirmed;
  @override
  double get confidence;
  @override
  String? get method;
  @override
  String? get explanation;

  /// Create a copy of OvulationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OvulationResultImplCopyWith<_$OvulationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConceptionLikelihood _$ConceptionLikelihoodFromJson(Map<String, dynamic> json) {
  return _ConceptionLikelihood.fromJson(json);
}

/// @nodoc
mixin _$ConceptionLikelihood {
  double get likelihood => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;

  /// Serializes this ConceptionLikelihood to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConceptionLikelihood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConceptionLikelihoodCopyWith<ConceptionLikelihood> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConceptionLikelihoodCopyWith<$Res> {
  factory $ConceptionLikelihoodCopyWith(
    ConceptionLikelihood value,
    $Res Function(ConceptionLikelihood) then,
  ) = _$ConceptionLikelihoodCopyWithImpl<$Res, ConceptionLikelihood>;
  @useResult
  $Res call({
    double likelihood,
    String? explanation,
    List<String> recommendations,
  });
}

/// @nodoc
class _$ConceptionLikelihoodCopyWithImpl<
  $Res,
  $Val extends ConceptionLikelihood
>
    implements $ConceptionLikelihoodCopyWith<$Res> {
  _$ConceptionLikelihoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConceptionLikelihood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likelihood = null,
    Object? explanation = freezed,
    Object? recommendations = null,
  }) {
    return _then(
      _value.copyWith(
            likelihood: null == likelihood
                ? _value.likelihood
                : likelihood // ignore: cast_nullable_to_non_nullable
                      as double,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConceptionLikelihoodImplCopyWith<$Res>
    implements $ConceptionLikelihoodCopyWith<$Res> {
  factory _$$ConceptionLikelihoodImplCopyWith(
    _$ConceptionLikelihoodImpl value,
    $Res Function(_$ConceptionLikelihoodImpl) then,
  ) = __$$ConceptionLikelihoodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double likelihood,
    String? explanation,
    List<String> recommendations,
  });
}

/// @nodoc
class __$$ConceptionLikelihoodImplCopyWithImpl<$Res>
    extends _$ConceptionLikelihoodCopyWithImpl<$Res, _$ConceptionLikelihoodImpl>
    implements _$$ConceptionLikelihoodImplCopyWith<$Res> {
  __$$ConceptionLikelihoodImplCopyWithImpl(
    _$ConceptionLikelihoodImpl _value,
    $Res Function(_$ConceptionLikelihoodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConceptionLikelihood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likelihood = null,
    Object? explanation = freezed,
    Object? recommendations = null,
  }) {
    return _then(
      _$ConceptionLikelihoodImpl(
        likelihood: null == likelihood
            ? _value.likelihood
            : likelihood // ignore: cast_nullable_to_non_nullable
                  as double,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConceptionLikelihoodImpl implements _ConceptionLikelihood {
  const _$ConceptionLikelihoodImpl({
    this.likelihood = 0.0,
    this.explanation,
    final List<String> recommendations = const [],
  }) : _recommendations = recommendations;

  factory _$ConceptionLikelihoodImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConceptionLikelihoodImplFromJson(json);

  @override
  @JsonKey()
  final double likelihood;
  @override
  final String? explanation;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'ConceptionLikelihood(likelihood: $likelihood, explanation: $explanation, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConceptionLikelihoodImpl &&
            (identical(other.likelihood, likelihood) ||
                other.likelihood == likelihood) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    likelihood,
    explanation,
    const DeepCollectionEquality().hash(_recommendations),
  );

  /// Create a copy of ConceptionLikelihood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConceptionLikelihoodImplCopyWith<_$ConceptionLikelihoodImpl>
  get copyWith =>
      __$$ConceptionLikelihoodImplCopyWithImpl<_$ConceptionLikelihoodImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConceptionLikelihoodImplToJson(this);
  }
}

abstract class _ConceptionLikelihood implements ConceptionLikelihood {
  const factory _ConceptionLikelihood({
    final double likelihood,
    final String? explanation,
    final List<String> recommendations,
  }) = _$ConceptionLikelihoodImpl;

  factory _ConceptionLikelihood.fromJson(Map<String, dynamic> json) =
      _$ConceptionLikelihoodImpl.fromJson;

  @override
  double get likelihood;
  @override
  String? get explanation;
  @override
  List<String> get recommendations;

  /// Create a copy of ConceptionLikelihood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConceptionLikelihoodImplCopyWith<_$ConceptionLikelihoodImpl>
  get copyWith => throw _privateConstructorUsedError;
}
