// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fertility_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntercourseLogImpl _$$IntercourseLogImplFromJson(Map<String, dynamic> json) =>
    _$IntercourseLogImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      unprotected: json['unprotected'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$IntercourseLogImplToJson(
  _$IntercourseLogImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'unprotected': instance.unprotected,
  'notes': instance.notes,
};

_$FertilityStatusImpl _$$FertilityStatusImplFromJson(
  Map<String, dynamic> json,
) => _$FertilityStatusImpl(
  cycleDay: (json['cycleDay'] as num).toInt(),
  dayType: $enumDecode(_$FertilityDayTypeEnumMap, json['dayType']),
  conceptionProbability:
      (json['conceptionProbability'] as num?)?.toDouble() ?? 0.0,
  recommendation: json['recommendation'] as String?,
  explanation: json['explanation'] as String?,
);

Map<String, dynamic> _$$FertilityStatusImplToJson(
  _$FertilityStatusImpl instance,
) => <String, dynamic>{
  'cycleDay': instance.cycleDay,
  'dayType': _$FertilityDayTypeEnumMap[instance.dayType]!,
  'conceptionProbability': instance.conceptionProbability,
  'recommendation': instance.recommendation,
  'explanation': instance.explanation,
};

const _$FertilityDayTypeEnumMap = {
  FertilityDayType.period: 'period',
  FertilityDayType.notFertile: 'notFertile',
  FertilityDayType.transitioning: 'transitioning',
  FertilityDayType.fertile: 'fertile',
  FertilityDayType.peakFertile: 'peakFertile',
  FertilityDayType.ovulation: 'ovulation',
  FertilityDayType.postOvulation: 'postOvulation',
  FertilityDayType.unknown: 'unknown',
};
