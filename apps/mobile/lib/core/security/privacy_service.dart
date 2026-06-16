import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_service.g.dart';

class PrivacyException implements Exception {
  final String message;
  final Object? cause;
  PrivacyException(this.message, [this.cause]);

  @override
  String toString() => 'PrivacyException: $message';
}

enum AutoLockDuration {
  immediately(Duration.zero, 'Immediately'),
  oneMinute(Duration(minutes: 1), '1 Minute'),
  fiveMinutes(Duration(minutes: 5), '5 Minutes'),
  fifteenMinutes(Duration(minutes: 15), '15 Minutes'),
  thirtyMinutes(Duration(minutes: 30), '30 Minutes');

  final Duration duration;
  final String label;
  const AutoLockDuration(this.duration, this.label);
}

class PrivacyService {
  final FlutterSecureStorage _secureStorage;

  static const String _privateModeKey = 'cyra_private_mode';
  static const String _autoLockKey = 'cyra_auto_lock';
  static const String _screenCaptureBlockKey = 'cyra_screen_capture_block';
  static const String _emergencyLockActiveKey = 'cyra_emergency_lock_active';

  bool _privateMode = false;
  bool _screenCaptureBlock = false;
  bool _emergencyLockActive = false;
  AutoLockDuration _autoLockDuration = AutoLockDuration.fiveMinutes;
  Timer? _autoLockTimer;

  final VoidCallback? onEmergencyLock;
  final VoidCallback? onAutoLock;

  PrivacyService({
    required this._secureStorage,
    this.onEmergencyLock,
    this.onAutoLock,
  });

  // --- Emergency Lock ---

  Future<void> activateEmergencyLock() async {
    try {
      _emergencyLockActive = true;
      await _secureStorage.write(
        key: _emergencyLockActiveKey,
        value: 'true',
      );
      await _secureStorage.write(
        key: _privateModeKey,
        value: 'true',
      );
      _privateMode = true;
      _cancelAutoLockTimer();
      onEmergencyLock?.call();
    } catch (e) {
      throw PrivacyException('Failed to activate emergency lock', e);
    }
  }

  Future<void> deactivateEmergencyLock() async {
    try {
      _emergencyLockActive = false;
      await _secureStorage.delete(key: _emergencyLockActiveKey);
      onAutoLock?.call();
      _restartAutoLockTimer();
    } catch (e) {
      throw PrivacyException('Failed to deactivate emergency lock', e);
    }
  }

  bool get isEmergencyLockActive => _emergencyLockActive;

  // --- Private Mode ---

  Future<void> enablePrivateMode() async {
    try {
      _privateMode = true;
      await _secureStorage.write(key: _privateModeKey, value: 'true');
    } catch (e) {
      throw PrivacyException('Failed to enable private mode', e);
    }
  }

  Future<void> disablePrivateMode() async {
    try {
      _privateMode = false;
      await _secureStorage.write(key: _privateModeKey, value: 'false');
    } catch (e) {
      throw PrivacyException('Failed to disable private mode', e);
    }
  }

  bool get isPrivateMode => _privateMode;

  Future<bool> isPrivateModeEnabled() async {
    try {
      final value = await _secureStorage.read(key: _privateModeKey);
      _privateMode = value == 'true';
      return _privateMode;
    } catch (e) {
      return false;
    }
  }

  // --- Screen Capture Block ---

  Future<void> enableScreenCaptureBlock() async {
    try {
      _screenCaptureBlock = true;
      await _secureStorage.write(
        key: _screenCaptureBlockKey,
        value: 'true',
      );
    } catch (e) {
      throw PrivacyException('Failed to enable screen capture block', e);
    }
  }

  Future<void> disableScreenCaptureBlock() async {
    try {
      _screenCaptureBlock = false;
      await _secureStorage.write(
        key: _screenCaptureBlockKey,
        value: 'false',
      );
    } catch (e) {
      throw PrivacyException('Failed to disable screen capture block', e);
    }
  }

  bool get isScreenCaptureBlocked => _screenCaptureBlock;

  Future<bool> isScreenCaptureBlockEnabled() async {
    try {
      final value = await _secureStorage.read(key: _screenCaptureBlockKey);
      _screenCaptureBlock = value == 'true';
      return _screenCaptureBlock;
    } catch (e) {
      return false;
    }
  }

  /// Returns FLAG_SECURE for Android secure windows.
  /// On iOS, returns an empty set (screen capture blocking is limited).
  Future<int> getScreenCaptureFlags() async {
    if (!_screenCaptureBlock) return 0;
    return 1; // Corresponds to FLAG_SECURE on Android
  }

  // --- Hidden App Icon ---

