import 'dart:io';

import 'package:cyra/core/security/health_data_pdf_renderer.dart';

Future<void> main() async {
  final output = Directory('build/pdf_previews');
  await output.create(recursive: true);
  final renderer = HealthDataPdfRenderer();
  final generatedAt = DateTime(2026, 7, 13);

  Future<void> write(
    String name,
    List<Map<String, dynamic>> records,
    DateTime start,
    DateTime end,
  ) async {
    final bytes = await renderer.render(
      records,
      HealthDataPdfRequest(
        start: start,
        end: end,
        name: 'Amina K.',
        includeDailyLog: true,
        generatedAt: generatedAt,
      ),
    );
    await File('${output.path}/$name.pdf').writeAsBytes(bytes);
  }

  await write('empty', const [], DateTime(2026, 1, 1), DateTime(2026, 7, 1));

  final minimalStart = DateTime(2026, 6, 1);
  await write(
    'minimal',
    [
      {
        'table': 'cycles',
        'id': 'cycle-1',
        'startDate': minimalStart,
        'endDate': minimalStart.add(const Duration(days: 27)),
        'cycleLength': 28,
        'periodLength': 5,
      },
      for (var day = 0; day < 5; day++)
        {
          'table': 'cycle_days',
          'id': 'day-$day',
          'cycleId': 'cycle-1',
          'date': minimalStart.add(Duration(days: day)),
          'flowIntensity': day < 2 ? 3 : 2,
        },
      {
        'table': 'symptom_logs',
        'id': 'symptom-1',
        'date': minimalStart,
        'symptomName': 'Cramps',
        'severity': 4,
      },
    ],
    minimalStart,
    DateTime(2026, 6, 30),
  );

  final substantial = <Map<String, dynamic>>[];
  for (var cycle = 0; cycle < 12; cycle++) {
    final start = DateTime(2025, 7, 1).add(Duration(days: cycle * 28));
    substantial.add({
      'table': 'cycles',
      'id': 'cycle-$cycle',
      'startDate': start,
      'endDate': start.add(const Duration(days: 27)),
      'cycleLength': 28,
      'periodLength': 5,
    });
    for (var day = 0; day < 28; day++) {
      final date = start.add(Duration(days: day));
      substantial.add({
        'table': 'cycle_days',
        'id': 'day-$cycle-$day',
        'cycleId': 'cycle-$cycle',
        'date': date,
        'flowIntensity': day < 5 ? (day % 3) + 1 : 0,
      });
      if (day % 4 == 0) {
        substantial.add({
          'table': 'symptom_logs',
          'id': 'symptom-$cycle-$day',
          'date': date,
          'symptomName': day.isEven ? 'Cramps' : 'Headache',
          'severity': (day % 5) + 1,
        });
      }
    }
  }
  await write(
    'substantial',
    substantial,
    DateTime(2025, 7, 1),
    DateTime(2026, 6, 30),
  );
}
