import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cyra/core/design/app_colors.dart';
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
import 'package:cyra/features/insights/screens/insights_hub_screen.dart';
import 'package:cyra/features/settings/screens/settings_screen.dart' as settings;
import 'package:cyra/features/privacy/screens/privacy_controls_screen.dart';

/// Tells GoRouter to re-evaluate redirects when auth/onboarding/emergency state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _authSub = _ref.listen(authStateNotifierProvider, (_, __) => notifyListeners());
    _onBoardSub = _ref.listen(onboardingStateProvider, (_, __) => notifyListeners());
    _emergencySub = _ref.listen(isEmergencyLockedProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
  late final ProviderSubscription _authSub;
  late final ProviderSubscription _onBoardSub;
  late final ProviderSubscription _emergencySub;

  @override
  void dispose() {
    _authSub.close();
    _onBoardSub.close();
    _emergencySub.close();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final goRefresh = _RouterRefresh(ref);

  return GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: goRefresh,
    redirect: (context, state) {
      final location = state.uri.toString();

      final authState = ref.read(authStateNotifierProvider);
      final isEmergencyLocked = ref.read(isEmergencyLockedProvider);

      if (isEmergencyLocked) {
        if (location != '/emergency-lock') return '/emergency-lock';
        return null;
      }

      if (authState == AuthStatus.locked) {
        if (location != '/lock') return '/lock';
        return null;
      }

      if (authState == AuthStatus.unauthenticated) {
        final onboardingComplete = ref.read(onboardingStateProvider);
        if (!onboardingComplete) {
          if (location != '/onboarding') return '/onboarding';
          return null;
        }
        if (location != '/privacy-setup' && !_isPublicRoute(location)) {
          return '/privacy-setup';
        }
        return null;
      }

      if (authState == AuthStatus.authenticated) {
        if (location == '/' ||
            location == '/onboarding' ||
            location == '/privacy-setup' ||
            location == '/lock') {
          return '/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/privacy-setup',
        builder: (_, __) => const PrivacySetupScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (_, __) => const LockScreen(),
      ),
      GoRoute(
        path: '/emergency-lock',
        builder: (_, __) => const EmergencyLockScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (_, __) => const SignInScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(
          location: state.uri.toString(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const cycle.DashboardScreen(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (_, __) => const cycle.CalendarScreen(),
          ),
          GoRoute(
            path: '/insights',
            builder: (_, __) => const InsightsHubScreen(),
          ),
          GoRoute(
            path: '/community',
            builder: (_, __) => const CommunityHubScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const settings.SettingsScreen(),
          ),
          GoRoute(
            path: '/settings/privacy',
            builder: (_, __) => const PrivacyControlsScreen(),
          ),
          GoRoute(
            path: '/settings/pin',
            builder: (_, __) => const PinSetupScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, __) => const Scaffold(
      body: Center(child: Text('Page not found')),
    ),
  );
});

bool _isPublicRoute(String location) {
  const publicRoutes = <String>{
    '/onboarding',
    '/privacy-setup',
    '/lock',
    '/emergency-lock',
    '/sign-in',
  };
  return publicRoutes.contains(location);
}

class MainShell extends StatelessWidget {
  final String location;
  final Widget child;

  const MainShell({
    super.key,
    required this.location,
    required this.child,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => _onTabTapped(context, index),
        backgroundColor: isDark ? AppColors.charcoal : Colors.white,
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
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
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
    );
  }
}
