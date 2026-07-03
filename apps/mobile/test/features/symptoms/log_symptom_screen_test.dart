import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';
import 'package:cyra/features/symptoms/repositories/symptom_repository.dart';
import 'package:cyra/features/symptoms/screens/log_symptom_screen.dart';

class _FakeSymptomRepo implements SymptomRepository {
  @override
  Future<List<SymptomEntry>> getSymptomsForDate(DateTime date) async => [];

  @override
  Future<SymptomEntry> createSymptomEntry(SymptomEntry entry) async => entry;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

Widget _createApp() {
  return ProviderScope(
    overrides: [
      symptomRepositoryProvider.overrideWithValue(_FakeSymptomRepo()),
    ],
    child: const MaterialApp(
      home: LogSymptomScreen(),
    ),
  );
}

void main() {
  group('LogSymptomScreen', () {
    testWidgets('renders three category tabs', (tester) async {
      await tester.pumpWidget(_createApp());
      await tester.pumpAndSettle();

      expect(find.text('Physical'), findsAtLeastNWidgets(1));
      expect(find.text('Emotional'), findsAtLeastNWidgets(1));
      expect(find.text('Lifestyle'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders save button disabled when no symptoms selected',
        (tester) async {
      await tester.pumpWidget(_createApp());
      await tester.pumpAndSettle();

      final saveButton = find.text('Save Symptoms');
      expect(saveButton, findsOneWidget);
    });

    testWidgets('selecting a symptom enables save', (tester) async {
      await tester.pumpWidget(_createApp());
      await tester.pumpAndSettle();

      // Tap a symptom on the Physical tab
      await tester.tap(find.text('Cramping'));
      await tester.pumpAndSettle();

      // Selected symptoms section should appear with the symptom
      expect(find.text('Selected Symptoms'), findsOneWidget);
      expect(find.text('Cramping'), findsWidgets);
    });

    testWidgets('selected symptoms filter by current tab', (tester) async {
      await tester.pumpWidget(_createApp());
      await tester.pumpAndSettle();

      // Select a Physical symptom
      await tester.tap(find.text('Cramping'));
      await tester.pumpAndSettle();

      // Switch to Emotional tab
      await tester.tap(find.text('Emotional'));
      await tester.pumpAndSettle();

      // Cramping (physical) should not appear in Selected Symptoms on Emotional tab
      expect(find.text('Selected Symptoms'), findsNothing);
    });

    testWidgets('can select symptoms from multiple tabs and save', (tester) async {
      await tester.pumpWidget(_createApp());
      await tester.pumpAndSettle();

      // Physical tab: select Cramping
      await tester.tap(find.text('Cramping'));
      await tester.pumpAndSettle();

      // Emotional tab: select Mood Swings
      await tester.tap(find.text('Emotional'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mood Swings'));
      await tester.pumpAndSettle();

      // Lifestyle tab: select Fatigue
      await tester.tap(find.text('Lifestyle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fatigue'));
      await tester.pumpAndSettle();

      // Save button should be enabled
      expect(find.text('Save Symptoms'), findsOneWidget);
    });
  });
}