// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIInsightCard _$AIInsightCardFromJson(Map<String, dynamic> json) {
  return _AIInsightCard.fromJson(json);
}

/// @nodoc
mixin _$AIInsightCard {
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  int get colorValue => throw _privateConstructorUsedError;
  InsightTopic get topic => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String? get disclaimer => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Serializes this AIInsightCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIInsightCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIInsightCardCopyWith<AIInsightCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIInsightCardCopyWith<$Res> {
  factory $AIInsightCardCopyWith(
    AIInsightCard value,
    $Res Function(AIInsightCard) then,
  ) = _$AIInsightCardCopyWithImpl<$Res, AIInsightCard>;
  @useResult
  $Res call({
    String title,
    String summary,
    String iconName,
    int colorValue,
    InsightTopic topic,
    double confidence,
    String? disclaimer,
    bool isLoading,
  });
}

/// @nodoc
class _$AIInsightCardCopyWithImpl<$Res, $Val extends AIInsightCard>
    implements $AIInsightCardCopyWith<$Res> {
  _$AIInsightCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIInsightCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? summary = null,
    Object? iconName = null,
    Object? colorValue = null,
    Object? topic = null,
    Object? confidence = null,
    Object? disclaimer = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            iconName: null == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String,
            colorValue: null == colorValue
                ? _value.colorValue
                : colorValue // ignore: cast_nullable_to_non_nullable
                      as int,
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as InsightTopic,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            disclaimer: freezed == disclaimer
                ? _value.disclaimer
                : disclaimer // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIInsightCardImplCopyWith<$Res>
    implements $AIInsightCardCopyWith<$Res> {
  factory _$$AIInsightCardImplCopyWith(
    _$AIInsightCardImpl value,
    $Res Function(_$AIInsightCardImpl) then,
  ) = __$$AIInsightCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String summary,
    String iconName,
    int colorValue,
    InsightTopic topic,
    double confidence,
    String? disclaimer,
    bool isLoading,
  });
}

/// @nodoc
class __$$AIInsightCardImplCopyWithImpl<$Res>
    extends _$AIInsightCardCopyWithImpl<$Res, _$AIInsightCardImpl>
    implements _$$AIInsightCardImplCopyWith<$Res> {
  __$$AIInsightCardImplCopyWithImpl(
    _$AIInsightCardImpl _value,
    $Res Function(_$AIInsightCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIInsightCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? summary = null,
    Object? iconName = null,
    Object? colorValue = null,
    Object? topic = null,
    Object? confidence = null,
    Object? disclaimer = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _$AIInsightCardImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        iconName: null == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String,
        colorValue: null == colorValue
            ? _value.colorValue
            : colorValue // ignore: cast_nullable_to_non_nullable
                  as int,
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as InsightTopic,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        disclaimer: freezed == disclaimer
            ? _value.disclaimer
            : disclaimer // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIInsightCardImpl implements _AIInsightCard {
  const _$AIInsightCardImpl({
    required this.title,
    required this.summary,
    required this.iconName,
    required this.colorValue,
    required this.topic,
    this.confidence = 0.0,
    this.disclaimer,
    this.isLoading = false,
  });

  factory _$AIInsightCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIInsightCardImplFromJson(json);

  @override
  final String title;
  @override
  final String summary;
  @override
  final String iconName;
  @override
  final int colorValue;
  @override
  final InsightTopic topic;
  @override
  @JsonKey()
  final double confidence;
  @override
  final String? disclaimer;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'AIInsightCard(title: $title, summary: $summary, iconName: $iconName, colorValue: $colorValue, topic: $topic, confidence: $confidence, disclaimer: $disclaimer, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIInsightCardImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.disclaimer, disclaimer) ||
                other.disclaimer == disclaimer) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    summary,
    iconName,
    colorValue,
    topic,
    confidence,
    disclaimer,
    isLoading,
  );

  /// Create a copy of AIInsightCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIInsightCardImplCopyWith<_$AIInsightCardImpl> get copyWith =>
      __$$AIInsightCardImplCopyWithImpl<_$AIInsightCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIInsightCardImplToJson(this);
  }
}

