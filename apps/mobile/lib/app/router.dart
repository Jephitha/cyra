import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cyra/app/app_routes.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';
import 'package:cyra/features/auth/screens/onboarding_screen.dart';
import 'package:cyra/features/auth/screens/lock_screen.dart';
import 'package:cyra/features/auth/screens/privacy_setup_screen.dart';
import 'package:cyra/features/auth/screens/emergency_lock_screen.dart';
import 'package:cyra/features/auth/screens/pin_setup_screen.dart';
import 'package:cyra/features/auth/screens/sign_in_screen.dart';
import 'package:cyra/features/community/screens/community_hub_screen.dart';
import 'package:cyra/features/cycle/screens/dashboard_screen.dart' as cycle;
import 'package:cyra/features/cycle/screens/calendar_screen.dart' as cycle;
import 'package:cyra/features/cycle/screens/cycle_detail_screen.dart';
import 'package:cyra/features/cycle/screens/cycle_history_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';
import 'package:cyra/features/cycle/screens/prediction_detail_screen.dart';
import 'package:cyra/features/insights/screens/insights_hub_screen.dart';
import 'package:cyra/features/ovulation/screens/log_bbt_screen.dart';
import 'package:cyra/features/ovulation/screens/log_mucus_screen.dart';
import 'package:cyra/features/ovulation/screens/log_opk_screen.dart';
import 'package:cyra/features/ovulation/screens/ovulation_dashboard_screen.dart';
import 'package:cyra/features/pregnancy/screens/pregnancy_dashboard_screen.dart';
import 'package:cyra/features/settings/screens/settings_screen.dart'
    as settings;
import 'package:cyra/features/settings/screens/appearance_screen.dart';
import 'package:cyra/features/settings/screens/notifications_screen.dart';
import 'package:cyra/features/subscriptions/paywall_screen.dart';
import 'package:cyra/features/symptoms/screens/log_symptom_screen.dart';
import 'package:cyra/features/wearables/screens/wearables_hub_screen.dart';
import 'package:cyra/features/privacy/screens/privacy_controls_screen.dart';

