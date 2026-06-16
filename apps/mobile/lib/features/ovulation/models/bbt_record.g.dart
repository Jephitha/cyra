// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbt_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BBTRecordImpl _$$BBTRecordImplFromJson(Map<String, dynamic> json) =>
    _$BBTRecordImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      method:
          $enumDecodeNullable(_$BBTMeasurementMethodEnumMap, json['method']) ??
          BBTMeasurementMethod.oral,
      timeOfDay: json['timeOfDay'] as String?,
      isEstimated: json['isEstimated'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$BBTRecordImplToJson(_$BBTRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'temperature': instance.temperature,
      'method': _$BBTMeasurementMethodEnumMap[instance.method]!,
      'timeOfDay': instance.timeOfDay,
      'isEstimated': instance.isEstimated,
      'notes': instance.notes,
    };

const _$BBTMeasurementMethodEnumMap = {
  BBTMeasurementMethod.oral: 'oral',
  BBTMeasurementMethod.vaginal: 'vaginal',
  BBTMeasurementMethod.armpit: 'armpit',
  BBTMeasurementMethod.wearable: 'wearable',
};