  /// On Android, this requires device admin privileges.
  /// On iOS, hidden app icons are not supported via public API.
  Future<bool> isHiddenAppIconAvailable() async {
    // Platform-specific implementation would be needed
    return false;
  }

  Future<void> hideAppIcon() async {
    throw UnsupportedError(
      'Hidden app icon requires platform-specific implementation.\n'
      'On Android: DevicePolicyManager with suspendPackage().\n'
      'On iOS: Not supported via public API.',
    );
  }

  Future<void> showAppIcon() async {
    throw UnsupportedError(
      'Showing app icon requires platform-specific implementation.',
    );
  }

  // --- Auto-Lock Timer ---

  Future<void> setAutoLockDuration(AutoLockDuration duration) async {
    try {
      _autoLockDuration = duration;
      await _secureStorage.write(
        key: _autoLockKey,
        value: duration.name,
      );
      _restartAutoLockTimer();
    } catch (e) {
      throw PrivacyException('Failed to set auto-lock duration', e);
    }
  }

  AutoLockDuration get autoLockDuration => _autoLockDuration;

  Future<AutoLockDuration> getAutoLockDuration() async {
    try {
      final value = await _secureStorage.read(key: _autoLockKey);
      if (value != null) {
        _autoLockDuration = AutoLockDuration.values.firstWhere(
          (d) => d.name == value,
          orElse: () => AutoLockDuration.fiveMinutes,
        );
      }
      return _autoLockDuration;
    } catch (e) {
      return AutoLockDuration.fiveMinutes;
    }
  }

  void _restartAutoLockTimer() {
    _cancelAutoLockTimer();
    if (_autoLockDuration == AutoLockDuration.immediately) return;
    if (_emergencyLockActive) return;

    _autoLockTimer = Timer(_autoLockDuration.duration, () {
      if (!_emergencyLockActive) {
        onAutoLock?.call();
      }
    });
  }

  void _cancelAutoLockTimer() {
    _autoLockTimer?.cancel();
    _autoLockTimer = null;
  }

  void resetAutoLockTimer() {
    _restartAutoLockTimer();
  }

  void dispose() {
    _cancelAutoLockTimer();
  }

  // --- Sensitive Notification Filter ---

  Future<bool> isNotificationFilterAvailable() async {
    return true;
  }

  Future<void> enableSensitiveNotificationFilter() async {
    try {
      await _secureStorage.write(
        key: 'cyra_sensitive_notification_filter',
        value: 'true',
      );
    } catch (e) {
      throw PrivacyException(
        'Failed to enable sensitive notification filter',
        e,
      );
    }
  }

  Future<void> disableSensitiveNotificationFilter() async {
    try {
      await _secureStorage.write(
        key: 'cyra_sensitive_notification_filter',
        value: 'false',
      );
    } catch (e) {
      throw PrivacyException(
        'Failed to disable sensitive notification filter',
        e,
      );
    }
  }

  Future<bool> isSensitiveNotificationFilterEnabled() async {
    try {
      final value = await _secureStorage.read(
        key: 'cyra_sensitive_notification_filter',
      );
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Sanitize notification body to remove sensitive period/fertility content.
  String sanitizeNotificationContent(String body, {bool isPrivateMode = false}) {
    if (!isPrivateMode) return body;

    final sensitivePatterns = <RegExp>[
      RegExp(r'\bperiod\b', caseSensitive: false),
      RegExp(r'\bfertile\w*\b', caseSensitive: false),
      RegExp(r'\bovulation\b', caseSensitive: false),
      RegExp(r'\bcycle day\b', caseSensitive: false),
      RegExp(r'\bspotting\b', caseSensitive: false),
      RegExp(r'\bcervical\b', caseSensitive: false),
      RegExp(r'\bmucus\b', caseSensitive: false),
      RegExp(r'\b(?:basal body )?temp(?:erature)?\b', caseSensitive: false),
      RegExp(r'\bluteal\b', caseSensitive: false),
      RegExp(r'\bmenses?\b', caseSensitive: false),
      RegExp(r'\bpregnancy\b', caseSensitive: false),
      RegExp(r'\bmiscarriage\b', caseSensitive: false),
      RegExp(r'\bcontraception\b', caseSensitive: false),
    ];

    var sanitized = body;
    for (final pattern in sensitivePatterns) {
      sanitized = sanitized.replaceAll(pattern, '***');
    }
    return sanitized;
  }

  /// Get notification importance for sensitive notifications in private mode.
  Future<int> getSensitiveNotificationImportance() async {
    if (_privateMode) {
      return 0; // IMPORTANCE_NONE on Android
    }
    return 3; // IMPORTANCE_DEFAULT
  }
}

@Riverpod(keepAlive: true)
PrivacyService privacyService(PrivacyServiceRef ref) {
  return PrivacyService(
    secureStorage: const FlutterSecureStorage(),
  );
}
