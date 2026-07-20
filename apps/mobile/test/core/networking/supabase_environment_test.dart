import 'package:cyra/core/networking/supabase_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupabaseEnvironmentConfig', () {
    test('allows offline startup when development values are absent', () {
      final config = SupabaseEnvironmentConfig.fromValues(
        environment: 'development',
        url: '',
        publishableKey: '',
        isRelease: false,
      );

      expect(config.enabled, isFalse);
    });

    test('allows a local URL only for non-release development', () {
      final config = SupabaseEnvironmentConfig.fromValues(
        environment: 'development',
        url: 'http://192.168.1.20:54321',
        publishableKey: 'sb_publishable_local_development_key',
        isRelease: false,
      );

      expect(config.enabled, isTrue);
      expect(config.environment, 'development');
    });

    test('rejects missing release values', () {
      expect(
        () => SupabaseEnvironmentConfig.fromValues(
          environment: 'production',
          url: '',
          publishableKey: '',
          isRelease: true,
        ),
        throwsA(isA<SupabaseConfigurationException>()),
      );
    });

    test('rejects LAN and HTTP URLs in a release environment', () {
      for (final url in [
        'http://project.supabase.co',
        'https://127.0.0.1:54321',
        'https://192.168.100.8:54321',
      ]) {
        expect(
          () => SupabaseEnvironmentConfig.fromValues(
            environment: 'production',
            url: url,
            publishableKey: 'sb_publishable_realistic_release_key',
            isRelease: true,
          ),
          throwsA(isA<SupabaseConfigurationException>()),
          reason: url,
        );
      }
    });

    test('accepts public HTTPS staging and production values', () {
      final config = SupabaseEnvironmentConfig.fromValues(
        environment: 'production',
        url: 'https://example-project.supabase.co',
        publishableKey: 'sb_publishable_realistic_release_key',
        isRelease: true,
      );

      expect(config.enabled, isTrue);
      expect(config.environment, 'production');
    });

    test(
      'documents production release values as distinct from debug values',
      () {
        final debugConfig = SupabaseEnvironmentConfig.fromValues(
          environment: 'development',
          url: 'http://192.168.1.20:54321',
          publishableKey: 'sb_publishable_local_development_key',
          isRelease: false,
        );
        final releaseConfig = SupabaseEnvironmentConfig.fromValues(
          environment: 'production',
          url: 'https://prod-project.supabase.co',
          publishableKey: 'sb_publishable_realistic_production_key',
          isRelease: true,
        );

        expect(debugConfig.url, isNot(releaseConfig.url));
        expect(debugConfig.environment, 'development');
        expect(releaseConfig.environment, 'production');
      },
    );
  });
}
