import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_models.freezed.dart';
part 'journal_models.g.dart';

@freezed
class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required DateTime date,
    String? title,
    String? content,
    @Default([]) List<String> photoPaths,
    @Default([]) List<String> voiceNotePaths,
    @Default(0) int moodRating,
    String? cycleDayId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}
