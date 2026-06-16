// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_insights_engine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardInsightsImpl _$$DashboardInsightsImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardInsightsImpl(
  weeklySummary: json['weeklySummary'] as String,
  nextPeriod: PredictionResult.fromJson(
    json['nextPeriod'] as Map<String, dynamic>,
  ),
  currentPhase: $enumDecode(_$CyclePhaseEnumMap, json['currentPhase']),
  regularity: CycleRegularityResult.fromJson(
    json['regularity'] as Map<String, dynamic>,
  ),
  topSymptoms: (json['topSymptoms'] as List<dynamic>)
      .map((e) => ImpactfulSymptom.fromJson(e as Map<String, dynamic>))
      .toList(),
  fertileWindow: json['fertileWindow'] == null
      ? null
      : FertileWindow.fromJson(json['fertileWindow'] as Map<String, dynamic>),
  healthTips: (json['healthTips'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$DashboardInsightsImplToJson(
  _$DashboardInsightsImpl instance,
) => <String, dynamic>{
  'weeklySummary': instance.weeklySummary,
  'nextPeriod': instance.nextPeriod,
  'currentPhase': _$CyclePhaseEnumMap[instance.currentPhase]!,
  'regularity': instance.regularity,
  'topSymptoms': instance.topSymptoms,
  'fertileWindow': instance.fertileWindow,
  'healthTips': instance.healthTips,
};

const _$CyclePhaseEnumMap = {
  CyclePhase.menstrual: 'menstrual',
  CyclePhase.follicular: 'follicular',
  CyclePhase.ovulation: 'ovulation',
  CyclePhase.luteal: 'luteal',
};

_$TopicInsightImpl _$$TopicInsightImplFromJson(Map<String, dynamic> json) =>
    _$TopicInsightImpl(
      topic: $enumDecode(_$InsightTopicEnumMap, json['topic']),
      title: json['title'] as String,
      summary: json['summary'] as String,
      detailedExplanation: json['detailedExplanation'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      relatedTopics: (json['relatedTopics'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requiresDisclaimer: json['requiresDisclaimer'] as bool? ?? false,
    );

Map<String, dynamic> _$$TopicInsightImplToJson(_$TopicInsightImpl instance) =>
    <String, dynamic>{
      'topic': _$InsightTopicEnumMap[instance.topic]!,
      'title': instance.title,
      'summary': instance.summary,
      'detailedExplanation': instance.detailedExplanation,
      'confidence': instance.confidence,
      'relatedTopics': instance.relatedTopics,
      'requiresDisclaimer': instance.requiresDisclaimer,
    };

const _$InsightTopicEnumMap = {
  InsightTopic.periodPrediction: 'periodPrediction',
  InsightTopic.ovulationDetection: 'ovulationDetection',
  InsightTopic.symptomCorrelation: 'symptomCorrelation',
  InsightTopic.cycleRegularity: 'cycleRegularity',
  InsightTopic.fertilityWindow: 'fertilityWindow',
  InsightTopic.conceptionTips: 'conceptionTips',
  InsightTopic.pregnancyMilestone: 'pregnancyMilestone',
};
