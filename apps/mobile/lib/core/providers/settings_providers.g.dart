// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSettingsNotifierHash() =>
    r'3cc8ada9b68dc9b65efd7f7519564e7b666a3b91';

/// See also [AppSettingsNotifier].
@ProviderFor(AppSettingsNotifier)
final appSettingsNotifierProvider =
    AsyncNotifierProvider<AppSettingsNotifier, Map<String, String>>.internal(
      AppSettingsNotifier.new,
      name: r'appSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppSettingsNotifier = AsyncNotifier<Map<String, String>>;
String _$localeSettingHash() => r'31f3e375c5b30dd8fa95689d97a26e5a0dd75bab';

/// See also [LocaleSetting].
@ProviderFor(LocaleSetting)
final localeSettingProvider =
    AutoDisposeNotifierProvider<LocaleSetting, Locale>.internal(
      LocaleSetting.new,
      name: r'localeSettingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$localeSettingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocaleSetting = AutoDisposeNotifier<Locale>;
String _$biometricEnabledHash() => r'42d298d2cfe98739fe46ee1169f848fc8c6e62b7';

/// See also [BiometricEnabled].
@ProviderFor(BiometricEnabled)
final biometricEnabledProvider =
    AsyncNotifierProvider<BiometricEnabled, bool>.internal(
      BiometricEnabled.new,
      name: r'biometricEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$biometricEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BiometricEnabled = AsyncNotifier<bool>;
String _$pinEnabledHash() => r'80546a6bbae184ed2cfbb98e13666812e9610c95';

/// See also [PinEnabled].
@ProviderFor(PinEnabled)
final pinEnabledProvider = AsyncNotifierProvider<PinEnabled, bool>.internal(
  PinEnabled.new,
  name: r'pinEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinEnabled = AsyncNotifier<bool>;
String _$notificationsEnabledHash() =>
    r'b27d102ff95e76dc143ff93d33a1d1e28a5c181a';

/// See also [NotificationsEnabled].
@ProviderFor(NotificationsEnabled)
final notificationsEnabledProvider =
    AsyncNotifierProvider<NotificationsEnabled, bool>.internal(
      NotificationsEnabled.new,
      name: r'notificationsEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationsEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationsEnabled = AsyncNotifier<bool>;
String _$cycleReminderSettingsNotifierHash() =>
    r'a865f35e7e9549db7f3201b3c9e0dbe98e7f8398';

/// See also [CycleReminderSettingsNotifier].
@ProviderFor(CycleReminderSettingsNotifier)
final cycleReminderSettingsNotifierProvider =
    AsyncNotifierProvider<
      CycleReminderSettingsNotifier,
      CycleReminderSettings
    >.internal(
      CycleReminderSettingsNotifier.new,
      name: r'cycleReminderSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cycleReminderSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CycleReminderSettingsNotifier = AsyncNotifier<CycleReminderSettings>;
String _$privateModeSettingHash() =>
    r'3aeede6728e783a4d3ad98f5f5de1117dd607cc1';

/// See also [PrivateModeSetting].
@ProviderFor(PrivateModeSetting)
final privateModeSettingProvider =
    AsyncNotifierProvider<PrivateModeSetting, bool>.internal(
      PrivateModeSetting.new,
      name: r'privateModeSettingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$privateModeSettingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PrivateModeSetting = AsyncNotifier<bool>;
String _$wearableSyncEnabledHash() =>
    r'1622d12f4729ed653a81ce183ad7e079cd0bd2b2';

/// See also [WearableSyncEnabled].
@ProviderFor(WearableSyncEnabled)
final wearableSyncEnabledProvider =
    AsyncNotifierProvider<WearableSyncEnabled, bool>.internal(
      WearableSyncEnabled.new,
      name: r'wearableSyncEnabledProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wearableSyncEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WearableSyncEnabled = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
