// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_insights_engine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardInsights _$DashboardInsightsFromJson(Map<String, dynamic> json) {
  return _DashboardInsights.fromJson(json);
}

/// @nodoc
mixin _$DashboardInsights {
  String get weeklySummary => throw _privateConstructorUsedError;
  PredictionResult get nextPeriod => throw _privateConstructorUsedError;
  CyclePhase get currentPhase => throw _privateConstructorUsedError;
  CycleRegularityResult get regularity => throw _privateConstructorUsedError;
  List<ImpactfulSymptom> get topSymptoms => throw _privateConstructorUsedError;
  FertileWindow? get fertileWindow => throw _privateConstructorUsedError;
  List<String>? get healthTips => throw _privateConstructorUsedError;

  /// Serializes this DashboardInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardInsightsCopyWith<DashboardInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardInsightsCopyWith<$Res> {
  factory $DashboardInsightsCopyWith(
    DashboardInsights value,
    $Res Function(DashboardInsights) then,
  ) = _$DashboardInsightsCopyWithImpl<$Res, DashboardInsights>;
  @useResult
  $Res call({
    String weeklySummary,
    PredictionResult nextPeriod,
    CyclePhase currentPhase,
    CycleRegularityResult regularity,
    List<ImpactfulSymptom> topSymptoms,
    FertileWindow? fertileWindow,
    List<String>? healthTips,
  });

  $PredictionResultCopyWith<$Res> get nextPeriod;
  $CycleRegularityResultCopyWith<$Res> get regularity;
  $FertileWindowCopyWith<$Res>? get fertileWindow;
}

