import 'package:cyra/core/database/app_database.dart' show AppDatabase;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import '../../helpers/in_memory_database.dart';

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

  group('CycleRepository with in-memory Drift', () {
    late AppDatabase database;
    late EncryptionService encryption;
    late CycleRepository repository;

    setUp(() async {
      database = createInMemoryDatabase();
      encryption = await createTestEncryptionService();
      repository = CycleRepository(database, encryption);
    });

    tearDown(() => database.close());

    test('persists encrypted cycle notes and reads them back', () async {
      final cycle = Cycle(
        id: 'cycle-1',
        startDate: DateTime(2026, 1, 1),
        notes: 'private cycle note',
      );

      await repository.createCycle(cycle);

      final stored = await database.select(database.cycles).getSingle();
      expect(stored.notes, isNot('private cycle note'));
      expect(
        (await repository.getCycle(cycle.id))?.notes,
        'private cycle note',
      );
    });

    test(
      'cycle day upsert and cycle delete remain scoped to the cycle',
      () async {
        final cycle = Cycle(id: 'cycle-1', startDate: DateTime(2026, 2, 1));
        await repository.createCycle(cycle);
        final day = CycleDay(
          id: 'day-1',
          cycleId: cycle.id,
          date: cycle.startDate,
          flowIntensity: 2,
        );

        await repository.saveCycleDay(day);
        await repository.saveCycleDay(day.copyWith(flowIntensity: 3));

        expect(await repository.getCycleDays(cycle.id), hasLength(1));
        expect(
          (await repository.getCycleDayForCycle(
            cycle.id,
            cycle.startDate,
          ))?.flowIntensity,
          3,
        );

        await repository.deleteCycle(cycle.id);
        expect(await repository.getCycle(cycle.id), isNull);
        expect(await repository.getCycleDays(cycle.id), isEmpty);
      },
    );
  });
}
