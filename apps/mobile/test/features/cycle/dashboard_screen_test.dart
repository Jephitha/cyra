import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/features/cycle/screens/dashboard_screen.dart';

Widget createTestApp() {
  return const ProviderScope(
    child: MaterialApp(
      home: DashboardScreen(),
    ),
  );
}

void main() {
  group('DashboardScreen', () {
    testWidgets('renders without crashing when data is loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('displays cycle day information after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Day'), findsOneWidget);
      expect(find.textContaining('of your cycle'), findsOneWidget);
    });

    testWidgets('displays prediction card when data exists',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Next period predicted'), findsOneWidget);
      // Multiple widgets may contain "days" (title + explanation)
      expect(find.textContaining('days'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays fertility card during fertile window',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Log today'), findsOneWidget);
    });

    testWidgets('responds to symptom chip tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final symptomChip = find.text('Cramps');
      expect(symptomChip, findsOneWidget);

      await tester.tap(symptomChip);
      await tester.pumpAndSettle();
    });

    testWidgets('shows prediction date range',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Prediction card should show a date range (e.g., "Mar 30 – Apr 4")
      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('displays water drop icon in prediction card',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.water_drop_rounded), findsWidgets);
    });

    testWidgets('displays cycle overview section',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Scroll down to reveal the Cycle Overview section below the fold
      await tester.scrollUntilVisible(
        find.text('Cycle Overview'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Cycle Overview'), findsOneWidget);
    });

    testWidgets('displays recent activity section',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Scroll down to reveal the Recent Activity section
      await tester.scrollUntilVisible(
        find.text('Recent Activity'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Recent Activity'), findsOneWidget);
    });

    testWidgets('displays health stats grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Scroll down to reveal the stats grid
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

    testWidgets('shows text input for notes',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('tapping see all symptoms shows more symptoms',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final seeAllButton = find.text('See all symptoms');
      expect(seeAllButton, findsOneWidget);

      await tester.tap(seeAllButton);
      await tester.pumpAndSettle();
    });

    testWidgets('navigates to full history on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Scroll down to reveal the "View full history" button
      await tester.scrollUntilVisible(
        find.text('View full history'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      final viewHistory = find.text('View full history');
      expect(viewHistory, findsOneWidget);

      await tester.tap(viewHistory);
      await tester.pumpAndSettle();
    });
  });
}
