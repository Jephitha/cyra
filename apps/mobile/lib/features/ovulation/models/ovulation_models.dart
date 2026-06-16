import 'package:freezed_annotation/freezed_annotation.dart';

part 'ovulation_models.freezed.dart';
part 'ovulation_models.g.dart';

enum BBTMeasurementMethod { oral, vaginal, armpit, wearable }

enum OPKResult { negative, positive, fading }

enum CervicalMucusType { dry, sticky, creamy, eggWhite, watery }

enum CervicalPosition { low, medium, high }

@freezed
class FertileWindow with _$FertileWindow {
  const factory FertileWindow({
    required DateTime windowStart,
    required DateTime windowEnd,
    DateTime? ovulationDate,
    @Default(0.0) double ovulationProbability,
    @Default(false) bool isInWindow,
    int? currentDayOfWindow,
    String? explanation,
  }) = _FertileWindow;

  factory FertileWindow.fromJson(Map<String, dynamic> json) =>
      _$FertileWindowFromJson(json);
}

@freezed
class OvulationResult with _$OvulationResult {
  const factory OvulationResult({
    DateTime? confirmedOvulationDate,
    DateTime? estimatedOvulationDate,
    @Default(false) bool isConfirmed,
    @Default(0.0) double confidence,
    String? method,
    String? explanation,
  }) = _OvulationResult;

  factory OvulationResult.fromJson(Map<String, dynamic> json) =>
      _$OvulationResultFromJson(json);
}

@freezed
class ConceptionLikelihood with _$ConceptionLikelihood {
  const factory ConceptionLikelihood({
    @Default(0.0) double likelihood,
    String? explanation,
    @Default([]) List<String> recommendations,
  }) = _ConceptionLikelihood;

  factory ConceptionLikelihood.fromJson(Map<String, dynamic> json) =>
      _$ConceptionLikelihoodFromJson(json);
}
