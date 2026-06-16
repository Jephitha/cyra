import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cyra/core/providers/settings_providers.dart';

part 'settings_notifier.g.dart';

enum AppAccentColor {
  forest,
  sage,
  gold,
  slate;

  Color get color {
    switch (this) {
      case AppAccentColor.forest:
        return const Color(0xFF1B4332);
      case AppAccentColor.sage:
        return const Color(0xFF7A9E7E);
      case AppAccentColor.gold:
        return const Color(0xFFC9A94E);
      case AppAccentColor.slate:
        return const Color(0xFF6B7280);
    }
  }

  String get label {
    switch (this) {
      case AppAccentColor.forest:
        return 'Forest';
      case AppAccentColor.sage:
        return 'Sage';
      case AppAccentColor.gold:
        return 'Gold';
      case AppAccentColor.slate:
        return 'Slate';
    }
  }
}

enum FontStyleSetting {
  standard,
  accessible,
  largePrint;

  String get label {
    switch (this) {
      case FontStyleSetting.standard:
        return 'Standard';
      case FontStyleSetting.accessible:
        return 'Accessible';
      case FontStyleSetting.largePrint:
        return 'Large Print';
    }
  }
}

enum UnitsSystem {
  metric,
  imperial;

  String get label {
    switch (this) {
      case UnitsSystem.metric:
        return 'Metric';
      case UnitsSystem.imperial:
        return 'Imperial';
    }
  }
}

enum TemperatureUnit {
  celsius,
  fahrenheit;

  String get label {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'Celsius (°C)';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit (°F)';
    }
  }
}

@Riverpod(keepAlive: true)
class ThemeModeSettingNotifier extends _$ThemeModeSettingNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(appSettingsNotifierProvider.notifier).setValue('theme_mode', mode.name);
  }
}

@Riverpod(keepAlive: true)
class AccentColorSettingNotifier extends _$AccentColorSettingNotifier {
  @override
  AppAccentColor build() => AppAccentColor.forest;

  void setAccentColor(AppAccentColor color) {
    state = color;
    ref.read(appSettingsNotifierProvider.notifier).setValue('accent_color', color.name);
  }
}

@Riverpod(keepAlive: true)
class TextSizeSettingNotifier extends _$TextSizeSettingNotifier {
  @override
  double build() => 1.0;

  void setTextSize(double scale) {
    state = scale.clamp(0.8, 1.4);
    ref.read(appSettingsNotifierProvider.notifier).setValue('text_size', state.toStringAsFixed(2));
  }
}

@Riverpod(keepAlive: true)
class FontStyleSettingNotifier extends _$FontStyleSettingNotifier {
  @override
  FontStyleSetting build() => FontStyleSetting.standard;

  void setFontStyle(FontStyleSetting style) {
    state = style;
    ref.read(appSettingsNotifierProvider.notifier).setValue('font_style', style.name);
  }
}

@Riverpod(keepAlive: true)
class ReduceMotionSettingNotifier extends _$ReduceMotionSettingNotifier {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
    ref.read(appSettingsNotifierProvider.notifier).setValue('reduce_motion', state.toString());
  }
}

@Riverpod(keepAlive: true)
class HighContrastSettingNotifier extends _$HighContrastSettingNotifier {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
    ref.read(appSettingsNotifierProvider.notifier).setValue('high_contrast', state.toString());
  }
}

@Riverpod(keepAlive: true)
class ShowCyclePhaseColorsNotifier extends _$ShowCyclePhaseColorsNotifier {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
    ref.read(appSettingsNotifierProvider.notifier).setValue('show_cycle_phase_colors', state.toString());
  }
}

@Riverpod(keepAlive: true)
class PrivateModeNotifier extends _$PrivateModeNotifier {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
    ref.read(appSettingsNotifierProvider.notifier).setValue('private_mode', state.toString());
  }
}

@Riverpod(keepAlive: true)
class AutoLockDurationNotifier extends _$AutoLockDurationNotifier {
  @override
  Duration build() => const Duration(minutes: 5);

  void setDuration(Duration duration) {
    state = duration;
    ref.read(appSettingsNotifierProvider.notifier).setValue('auto_lock_duration', duration.inSeconds.toString());
  }
}

@Riverpod(keepAlive: true)
class UnitsSystemNotifier extends _$UnitsSystemNotifier {
  @override
  UnitsSystem build() => UnitsSystem.metric;

  void setUnitsSystem(UnitsSystem system) {
    state = system;
    ref.read(appSettingsNotifierProvider.notifier).setValue('units_system', system.name);
  }
}

@Riverpod(keepAlive: true)
class TemperatureUnitNotifier extends _$TemperatureUnitNotifier {
  @override
  TemperatureUnit build() => TemperatureUnit.celsius;

  void setTemperatureUnit(TemperatureUnit unit) {
    state = unit;
    ref.read(appSettingsNotifierProvider.notifier).setValue('temperature_unit', unit.name);
  }
}

@Riverpod(keepAlive: true)
class NotificationPreviewSettingNotifier extends _$NotificationPreviewSettingNotifier {
  @override
  NotificationPreviewMode build() => NotificationPreviewMode.nameOnly;

  void setPreviewMode(NotificationPreviewMode mode) {
    state = mode;
    ref.read(appSettingsNotifierProvider.notifier).setValue('notification_preview', mode.name);
  }
}

enum NotificationPreviewMode {
  none,
  nameOnly,
  full;

  String get label {
    switch (this) {
      case NotificationPreviewMode.none:
        return 'No preview';
      case NotificationPreviewMode.nameOnly:
        return 'App name only';
      case NotificationPreviewMode.full:
        return 'Full content';
    }
  }
}
