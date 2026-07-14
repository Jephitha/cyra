import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/screens/dashboard_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';

final _fakeCycles = [
  Cycle(
    id: 'test-cycle',
    startDate: DateTime.now().subtract(const Duration(days: 13)),
  ),
];

final _fakeSummary = CycleSummary(
  cycleCount: 3,
  averageLength: 28,
  minLength: 26,
  maxLength: 30,
  variabilityScore: 0.05,
  averagePeriodLength: 5,
  lastPeriodStart: DateTime.now().subtract(const Duration(days: 13)),
  nextPredictedPeriodStart: DateTime.now().add(const Duration(days: 15)),
);

final _fakePrediction = PredictionResult(
  predictedDate: DateTime.now().add(const Duration(days: 15)),
  confidenceScore: 0.85,
  variabilityScore: 0.05,
  predictionRangeStart: DateTime.now().add(const Duration(days: 13)),
  predictionRangeEnd: DateTime.now().add(const Duration(days: 17)),
  explanation: 'Based on your last 3 cycles.',
);

final _fakeInsights = DashboardInsights(
  weeklySummary: 'You are in the follicular phase.',
  nextPeriod: _fakePrediction,
  currentPhase: CyclePhase.follicular,
  regularity: CycleRegularityResult(
    regularity: CycleRegularity.regular,
    coefficientOfVariation: 0.05,
    standardDeviation: 1.4,
  ),
  topSymptoms: [],
  fertileWindow: null,
  healthTips: null,
);

Widget _createEmptyApp() {
  return ProviderScope(
    overrides: [allCyclesProvider.overrideWith((ref) async => [])],
    child: const MaterialApp(home: DashboardScreen()),
  );
}

Widget _createPopulatedApp() {
  return ProviderScope(
    overrides: [
      allCyclesProvider.overrideWith((ref) async => _fakeCycles),
      activeCycleProvider.overrideWith((ref) async => _fakeCycles.first),
      cycleSummaryProvider.overrideWith((ref) async => _fakeSummary),
      nextPeriodPredictionProvider.overrideWith((ref) async => _fakePrediction),
      dashboardInsightsProvider.overrideWith((ref) async => _fakeInsights),
    ],
    child: const MaterialApp(home: DashboardScreen()),
  );
}

void main() {
  group('DashboardScreen empty state', () {
    testWidgets('shows welcome message and log button when no cycles exist', (
      tester,
    ) async {
      await tester.pumpWidget(_createEmptyApp());
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Cyra!'), findsOneWidget);
      expect(find.text('Log Period'), findsOneWidget);
      expect(find.text('Explore Calendar'), findsOneWidget);
    });

    testWidgets('tapping Log Your Period navigates to LogPeriodScreen', (
      tester,
    ) async {
      await tester.pumpWidget(_createEmptyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Period'));
      await tester.pumpAndSettle();

      expect(find.byType(LogPeriodScreen), findsOneWidget);
    });
  });

  group('DashboardScreen populated state', () {
    testWidgets('renders without crashing when data is loaded', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('displays cycle day information', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('of your cycle'), findsOneWidget);
    });

    testWidgets('displays prediction card', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Next period predicted'), findsOneWidget);
      expect(find.byIcon(Icons.sync_rounded), findsWidgets);
    });

    testWidgets('displays cycle overview section', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Cycle Overview'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Cycle Overview'), findsOneWidget);
    });

    testWidgets('displays health stats grid', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('Cycle Day'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('Cycle Day'), findsOneWidget);
      expect(find.textContaining('Cycle Length'), findsOneWidget);
      expect(find.textContaining('Period Length'), findsOneWidget);
      expect(find.textContaining('Variability'), findsOneWidget);
    });

    testWidgets('displays log today card', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Log today'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Log today'), findsOneWidget);
    });
  });
}
