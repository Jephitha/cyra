import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/features/ovulation/models/ovulation_models.dart';

part 'bbt_record.freezed.dart';
part 'bbt_record.g.dart';

@freezed
class BBTRecord with _$BBTRecord {
  const factory BBTRecord({
    required String id,
    required DateTime date,
    required double temperature,
    @Default(BBTMeasurementMethod.oral) BBTMeasurementMethod method,
    String? timeOfDay,
    @Default(false) bool isEstimated,
    String? notes,
  }) = _BBTRecord;

  factory BBTRecord.fromJson(Map<String, dynamic> json) =>
      _$BBTRecordFromJson(json);
}
