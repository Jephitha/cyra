import 'package:flutter/foundation.dart';

import 'package:cyra/core/constants/api_constants.dart';

class SupabaseConfigurationException implements Exception {
  const SupabaseConfigurationException(this.message);

  final String message;

  @override
  String toString() => 'SupabaseConfigurationException: $message';
}

class SupabaseEnvironmentConfig {
  const SupabaseEnvironmentConfig._({
    required this.environment,
    required this.url,
    required this.publishableKey,
    required this.enabled,
  });

  final String environment;
  final String url;
  final String publishableKey;
  final bool enabled;

  factory SupabaseEnvironmentConfig.current() {
    final useProductionDefines =
        kReleaseMode && ApiConstants.appEnvironment == 'production';
    return SupabaseEnvironmentConfig.fromValues(
      environment: ApiConstants.appEnvironment,
      url: useProductionDefines
          ? ApiConstants.supabaseUrlProd
          : ApiConstants.supabaseUrl,
      publishableKey: useProductionDefines
          ? ApiConstants.supabaseAnonKeyProd
          : ApiConstants.supabaseAnonKey,
      isRelease: kReleaseMode,
    );
  }

  factory SupabaseEnvironmentConfig.fromValues({
    required String environment,
    required String url,
    required String publishableKey,
    required bool isRelease,
  }) {
    final normalizedEnvironment = environment.trim().toLowerCase();
    final normalizedUrl = url.trim();
    final normalizedKey = publishableKey.trim();

    if (normalizedUrl.isEmpty || normalizedKey.isEmpty) {
      if (isRelease) {
        throw const SupabaseConfigurationException(
          'Release builds require APP_ENV plus the matching Supabase dart-defines. Production releases use SUPABASE_URL_PROD and SUPABASE_ANON_KEY_PROD.',
        );
      }
      return SupabaseEnvironmentConfig._(
        environment: normalizedEnvironment.isEmpty
            ? 'development'
            : normalizedEnvironment,
        url: '',
        publishableKey: '',
        enabled: false,
      );
    }

    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw const SupabaseConfigurationException(
        'SUPABASE_URL must be an absolute URL.',
      );
    }

    if (isRelease) {
      if (normalizedEnvironment != 'staging' &&
          normalizedEnvironment != 'production') {
        throw const SupabaseConfigurationException(
          'Release APP_ENV must be staging or production.',
        );
      }
      if (uri.scheme != 'https') {
        throw const SupabaseConfigurationException(
          'Release SUPABASE_URL must use HTTPS.',
        );
      }
      if (_isLocalOrPrivateHost(uri.host)) {
        throw const SupabaseConfigurationException(
          'Release SUPABASE_URL cannot target localhost or a private network.',
        );
      }
      if (_isPlaceholderKey(normalizedKey)) {
        throw const SupabaseConfigurationException(
          'Release SUPABASE_ANON_KEY is missing or still a placeholder.',
        );
      }
    }

    return SupabaseEnvironmentConfig._(
      environment: normalizedEnvironment.isEmpty
          ? 'development'
          : normalizedEnvironment,
      url: normalizedUrl,
      publishableKey: normalizedKey,
      enabled: true,
    );
  }

  static bool _isPlaceholderKey(String key) {
    final lower = key.toLowerCase();
    return key.length < 20 ||
        lower.contains('placeholder') ||
        lower.contains('your_') ||
        lower.contains('changeme');
  }

  static bool _isLocalOrPrivateHost(String host) {
    final lower = host.toLowerCase();
    if (lower == 'localhost' || lower == '::1' || lower.endsWith('.local')) {
      return true;
    }
    final octets = lower.split('.').map(int.tryParse).toList();
    if (octets.length != 4 || octets.any((part) => part == null)) return false;
    final first = octets[0]!;
    final second = octets[1]!;
    return first == 10 ||
        first == 127 ||
        (first == 169 && second == 254) ||
        (first == 172 && second >= 16 && second <= 31) ||
        (first == 192 && second == 168);
  }
}
