import 'package:cyra/core/security/health_data_pdf_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final renderer = HealthDataPdfRenderer();
  final request = HealthDataPdfRequest(
    start: DateTime(2026, 1, 1),
    end: DateTime(2026, 7, 1),
    generatedAt: DateTime(2026, 7, 13),
  );

  test('empty data produces a valid, calm empty-state PDF', () async {
    final summary = renderer.summarize(const []);
    final bytes = await renderer.render(const [], request);

    expect(summary.cycleCount, 0);
    expect(summary.averageCycleLength, isNull);
    expect(summary.symptomFrequency, isEmpty);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });

  test('one cycle is represented without inventing a trend', () async {
    final records = <Map<String, dynamic>>[
      {
        'table': 'cycles',
        'id': 'cycle-1',
        'startDate': DateTime(2026, 6, 1),
        'endDate': DateTime(2026, 6, 28),
        'cycleLength': 28,
        'periodLength': 5,
      },
      {
        'table': 'cycle_days',
        'id': 'day-1',
        'cycleId': 'cycle-1',
        'date': DateTime(2026, 6, 1),
        'flowIntensity': 3,
      },
      {
        'table': 'symptom_logs',
        'id': 'symptom-1',
        'date': DateTime(2026, 6, 1),
        'symptomName': 'Cramps',
        'severity': 4,
      },
    ];

    final summary = renderer.summarize(records);
    final bytes = await renderer.render(records, request);

    expect(summary.cycleCount, 1);
    expect(summary.averageCycleLength, 28);
    expect(summary.averagePeriodLength, 5);
    expect(summary.symptomFrequency, {'Cramps': 1});
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test(
    'substantial history wraps across PDF pages without data loss',
    () async {
      final records = <Map<String, dynamic>>[];
      for (var cycleIndex = 0; cycleIndex < 18; cycleIndex++) {
        final start = DateTime(2025, 1, 1).add(Duration(days: cycleIndex * 28));
        records.add({
          'table': 'cycles',
          'id': 'cycle-$cycleIndex',
          'startDate': start,
          'endDate': start.add(const Duration(days: 27)),
          'cycleLength': 28,
          'periodLength': 5,
        });
        for (var day = 0; day < 28; day++) {
          final date = start.add(Duration(days: day));
          records.add({
            'table': 'cycle_days',
            'id': 'day-$cycleIndex-$day',
            'cycleId': 'cycle-$cycleIndex',
            'date': date,
            'flowIntensity': day < 5 ? (day % 3) + 1 : 0,
          });
          if (day.isEven) {
            records.add({
              'table': 'symptom_logs',
              'id': 'symptom-$cycleIndex-$day',
              'date': date,
              'symptomName': day % 4 == 0 ? 'Cramps' : 'Headache',
              'severity': (day % 5) + 1,
            });
          }
        }
      }

      final summary = renderer.summarize(records);
      final bytes = await renderer.render(
        records,
        HealthDataPdfRequest(
          start: DateTime(2025, 1, 1),
          end: DateTime(2026, 6, 1),
          includeJournalEntries: true,
          generatedAt: DateTime(2026, 7, 13),
        ),
      );

      expect(summary.cycleCount, 18);
      expect(summary.dailyLogCount, 504);
      expect(summary.symptomFrequency.values.reduce((a, b) => a + b), 252);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(20000));
    },
  );
}
