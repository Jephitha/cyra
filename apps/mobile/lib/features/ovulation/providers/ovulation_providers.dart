import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/fertility/models/fertility_models.dart';
import 'package:cyra/features/fertility/repositories/fertility_repository.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/mucus_observation.dart';
import 'package:cyra/features/ovulation/repositories/ovulation_repository.dart';

part 'ovulation_providers.g.dart';

@Riverpod(keepAlive: true)
OvulationRepository ovulationRepository(OvulationRepositoryRef ref) {
  return OvulationRepository(ref.watch(db.appDatabaseProvider));
}

@Riverpod(keepAlive: true)
FertilityRepository fertilityRepository(FertilityRepositoryRef ref) {
  return FertilityRepository(ref.watch(db.appDatabaseProvider));
}

@riverpod
Future<FertileWindow> fertileWindow(FertileWindowRef ref) async {
  final repo = ref.watch(ovulationRepositoryProvider);
  final activeCycle = await ref.watch(activeCycleProvider.future);
  if (activeCycle == null) {
    throw Exception('No active cycle. Start logging your cycle first.');
  }
  return repo.calculateFertileWindow(
    lastPeriodStart: activeCycle.startDate,
    cycleLength: activeCycle.cycleLength,
  );
}

@riverpod
Future<OvulationResult> ovulationDetection(OvulationDetectionRef ref) async {
  final repo = ref.watch(ovulationRepositoryProvider);
  final activeCycle = await ref.watch(activeCycleProvider.future);
  if (activeCycle == null) {
    throw Exception('No active cycle. Start logging your cycle first.');
  }

  final bbtData = await repo.getBBTForCycle(activeCycle.id);
  final opkData = await repo.getOPKRange(
    activeCycle.startDate,
    activeCycle.endDate ?? DateTime.now(),
  );
  final mucusData = await repo.getMucusRange(
    activeCycle.startDate,
    activeCycle.endDate ?? DateTime.now(),
  );

  return repo.detectOvulation(
    cycles: [activeCycle],
    bbtRecords: bbtData,
    opkResults: opkData,
    mucusObservations: mucusData,
  );
}

@riverpod
Future<ConceptionLikelihood> conceptionLikelihood(
  ConceptionLikelihoodRef ref,
) async {
  final activeCycle = await ref.watch(activeCycleProvider.future);
  if (activeCycle == null) {
    throw Exception('No active cycle. Start logging your cycle first.');
  }

  final now = DateTime.now();
  final cycleDay = now.difference(activeCycle.startDate).inDays + 1;
  final cycleLength = activeCycle.cycleLength;

  final ovulationRepo = ref.watch(ovulationRepositoryProvider);
  final fertilityRepo = ref.watch(fertilityRepositoryProvider);

  final mode = await fertilityRepo.getFertilityMode();
  if (mode != FertilityMode.tryingToConceive) {
    return ConceptionLikelihood(
      likelihood: 0.0,
      explanation:
          'Switch to TTC (Trying to Conceive) mode to see '
          'conception likelihood and recommendations.',
      recommendations: [],
    );
  }

  final bbtData = await ovulationRepo.getBBTForCycle(activeCycle.id);
  final opkData = await ovulationRepo.getOPKRange(
    activeCycle.startDate,
    activeCycle.endDate ?? now,
  );
  final mucusData = await ovulationRepo.getMucusRange(
    activeCycle.startDate,
    activeCycle.endDate ?? now,
  );

  final detection = await ovulationRepo.detectOvulation(
    cycles: [activeCycle],
    bbtRecords: bbtData,
    opkResults: opkData,
    mucusObservations: mucusData,
  );

  final lastIntercourse = await fertilityRepo.getLatestIntercourseLog();

  return ovulationRepo.calculateConceptionLikelihood(
    cycleDay: cycleDay,
    cycleLength: cycleLength,
    ovulationConfirmed: detection.isConfirmed,
    lastIntercourseDate: lastIntercourse?.date,
  );
}

@riverpod
class FertilityModeSetting extends _$FertilityModeSetting {
  @override
  FertilityMode build() => FertilityMode.notPlanning;

  Future<void> load() async {
    final repo = ref.read(fertilityRepositoryProvider);
    state = await repo.getFertilityMode();
  }

  Future<void> set(FertilityMode mode) async {
    final repo = ref.read(fertilityRepositoryProvider);
    await repo.setFertilityMode(mode);
    state = mode;
  }
}

@riverpod
Future<List<BBTRecord>> bbtForCycle(BbtForCycleRef ref, String cycleId) async {
  final repo = ref.watch(ovulationRepositoryProvider);
  return repo.getBBTForCycle(cycleId);
}

@riverpod
Future<List<OPKTestResult>> opkForCycle(
  OpkForCycleRef ref,
  String cycleId,
) async {
  final repo = ref.watch(ovulationRepositoryProvider);
  final cycles = await ref.watch(allCyclesProvider.future);
  final cycle = cycles
      .where((candidate) => candidate.id == cycleId)
      .firstOrNull;
  if (cycle == null) return [];
  return repo.getOPKRange(cycle.startDate, cycle.endDate ?? DateTime.now());
}

@riverpod
Future<List<MucusObservation>> mucusForCycle(
  MucusForCycleRef ref,
  String cycleId,
) async {
  final repo = ref.watch(ovulationRepositoryProvider);
  final cycles = await ref.watch(allCyclesProvider.future);
  final cycle = cycles
      .where((candidate) => candidate.id == cycleId)
      .firstOrNull;
  if (cycle == null) return [];
  return repo.getMucusRange(cycle.startDate, cycle.endDate ?? DateTime.now());
}
