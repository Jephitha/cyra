import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cyra/core/database/daos/cycle_dao.dart';
import 'package:cyra/core/notifications/cycle_reminder_settings.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  Future<Map<String, String>> build() async {
    final dao = ref.read(settingsDaoProvider);
    final settings = await dao.getAllSettings();
    final map = <String, String>{};
    for (final s in settings) {
      map[s.key] = s.value;
    }
    return map;
  }

  Future<void> setValue(String key, String value) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue(key, value);
    ref.invalidateSelf();
  }

  Future<String?> getValue(String key) async {
    final dao = ref.read(settingsDaoProvider);
    return dao.getValue(key);
  }

  Future<void> deleteKey(String key) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.deleteKey(key);
    ref.invalidateSelf();
  }
}

@riverpod
class LocaleSetting extends _$LocaleSetting {
  @override
  Locale build() {
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
    ref
        .read(appSettingsNotifierProvider.notifier)
        .setValue('locale', locale.languageCode);
  }
}

@Riverpod(keepAlive: true)
class BiometricEnabled extends _$BiometricEnabled {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.getValue('biometric_enabled');
    return val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('biometric_enabled', enabled.toString());
    state = AsyncData(enabled);
  }
}

@Riverpod(keepAlive: true)
class PinEnabled extends _$PinEnabled {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.getValue('pin_enabled');
    return val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('pin_enabled', enabled.toString());
    state = AsyncData(enabled);
  }
}

@Riverpod(keepAlive: true)
class NotificationsEnabled extends _$NotificationsEnabled {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.getValue('notifications_enabled');
    return val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('notifications_enabled', enabled.toString());
    state = AsyncData(enabled);
  }
}

@Riverpod(keepAlive: true)
class CycleReminderSettingsNotifier extends _$CycleReminderSettingsNotifier {
  @override
  Future<CycleReminderSettings> build() async {
    final settings = await ref.read(settingsDaoProvider).getAllSettings();
    return CycleReminderSettings.fromMap({
      for (final setting in settings) setting.key: setting.value,
    });
  }

  Future<void> save(CycleReminderSettings value) async {
    final dao = ref.read(settingsDaoProvider);
    for (final entry in value.toMap().entries) {
      await dao.setValue(entry.key, entry.value);
    }
    state = AsyncData(value);
  }
}

@Riverpod(keepAlive: true)
class PrivateModeSetting extends _$PrivateModeSetting {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.getValue('private_mode');
    return val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('private_mode', enabled.toString());
    state = AsyncData(enabled);
  }

  void toggle() {
    final current = state.valueOrNull ?? false;
    setEnabled(!current);
  }
}

@Riverpod(keepAlive: true)
class WearableSyncEnabled extends _$WearableSyncEnabled {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.getValue('wearable_sync_enabled');
    return val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('wearable_sync_enabled', enabled.toString());
    state = AsyncData(enabled);
  }
}
