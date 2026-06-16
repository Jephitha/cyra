// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wearable_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wearableServiceHash() => r'f85f33c806c5a7869d0766bdf36e61162471864e';

/// See also [wearableService].
@ProviderFor(wearableService)
final wearableServiceProvider = Provider<WearableService>.internal(
  wearableService,
  name: r'wearableServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wearableServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WearableServiceRef = ProviderRef<WearableService>;
String _$connectedDevicesHash() => r'bc4f796fe49fe35f717f3af899d694a1a247d352';

/// See also [connectedDevices].
@ProviderFor(connectedDevices)
final connectedDevicesProvider =
    AutoDisposeFutureProvider<List<WearableDevice>>.internal(
      connectedDevices,
      name: r'connectedDevicesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectedDevicesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectedDevicesRef =
    AutoDisposeFutureProviderRef<List<WearableDevice>>;
String _$availableDevicesHash() => r'971e9182fe8dbd915f14fb2ca0aded331cc77b84';

/// See also [availableDevices].
@ProviderFor(availableDevices)
final availableDevicesProvider =
    AutoDisposeFutureProvider<List<WearableDevice>>.internal(
      availableDevices,
      name: r'availableDevicesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableDevicesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableDevicesRef =
    AutoDisposeFutureProviderRef<List<WearableDevice>>;
String _$syncStatusHash() => r'4b8258c188ade85ad8e67fe40046071e167fb9dd';

/// See also [syncStatus].
@ProviderFor(syncStatus)
final syncStatusProvider =
    AutoDisposeStreamProvider<WearableSyncStatus>.internal(
      syncStatus,
      name: r'syncStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncStatusRef = AutoDisposeStreamProviderRef<WearableSyncStatus>;
String _$syncAllDevicesHash() => r'827e3dd2fdf45ee6285deb93551f9b5ac95daf9b';

/// See also [syncAllDevices].
@ProviderFor(syncAllDevices)
final syncAllDevicesProvider = AutoDisposeFutureProvider<void>.internal(
  syncAllDevices,
  name: r'syncAllDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncAllDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncAllDevicesRef = AutoDisposeFutureProviderRef<void>;
String _$deviceDataSummaryHash() => r'47f8885dfe8f9f5da2cdb3454e7984bca2fd0a93';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [deviceDataSummary].
@ProviderFor(deviceDataSummary)
const deviceDataSummaryProvider = DeviceDataSummaryFamily();

/// See also [deviceDataSummary].
class DeviceDataSummaryFamily extends Family<AsyncValue<WearableDataSummary>> {
  /// See also [deviceDataSummary].
  const DeviceDataSummaryFamily();

  /// See also [deviceDataSummary].
  DeviceDataSummaryProvider call(String deviceId, {int days = 7}) {
    return DeviceDataSummaryProvider(deviceId, days: days);
  }

  @override
  DeviceDataSummaryProvider getProviderOverride(
    covariant DeviceDataSummaryProvider provider,
  ) {
    return call(provider.deviceId, days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deviceDataSummaryProvider';
}

/// See also [deviceDataSummary].
class DeviceDataSummaryProvider
    extends AutoDisposeFutureProvider<WearableDataSummary> {
  /// See also [deviceDataSummary].
  DeviceDataSummaryProvider(String deviceId, {int days = 7})
    : this._internal(
        (ref) => deviceDataSummary(
          ref as DeviceDataSummaryRef,
          deviceId,
          days: days,
        ),
        from: deviceDataSummaryProvider,
        name: r'deviceDataSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deviceDataSummaryHash,
        dependencies: DeviceDataSummaryFamily._dependencies,
        allTransitiveDependencies:
            DeviceDataSummaryFamily._allTransitiveDependencies,
        deviceId: deviceId,
        days: days,
      );

  DeviceDataSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deviceId,
    required this.days,
  }) : super.internal();

  final String deviceId;
  final int days;

  @override
  Override overrideWith(
    FutureOr<WearableDataSummary> Function(DeviceDataSummaryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeviceDataSummaryProvider._internal(
        (ref) => create(ref as DeviceDataSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deviceId: deviceId,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WearableDataSummary> createElement() {
    return _DeviceDataSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceDataSummaryProvider &&
        other.deviceId == deviceId &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeviceDataSummaryRef
    on AutoDisposeFutureProviderRef<WearableDataSummary> {
  /// The parameter `deviceId` of this provider.
  String get deviceId;

  /// The parameter `days` of this provider.
  int get days;
}

class _DeviceDataSummaryProviderElement
    extends AutoDisposeFutureProviderElement<WearableDataSummary>
    with DeviceDataSummaryRef {
  _DeviceDataSummaryProviderElement(super.provider);

  @override
  String get deviceId => (origin as DeviceDataSummaryProvider).deviceId;
  @override
  int get days => (origin as DeviceDataSummaryProvider).days;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
