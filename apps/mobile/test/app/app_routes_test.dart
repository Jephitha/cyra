import 'package:cyra/app/app_routes.dart';
import 'package:cyra/app/router.dart';
import 'package:cyra/core/navigation/navigation_intent_service.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date routes use a stable calendar-date query', () {
    final location = AppRoutes.withDate(
      AppRoutes.logPeriod,
      DateTime(2026, 7, 13, 22, 45),
    );

    expect(location, '/cycle/log-period?date=2026-07-13');
    expect(
      AppRoutes.dateFromQuery(Uri.parse(location).queryParameters['date']),
      DateTime(2026, 7, 13),
    );
    expect(AppRoutes.dateFromQuery('not-a-date'), isNull);
  });

  test(
    'navigation intents retain one cold-start route and reject non-routes',
    () {
      final service = NavigationIntentService();
      final opened = <String>[];

      service.open('not-a-route');
      service.open(AppRoutes.logPeriod);
      service.attach(opened.add);
      service.open(AppRoutes.ovulation);

      expect(opened, [AppRoutes.logPeriod, AppRoutes.ovulation]);
    },
  );

  test('GoRouter declares core log, detail, and notification destinations', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(authStateNotifierProvider.notifier).authenticate();
    final router = container.read(routerProvider);

    final locations = [
      AppRoutes.withDate(AppRoutes.logPeriod, DateTime(2026, 7, 13)),
      AppRoutes.cycleHistory,
      AppRoutes.cycleDetail('cycle-123'),
      AppRoutes.predictionDetail,
      AppRoutes.logSymptoms,
      AppRoutes.ovulation,
      AppRoutes.logBbt,
      AppRoutes.logMucus,
      AppRoutes.logOpk,
      AppRoutes.pregnancy,
      AppRoutes.notifications,
      AppRoutes.wearables,
      AppRoutes.premium,
    ];

    for (final location in locations) {
      router.go(location);
      expect(
        router.routeInformationProvider.value.uri.toString(),
        location,
        reason: location,
      );
    }
  });

  testWidgets('locked deep links preserve their destination through unlock', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(authStateNotifierProvider.notifier).lock();
    final router = container.read(routerProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go(AppRoutes.logPeriod);
    await tester.pumpAndSettle();

    var uri = router.routeInformationProvider.value.uri;
    expect(uri.path, AppRoutes.lock);
    expect(uri.queryParameters['continue'], AppRoutes.logPeriod);

    container.read(authStateNotifierProvider.notifier).authenticate();
    await tester.pumpAndSettle();

    uri = router.routeInformationProvider.value.uri;
    expect(uri.path, AppRoutes.logPeriod);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
