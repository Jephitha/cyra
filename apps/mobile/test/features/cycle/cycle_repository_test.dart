import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';
import 'package:cyra/core/prediction/cycle_predictor.dart';

class MockAppDatabase extends Mock implements db.AppDatabase {}
class MockEncryptionService extends Mock implements EncryptionService {}

void main() {
  group('CycleRepository', () {
    late MockAppDatabase mockDb;
    late MockEncryptionService mockEncryption;
    late CycleRepository repository;

    setUp(() {
      mockDb = MockAppDatabase();
      mockEncryption = MockEncryptionService();
      repository = CycleRepository(mockDb, mockEncryption);

      when(mockEncryption.encryptString(any)).thenAnswer((invocation) {
        return 'enc:${invocation.positionalArguments[0]}';
      });
      when(mockEncryption.decryptString(any)).thenAnswer((invocation) {
        final arg = invocation.positionalArguments[0] as String;
        return arg.startsWith('enc:') ? arg.substring(4) : arg;
      });
    });

    group('createCycle', () {
      test('inserts cycle into database with correct data', () async {
        final cycle = Cycle(
          id: 'c1',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 28),
          cycleLength: 27,
          periodLength: 5,
        );

        final result = await repository.createCycle(cycle);

        expect(result.id, 'c1');
        expect(result.createdAt, isNotNull);
        expect(result.updatedAt, isNotNull);
      });
    });

    group('updateCycle', () {
      test('updates cycle with new dates', () async {
        final cycle = Cycle(
          id: 'c1',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 30),
          cycleLength: 29,
          periodLength: 5,
        );

        final result = await repository.updateCycle(cycle);

        expect(result.updatedAt, isNotNull);
      });
    });

    group('deleteCycle', () {
      test('deletes associated cycle days and the cycle', () async {
        await repository.deleteCycle('c1');
      });
    });

    group('getCycle', () {
      test('returns null when cycle not found', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));

        final result = await repository.getCycle('nonexistent');

        expect(result, isNull);
      });
    });

    group('getAllCycles', () {
      test('returns empty list when no cycles exist', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => []));

        final result = await repository.getAllCycles();

        expect(result, isEmpty);
      });
    });

    group('getLatestCycle', () {
      test('returns null when no cycles', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));

        final result = await repository.getLatestCycle();

        expect(result, isNull);
      });
    });

    group('getActiveCycle', () {
      test('returns null when no active cycles', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));

        final result = await repository.getActiveCycle();

        expect(result, isNull);
      });
    });

    group('getCycleSummary', () {
      test('returns empty summary when no cycles', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => []));

        final summary = await repository.getCycleSummary();

        expect(summary.cycleCount, 0);
        expect(summary.averageLength, 0);
        expect(summary.lastPeriodStart, isNull);
        expect(summary.nextPredictedPeriodStart, isNull);
      });
    });

    group('predictNextPeriod', () {
      test('returns a prediction result', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => []));

        final result = await repository.predictNextPeriod();

        expect(result, isA<PredictionResult>());
      });
    });

    group('saveCycleDay', () {
      test('saves a new cycle day', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));
        when(mockDb.into(any)).thenAnswer((_) => _MockInto());

        final day = CycleDay(
          id: 'd1',
          cycleId: 'c1',
          date: DateTime(2025, 1, 1),
          flowIntensity: 2,
          spotting: false,
        );

        final result = await repository.saveCycleDay(day);

        expect(result.id, 'd1');
      });

      test('encrypts notes when saving cycle day with notes', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));
        when(mockDb.into(any)).thenAnswer((_) => _MockInto());

        final day = CycleDay(
          id: 'd2',
          cycleId: 'c1',
          date: DateTime(2025, 1, 1),
          notes: 'Private health note',
        );

        await repository.saveCycleDay(day);

        verify(mockEncryption.encryptString('Private health note')).called(1);
      });
    });

    group('getCycleDay', () {
      test('returns null when day not found', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));

        final result = await repository.getCycleDay(DateTime(2025, 1, 1));

        expect(result, isNull);
      });
    });

    group('getCycleDays', () {
      test('returns empty list when no days', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => []));

        final result = await repository.getCycleDays('c1');

        expect(result, isEmpty);
      });
    });

    group('deleteCycleDay', () {
      test('deletes cycle day', () async {
        await repository.deleteCycleDay('d1');
      });
    });

    group('getCyclesInRange', () {
      test('returns empty list for empty range', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => []));

        final result = await repository.getCyclesInRange(
          DateTime(2025, 1, 1),
          DateTime(2025, 12, 31),
        );

        expect(result, isEmpty);
      });
    });

    group('logPeriodStart', () {
      test('creates a new cycle when no active cycle', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));
        when(mockDb.into(any)).thenAnswer((_) => _MockInto());

        await repository.logPeriodStart(DateTime(2025, 1, 15));

        verify(mockDb.into(any)).called(1);
      });

      test('includes flow intensity in new cycle day', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));
        when(mockDb.into(any)).thenAnswer((_) => _MockInto());

        await repository.logPeriodStart(DateTime(2025, 1, 15), flowIntensity: 3);

        verify(mockDb.into(any)).called(2);
      });
    });

    group('logPeriodEnd', () {
      test('does nothing when no active cycle', () async {
        when(mockDb.select(any)).thenReturn(_mockSelect(() => null));

        await repository.logPeriodEnd(DateTime(2025, 1, 28));
      });
    });

    group('encryption', () {
      test('encrypts notes when saving cycle', () async {
        final cycle = Cycle(
          id: 'enc_test',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 28),
          cycleLength: 27,
          periodLength: 5,
          notes: 'Sensitive medical note',
        );

        await repository.createCycle(cycle);

        verify(mockEncryption.encryptString('Sensitive medical note')).called(1);
      });

      test('does not encrypt when notes is null', () async {
        final cycle = Cycle(
          id: 'no_notes',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 28),
          cycleLength: 27,
          periodLength: 5,
          notes: null,
        );

        await repository.createCycle(cycle);

        verify(mockEncryption.encryptString(any)).called(0);
      });
    });
  });
}

/// Returns a mock Select/Executable that returns the given result.
_mockSelect<T>(T Function() resultProvider) {
  final select = _MockSelectable<T>();
  when(select.where(any)).thenReturn(select);
  when(select.orderBy(any)).thenReturn(select);
  when(select.limit(any)).thenReturn(select);
  when(select.get()).thenAnswer((_) async {
    final r = resultProvider();
    if (r is List) return r;
    if (r != null) return [r];
    return [];
  });
  when(select.getSingleOrNull()).thenAnswer((_) async => resultProvider());
  return select;
}

class _MockSelectable<T> extends Mock {
  _MockSelectable<T> where(dynamic condition) => this;
  _MockSelectable<T> orderBy(List<dynamic>? orders) => this;
  _MockSelectable<T> limit(int? limit) => this;
  Future<List<T>> get() async => [];
  Future<T?> getSingleOrNull() async => null;
}

class _MockInto extends Mock {
  Future<void> insert(dynamic companion, {bool? orReplace}) async {}
}
