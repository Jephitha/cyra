import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/conditions/models/condition_models.dart';
import 'package:cyra/features/conditions/repositories/condition_repository.dart';

part 'condition_providers.g.dart';

@Riverpod(keepAlive: true)
ConditionRepository conditionRepository(ConditionRepositoryRef ref) {
  return ConditionRepository(
    ref.watch(db.appDatabaseProvider),
    ref.watch(encryptionServiceProvider),
  );
}

@riverpod
Future<List<UserCondition>> allConditions(AllConditionsRef ref) async {
  final repo = ref.watch(conditionRepositoryProvider);
  return repo.getAllConditions();
}

@riverpod
Future<List<UserCondition>> activeConditions(ActiveConditionsRef ref) async {
  final repo = ref.watch(conditionRepositoryProvider);
  return repo.getActiveConditions();
}

@riverpod
Future<UserCondition?> conditionById(ConditionByIdRef ref, String id) async {
  final repo = ref.watch(conditionRepositoryProvider);
  return repo.getCondition(id);
}

@riverpod
Future<Map<String, dynamic>> conditionPatterns(
    ConditionPatternsRef ref, String conditionType) async {
  final repo = ref.watch(conditionRepositoryProvider);
  return repo.detectPatterns(conditionType);
}

@riverpod
Future<List<String>> trackingRecommendations(
    TrackingRecommendationsRef ref, String conditionType) async {
  final repo = ref.watch(conditionRepositoryProvider);
  return Future.value(repo.getTrackingRecommendations(conditionType));
}

@riverpod
class ConditionManager extends _$ConditionManager {
  @override
  Future<void> build() => Future.value();

  Future<void> addCondition(UserCondition condition) async {
    final repo = ref.read(conditionRepositoryProvider);
    await repo.createCondition(condition);
    ref.invalidate(allConditionsProvider);
    ref.invalidate(activeConditionsProvider);
  }

  Future<void> updateCondition(UserCondition condition) async {
    final repo = ref.read(conditionRepositoryProvider);
    await repo.updateCondition(condition);
    ref.invalidate(allConditionsProvider);
    ref.invalidate(activeConditionsProvider);
    ref.invalidate(conditionByIdProvider(condition.id));
  }

  Future<void> removeCondition(String id) async {
    final repo = ref.read(conditionRepositoryProvider);
    await repo.deleteCondition(id);
    ref.invalidate(allConditionsProvider);
    ref.invalidate(activeConditionsProvider);
  }

  Future<void> toggleCondition(String id, bool isActive) async {
    final repo = ref.read(conditionRepositoryProvider);
    await repo.toggleCondition(id, isActive);
    ref.invalidate(allConditionsProvider);
    ref.invalidate(activeConditionsProvider);
    ref.invalidate(conditionByIdProvider(id));
  }
}
