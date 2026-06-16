import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/features/cycle/models/cycle.dart';

part 'report_models.freezed.dart';
part 'report_models.g.dart';

@freezed
class HealthReport with _$HealthReport {
  const factory HealthReport({
    required String id,
    required String reportType,
    required DateTime dateRangeStart,
    required DateTime dateRangeEnd,
    String? filePath,
    int? fileSize,
    @Default(false) bool isGenerated,
    DateTime? createdAt,
  }) = _HealthReport;

  factory HealthReport.fromJson(Map<String, dynamic> json) =>
      _$HealthReportFromJson(json);
}

@freezed
class SymptomEntry with _$SymptomEntry {
  const factory SymptomEntry({
    required String id,
    required String name,
    required String category,
    required DateTime loggedAt,
    @Default(0) int severity,
    String? notes,
  }) = _SymptomEntry;

  factory SymptomEntry.fromJson(Map<String, dynamic> json) =>
      _$SymptomEntryFromJson(json);
}

@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    required DateTime generatedAt,
    required DateTime dateRangeStart,
    required DateTime dateRangeEnd,
    required int totalCycles,
    required double averageCycleLength,
    required double averagePeriodLength,
    required double variabilityScore,
    required List<Cycle> cycles,
    required List<SymptomEntry> symptoms,
    String? fertilitySummary,
    String? notes,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
}
