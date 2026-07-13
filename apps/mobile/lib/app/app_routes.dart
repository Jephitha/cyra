abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const privacySetup = '/privacy-setup';
  static const lock = '/lock';
  static const emergencyLock = '/emergency-lock';
  static const signIn = '/sign-in';
  static const dashboard = '/dashboard';
  static const calendar = '/calendar';
  static const insights = '/insights';
  static const community = '/community';
  static const settings = '/settings';

  static const logPeriod = '/cycle/log-period';
  static const cycleHistory = '/cycle/history';
  static const predictionDetail = '/cycle/prediction';
  static const logSymptoms = '/symptoms/log';
  static const ovulation = '/ovulation';
  static const logBbt = '/ovulation/bbt';
  static const logMucus = '/ovulation/mucus';
  static const logOpk = '/ovulation/opk';
  static const pregnancy = '/pregnancy';
  static const privacy = '/settings/privacy';
  static const pin = '/settings/pin';
  static const appearance = '/settings/appearance';
  static const notifications = '/settings/notifications';
  static const wearables = '/settings/wearables';
  static const premium = '/settings/premium';

  static String cycleDetail(String cycleId) =>
      '/cycle/${Uri.encodeComponent(cycleId)}';

  static String withDate(String route, DateTime date) {
    final value = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T').first;
    return '$route?date=$value';
  }

  static DateTime? dateFromQuery(String? value) {
    if (value == null) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }
}
