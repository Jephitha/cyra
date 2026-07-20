import 'package:cyra/features/fertility/models/fertility_models.dart';

class ConceptionWindowEstimate {
  const ConceptionWindowEstimate({
    required this.windowStart,
    required this.windowEnd,
    required this.supportingActivityDates,
    required this.copy,
  });

  final DateTime windowStart;
  final DateTime windowEnd;
  final List<DateTime> supportingActivityDates;
  final String copy;

  DateTime get midpoint => DateTime(
    windowStart.year,
    windowStart.month,
    windowStart.day + windowEnd.difference(windowStart).inDays ~/ 2,
  );
}

class ConceptionWindowService {
  const ConceptionWindowService();

  static const maxLookback = Duration(days: 21);
  static const maxForward = Duration(days: 2);
  static const spermSurvivalWindow = Duration(days: 5);

  ConceptionWindowEstimate? estimateFromSexActivity({
    required DateTime positiveTestOrToday,
    required List<IntercourseLog> activity,
  }) {
    final latestAllowed = _dateOnly(positiveTestOrToday).add(maxForward);
    final earliestAllowed = _dateOnly(
      positiveTestOrToday,
    ).subtract(maxLookback);
    final candidates =
        activity
            .where((log) => log.unprotected)
            .map((log) => _dateOnly(log.date))
            .where(
              (date) =>
                  !date.isBefore(earliestAllowed) &&
                  !date.isAfter(latestAllowed),
            )
            .toSet()
            .toList()
          ..sort();

    if (candidates.isEmpty) return null;

    final windowStart = candidates.first.subtract(spermSurvivalWindow);
    final windowEnd = candidates.last.add(maxForward);
    final boundedStart = windowStart.isBefore(earliestAllowed)
        ? earliestAllowed
        : windowStart;
    final boundedEnd = windowEnd.isAfter(latestAllowed)
        ? latestAllowed
        : windowEnd;

    if (boundedEnd.difference(boundedStart).inDays > maxLookback.inDays) {
      return null;
    }

    return ConceptionWindowEstimate(
      windowStart: boundedStart,
      windowEnd: boundedEnd,
      supportingActivityDates: candidates,
      copy:
          'Based on saved unprotected sex activity, conception may have happened in this window. This is an estimate, not a confirmation. Ultrasound or clinician dating is more reliable.',
    );
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
