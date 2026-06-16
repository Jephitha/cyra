import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/reports/models/report_models.dart';
import 'package:cyra/features/reports/repositories/report_repository.dart';

part 'report_providers.g.dart';

@Riverpod(keepAlive: true)
ReportRepository reportRepository(ReportRepositoryRef ref) {
  return ReportRepository(
    ref.watch(db.appDatabaseProvider),
    ref.watch(encryptionServiceProvider),
  );
}

@riverpod
Future<List<HealthReport>> allReports(AllReportsRef ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getAllReports();
}

@riverpod
Future<HealthReport?> reportById(ReportByIdRef ref, String id) async {
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getReport(id);
}

@riverpod
class ReportGenerator extends _$ReportGenerator {
  @override
  Future<void> build() => Future.value();

  Future<File> generateCycleSummary(
      DateTime start, DateTime end) async {
    final repo = ref.read(reportRepositoryProvider);
    final file = await repo.generateCycleSummaryReport(start, end);
    ref.invalidate(allReportsProvider);
    return file;
  }

  Future<File> generateFertilityReport(
      DateTime start, DateTime end) async {
    final repo = ref.read(reportRepositoryProvider);
    final file = await repo.generateFertilityReport(start, end);
    ref.invalidate(allReportsProvider);
    return file;
  }

  Future<File> generateSymptomReport(
      DateTime start, DateTime end) async {
    final repo = ref.read(reportRepositoryProvider);
    final file = await repo.generateSymptomReport(start, end);
    ref.invalidate(allReportsProvider);
    return file;
  }

  Future<File> generateFullHistory() async {
    final repo = ref.read(reportRepositoryProvider);
    final file = await repo.generateFullHistoryReport();
    ref.invalidate(allReportsProvider);
    return file;
  }

  Future<void> deleteReport(String id) async {
    final repo = ref.read(reportRepositoryProvider);
    await repo.deleteReport(id);
    ref.invalidate(allReportsProvider);
  }
}
