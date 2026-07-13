import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:health/health.dart';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';

class WearableService {
  final AppDatabase _db;
  final EncryptionService _encryption;
  final Health _health;

  bool _healthInitialized = false;
  final _syncStatusController = StreamController<WearableSyncStatus>.broadcast();
  final List<WearableDevice> _devices = [];

  Stream<WearableSyncStatus> get syncStatusStream => _syncStatusController.stream;
  String get platformSourceId => Platform.isIOS ? 'apple_health' : 'health_connect';

  WearableService(this._db, this._encryption, {Health? health})
      : _health = health ?? Health();

  Future<List<WearableDevice>> getAvailableDevices() async {
    await _ensureHealthInitialized();
    return List.unmodifiable(_devices);
  }

  Future<List<WearableDevice>> getConnectedDevices() async {
    await _ensureHealthInitialized();
    return _devices.where((d) => d.isConnected).toList();
  }

  Future<void> _ensureHealthInitialized() async {
    if (_healthInitialized) return;
    await _health.configure();
    await _discoverDevices();
    _healthInitialized = true;
  }

  Future<void> _discoverDevices() async {
    _devices.clear();
    final id = platformSourceId;
    final row = await (_db.select(_db.wearableSources)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    WearableDevice? saved;
    if (row?.settingsJson != null) {
      try {
        saved = WearableDevice.fromJson(
          jsonDecode(_encryption.decryptString(row!.settingsJson!))
              as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    _devices.add(
      saved ??
          WearableDevice(
            id: id,
            name: Platform.isIOS ? 'Apple Health' : 'Health Connect',
            type: Platform.isIOS
                ? WearableType.appleWatch
                : WearableType.healthConnect,
            isConnected: false,
            isEnabled: false,
            enabledDataTypes: const {
              'temperature': true,
              'heartRate': true,
              'hrv': true,
              'sleep': true,
            },
          ),
    );
  }

  Future<bool> connect(WearableType type) async {
    _updateSyncStatus(isSyncing: true);

    try {
      final index = _devices.indexWhere((d) => d.type == type);
      if (index == -1) return false;

      final authorized = await _health.requestAuthorization(_healthTypes);
      if (!authorized) {
        _updateSyncStatus(
          isSyncing: false,
          errorMessage: 'Health data permission was not granted.',
        );
        return false;
      }

      final device = _devices[index];
      _devices[index] = device.copyWith(
        isConnected: true,
        isEnabled: true,
        lastSyncAt: DateTime.now(),
      );

      await _persistDevice(_devices[index]);
      await _doSync(_devices[index]);
      _updateSyncStatus(isSyncing: false);
      return true;
    } catch (e) {
      _updateSyncStatus(isSyncing: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> disconnect(String deviceId) async {
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index == -1) return;

    _devices[index] = _devices[index].copyWith(
      isConnected: false,
      isEnabled: false,
    );

    await _persistDevice(_devices[index]);
  }

  Future<void> syncData(String deviceId) async {
    final device = _devices.firstWhere((d) => d.id == deviceId);
    if (!device.isConnected) return;

    _updateSyncStatus(isSyncing: true);

    try {
      await _doSync(device);
      _updateSyncStatus(isSyncing: false, lastSync: DateTime.now());
    } catch (e) {
      _updateSyncStatus(isSyncing: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> syncAllDevices() async {
    await _ensureHealthInitialized();
    final connected = _devices.where((d) => d.isConnected).toList();
    if (connected.isEmpty) return;

    _updateSyncStatus(isSyncing: true);

    try {
      for (final device in connected) {
        await _doSync(device);
      }
      _updateSyncStatus(isSyncing: false, lastSync: DateTime.now());
    } catch (e) {
      _updateSyncStatus(isSyncing: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> _doSync(WearableDevice device) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    if (device.enabledDataTypes['temperature'] == true) {
      await _syncTemperature(device.id, sevenDaysAgo, now);
    }
    if (device.enabledDataTypes['heartRate'] == true) {
      await _syncHeartRate(device.id, sevenDaysAgo, now);
    }
    if (device.enabledDataTypes['hrv'] == true) {
      await _syncHrv(device.id, sevenDaysAgo, now);
    }
    if (device.enabledDataTypes['sleep'] == true) {
      await _syncSleep(device.id, sevenDaysAgo, now);
    }

    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(lastSyncAt: now);
      await _persistDevice(_devices[index]);
    }
  }

  List<HealthDataType> get _healthTypes => [
        HealthDataType.BODY_TEMPERATURE,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_ASLEEP,
        Platform.isAndroid
            ? HealthDataType.HEART_RATE_VARIABILITY_RMSSD
            : HealthDataType.HEART_RATE_VARIABILITY_SDNN,
      ].where(_health.isDataTypeAvailable).toList();

  Future<void> _syncTemperature(String deviceId, DateTime from, DateTime to) async {
    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.BODY_TEMPERATURE],
      startTime: from,
      endTime: to,
    );

    for (final point in data) {
      final numericValue = (point.value as NumericHealthValue).numericValue;
      final dataPoint = WearableDataPoint(
        timestamp: point.dateFrom,
        value: numericValue.toDouble(),
        type: 'temperature',
        source: point.sourceName.isEmpty ? deviceId : point.sourceName,
        externalId: point.uuid,
      );
      await _storeDataPoint(dataPoint);
    }
  }

  Future<void> _syncHeartRate(String deviceId, DateTime from, DateTime to) async {
    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.HEART_RATE],
      startTime: from,
      endTime: to,
    );

    for (final point in data) {
      final numericValue = (point.value as NumericHealthValue).numericValue;
      final dataPoint = WearableDataPoint(
        timestamp: point.dateFrom,
        value: numericValue.toDouble(),
        type: 'heartRate',
        source: point.sourceName.isEmpty ? deviceId : point.sourceName,
        externalId: point.uuid,
      );
      await _storeDataPoint(dataPoint);
    }
  }

  Future<void> _syncHrv(String deviceId, DateTime from, DateTime to) async {
    final type = Platform.isAndroid
        ? HealthDataType.HEART_RATE_VARIABILITY_RMSSD
        : HealthDataType.HEART_RATE_VARIABILITY_SDNN;
    final data = await _health.getHealthDataFromTypes(
      types: [type],
      startTime: from,
      endTime: to,
    );

    for (final point in data) {
      final numericValue = (point.value as NumericHealthValue).numericValue;
      await _storeDataPoint(
        WearableDataPoint(
          timestamp: point.dateFrom,
          value: numericValue.toDouble(),
          type: 'hrv',
          source: point.sourceName.isEmpty ? deviceId : point.sourceName,
          externalId: point.uuid,
        ),
      );
    }
  }

  Future<void> _syncSleep(String deviceId, DateTime from, DateTime to) async {
    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.SLEEP_ASLEEP],
      startTime: from,
      endTime: to,
    );

    Map<DateTime, double> sleepHoursByDay = {};
    for (final point in data) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final numericValue = (point.value as NumericHealthValue).numericValue;
      final hours = numericValue.toDouble() / 60;
      sleepHoursByDay.update(day, (v) => v + hours, ifAbsent: () => hours);
    }

    for (final entry in sleepHoursByDay.entries) {
      final dataPoint = WearableDataPoint(
        timestamp: entry.key,
        value: entry.value,
        type: 'sleep',
        source: deviceId,
        externalId: 'sleep_${entry.key.toIso8601String()}',
      );
      await _storeDataPoint(dataPoint);
    }
  }

  Future<void> _storeDataPoint(WearableDataPoint point) async {
    final jsonStr = jsonEncode(point.toJson());
    final encryptedJson = _encryption.encryptString(jsonStr);
    await _db.into(_db.wearableSources).insertOnConflictUpdate(
          WearableSourcesCompanion.insert(
            id: '${point.type}_${point.externalId ?? point.timestamp.microsecondsSinceEpoch}',
            userId: 'default',
            sourceType: point.type,
            isConnected: const Value(true),
            settingsJson: Value(encryptedJson),
            createdAt: point.timestamp,
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> _persistDevice(WearableDevice device) async {
    final jsonStr = jsonEncode(device.toJson());
    final encryptedJson = _encryption.encryptString(jsonStr);
    await _db.into(_db.wearableSources).insertOnConflictUpdate(
          WearableSourcesCompanion.insert(
            id: device.id,
            userId: 'default',
            sourceType: device.type.name,
            isConnected: Value(device.isConnected),
            lastSyncAt: Value(device.lastSyncAt),
            settingsJson: Value(encryptedJson),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<bool> requestPermissions() async {
    await _ensureHealthInitialized();
    return _health.requestAuthorization(_healthTypes);
  }

  Future<void> enableDataType(String deviceId, String dataType) async {
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index == -1) return;

    final device = _devices[index];
    final updatedTypes = Map<String, bool>.from(device.enabledDataTypes);
    updatedTypes[dataType] = !(updatedTypes[dataType] ?? false);

    _devices[index] = device.copyWith(enabledDataTypes: updatedTypes);
    await _persistDevice(_devices[index]);
  }

  Future<List<WearableDataPoint>> getTemperatureData(DateTime from, DateTime to) async {
    return _queryDataPoints('temperature', from, to);
  }

  Future<List<WearableDataPoint>> getHeartRateData(DateTime from, DateTime to) async {
    return _queryDataPoints('heartRate', from, to);
  }

  Future<List<WearableDataPoint>> getSleepData(DateTime from, DateTime to) async {
    return _queryDataPoints('sleep', from, to);
  }

  Future<List<WearableDataPoint>> getActivityData(DateTime from, DateTime to) async {
    return _queryDataPoints('activity', from, to);
  }

  Future<List<WearableDataPoint>> getHrvData(DateTime from, DateTime to) async {
    return _queryDataPoints('hrv', from, to);
  }

  Future<List<WearableDataPoint>> _queryDataPoints(
    String type,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await (_db.select(_db.wearableSources)
          ..where(
            (t) =>
                t.sourceType.equals(type) &
                t.createdAt.isBetween(Variable(from), Variable(to)),
          ))
        .get();

    final points = <WearableDataPoint>[];
    for (final row in rows) {
      if (row.settingsJson == null) continue;
      try {
        final decrypted = _encryption.decryptString(row.settingsJson!);
        final map = jsonDecode(decrypted) as Map<String, dynamic>;
        final point = WearableDataPoint.fromJson(map);
        points.add(point);
      } catch (_) {}
    }
    return points;
  }

  BBTRecord mapToBBTRecord(WearableDataPoint temp) {
    return BBTRecord(
      id: 'wearable_${temp.externalId ?? temp.timestamp.microsecondsSinceEpoch}',
      date: temp.timestamp,
      temperature: temp.value,
      method: BBTMeasurementMethod.wearable,
      isEstimated: false,
      timeOfDay: 'auto',
      notes: 'Synced from ${temp.source ?? 'wearable'}',
    );
  }

  Future<WearableDataSummary> getDataSummary(
    String deviceId, {
    int days = 7,
  }) async {
    final now = DateTime.now();
    final from = now.subtract(Duration(days: days));

    final temps = await getTemperatureData(from, now);
    final heartRates = await getHeartRateData(from, now);
    final sleeps = await getSleepData(from, now);
    final hrv = await getHrvData(from, now);
    final activities = await getActivityData(from, now);

    final avgTemp = temps.isEmpty
        ? 0.0
        : temps.map((p) => p.value).reduce((a, b) => a + b) / temps.length;

    final avgHr = heartRates.isEmpty
        ? 0.0
        : heartRates.map((p) => p.value).reduce((a, b) => a + b) / heartRates.length;

    final avgSleep = sleeps.isEmpty
        ? 0.0
        : sleeps.map((p) => p.value).reduce((a, b) => a + b) / sleeps.length;

    final totalSteps = activities.isEmpty
        ? 0
        : activities.map((p) => p.value.toInt()).reduce((a, b) => a + b);

    final avgHrv = hrv.isEmpty
        ? 0.0
        : hrv.map((p) => p.value).reduce((a, b) => a + b) / hrv.length;

    return WearableDataSummary(
      averageTemperature: double.parse(avgTemp.toStringAsFixed(2)),
      averageHeartRate: double.parse(avgHr.toStringAsFixed(1)),
      averageSleepHours: double.parse(avgSleep.toStringAsFixed(1)),
      averageHrv: double.parse(avgHrv.toStringAsFixed(1)),
      stepCount: totalSteps,
      dataPointCount:
          temps.length +
          heartRates.length +
          sleeps.length +
          hrv.length +
          activities.length,
    );
  }

  Future<void> requestAuthorization() async {
    await requestPermissions();
  }

  void _updateSyncStatus({
    required bool isSyncing,
    DateTime? lastSync,
    String? errorMessage,
  }) {
    _syncStatusController.add(WearableSyncStatus(
      isSyncing: isSyncing,
      lastSuccessfulSync: lastSync,
      pendingRecords: 0,
      errorMessage: errorMessage,
    ));
  }

  void dispose() {
    _syncStatusController.close();
  }
}
