abstract final class ApiConstants {
  static const String appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );
  static const String supabaseUrlProd = String.fromEnvironment(
    'SUPABASE_URL_PROD',
  );
  static const String supabaseAnonKeyProd = String.fromEnvironment(
    'SUPABASE_ANON_KEY_PROD',
  );
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const String sentryEnvironment = String.fromEnvironment(
    'SENTRY_ENVIRONMENT',
    defaultValue: appEnvironment,
  );
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}
