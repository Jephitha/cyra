import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';
import 'package:cyra/features/wearables/services/wearable_service.dart';

part 'wearable_providers.g.dart';

@Riverpod(keepAlive: true)
WearableService wearableService(WearableServiceRef ref) {
  final service = WearableService(
    ref.watch(appDatabaseProvider),
    ref.watch(encryptionServiceProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
Future<List<WearableDevice>> connectedDevices(ConnectedDevicesRef ref) async {
  final service = ref.watch(wearableServiceProvider);
  return service.getConnectedDevices();
}

@riverpod
Future<List<WearableDevice>> availableDevices(AvailableDevicesRef ref) async {
  final service = ref.watch(wearableServiceProvider);
  return service.getAvailableDevices();
}

@riverpod
Stream<WearableSyncStatus> syncStatus(SyncStatusRef ref) {
  final service = ref.watch(wearableServiceProvider);
  return service.syncStatusStream;
}

@riverpod
Future<void> syncAllDevices(SyncAllDevicesRef ref) async {
  final service = ref.watch(wearableServiceProvider);
  await service.syncAllDevices();
  ref.invalidate(connectedDevicesProvider);
  ref.invalidate(availableDevicesProvider);
}

@riverpod
Future<WearableDataSummary> deviceDataSummary(
  DeviceDataSummaryRef ref,
  String deviceId, {
  int days = 7,
}) async {
  final service = ref.watch(wearableServiceProvider);
  return service.getDataSummary(deviceId, days: days);
}
