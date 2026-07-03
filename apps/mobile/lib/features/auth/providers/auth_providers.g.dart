// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingStateHash() => r'8014ff1b3792e1d84516b676d3c2dcaa5a4b77f1';

/// See also [OnboardingState].
@ProviderFor(OnboardingState)
final onboardingStateProvider =
    NotifierProvider<OnboardingState, bool>.internal(
      OnboardingState.new,
      name: r'onboardingStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingState = Notifier<bool>;
String _$authStateNotifierHash() => r'a75b7da673b092a017734cac73f5caa864bdd144';

/// See also [AuthStateNotifier].
@ProviderFor(AuthStateNotifier)
final authStateNotifierProvider =
    NotifierProvider<AuthStateNotifier, AuthStatus>.internal(
      AuthStateNotifier.new,
      name: r'authStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthStateNotifier = Notifier<AuthStatus>;
String _$privacySettingsHash() => r'1ab9b40e307b3803deb227e27ebcbf3f0bf941a9';

/// See also [PrivacySettings].
@ProviderFor(PrivacySettings)
final privacySettingsProvider =
    NotifierProvider<PrivacySettings, PrivacyConfig>.internal(
      PrivacySettings.new,
      name: r'privacySettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$privacySettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PrivacySettings = Notifier<PrivacyConfig>;
String _$failedPinAttemptsHash() => r'dd8b67f75a9732063fa646a05ad4f5c878e28147';

/// See also [FailedPinAttempts].
@ProviderFor(FailedPinAttempts)
final failedPinAttemptsProvider =
    NotifierProvider<FailedPinAttempts, int>.internal(
      FailedPinAttempts.new,
      name: r'failedPinAttemptsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$failedPinAttemptsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FailedPinAttempts = Notifier<int>;
String _$isEmergencyLockedHash() => r'6cb85578e7193119af42d526e9b0717548225aa5';

/// See also [IsEmergencyLocked].
@ProviderFor(IsEmergencyLocked)
final isEmergencyLockedProvider =
    NotifierProvider<IsEmergencyLocked, bool>.internal(
      IsEmergencyLocked.new,
      name: r'isEmergencyLockedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$isEmergencyLockedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IsEmergencyLocked = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
