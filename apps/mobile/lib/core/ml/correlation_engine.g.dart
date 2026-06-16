// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correlation_engine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CorrelationResultImpl _$$CorrelationResultImplFromJson(
  Map<String, dynamic> json,
) => _$CorrelationResultImpl(
  featureA: json['featureA'] as String,
  featureB: json['featureB'] as String,
  correlationCoefficient: (json['correlationCoefficient'] as num).toDouble(),
  isSignificant: json['isSignificant'] as bool,
  mostCommonPhase: json['mostCommonPhase'] as String? ?? '',
  explanation: json['explanation'] as String? ?? '',
);

Map<String, dynamic> _$$CorrelationResultImplToJson(
  _$CorrelationResultImpl instance,
) => <String, dynamic>{
  'featureA': instance.featureA,
  'featureB': instance.featureB,
  'correlationCoefficient': instance.correlationCoefficient,
  'isSignificant': instance.isSignificant,
  'mostCommonPhase': instance.mostCommonPhase,
  'explanation': instance.explanation,
};

_$CycleRegularityResultImpl _$$CycleRegularityResultImplFromJson(
  Map<String, dynamic> json,
) => _$CycleRegularityResultImpl(
  regularity: $enumDecode(_$CycleRegularityEnumMap, json['regularity']),
  coefficientOfVariation: (json['coefficientOfVariation'] as num).toDouble(),
  standardDeviation: (json['standardDeviation'] as num).toDouble(),
  trend: json['trend'] as String?,
  explanation: json['explanation'] as String?,
);

Map<String, dynamic> _$$CycleRegularityResultImplToJson(
  _$CycleRegularityResultImpl instance,
) => <String, dynamic>{
  'regularity': _$CycleRegularityEnumMap[instance.regularity]!,
  'coefficientOfVariation': instance.coefficientOfVariation,
  'standardDeviation': instance.standardDeviation,
  'trend': instance.trend,
  'explanation': instance.explanation,
};

const _$CycleRegularityEnumMap = {
  CycleRegularity.regular: 'regular',
  CycleRegularity.slightlyIrregular: 'slightlyIrregular',
  CycleRegularity.irregular: 'irregular',
};

_$SeverityTrendImpl _$$SeverityTrendImplFromJson(Map<String, dynamic> json) =>
    _$SeverityTrendImpl(
      direction: $enumDecode(_$TrendDirectionEnumMap, json['direction']),
      slope: (json['slope'] as num).toDouble(),
    );

Map<String, dynamic> _$$SeverityTrendImplToJson(_$SeverityTrendImpl instance) =>
    <String, dynamic>{
      'direction': _$TrendDirectionEnumMap[instance.direction]!,
      'slope': instance.slope,
    };

const _$TrendDirectionEnumMap = {
  TrendDirection.improving: 'improving',
  TrendDirection.worsening: 'worsening',
  TrendDirection.stable: 'stable',
};

_$ImpactfulSymptomImpl _$$ImpactfulSymptomImplFromJson(
  Map<String, dynamic> json,
) => _$ImpactfulSymptomImpl(
  symptomId: json['symptomId'] as String,
  symptomName: json['symptomName'] as String,
  impactScore: (json['impactScore'] as num).toDouble(),
  frequency: (json['frequency'] as num).toInt(),
  averageSeverity: (json['averageSeverity'] as num).toDouble(),
  insight: json['insight'] as String? ?? '',
);

Map<String, dynamic> _$$ImpactfulSymptomImplToJson(
  _$ImpactfulSymptomImpl instance,
) => <String, dynamic>{
  'symptomId': instance.symptomId,
  'symptomName': instance.symptomName,
  'impactScore': instance.impactScore,
  'frequency': instance.frequency,
  'averageSeverity': instance.averageSeverity,
  'insight': instance.insight,
};
