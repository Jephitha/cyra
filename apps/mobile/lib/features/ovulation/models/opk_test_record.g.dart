// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opk_test_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OPKTestResultImpl _$$OPKTestResultImplFromJson(Map<String, dynamic> json) =>
    _$OPKTestResultImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      result: $enumDecode(_$OPKResultEnumMap, json['result']),
      timeOfDay: json['timeOfDay'] as String?,
      brand: json['brand'] as String?,
      photoPath: json['photoPath'] as String?,
    );

Map<String, dynamic> _$$OPKTestResultImplToJson(_$OPKTestResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'result': _$OPKResultEnumMap[instance.result]!,
      'timeOfDay': instance.timeOfDay,
      'brand': instance.brand,
      'photoPath': instance.photoPath,
    };

const _$OPKResultEnumMap = {
  OPKResult.negative: 'negative',
  OPKResult.positive: 'positive',
  OPKResult.fading: 'fading',
};
