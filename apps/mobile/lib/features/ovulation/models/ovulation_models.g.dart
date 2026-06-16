// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ovulation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FertileWindowImpl _$$FertileWindowImplFromJson(Map<String, dynamic> json) =>
    _$FertileWindowImpl(
      windowStart: DateTime.parse(json['windowStart'] as String),
      windowEnd: DateTime.parse(json['windowEnd'] as String),
      ovulationDate: json['ovulationDate'] == null
          ? null
          : DateTime.parse(json['ovulationDate'] as String),
      ovulationProbability:
          (json['ovulationProbability'] as num?)?.toDouble() ?? 0.0,
      isInWindow: json['isInWindow'] as bool? ?? false,
      currentDayOfWindow: (json['currentDayOfWindow'] as num?)?.toInt(),
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$$FertileWindowImplToJson(_$FertileWindowImpl instance) =>
    <String, dynamic>{
      'windowStart': instance.windowStart.toIso8601String(),
      'windowEnd': instance.windowEnd.toIso8601String(),
      'ovulationDate': instance.ovulationDate?.toIso8601String(),
      'ovulationProbability': instance.ovulationProbability,
      'isInWindow': instance.isInWindow,
      'currentDayOfWindow': instance.currentDayOfWindow,
      'explanation': instance.explanation,
    };

_$OvulationResultImpl _$$OvulationResultImplFromJson(
  Map<String, dynamic> json,
) => _$OvulationResultImpl(
  confirmedOvulationDate: json['confirmedOvulationDate'] == null
      ? null
      : DateTime.parse(json['confirmedOvulationDate'] as String),
  estimatedOvulationDate: json['estimatedOvulationDate'] == null
      ? null
      : DateTime.parse(json['estimatedOvulationDate'] as String),
  isConfirmed: json['isConfirmed'] as bool? ?? false,
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  method: json['method'] as String?,
  explanation: json['explanation'] as String?,
);

Map<String, dynamic> _$$OvulationResultImplToJson(
  _$OvulationResultImpl instance,
) => <String, dynamic>{
  'confirmedOvulationDate': instance.confirmedOvulationDate?.toIso8601String(),
  'estimatedOvulationDate': instance.estimatedOvulationDate?.toIso8601String(),
  'isConfirmed': instance.isConfirmed,
  'confidence': instance.confidence,
  'method': instance.method,
  'explanation': instance.explanation,
};

_$ConceptionLikelihoodImpl _$$ConceptionLikelihoodImplFromJson(
  Map<String, dynamic> json,
) => _$ConceptionLikelihoodImpl(
  likelihood: (json['likelihood'] as num?)?.toDouble() ?? 0.0,
  explanation: json['explanation'] as String?,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ConceptionLikelihoodImplToJson(
  _$ConceptionLikelihoodImpl instance,
) => <String, dynamic>{
  'likelihood': instance.likelihood,
  'explanation': instance.explanation,
  'recommendations': instance.recommendations,
};
