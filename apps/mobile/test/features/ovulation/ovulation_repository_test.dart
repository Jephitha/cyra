import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/mucus_observation.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/repositories/ovulation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_database.dart';

void main() {
  group('OvulationRepository with in-memory Drift', () {
    late AppDatabase database;
    late OvulationRepository repository;

    setUp(() {
      database = createInMemoryDatabase();
      repository = OvulationRepository(database);
    });

    tearDown(() => database.close());

    test('BBT upsert preserves one reading per timestamp', () async {
      final date = DateTime(2026, 5, 1, 7);
      await repository.saveBBT(
        BBTRecord(id: 'bbt-1', date: date, temperature: 36.4),
      );
      await repository.saveBBT(
        BBTRecord(id: 'bbt-2', date: date, temperature: 36.8),
      );

      final readings = await repository.getBBTRange(
        DateTime(2026, 5, 1),
        DateTime(2026, 5, 2),
      );
      expect(readings, hasLength(1));
      expect(readings.single.temperature, 36.8);
    });

    test('OPK upsert and latest query return persisted result', () async {
      final date = DateTime(2026, 5, 2, 14);
      await repository.saveOPK(
        OPKTestResult(id: 'opk-1', date: date, result: OPKResult.negative),
      );
      await repository.saveOPK(
        OPKTestResult(id: 'opk-2', date: date, result: OPKResult.positive),
      );

      expect((await repository.getLatestOPK())?.result, OPKResult.positive);
      expect(
        await database.select(database.ovulationTests).get(),
        hasLength(1),
      );
    });

    test('mucus observation retains its observation date', () async {
      final date = DateTime(2025, 12, 20, 8);
      await repository.saveMucus(
        MucusObservation(
          id: 'mucus-1',
          date: date,
          type: CervicalMucusType.eggWhite,
          amount: 'medium',
        ),
      );

      final saved = await repository.getMucus(date);
      expect(saved, isNotNull);
      expect(saved?.date, date);
      expect(saved?.type, CervicalMucusType.eggWhite);
    });
  });
}
