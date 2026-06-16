import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/features/cycle/models/cycle.dart';

void main() {
  group('Cycle model', () {
    test('creates cycle with required fields', () {
      final cycle = Cycle(
        id: 'c1',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 28),
        cycleLength: 27,
        periodLength: 5,
      );

      expect(cycle.id, 'c1');
      expect(cycle.cycleLength, 27);
      expect(cycle.periodLength, 5);
    });

    test('CycleDay creates with correct fields', () {
      final day = CycleDay(
        id: 'd1',
        cycleId: 'c1',
        date: DateTime(2025, 1, 1),
        flowIntensity: 2,
        spotting: false,
      );

      expect(day.id, 'd1');
      expect(day.flowIntensity, 2);
    });
  });
}
