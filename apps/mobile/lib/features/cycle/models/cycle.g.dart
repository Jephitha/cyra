// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CycleImpl _$$CycleImplFromJson(Map<String, dynamic> json) => _$CycleImpl(
  id: json['id'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  cycleLength: (json['cycleLength'] as num?)?.toInt() ?? 28,
  periodLength: (json['periodLength'] as num?)?.toInt() ?? 5,
  notes: json['notes'] as String?,
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => CycleDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CycleImplToJson(_$CycleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'cycleLength': instance.cycleLength,
      'periodLength': instance.periodLength,
      'notes': instance.notes,
      'days': instance.days,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CycleDayImpl _$$CycleDayImplFromJson(Map<String, dynamic> json) =>
    _$CycleDayImpl(
      id: json['id'] as String,
      cycleId: json['cycleId'] as String,
      date: DateTime.parse(json['date'] as String),
      flowIntensity: (json['flowIntensity'] as num?)?.toInt() ?? 0,
      spotting: json['spotting'] as bool? ?? false,
      clotting: json['clotting'] as bool? ?? false,
      symptomsJson: json['symptomsJson'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      cervicalMucus: json['cervicalMucus'] as String?,
      cervicalPosition: json['cervicalPosition'] as String?,
      opkResult: json['opkResult'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CycleDayImplToJson(_$CycleDayImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycleId': instance.cycleId,
      'date': instance.date.toIso8601String(),
      'flowIntensity': instance.flowIntensity,
      'spotting': instance.spotting,
      'clotting': instance.clotting,
      'symptomsJson': instance.symptomsJson,
      'temperature': instance.temperature,
      'cervicalMucus': instance.cervicalMucus,
      'cervicalPosition': instance.cervicalPosition,
      'opkResult': instance.opkResult,
      'notes': instance.notes,
    };

_$CycleSummaryImpl _$$CycleSummaryImplFromJson(Map<String, dynamic> json) =>
    _$CycleSummaryImpl(
      cycleCount: (json['cycleCount'] as num).toInt(),
      averageLength: (json['averageLength'] as num).toDouble(),
      minLength: (json['minLength'] as num).toInt(),
      maxLength: (json['maxLength'] as num).toInt(),
      variabilityScore: (json['variabilityScore'] as num).toDouble(),
      averagePeriodLength: (json['averagePeriodLength'] as num).toDouble(),
      lastPeriodStart: json['lastPeriodStart'] == null
          ? null
          : DateTime.parse(json['lastPeriodStart'] as String),
      nextPredictedPeriodStart: json['nextPredictedPeriodStart'] == null
          ? null
          : DateTime.parse(json['nextPredictedPeriodStart'] as String),
    );

Map<String, dynamic> _$$CycleSummaryImplToJson(_$CycleSummaryImpl instance) =>
    <String, dynamic>{
      'cycleCount': instance.cycleCount,
      'averageLength': instance.averageLength,
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'variabilityScore': instance.variabilityScore,
      'averagePeriodLength': instance.averagePeriodLength,
      'lastPeriodStart': instance.lastPeriodStart?.toIso8601String(),
      'nextPredictedPeriodStart': instance.nextPredictedPeriodStart
          ?.toIso8601String(),
    };

_$PredictionResultImpl _$$PredictionResultImplFromJson(
  Map<String, dynamic> json,
) => _$PredictionResultImpl(
  predictedDate: DateTime.parse(json['predictedDate'] as String),
  confidenceScore: (json['confidenceScore'] as num).toDouble(),
  variabilityScore: (json['variabilityScore'] as num).toDouble(),
  predictionRangeStart: DateTime.parse(json['predictionRangeStart'] as String),
  predictionRangeEnd: DateTime.parse(json['predictionRangeEnd'] as String),
  explanation: json['explanation'] as String,
);

Map<String, dynamic> _$$PredictionResultImplToJson(
  _$PredictionResultImpl instance,
) => <String, dynamic>{
  'predictedDate': instance.predictedDate.toIso8601String(),
  'confidenceScore': instance.confidenceScore,
  'variabilityScore': instance.variabilityScore,
  'predictionRangeStart': instance.predictionRangeStart.toIso8601String(),
  'predictionRangeEnd': instance.predictionRangeEnd.toIso8601String(),
  'explanation': instance.explanation,
};
