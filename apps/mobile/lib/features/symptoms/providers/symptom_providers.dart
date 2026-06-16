import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/repositories/symptom_repository.dart';

part 'symptom_providers.g.dart';

@Riverpod(keepAlive: true)
SymptomRepository symptomRepository(SymptomRepositoryRef ref) {
  return SymptomRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(encryptionServiceProvider),
  );
}

@riverpod
Future<List<SymptomEntry>> todaySymptoms(TodaySymptomsRef ref) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getSymptomsForDate(DateTime.now());
}

@riverpod
Future<List<SymptomEntry>> symptomsForDate(
    SymptomsForDateRef ref, DateTime date) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getSymptomsForDate(date);
}

@riverpod
Future<List<SymptomPattern>> symptomPatterns(SymptomPatternsRef ref) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getSymptomPatterns();
}

@riverpod
Future<int> symptomStreak(SymptomStreakRef ref) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getSymptomStreak();
}

@riverpod
Future<List<SymptomEntry>> symptomsInRange(
    SymptomsInRangeRef ref, DateTime start, DateTime end) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getSymptomsInRange(start, end);
}

@riverpod
Future<MoodEntry?> moodForDate(MoodForDateRef ref, DateTime date) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getMoodForDate(date);
}

@riverpod
Future<List<MoodEntry>> moodsInRange(
    MoodsInRangeRef ref, DateTime start, DateTime end) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getMoodsInRange(start, end);
}

@riverpod
Future<Map<String, dynamic>> moodCycleCorrelation(
    MoodCycleCorrelationRef ref) async {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.getMoodCycleCorrelation();
}

@riverpod
class SymptomLogger extends _$SymptomLogger {
  @override
  Future<void> build() => Future.value();

  Future<void> saveSymptoms(List<SymptomEntry> entries) async {
    final repo = ref.read(symptomRepositoryProvider);
    for (final entry in entries) {
      await repo.createSymptomEntry(entry);
    }
    ref.invalidate(todaySymptomsProvider);
    ref.invalidate(symptomPatternsProvider);
    ref.invalidate(symptomStreakProvider);
  }

  Future<void> deleteSymptom(String id) async {
    final repo = ref.read(symptomRepositoryProvider);
    await repo.deleteSymptomEntry(id);
    ref.invalidate(todaySymptomsProvider);
    ref.invalidate(symptomPatternsProvider);
    ref.invalidate(symptomStreakProvider);
  }
}

@riverpod
class MoodLogger extends _$MoodLogger {
  @override
  Future<void> build() => Future.value();

  Future<void> saveMood(MoodEntry entry) async {
    final repo = ref.read(symptomRepositoryProvider);
    final existing = await repo.getMoodForDate(entry.date);
    if (existing != null) {
      await repo.updateMoodEntry(entry.copyWith(id: existing.id));
    } else {
      await repo.createMoodEntry(entry);
    }
    ref.invalidate(moodForDateProvider(entry.date));
    ref.invalidate(moodCycleCorrelationProvider);
  }
}
