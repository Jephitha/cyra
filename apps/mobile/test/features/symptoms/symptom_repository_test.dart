import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/repositories/symptom_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_database.dart';

void main() {
  group('SymptomRepository with in-memory Drift', () {
    late AppDatabase database;
    late EncryptionService encryption;
    late SymptomRepository repository;

    setUp(() async {
      database = createInMemoryDatabase();
      encryption = await createTestEncryptionService();
      repository = SymptomRepository(database, encryption);
      await database
          .into(database.symptoms)
          .insert(
            SymptomsCompanion.insert(
              id: 'cramps',
              name: 'Cramps',
              category: 'pain',
              iconName: 'healing',
              colorHex: '#000000',
              predefinedOptions: '[]',
              createdAt: DateTime(2026, 1, 1),
            ),
          );
    });

    tearDown(() => database.close());

    test('creates, decrypts, updates, and deletes a symptom entry', () async {
      final entry = SymptomEntry(
        id: 'log-1',
        date: DateTime(2026, 3, 5, 9),
        symptomId: 'cramps',
        symptomName: 'Cramps',
        severity: 2,
        notes: 'private symptom note',
      );

      await repository.createSymptomEntry(entry);

      final stored = await database.select(database.symptomLogs).getSingle();
      expect(stored.notes, isNot(entry.notes));
      expect((await repository.getSymptomEntry(entry.id))?.notes, entry.notes);

      await repository.updateSymptomEntry(entry.copyWith(severity: 4));
      expect((await repository.getSymptomEntry(entry.id))?.severity, 4);

      await repository.deleteSymptomEntry(entry.id);
      expect(await repository.getSymptomEntry(entry.id), isNull);
    });

    test('date and range queries return only matching records', () async {
      for (var day = 1; day <= 3; day++) {
        await repository.createSymptomEntry(
          SymptomEntry(
            id: 'log-$day',
            date: DateTime(2026, 4, day, 10),
            symptomId: 'cramps',
            symptomName: 'Cramps',
          ),
        );
      }

      expect(
        await repository.getSymptomsForDate(DateTime(2026, 4, 2)),
        hasLength(1),
      );
      expect(
        await repository.getSymptomsInRange(
          DateTime(2026, 4, 1),
          DateTime(2026, 4, 2, 23, 59),
        ),
        hasLength(2),
      );
    });
  });
}
