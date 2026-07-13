import 'package:freezed_annotation/freezed_annotation.dart';

part 'wearable_models.freezed.dart';
part 'wearable_models.g.dart';

enum WearableType {
  healthConnect,
  appleWatch,
  fitbit,
  garmin,
  oura,
  oneplus,
  oppo,
  redmi,
}

extension WearableTypeX on WearableType {
  String get displayName {
    switch (this) {
      case WearableType.healthConnect:
        return 'Health Connect';
      case WearableType.appleWatch:
        return 'Apple Watch';
      case WearableType.fitbit:
        return 'Fitbit';
      case WearableType.garmin:
        return 'Garmin';
      case WearableType.oura:
        return 'Oura Ring';
      case WearableType.oneplus:
        return 'OnePlus Watch';
      case WearableType.oppo:
        return 'Oppo Watch';
      case WearableType.redmi:
        return 'Redmi Watch';
    }
  }

  String get description {
    switch (this) {
      case WearableType.healthConnect:
        return 'Temperature, heart rate, HRV, and sleep from connected apps and devices';
      case WearableType.appleWatch:
        return 'Temperature, heart rate, sleep, and activity tracking';
      case WearableType.fitbit:
        return 'Sleep stages, heart rate, and activity data';
      case WearableType.garmin:
        return 'Advanced sleep tracking, HRV, and body temperature';
      case WearableType.oura:
        return 'Nightly temperature, sleep, HRV, and readiness data';
      case WearableType.oneplus:
        return 'Heart rate, sleep, and blood oxygen tracking';
      case WearableType.oppo:
        return 'Sleep analysis, heart rate, and activity tracking';
      case WearableType.redmi:
        return 'Heart rate, sleep, and step counting';
    }
  }
}

@freezed
class WearableDevice with _$WearableDevice {
  const factory WearableDevice({
    required String id,
    required String name,
    required WearableType type,
    required bool isConnected,
    required bool isEnabled,
    DateTime? lastSyncAt,
    @Default({}) Map<String, bool> enabledDataTypes,
    String? deviceModel,
    String? firmwareVersion,
  }) = _WearableDevice;

  factory WearableDevice.fromJson(Map<String, dynamic> json) =>
      _$WearableDeviceFromJson(json);
}

@freezed
class WearableDataPoint with _$WearableDataPoint {
  const factory WearableDataPoint({
    required DateTime timestamp,
    required double value,
    required String type,
    String? source,
    String? externalId,
  }) = _WearableDataPoint;

  factory WearableDataPoint.fromJson(Map<String, dynamic> json) =>
      _$WearableDataPointFromJson(json);
}

@freezed
class WearableSyncStatus with _$WearableSyncStatus {
  const factory WearableSyncStatus({
    required bool isSyncing,
    required DateTime? lastSuccessfulSync,
    required int pendingRecords,
    String? errorMessage,
  }) = _WearableSyncStatus;

  factory WearableSyncStatus.fromJson(Map<String, dynamic> json) =>
      _$WearableSyncStatusFromJson(json);
}

@freezed
class WearableDataSummary with _$WearableDataSummary {
  const factory WearableDataSummary({
    required double averageTemperature,
    required double averageHeartRate,
    required double averageSleepHours,
    @Default(0.0) double averageHrv,
    required int stepCount,
    required int dataPointCount,
  }) = _WearableDataSummary;

  factory WearableDataSummary.fromJson(Map<String, dynamic> json) =>
      _$WearableDataSummaryFromJson(json);
}
