import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/core/ml/insight_service.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

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
Future<DashboardInsights> dashboardInsights(DashboardInsightsRef ref) async {
  final cycleRepo = ref.watch(cycleRepositoryProvider);
  final symptomRepo = ref.watch(symptomRepositoryProvider);
  final ovulationRepo = ref.watch(ovulationRepositoryProvider);
  final engine = ref.watch(healthInsightsEngineProvider);

  final cycles = await cycleRepo.getAllCycles();

  final ascendingCycles = cycles.reversed.toList();

  final activeCycle = cycles.isNotEmpty ? cycles.first : null;
  final recentDays = activeCycle != null
      ? await cycleRepo.getCycleDays(activeCycle.id)
      : <CycleDay>[];

  final bbtRecords = activeCycle != null
      ? await ovulationRepo.getBBTForCycle(activeCycle.id)
      : <BBTRecord>[];

  final now = DateTime.now();
  final symptoms = await symptomRepo.getSymptomsInRange(
    now.subtract(const Duration(days: 30)),
    now,
  );

  return engine.generateDashboardInsights(
    cycles: ascendingCycles,
    recentDays: recentDays,
    bbtRecords: bbtRecords,
    symptoms: symptoms,
  );
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
