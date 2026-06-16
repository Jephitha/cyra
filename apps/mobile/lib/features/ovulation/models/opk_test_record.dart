import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/features/ovulation/models/ovulation_models.dart';

part 'opk_test_record.freezed.dart';
part 'opk_test_record.g.dart';

@freezed
class OPKTestResult with _$OPKTestResult {
  const factory OPKTestResult({
    required String id,
    required DateTime date,
    required OPKResult result,
    String? timeOfDay,
    String? brand,
    String? photoPath,
  }) = _OPKTestResult;

  factory OPKTestResult.fromJson(Map<String, dynamic> json) =>
      _$OPKTestResultFromJson(json);
}