/// @nodoc
class _$DashboardInsightsCopyWithImpl<$Res, $Val extends DashboardInsights>
    implements $DashboardInsightsCopyWith<$Res> {
  _$DashboardInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklySummary = null,
    Object? nextPeriod = null,
    Object? currentPhase = null,
    Object? regularity = null,
    Object? topSymptoms = null,
    Object? fertileWindow = freezed,
    Object? healthTips = freezed,
  }) {
    return _then(
      _value.copyWith(
            weeklySummary: null == weeklySummary
                ? _value.weeklySummary
                : weeklySummary // ignore: cast_nullable_to_non_nullable
                      as String,
            nextPeriod: null == nextPeriod
                ? _value.nextPeriod
                : nextPeriod // ignore: cast_nullable_to_non_nullable
                      as PredictionResult,
            currentPhase: null == currentPhase
                ? _value.currentPhase
                : currentPhase // ignore: cast_nullable_to_non_nullable
                      as CyclePhase,
            regularity: null == regularity
                ? _value.regularity
                : regularity // ignore: cast_nullable_to_non_nullable
                      as CycleRegularityResult,
            topSymptoms: null == topSymptoms
                ? _value.topSymptoms
                : topSymptoms // ignore: cast_nullable_to_non_nullable
                      as List<ImpactfulSymptom>,
            fertileWindow: freezed == fertileWindow
                ? _value.fertileWindow
                : fertileWindow // ignore: cast_nullable_to_non_nullable
                      as FertileWindow?,
            healthTips: freezed == healthTips
                ? _value.healthTips
                : healthTips // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PredictionResultCopyWith<$Res> get nextPeriod {
    return $PredictionResultCopyWith<$Res>(_value.nextPeriod, (value) {
      return _then(_value.copyWith(nextPeriod: value) as $Val);
    });
  }

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CycleRegularityResultCopyWith<$Res> get regularity {
    return $CycleRegularityResultCopyWith<$Res>(_value.regularity, (value) {
      return _then(_value.copyWith(regularity: value) as $Val);
    });
  }

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FertileWindowCopyWith<$Res>? get fertileWindow {
    if (_value.fertileWindow == null) {
      return null;
    }

    return $FertileWindowCopyWith<$Res>(_value.fertileWindow!, (value) {
      return _then(_value.copyWith(fertileWindow: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardInsightsImplCopyWith<$Res>
    implements $DashboardInsightsCopyWith<$Res> {
  factory _$$DashboardInsightsImplCopyWith(
    _$DashboardInsightsImpl value,
    $Res Function(_$DashboardInsightsImpl) then,
  ) = __$$DashboardInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String weeklySummary,
    PredictionResult nextPeriod,
    CyclePhase currentPhase,
    CycleRegularityResult regularity,
    List<ImpactfulSymptom> topSymptoms,
    FertileWindow? fertileWindow,
    List<String>? healthTips,
  });

  @override
  $PredictionResultCopyWith<$Res> get nextPeriod;
  @override
  $CycleRegularityResultCopyWith<$Res> get regularity;
  @override
  $FertileWindowCopyWith<$Res>? get fertileWindow;
}

/// @nodoc
class __$$DashboardInsightsImplCopyWithImpl<$Res>
    extends _$DashboardInsightsCopyWithImpl<$Res, _$DashboardInsightsImpl>
    implements _$$DashboardInsightsImplCopyWith<$Res> {
  __$$DashboardInsightsImplCopyWithImpl(
    _$DashboardInsightsImpl _value,
    $Res Function(_$DashboardInsightsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklySummary = null,
    Object? nextPeriod = null,
    Object? currentPhase = null,
    Object? regularity = null,
    Object? topSymptoms = null,
    Object? fertileWindow = freezed,
    Object? healthTips = freezed,
  }) {
    return _then(
      _$DashboardInsightsImpl(
        weeklySummary: null == weeklySummary
            ? _value.weeklySummary
            : weeklySummary // ignore: cast_nullable_to_non_nullable
                  as String,
        nextPeriod: null == nextPeriod
            ? _value.nextPeriod
            : nextPeriod // ignore: cast_nullable_to_non_nullable
                  as PredictionResult,
        currentPhase: null == currentPhase
            ? _value.currentPhase
            : currentPhase // ignore: cast_nullable_to_non_nullable
                  as CyclePhase,
        regularity: null == regularity
            ? _value.regularity
            : regularity // ignore: cast_nullable_to_non_nullable
                  as CycleRegularityResult,
        topSymptoms: null == topSymptoms
            ? _value._topSymptoms
            : topSymptoms // ignore: cast_nullable_to_non_nullable
                  as List<ImpactfulSymptom>,
        fertileWindow: freezed == fertileWindow
            ? _value.fertileWindow
            : fertileWindow // ignore: cast_nullable_to_non_nullable
                  as FertileWindow?,
        healthTips: freezed == healthTips
            ? _value._healthTips
            : healthTips // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardInsightsImpl implements _DashboardInsights {
  const _$DashboardInsightsImpl({
    required this.weeklySummary,
    required this.nextPeriod,
    required this.currentPhase,
    required this.regularity,
    required final List<ImpactfulSymptom> topSymptoms,
    this.fertileWindow,
    final List<String>? healthTips,
  }) : _topSymptoms = topSymptoms,
       _healthTips = healthTips;

  factory _$DashboardInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardInsightsImplFromJson(json);

  @override
  final String weeklySummary;
  @override
  final PredictionResult nextPeriod;
  @override
  final CyclePhase currentPhase;
  @override
  final CycleRegularityResult regularity;
  final List<ImpactfulSymptom> _topSymptoms;
  @override
  List<ImpactfulSymptom> get topSymptoms {
    if (_topSymptoms is EqualUnmodifiableListView) return _topSymptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSymptoms);
  }

  @override
  final FertileWindow? fertileWindow;
  final List<String>? _healthTips;
  @override
  List<String>? get healthTips {
    final value = _healthTips;
    if (value == null) return null;
    if (_healthTips is EqualUnmodifiableListView) return _healthTips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'DashboardInsights(weeklySummary: $weeklySummary, nextPeriod: $nextPeriod, currentPhase: $currentPhase, regularity: $regularity, topSymptoms: $topSymptoms, fertileWindow: $fertileWindow, healthTips: $healthTips)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardInsightsImpl &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary) &&
            (identical(other.nextPeriod, nextPeriod) ||
                other.nextPeriod == nextPeriod) &&
            (identical(other.currentPhase, currentPhase) ||
                other.currentPhase == currentPhase) &&
            (identical(other.regularity, regularity) ||
                other.regularity == regularity) &&
            const DeepCollectionEquality().equals(
              other._topSymptoms,
              _topSymptoms,
            ) &&
            (identical(other.fertileWindow, fertileWindow) ||
                other.fertileWindow == fertileWindow) &&
            const DeepCollectionEquality().equals(
              other._healthTips,
              _healthTips,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    weeklySummary,
    nextPeriod,
    currentPhase,
    regularity,
    const DeepCollectionEquality().hash(_topSymptoms),
    fertileWindow,
    const DeepCollectionEquality().hash(_healthTips),
  );

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardInsightsImplCopyWith<_$DashboardInsightsImpl> get copyWith =>
      __$$DashboardInsightsImplCopyWithImpl<_$DashboardInsightsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardInsightsImplToJson(this);
  }
}

abstract class _DashboardInsights implements DashboardInsights {
  const factory _DashboardInsights({
    required final String weeklySummary,
    required final PredictionResult nextPeriod,
    required final CyclePhase currentPhase,
    required final CycleRegularityResult regularity,
    required final List<ImpactfulSymptom> topSymptoms,
    final FertileWindow? fertileWindow,
    final List<String>? healthTips,
  }) = _$DashboardInsightsImpl;

  factory _DashboardInsights.fromJson(Map<String, dynamic> json) =
      _$DashboardInsightsImpl.fromJson;

  @override
  String get weeklySummary;
  @override
  PredictionResult get nextPeriod;
  @override
  CyclePhase get currentPhase;
  @override
  CycleRegularityResult get regularity;
  @override
  List<ImpactfulSymptom> get topSymptoms;
  @override
  FertileWindow? get fertileWindow;
  @override
  List<String>? get healthTips;

  /// Create a copy of DashboardInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardInsightsImplCopyWith<_$DashboardInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicInsight _$TopicInsightFromJson(Map<String, dynamic> json) {
  return _TopicInsight.fromJson(json);
}

/// @nodoc
mixin _$TopicInsight {
  InsightTopic get topic => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get detailedExplanation => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  List<String>? get relatedTopics => throw _privateConstructorUsedError;
  bool get requiresDisclaimer => throw _privateConstructorUsedError;

  /// Serializes this TopicInsight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicInsightCopyWith<TopicInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicInsightCopyWith<$Res> {
  factory $TopicInsightCopyWith(
    TopicInsight value,
    $Res Function(TopicInsight) then,
  ) = _$TopicInsightCopyWithImpl<$Res, TopicInsight>;
  @useResult
  $Res call({
    InsightTopic topic,
    String title,
    String summary,
    String detailedExplanation,
    double confidence,
    List<String>? relatedTopics,
    bool requiresDisclaimer,
  });
}

/// @nodoc
class _$TopicInsightCopyWithImpl<$Res, $Val extends TopicInsight>
    implements $TopicInsightCopyWith<$Res> {
  _$TopicInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? title = null,
    Object? summary = null,
    Object? detailedExplanation = null,
    Object? confidence = null,
    Object? relatedTopics = freezed,
    Object? requiresDisclaimer = null,
  }) {
    return _then(
      _value.copyWith(
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as InsightTopic,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            detailedExplanation: null == detailedExplanation
                ? _value.detailedExplanation
                : detailedExplanation // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            relatedTopics: freezed == relatedTopics
                ? _value.relatedTopics
                : relatedTopics // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            requiresDisclaimer: null == requiresDisclaimer
                ? _value.requiresDisclaimer
                : requiresDisclaimer // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopicInsightImplCopyWith<$Res>
    implements $TopicInsightCopyWith<$Res> {
  factory _$$TopicInsightImplCopyWith(
    _$TopicInsightImpl value,
    $Res Function(_$TopicInsightImpl) then,
  ) = __$$TopicInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    InsightTopic topic,
    String title,
    String summary,
    String detailedExplanation,
    double confidence,
    List<String>? relatedTopics,
    bool requiresDisclaimer,
  });
}

/// @nodoc
class __$$TopicInsightImplCopyWithImpl<$Res>
    extends _$TopicInsightCopyWithImpl<$Res, _$TopicInsightImpl>
    implements _$$TopicInsightImplCopyWith<$Res> {
  __$$TopicInsightImplCopyWithImpl(
    _$TopicInsightImpl _value,
    $Res Function(_$TopicInsightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopicInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? title = null,
    Object? summary = null,
    Object? detailedExplanation = null,
    Object? confidence = null,
    Object? relatedTopics = freezed,
    Object? requiresDisclaimer = null,
  }) {
    return _then(
      _$TopicInsightImpl(
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as InsightTopic,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        detailedExplanation: null == detailedExplanation
            ? _value.detailedExplanation
            : detailedExplanation // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        relatedTopics: freezed == relatedTopics
            ? _value._relatedTopics
            : relatedTopics // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        requiresDisclaimer: null == requiresDisclaimer
            ? _value.requiresDisclaimer
            : requiresDisclaimer // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicInsightImpl implements _TopicInsight {
  const _$TopicInsightImpl({
    required this.topic,
    required this.title,
    required this.summary,
    required this.detailedExplanation,
    required this.confidence,
    final List<String>? relatedTopics,
    this.requiresDisclaimer = false,
  }) : _relatedTopics = relatedTopics;

  factory _$TopicInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicInsightImplFromJson(json);

  @override
  final InsightTopic topic;
  @override
  final String title;
  @override
  final String summary;
  @override
  final String detailedExplanation;
  @override
  final double confidence;
  final List<String>? _relatedTopics;
  @override
  List<String>? get relatedTopics {
    final value = _relatedTopics;
    if (value == null) return null;
    if (_relatedTopics is EqualUnmodifiableListView) return _relatedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool requiresDisclaimer;

  @override
  String toString() {
    return 'TopicInsight(topic: $topic, title: $title, summary: $summary, detailedExplanation: $detailedExplanation, confidence: $confidence, relatedTopics: $relatedTopics, requiresDisclaimer: $requiresDisclaimer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicInsightImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.detailedExplanation, detailedExplanation) ||
                other.detailedExplanation == detailedExplanation) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(
              other._relatedTopics,
              _relatedTopics,
            ) &&
            (identical(other.requiresDisclaimer, requiresDisclaimer) ||
                other.requiresDisclaimer == requiresDisclaimer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    topic,
    title,
    summary,
    detailedExplanation,
    confidence,
    const DeepCollectionEquality().hash(_relatedTopics),
    requiresDisclaimer,
  );

  /// Create a copy of TopicInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicInsightImplCopyWith<_$TopicInsightImpl> get copyWith =>
      __$$TopicInsightImplCopyWithImpl<_$TopicInsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicInsightImplToJson(this);
  }
}

abstract class _TopicInsight implements TopicInsight {
  const factory _TopicInsight({
    required final InsightTopic topic,
    required final String title,
    required final String summary,
    required final String detailedExplanation,
    required final double confidence,
    final List<String>? relatedTopics,
    final bool requiresDisclaimer,
  }) = _$TopicInsightImpl;

  factory _TopicInsight.fromJson(Map<String, dynamic> json) =
      _$TopicInsightImpl.fromJson;

  @override
  InsightTopic get topic;
  @override
  String get title;
  @override
  String get summary;
  @override
  String get detailedExplanation;
  @override
  double get confidence;
  @override
  List<String>? get relatedTopics;
  @override
  bool get requiresDisclaimer;

  /// Create a copy of TopicInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicInsightImplCopyWith<_$TopicInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
