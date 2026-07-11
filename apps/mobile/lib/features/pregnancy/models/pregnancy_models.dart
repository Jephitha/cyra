import 'package:freezed_annotation/freezed_annotation.dart';

part 'pregnancy_models.freezed.dart';
part 'pregnancy_models.g.dart';

@freezed
class Pregnancy with _$Pregnancy {
  const Pregnancy._();

  const factory Pregnancy({
    required String id,
    DateTime? conceptionDate,
    required DateTime dueDate,
    required int currentWeek,
    required int currentTrimester,
    @Default(true) bool isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Pregnancy;

  factory Pregnancy.fromJson(Map<String, dynamic> json) =>
      _$PregnancyFromJson(json);

  int get weeksRemaining => 40 - currentWeek;
  double get progress => currentWeek / 40.0;
  String get trimesterName => switch (currentTrimester) {
    1 => 'First Trimester',
    2 => 'Second Trimester',
    3 => 'Third Trimester',
    _ => '',
  };
}

@freezed
class FetalMeasurement with _$FetalMeasurement {
  const factory FetalMeasurement({
    required String id,
    required String pregnancyId,
    required DateTime date,
    double? weight,
    double? weightPercentile,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    double? glucoseLevel,
    int? kicksCount,
    int? kicksDurationMinutes,
    String? contractionsJson,
    String? notes,
  }) = _FetalMeasurement;

  factory FetalMeasurement.fromJson(Map<String, dynamic> json) =>
      _$FetalMeasurementFromJson(json);
}

@freezed
class WeeklyMilestone with _$WeeklyMilestone {
  const factory WeeklyMilestone({
    required int week,
    required String babySizeComparison,
    required double babyLengthCm,
    required double babyWeightG,
    required String developmentSummary,
    required String maternalChanges,
    required List<String> symptoms,
    required List<String> tips,
    String? imageAsset,
  }) = _WeeklyMilestone;
}

@freezed
class Contraction with _$Contraction {
  const factory Contraction({
    required DateTime startTime,
    required Duration duration,
    @Default(1.0) double intensity,
  }) = _Contraction;

  factory Contraction.fromJson(Map<String, dynamic> json) => _Contraction(
    startTime: DateTime.parse(json['startTime'] as String),
    duration: Duration(microseconds: json['durationMicroseconds'] as int),
    intensity: (json['intensity'] as num?)?.toDouble() ?? 1.0,
  );
}

extension ContractionX on Contraction {
  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'durationMicroseconds': duration.inMicroseconds,
    'intensity': intensity,
  };
}

@freezed
class KickLog with _$KickLog {
  const factory KickLog({
    required String id,
    required String pregnancyId,
    required DateTime date,
    required int kickCount,
    required int durationMinutes,
    bool? isNormal,
  }) = _KickLog;

  factory KickLog.fromJson(Map<String, dynamic> json) =>
      _$KickLogFromJson(json);
}