/// Tells GoRouter to re-evaluate redirects when auth/onboarding/emergency state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _authSub = _ref.listen(
      authStateNotifierProvider,
      (_, __) => notifyListeners(),
    );
    _onBoardSub = _ref.listen(
      onboardingStateProvider,
      (_, __) => notifyListeners(),
    );
    _emergencySub = _ref.listen(
      isEmergencyLockedProvider,
      (_, __) => notifyListeners(),
    );
    _settingsSub = _ref.listen(
      appSettingsNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription _authSub;
  late final ProviderSubscription _onBoardSub;
  late final ProviderSubscription _emergencySub;
  late final ProviderSubscription _settingsSub;

  @override
  void dispose() {
    _authSub.close();
    _onBoardSub.close();
    _emergencySub.close();
    _settingsSub.close();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final goRefresh = _RouterRefresh(ref);

  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    refreshListenable: goRefresh,
    redirect: (context, state) {
      final location = state.uri.toString();

      final authState = ref.read(authStateNotifierProvider);
      final isEmergencyLocked = ref.read(isEmergencyLockedProvider);
      final settings = ref.read(appSettingsNotifierProvider).valueOrNull ?? {};
      final ovulationTrackingEnabled =
          (settings['feature_bbt'] ?? 'true') == 'true' ||
          (settings['feature_mucus'] ?? 'true') == 'true' ||
          (settings['feature_opk'] ?? 'true') == 'true';
      final ovulationPathBlocked =
          state.uri.path == AppRoutes.ovulation ||
          state.uri.path == AppRoutes.logBbt ||
          state.uri.path == AppRoutes.logMucus ||
          state.uri.path == AppRoutes.logOpk;

      if (isEmergencyLocked) {
        if (location != AppRoutes.emergencyLock) return AppRoutes.emergencyLock;
        return null;
      }

      if (!ovulationTrackingEnabled && ovulationPathBlocked) {
        return AppRoutes.dashboard;
      }

      if (authState == AuthStatus.locked) {
        if (state.uri.path != AppRoutes.lock) {
          return Uri(
            path: AppRoutes.lock,
            queryParameters: {'continue': location},
          ).toString();
        }
        return null;
      }

      if (authState == AuthStatus.unauthenticated) {
        final onboardingComplete = ref.read(onboardingStateProvider);
        if (!onboardingComplete) {
          if (location != AppRoutes.onboarding) return AppRoutes.onboarding;
          return null;
        }
        if (location != AppRoutes.privacySetup) return AppRoutes.privacySetup;
        return null;
      }

      if (authState == AuthStatus.authenticated) {
        if (location == '/' ||
            location == '/onboarding' ||
            location == '/privacy-setup' ||
            state.uri.path == AppRoutes.lock) {
          return state.uri.queryParameters['continue'] ?? AppRoutes.dashboard;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacySetup,
        builder: (_, __) => const PrivacySetupScreen(),
      ),
      GoRoute(path: AppRoutes.lock, builder: (_, __) => const LockScreen()),
      GoRoute(
        path: AppRoutes.emergencyLock,
        builder: (_, __) => const EmergencyLockScreen(),
      ),
      GoRoute(path: AppRoutes.signIn, builder: (_, __) => const SignInScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            MainShell(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (_, __) => const cycle.DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            builder: (_, __) => const cycle.CalendarScreen(),
          ),
          GoRoute(
            path: AppRoutes.insights,
            builder: (_, __) => const InsightsHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.community,
            builder: (_, __) => const CommunityHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const settings.SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.privacy,
            builder: (_, __) => const PrivacyControlsScreen(),
          ),
          GoRoute(
            path: AppRoutes.pin,
            builder: (_, __) => const PinSetupScreen(),
          ),
          GoRoute(
            path: AppRoutes.logPeriod,
            builder: (_, state) => LogPeriodScreen(
              initialDate: AppRoutes.dateFromQuery(
                state.uri.queryParameters['date'],
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.cycleHistory,
            builder: (_, __) => const CycleHistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.predictionDetail,
            builder: (_, __) => const PredictionDetailScreen(),
          ),
          GoRoute(
            path: '/cycle/:cycleId',
            builder: (_, state) =>
                CycleDetailScreen(cycleId: state.pathParameters['cycleId']!),
          ),
          GoRoute(
            path: AppRoutes.logSymptoms,
            builder: (_, state) => LogSymptomScreen(
              initialDate: AppRoutes.dateFromQuery(
                state.uri.queryParameters['date'],
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.ovulation,
            builder: (_, __) => const OvulationDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.logBbt,
            builder: (_, state) => LogBBTScreen(
              initialDate: AppRoutes.dateFromQuery(
                state.uri.queryParameters['date'],
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.logMucus,
            builder: (_, state) => LogMucusScreen(
              initialDate: AppRoutes.dateFromQuery(
                state.uri.queryParameters['date'],
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.logOpk,
            builder: (_, state) => LogOPKScreen(
              initialDate: AppRoutes.dateFromQuery(
                state.uri.queryParameters['date'],
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.pregnancy,
            builder: (_, __) => const PregnancyDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.appearance,
            builder: (_, __) => const AppearanceScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (_, __) => const NotificationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.wearables,
            builder: (_, __) => const WearablesHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.premium,
            builder: (_, __) => const PaywallScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, __) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
  ref.onDispose(() {
    router.dispose();
    goRefresh.dispose();
  });
  return router;
});

class MainShell extends StatelessWidget {
  final String location;
  final Widget child;

  const MainShell({super.key, required this.location, required this.child});

  int get _currentIndex {
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/insights')) return 2;
    if (location.startsWith('/community')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/calendar');
      case 2:
        context.go('/insights');
      case 3:
        context.go('/community');
      case 4:
        context.go('/settings');
    }
  }

  bool get _isRootTabRoute {
    final path = Uri.parse(location).path;
    return path == AppRoutes.dashboard ||
        path == AppRoutes.calendar ||
        path == AppRoutes.insights ||
        path == AppRoutes.community ||
        path == AppRoutes.settings;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: !_isRootTabRoute || _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !_isRootTabRoute || _currentIndex == 0) return;
        context.go(AppRoutes.dashboard);
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => _onTabTapped(context, index),
          backgroundColor: isDark ? AppColors.charcoal : AppColors.onBrand,
          indicatorColor: AppColors.forestGreen.withValues(alpha: 0.15),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outline_rounded),
              selectedIcon: Icon(Icons.lightbulb_rounded),
              label: 'Insights',
            ),
            NavigationDestination(
              icon: Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum),
              label: 'Community',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
