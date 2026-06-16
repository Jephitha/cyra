// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mucus_observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MucusObservationImpl _$$MucusObservationImplFromJson(
  Map<String, dynamic> json,
) => _$MucusObservationImpl(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$CervicalMucusTypeEnumMap, json['type']),
  consistency: json['consistency'] as String?,
  color: json['color'] as String?,
  amount: json['amount'] as String?,
);

Map<String, dynamic> _$$MucusObservationImplToJson(
  _$MucusObservationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'type': _$CervicalMucusTypeEnumMap[instance.type]!,
  'consistency': instance.consistency,
  'color': instance.color,
  'amount': instance.amount,
};

const _$CervicalMucusTypeEnumMap = {
  CervicalMucusType.dry: 'dry',
  CervicalMucusType.sticky: 'sticky',
  CervicalMucusType.creamy: 'creamy',
  CervicalMucusType.eggWhite: 'eggWhite',
  CervicalMucusType.watery: 'watery',
};
