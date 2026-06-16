import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';

part 'cycle_providers.g.dart';

@Riverpod(keepAlive: true)
CycleRepository cycleRepository(CycleRepositoryRef ref) {
  return CycleRepository(
    ref.watch(db.appDatabaseProvider),
    ref.watch(encryptionServiceProvider),
  );
}

@riverpod
Future<List<Cycle>> allCycles(AllCyclesRef ref) async {
  final repo = ref.watch(cycleRepositoryProvider);
  return repo.getAllCycles();
}

@riverpod
Future<Cycle?> activeCycle(ActiveCycleRef ref) async {
  final repo = ref.watch(cycleRepositoryProvider);
  return repo.getActiveCycle();
}

@riverpod
Future<CycleSummary> cycleSummary(CycleSummaryRef ref) async {
  final repo = ref.watch(cycleRepositoryProvider);
  return repo.getCycleSummary();
}

@riverpod
Future<PredictionResult> nextPeriodPrediction(
    NextPeriodPredictionRef ref) async {
  final repo = ref.watch(cycleRepositoryProvider);
  return repo.predictNextPeriod();
}

@riverpod
Future<List<CycleDay>> cycleDays(CycleDaysRef ref, String cycleId) async {
  final repo = ref.watch(cycleRepositoryProvider);
  return repo.getCycleDays(cycleId);
}

@riverpod
Future<CycleDay?> cycleDayForDate(CycleDayForDateRef ref, DateTime date) async {
  final repo = ref.watch(cycleRepositoryProvider);
  return repo.getCycleDay(date);
}

@riverpod
class FlowLogger extends _$FlowLogger {
  @override
  Future<void> build() => Future.value();

  Future<void> logPeriodStart(DateTime date, {int? flow}) async {
    final repo = ref.read(cycleRepositoryProvider);
    await repo.logPeriodStart(date, flowIntensity: flow);
    ref.invalidate(allCyclesProvider);
    ref.invalidate(activeCycleProvider);
    ref.invalidate(cycleSummaryProvider);
    ref.invalidate(nextPeriodPredictionProvider);
  }

  Future<void> logPeriodEnd(DateTime date) async {
    final repo = ref.read(cycleRepositoryProvider);
    await repo.logPeriodEnd(date);
    ref.invalidate(allCyclesProvider);
    ref.invalidate(activeCycleProvider);
    ref.invalidate(cycleSummaryProvider);
  }

  Future<void> saveDayData(DateTime date, CycleDay day) async {
    final repo = ref.read(cycleRepositoryProvider);
    await repo.saveCycleDay(day);
    ref.invalidate(cycleDayForDateProvider(date));
  }
}