abstract class _AIInsightCard implements AIInsightCard {
  const factory _AIInsightCard({
    required final String title,
    required final String summary,
    required final String iconName,
    required final int colorValue,
    required final InsightTopic topic,
    final double confidence,
    final String? disclaimer,
    final bool isLoading,
  }) = _$AIInsightCardImpl;

  factory _AIInsightCard.fromJson(Map<String, dynamic> json) =
      _$AIInsightCardImpl.fromJson;

  @override
  String get title;
  @override
  String get summary;
  @override
  String get iconName;
  @override
  int get colorValue;
  @override
  InsightTopic get topic;
  @override
  double get confidence;
  @override
  String? get disclaimer;
  @override
  bool get isLoading;

  /// Create a copy of AIInsightCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIInsightCardImplCopyWith<_$AIInsightCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklySummary _$WeeklySummaryFromJson(Map<String, dynamic> json) {
  return _WeeklySummary.fromJson(json);
}

/// @nodoc
mixin _$WeeklySummary {
  DateTime get weekStart => throw _privateConstructorUsedError;
  DateTime get weekEnd => throw _privateConstructorUsedError;
  int get symptomCount => throw _privateConstructorUsedError;
  double get moodAverage => throw _privateConstructorUsedError;
  List<String> get highlights => throw _privateConstructorUsedError;
  String get keyInsight => throw _privateConstructorUsedError;
  String? get tip => throw _privateConstructorUsedError;

  /// Serializes this WeeklySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklySummaryCopyWith<WeeklySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklySummaryCopyWith<$Res> {
  factory $WeeklySummaryCopyWith(
    WeeklySummary value,
    $Res Function(WeeklySummary) then,
  ) = _$WeeklySummaryCopyWithImpl<$Res, WeeklySummary>;
  @useResult
  $Res call({
    DateTime weekStart,
    DateTime weekEnd,
    int symptomCount,
    double moodAverage,
    List<String> highlights,
    String keyInsight,
    String? tip,
  });
}

