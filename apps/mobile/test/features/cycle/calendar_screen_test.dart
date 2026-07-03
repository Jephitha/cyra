import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';
import 'package:cyra/features/cycle/screens/calendar_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';

final _fakeCycle = Cycle(
  id: 'test-cycle',
  startDate: DateTime.now().subtract(const Duration(days: 13)),
);

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

class _FakeCycleRepo implements CycleRepository {
  @override
  Future<Cycle?> getActiveCycle() async => _fakeCycle;

  @override
  Future<List<Cycle>> getAllCycles({int limit = 12}) async => [_fakeCycle];

  @override
  Future<CycleSummary> getCycleSummary() async => _fakeSummary;

  @override
  Future<List<CycleDay>> getCycleDays(String cycleId) async => [];

  @override
  Future<PredictionResult> predictNextPeriod() async => PredictionResult(
        predictedDate: DateTime.now().add(const Duration(days: 15)),
        confidenceScore: 0.85,
        variabilityScore: 0.05,
        predictionRangeStart: DateTime.now().add(const Duration(days: 13)),
        predictionRangeEnd: DateTime.now().add(const Duration(days: 17)),
        explanation: 'Based on your last 3 cycles.',
      );

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

Widget _createEmptyApp() {
  return ProviderScope(
    overrides: [
      activeCycleProvider.overrideWith((ref) async => null),
    ],
    child: const MaterialApp(
      home: CalendarScreen(),
    ),
  );
}

Widget _createPopulatedApp() {
  return ProviderScope(
    overrides: [
      cycleRepositoryProvider.overrideWithValue(_FakeCycleRepo()),
      activeCycleProvider.overrideWith((ref) async => _fakeCycle),
      cycleSummaryProvider.overrideWith((ref) async => _fakeSummary),
      allCyclesProvider.overrideWith((ref) async => [_fakeCycle]),
    ],
    child: const MaterialApp(
      home: CalendarScreen(),
    ),
  );
}

void main() {
  group('CalendarScreen empty state', () {
    testWidgets('shows empty state when no active cycle', (tester) async {
      await tester.pumpWidget(_createEmptyApp());
      await tester.pumpAndSettle();

      expect(find.text('No entries yet'), findsOneWidget);
      expect(find.text('Log Your Period'), findsOneWidget);
    });

    testWidgets('tapping Log Your Period navigates to LogPeriodScreen',
        (tester) async {
      await tester.pumpWidget(_createEmptyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Your Period'));
      await tester.pumpAndSettle();

      expect(find.byType(LogPeriodScreen), findsOneWidget);
    });
  });

  group('CalendarScreen populated state', () {
    testWidgets('renders calendar without crashing', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.text('Cycle Calendar'), findsOneWidget);
    });

    testWidgets('shows Today button in app bar', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('shows legend with Period, Fertile, Ovulation', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Period'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Period'), findsAtLeastNWidgets(1));
      expect(find.text('Fertile'), findsAtLeastNWidgets(1));
      expect(find.text('Ovulation'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows selected day detail with cycle day', (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('Day'),
        300,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('Day'), findsWidgets);
    });

    testWidgets('shows Log Period and Log Symptoms buttons in detail card',
        (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Log Period'),
        300,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Log Period'), findsOneWidget);
      expect(find.text('Log Symptoms'), findsOneWidget);
    });

    testWidgets('tapping Log Period navigates to LogPeriodScreen',
        (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Log Period'),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(find.text('Log Period'));
      await tester.pumpAndSettle();

      expect(find.byType(LogPeriodScreen), findsOneWidget);
    });

    testWidgets('does not use PMS jargon in phase descriptions',
        (tester) async {
      await tester.pumpWidget(_createPopulatedApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('PMS'), findsNothing);
    });
  });
}
