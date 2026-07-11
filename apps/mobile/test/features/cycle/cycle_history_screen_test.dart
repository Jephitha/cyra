import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/screens/cycle_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _appWithCycles(List<Cycle> cycles) => ProviderScope(
  overrides: [allCyclesProvider.overrideWith((ref) async => cycles)],
  child: const MaterialApp(home: CycleHistoryScreen()),
);

void main() {
  testWidgets('shows an honest empty state when no cycles are stored', (
    tester,
  ) async {
    await tester.pumpWidget(_appWithCycles([]));
    await tester.pumpAndSettle();

    expect(find.text('No cycles tracked yet'), findsOneWidget);
    expect(find.text('Log Your First Period'), findsOneWidget);
  });

  testWidgets('renders stored cycle dates and summary values', (tester) async {
    await tester.pumpWidget(
      _appWithCycles([
        Cycle(
          id: 'real-cycle-id',
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 28),
          cycleLength: 28,
          periodLength: 4,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 tracked cycles'), findsOneWidget);
    expect(find.text('Jun 1 – Jun 28'), findsOneWidget);
    expect(find.text('28 days • Period 4 days'), findsOneWidget);
  });
}
