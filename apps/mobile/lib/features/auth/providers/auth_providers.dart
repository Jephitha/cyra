import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cyra/app/bootstrap.dart';

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

  void complete() => state = true;
  void reset() => state = false;
}

@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthStatus build() {
    final auth = Supabase.instance.client.auth;
    final subscription = auth.onAuthStateChange.listen((event) {
      final hasSession = event.session != null;
      if (hasSession) {
        state = AuthStatus.authenticated;
      } else if (state != AuthStatus.locked) {
        state = AuthStatus.unauthenticated;
      }
    });
    ref.onDispose(subscription.cancel);

    return auth.currentSession == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
  }

  Future<void> authenticate() async {
    state = AuthStatus.authenticated;
    await ensureSupabaseSession();
  }

  void lock() => state = AuthStatus.locked;

  Future<void> unauthenticate() async {
    await Supabase.instance.client.auth.signOut();
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
