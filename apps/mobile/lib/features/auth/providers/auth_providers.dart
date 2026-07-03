import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cyra/core/security/secure_storage_service.dart';

part 'auth_providers.freezed.dart';
part 'auth_providers.g.dart';

enum AuthStatus { authenticated, unauthenticated, locked }

@freezed
class PrivacyConfig with _$PrivacyConfig {
  const factory PrivacyConfig({
    @Default(false) bool biometricEnabled,
    @Default(false) bool pinEnabled,
    @Default(false) bool privateModeEnabled,
    @Default(false) bool hiddenAppIconEnabled,
    @Default(false) bool emergencyLockEnabled,
    @Default(5) int autoLockMinutes,
    @Default('') String emergencyContactName,
    @Default('') String emergencyContactPhone,
  }) = _PrivacyConfig;

  factory PrivacyConfig.defaults() => const PrivacyConfig();
}

@Riverpod(keepAlive: true)
class OnboardingState extends _$OnboardingState {
  @override
  bool build() => false;

  void complete() {
    state = true;
    ref
        .read(secureStorageServiceProvider)
        .storeString('onboarding_complete', 'true');
  }

  void reset() {
    state = false;
    ref.read(secureStorageServiceProvider).deleteKey('onboarding_complete');
  }
}

@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  /// Tracks whether the user has locally authenticated (PIN/biometrics).
  /// Prevents Supabase stream from overriding to unauthenticated
  /// when the user has already passed onboarding/privacy setup.
  bool _localAuthenticated = false;

  @override
  AuthStatus build() {
    try {
      final auth = Supabase.instance.client.auth;
      final subscription = auth.onAuthStateChange.listen((event) {
        final hasSession = event.session != null;
        if (hasSession) {
          state = AuthStatus.authenticated;
        } else if (!_localAuthenticated && state != AuthStatus.locked) {
          state = AuthStatus.unauthenticated;
        }
      });
      ref.onDispose(subscription.cancel);

      return auth.currentSession == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
    } catch (_) {
      return AuthStatus.unauthenticated;
    }
  }

  void authenticate() {
    _localAuthenticated = true;
    state = AuthStatus.authenticated;
  }

  Future<void> ensureAuthenticated() async {
    _localAuthenticated = true;
    state = AuthStatus.authenticated;
    try {
      final client = Supabase.instance.client;
      if (client.auth.currentSession == null) {
        await client.auth.signInAnonymously();
      }
    } catch (_) {}
  }

  void lock() => state = AuthStatus.locked;

  Future<void> unauthenticate() async {
    _localAuthenticated = false;
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {
      // Allow offline sign-out
    }
    state = AuthStatus.unauthenticated;
  }
}

@Riverpod(keepAlive: true)
class PrivacySettings extends _$PrivacySettings {
  @override
  PrivacyConfig build() => PrivacyConfig.defaults();

  void update(PrivacyConfig config) => state = config;
  void updateBiometric(bool enabled) =>
      state = state.copyWith(biometricEnabled: enabled);
  void updatePin(bool enabled) => state = state.copyWith(pinEnabled: enabled);
  void updatePrivateMode(bool enabled) =>
      state = state.copyWith(privateModeEnabled: enabled);
  void updateHiddenAppIcon(bool enabled) =>
      state = state.copyWith(hiddenAppIconEnabled: enabled);
  void updateEmergencyLock(bool enabled) =>
      state = state.copyWith(emergencyLockEnabled: enabled);
  void updateAutoLock(int minutes) =>
      state = state.copyWith(autoLockMinutes: minutes);
  void updateEmergencyContact(String name, String phone) => state = state
      .copyWith(emergencyContactName: name, emergencyContactPhone: phone);
  void reset() => state = PrivacyConfig.defaults();
}

@Riverpod(keepAlive: true)
class FailedPinAttempts extends _$FailedPinAttempts {
  @override
  int build() => 0;

  void increment() => state = state + 1;
  void reset() => state = 0;
}

@Riverpod(keepAlive: true)
class IsEmergencyLocked extends _$IsEmergencyLocked {
  @override
  bool build() => false;

  void activate() => state = true;
  void deactivate() => state = false;
}
