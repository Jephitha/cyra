import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/features/pregnancy/data/weekly_milestones.dart';
import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';
import 'package:cyra/features/pregnancy/repositories/pregnancy_repository.dart';

part 'pregnancy_providers.g.dart';

@Riverpod(keepAlive: true)
PregnancyRepository pregnancyRepository(PregnancyRepositoryRef ref) {
  return PregnancyRepository(ref.watch(db.appDatabaseProvider));
}

@riverpod
Future<Pregnancy?> currentPregnancy(CurrentPregnancyRef ref) async {
  final repo = ref.watch(pregnancyRepositoryProvider);
  return repo.getCurrentPregnancy();
}

@riverpod
Future<WeeklyMilestone> currentWeekMilestone(
    CurrentWeekMilestoneRef ref) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) throw Exception('No active pregnancy');
  return PregnancyData.getMilestone(pregnancy.currentWeek);
}

@riverpod
Future<List<FetalMeasurement>> fetalMeasurements(
    FetalMeasurementsRef ref) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) return [];
  final repo = ref.watch(pregnancyRepositoryProvider);
  return repo.getMeasurements(pregnancy.id);
}

@riverpod
Future<List<KickLog>> kickLogs(KickLogsRef ref, {DateTime? from, DateTime? to}) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) return [];
  final repo = ref.watch(pregnancyRepositoryProvider);
  return repo.getKickLogs(pregnancy.id, from: from, to: to);
}

@riverpod
double pregnancyProgress(PregnancyProgressRef ref) {
  final pregnancy = ref.watch(currentPregnancyProvider).valueOrNull;
  return pregnancy?.progress ?? 0.0;
}

@riverpod
Map<String, DateTime> pregnancyKeyDates(PregnancyKeyDatesRef ref) {
  final pregnancy = ref.watch(currentPregnancyProvider).valueOrNull;
  if (pregnancy == null) return {};
  return {
    'Due Date': pregnancy.dueDate,
    'End of First Trimester':
        pregnancy.dueDate.subtract(const Duration(days: 189)),
    'End of Second Trimester':
        pregnancy.dueDate.subtract(const Duration(days: 91)),
    'Full Term (37 weeks)':
        pregnancy.dueDate.subtract(const Duration(days: 21)),
    'Early Term (39 weeks)':
        pregnancy.dueDate.subtract(const Duration(days: 7)),
  };
}

@riverpod
Future<int> currentTrimester(CurrentTrimesterRef ref) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) throw Exception('No active pregnancy');
  return pregnancy.currentTrimester;
}

@riverpod
Future<int> weeksRemaining(WeeksRemainingRef ref) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) throw Exception('No active pregnancy');
  return pregnancy.weeksRemaining;
}

@riverpod
Future<List<WeeklyMilestone>> trimesterMilestones(
    TrimesterMilestonesRef ref) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) return [];
  return PregnancyData.getTrimesterMilestones(pregnancy.currentTrimester);
}

@riverpod
Future<FetalMeasurement?> latestMeasurement(
    LatestMeasurementRef ref) async {
  final pregnancy = await ref.watch(currentPregnancyProvider.future);
  if (pregnancy == null) return null;
  final repo = ref.watch(pregnancyRepositoryProvider);
  return repo.getLatestMeasurement(pregnancy.id);
}
