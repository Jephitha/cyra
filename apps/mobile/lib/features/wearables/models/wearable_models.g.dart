// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wearable_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WearableDeviceImpl _$$WearableDeviceImplFromJson(Map<String, dynamic> json) =>
    _$WearableDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$WearableTypeEnumMap, json['type']),
      isConnected: json['isConnected'] as bool,
      isEnabled: json['isEnabled'] as bool,
      lastSyncAt: json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
      enabledDataTypes:
          (json['enabledDataTypes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      deviceModel: json['deviceModel'] as String?,
      firmwareVersion: json['firmwareVersion'] as String?,
    );

Map<String, dynamic> _$$WearableDeviceImplToJson(
  _$WearableDeviceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$WearableTypeEnumMap[instance.type]!,
  'isConnected': instance.isConnected,
  'isEnabled': instance.isEnabled,
  'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
  'enabledDataTypes': instance.enabledDataTypes,
  'deviceModel': instance.deviceModel,
  'firmwareVersion': instance.firmwareVersion,
};

const _$WearableTypeEnumMap = {
  WearableType.appleWatch: 'appleWatch',
  WearableType.fitbit: 'fitbit',
  WearableType.garmin: 'garmin',
  WearableType.oura: 'oura',
  WearableType.oneplus: 'oneplus',
  WearableType.oppo: 'oppo',
  WearableType.redmi: 'redmi',
};

_$WearableDataPointImpl _$$WearableDataPointImplFromJson(
  Map<String, dynamic> json,
) => _$WearableDataPointImpl(
  timestamp: DateTime.parse(json['timestamp'] as String),
  value: (json['value'] as num).toDouble(),
  type: json['type'] as String,
  source: json['source'] as String?,
);

Map<String, dynamic> _$$WearableDataPointImplToJson(
  _$WearableDataPointImpl instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp.toIso8601String(),
  'value': instance.value,
  'type': instance.type,
  'source': instance.source,
};

_$WearableSyncStatusImpl _$$WearableSyncStatusImplFromJson(
  Map<String, dynamic> json,
) => _$WearableSyncStatusImpl(
  isSyncing: json['isSyncing'] as bool,
  lastSuccessfulSync: json['lastSuccessfulSync'] == null
      ? null
      : DateTime.parse(json['lastSuccessfulSync'] as String),
  pendingRecords: (json['pendingRecords'] as num).toInt(),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$WearableSyncStatusImplToJson(
  _$WearableSyncStatusImpl instance,
) => <String, dynamic>{
  'isSyncing': instance.isSyncing,
  'lastSuccessfulSync': instance.lastSuccessfulSync?.toIso8601String(),
  'pendingRecords': instance.pendingRecords,
  'errorMessage': instance.errorMessage,
};

_$WearableDataSummaryImpl _$$WearableDataSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$WearableDataSummaryImpl(
  averageTemperature: (json['averageTemperature'] as num).toDouble(),
  averageHeartRate: (json['averageHeartRate'] as num).toDouble(),
  averageSleepHours: (json['averageSleepHours'] as num).toDouble(),
  stepCount: (json['stepCount'] as num).toInt(),
  dataPointCount: (json['dataPointCount'] as num).toInt(),
);

Map<String, dynamic> _$$WearableDataSummaryImplToJson(
  _$WearableDataSummaryImpl instance,
) => <String, dynamic>{
  'averageTemperature': instance.averageTemperature,
  'averageHeartRate': instance.averageHeartRate,
  'averageSleepHours': instance.averageSleepHours,
  'stepCount': instance.stepCount,
  'dataPointCount': instance.dataPointCount,
};