/// @nodoc
class _$WeeklySummaryCopyWithImpl<$Res, $Val extends WeeklySummary>
    implements $WeeklySummaryCopyWith<$Res> {
  _$WeeklySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? symptomCount = null,
    Object? moodAverage = null,
    Object? highlights = null,
    Object? keyInsight = null,
    Object? tip = freezed,
  }) {
    return _then(
      _value.copyWith(
            weekStart: null == weekStart
                ? _value.weekStart
                : weekStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weekEnd: null == weekEnd
                ? _value.weekEnd
                : weekEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            symptomCount: null == symptomCount
                ? _value.symptomCount
                : symptomCount // ignore: cast_nullable_to_non_nullable
                      as int,
            moodAverage: null == moodAverage
                ? _value.moodAverage
                : moodAverage // ignore: cast_nullable_to_non_nullable
                      as double,
            highlights: null == highlights
                ? _value.highlights
                : highlights // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            keyInsight: null == keyInsight
                ? _value.keyInsight
                : keyInsight // ignore: cast_nullable_to_non_nullable
                      as String,
            tip: freezed == tip
                ? _value.tip
                : tip // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklySummaryImplCopyWith<$Res>
    implements $WeeklySummaryCopyWith<$Res> {
  factory _$$WeeklySummaryImplCopyWith(
    _$WeeklySummaryImpl value,
    $Res Function(_$WeeklySummaryImpl) then,
  ) = __$$WeeklySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime weekStart,
    DateTime weekEnd,
    int symptomCount,
    double moodAverage,
    List<String> highlights,
    String keyInsight,
    String? tip,
  });
}

/// @nodoc
class __$$WeeklySummaryImplCopyWithImpl<$Res>
    extends _$WeeklySummaryCopyWithImpl<$Res, _$WeeklySummaryImpl>
    implements _$$WeeklySummaryImplCopyWith<$Res> {
  __$$WeeklySummaryImplCopyWithImpl(
    _$WeeklySummaryImpl _value,
    $Res Function(_$WeeklySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? symptomCount = null,
    Object? moodAverage = null,
    Object? highlights = null,
    Object? keyInsight = null,
    Object? tip = freezed,
  }) {
    return _then(
      _$WeeklySummaryImpl(
        weekStart: null == weekStart
            ? _value.weekStart
            : weekStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weekEnd: null == weekEnd
            ? _value.weekEnd
            : weekEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        symptomCount: null == symptomCount
            ? _value.symptomCount
            : symptomCount // ignore: cast_nullable_to_non_nullable
                  as int,
        moodAverage: null == moodAverage
            ? _value.moodAverage
            : moodAverage // ignore: cast_nullable_to_non_nullable
                  as double,
        highlights: null == highlights
            ? _value._highlights
            : highlights // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        keyInsight: null == keyInsight
            ? _value.keyInsight
            : keyInsight // ignore: cast_nullable_to_non_nullable
                  as String,
        tip: freezed == tip
            ? _value.tip
            : tip // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklySummaryImpl implements _WeeklySummary {
  const _$WeeklySummaryImpl({
    required this.weekStart,
    required this.weekEnd,
    required this.symptomCount,
    required this.moodAverage,
    final List<String> highlights = const [],
    required this.keyInsight,
    this.tip,
  }) : _highlights = highlights;

  factory _$WeeklySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklySummaryImplFromJson(json);

  @override
  final DateTime weekStart;
  @override
  final DateTime weekEnd;
  @override
  final int symptomCount;
  @override
  final double moodAverage;
  final List<String> _highlights;
  @override
  @JsonKey()
  List<String> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  @override
  final String keyInsight;
  @override
  final String? tip;

  @override
  String toString() {
    return 'WeeklySummary(weekStart: $weekStart, weekEnd: $weekEnd, symptomCount: $symptomCount, moodAverage: $moodAverage, highlights: $highlights, keyInsight: $keyInsight, tip: $tip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklySummaryImpl &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd) &&
            (identical(other.symptomCount, symptomCount) ||
                other.symptomCount == symptomCount) &&
            (identical(other.moodAverage, moodAverage) ||
                other.moodAverage == moodAverage) &&
            const DeepCollectionEquality().equals(
              other._highlights,
              _highlights,
            ) &&
            (identical(other.keyInsight, keyInsight) ||
                other.keyInsight == keyInsight) &&
            (identical(other.tip, tip) || other.tip == tip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    weekStart,
    weekEnd,
    symptomCount,
    moodAverage,
    const DeepCollectionEquality().hash(_highlights),
    keyInsight,
    tip,
  );

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklySummaryImplCopyWith<_$WeeklySummaryImpl> get copyWith =>
      __$$WeeklySummaryImplCopyWithImpl<_$WeeklySummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklySummaryImplToJson(this);
  }
}

abstract class _WeeklySummary implements WeeklySummary {
  const factory _WeeklySummary({
    required final DateTime weekStart,
    required final DateTime weekEnd,
    required final int symptomCount,
    required final double moodAverage,
    final List<String> highlights,
    required final String keyInsight,
    final String? tip,
  }) = _$WeeklySummaryImpl;

  factory _WeeklySummary.fromJson(Map<String, dynamic> json) =
      _$WeeklySummaryImpl.fromJson;

  @override
  DateTime get weekStart;
  @override
  DateTime get weekEnd;
  @override
  int get symptomCount;
  @override
  double get moodAverage;
  @override
  List<String> get highlights;
  @override
  String get keyInsight;
  @override
  String? get tip;

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklySummaryImplCopyWith<_$WeeklySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
