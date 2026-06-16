import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/features/ovulation/models/ovulation_models.dart';

part 'mucus_observation.freezed.dart';
part 'mucus_observation.g.dart';

@freezed
class MucusObservation with _$MucusObservation {
  const factory MucusObservation({
    required String id,
    required DateTime date,
    required CervicalMucusType type,
    String? consistency,
    String? color,
    String? amount,
  }) = _MucusObservation;

  factory MucusObservation.fromJson(Map<String, dynamic> json) =>
      _$MucusObservationFromJson(json);
}
