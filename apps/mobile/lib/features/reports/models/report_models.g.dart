// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthReportImpl _$$HealthReportImplFromJson(Map<String, dynamic> json) =>
    _$HealthReportImpl(
      id: json['id'] as String,
      reportType: json['reportType'] as String,
      dateRangeStart: DateTime.parse(json['dateRangeStart'] as String),
      dateRangeEnd: DateTime.parse(json['dateRangeEnd'] as String),
      filePath: json['filePath'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      isGenerated: json['isGenerated'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$HealthReportImplToJson(_$HealthReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reportType': instance.reportType,
      'dateRangeStart': instance.dateRangeStart.toIso8601String(),
      'dateRangeEnd': instance.dateRangeEnd.toIso8601String(),
      'filePath': instance.filePath,
      'fileSize': instance.fileSize,
      'isGenerated': instance.isGenerated,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$SymptomEntryImpl _$$SymptomEntryImplFromJson(Map<String, dynamic> json) =>
    _$SymptomEntryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      severity: (json['severity'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$SymptomEntryImplToJson(_$SymptomEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'severity': instance.severity,
      'notes': instance.notes,
    };

_$ReportDataImpl _$$ReportDataImplFromJson(Map<String, dynamic> json) =>
    _$ReportDataImpl(
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      dateRangeStart: DateTime.parse(json['dateRangeStart'] as String),
      dateRangeEnd: DateTime.parse(json['dateRangeEnd'] as String),
      totalCycles: (json['totalCycles'] as num).toInt(),
      averageCycleLength: (json['averageCycleLength'] as num).toDouble(),
      averagePeriodLength: (json['averagePeriodLength'] as num).toDouble(),
      variabilityScore: (json['variabilityScore'] as num).toDouble(),
      cycles: (json['cycles'] as List<dynamic>)
          .map((e) => Cycle.fromJson(e as Map<String, dynamic>))
          .toList(),
      symptoms: (json['symptoms'] as List<dynamic>)
          .map((e) => SymptomEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      fertilitySummary: json['fertilitySummary'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ReportDataImplToJson(_$ReportDataImpl instance) =>
    <String, dynamic>{
      'generatedAt': instance.generatedAt.toIso8601String(),
      'dateRangeStart': instance.dateRangeStart.toIso8601String(),
      'dateRangeEnd': instance.dateRangeEnd.toIso8601String(),
      'totalCycles': instance.totalCycles,
      'averageCycleLength': instance.averageCycleLength,
      'averagePeriodLength': instance.averagePeriodLength,
      'variabilityScore': instance.variabilityScore,
      'cycles': instance.cycles,
      'symptoms': instance.symptoms,
      'fertilitySummary': instance.fertilitySummary,
      'notes': instance.notes,
    };
