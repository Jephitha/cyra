// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIInsightCardImpl _$$AIInsightCardImplFromJson(Map<String, dynamic> json) =>
    _$AIInsightCardImpl(
      title: json['title'] as String,
      summary: json['summary'] as String,
      iconName: json['iconName'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
      topic: $enumDecode(_$InsightTopicEnumMap, json['topic']),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      disclaimer: json['disclaimer'] as String?,
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$$AIInsightCardImplToJson(_$AIInsightCardImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'summary': instance.summary,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'topic': _$InsightTopicEnumMap[instance.topic]!,
      'confidence': instance.confidence,
      'disclaimer': instance.disclaimer,
      'isLoading': instance.isLoading,
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

_$WeeklySummaryImpl _$$WeeklySummaryImplFromJson(Map<String, dynamic> json) =>
    _$WeeklySummaryImpl(
      weekStart: DateTime.parse(json['weekStart'] as String),
      weekEnd: DateTime.parse(json['weekEnd'] as String),
      symptomCount: (json['symptomCount'] as num).toInt(),
      moodAverage: (json['moodAverage'] as num).toDouble(),
      highlights:
          (json['highlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      keyInsight: json['keyInsight'] as String,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$$WeeklySummaryImplToJson(_$WeeklySummaryImpl instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'weekEnd': instance.weekEnd.toIso8601String(),
      'symptomCount': instance.symptomCount,
      'moodAverage': instance.moodAverage,
      'highlights': instance.highlights,
      'keyInsight': instance.keyInsight,
      'tip': instance.tip,
    };
