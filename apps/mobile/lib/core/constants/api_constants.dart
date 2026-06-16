abstract final class ApiConstants {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}
