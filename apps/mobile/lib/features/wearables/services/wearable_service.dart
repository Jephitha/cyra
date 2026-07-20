import 'dart:async';

import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';

class WearableService {
  final _syncStatusController =
      StreamController<WearableSyncStatus>.broadcast();

  String get platformSourceId => 'wearables_future_feature';

  Stream<WearableSyncStatus> get syncStatusStream =>
      _syncStatusController.stream;

  Future<List<WearableDevice>> getAvailableDevices() async => const [];

  Future<List<WearableDevice>> getConnectedDevices() async => const [];

  Future<bool> connect(WearableType type) async {
    _syncStatusController.add(
      const WearableSyncStatus(
        isSyncing: false,
        lastSuccessfulSync: null,
        pendingRecords: 0,
        errorMessage: 'Wearable sync is planned as a future feature.',
      ),
    );
    return false;
  }

  Future<void> disconnect(String deviceId) async {}

  Future<void> enableDataType(String deviceId, String dataType) async {
    _syncStatusController.add(
      const WearableSyncStatus(
        isSyncing: false,
        lastSuccessfulSync: null,
        pendingRecords: 0,
        errorMessage: 'Wearable sync is planned as a future feature.',
      ),
    );
  }

  Future<void> syncData(String deviceId) async {
    _syncStatusController.add(
      const WearableSyncStatus(
        isSyncing: false,
        lastSuccessfulSync: null,
        pendingRecords: 0,
        errorMessage: 'Wearable sync is planned as a future feature.',
      ),
    );
  }

  Future<void> syncAllDevices() async {}

  Future<List<WearableDataPoint>> getTemperatureData(
    DateTime from,
    DateTime to,
  ) async {
    return const [];
  }

  BBTRecord mapToBBTRecord(WearableDataPoint point) {
    return BBTRecord(
      id: point.externalId ?? 'wearable-${point.timestamp.toIso8601String()}',
      date: point.timestamp,
      temperature: point.value,
      method: BBTMeasurementMethod.wearable,
      isEstimated: true,
      notes: 'Imported from wearable source',
    );
  }

  Future<WearableDataSummary> getDataSummary(
    String deviceId, {
    int days = 7,
  }) async {
    return const WearableDataSummary(
      averageTemperature: 0,
      averageHeartRate: 0,
      averageSleepHours: 0,
      averageHrv: 0,
      stepCount: 0,
      dataPointCount: 0,
    );
  }

  void dispose() {
    unawaited(_syncStatusController.close());
  }
}
