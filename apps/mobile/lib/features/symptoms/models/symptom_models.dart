import 'package:freezed_annotation/freezed_annotation.dart';

part 'symptom_models.freezed.dart';
part 'symptom_models.g.dart';

@freezed
class SymptomEntry with _$SymptomEntry {
  const factory SymptomEntry({
    required String id,
    required DateTime date,
    required String symptomId,
    required String symptomName,
    @Default(1) int severity,
    String? notes,
    String? category,
    DateTime? createdAt,
  }) = _SymptomEntry;

  factory SymptomEntry.fromJson(Map<String, dynamic> json) =>
      _$SymptomEntryFromJson(json);
}

@freezed
class SymptomPattern with _$SymptomPattern {
  const factory SymptomPattern({
    required String symptomId,
    required String symptomName,
    @Default(0) int frequency,
    @Default(0.0) double averageSeverity,
    @Default([]) List<int> commonCycleDays,
    String? correlation,
  }) = _SymptomPattern;

  factory SymptomPattern.fromJson(Map<String, dynamic> json) =>
      _$SymptomPatternFromJson(json);
}

@freezed
class MoodEntry with _$MoodEntry {
  const factory MoodEntry({
    required String id,
    required DateTime date,
    @Default(3) int moodRating,
    String? notes,
    DateTime? createdAt,
  }) = _MoodEntry;

  factory MoodEntry.fromJson(Map<String, dynamic> json) =>
      _$MoodEntryFromJson(json);
}
