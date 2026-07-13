import 'package:flutter_test/flutter_test.dart';

import 'package:cyra/core/notifications/cycle_notification_gateway.dart';
import 'package:cyra/core/notifications/cycle_reminder_scheduler.dart';
import 'package:cyra/core/notifications/cycle_reminder_settings.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';

void main() {
  test('schedules cycle reminders from repository prediction dates', () async {
    final notifications = _Notifications();
    final cycles = _completedCycles(3);
    final scheduler = CycleReminderScheduler(
      notifications: notifications,
      notificationsEnabled: () async => true,
      settings: () async => const CycleReminderSettings(
        periodDaysBefore: 3,
        periodHour: 9,
        periodMinute: 15,
        fertileDaysBefore: 2,
        fertileHour: 7,
        fertileMinute: 30,
        ovulationHour: 10,
        ovulationMinute: 45,
      ),
      cycles: () async => cycles,
      activeCycle: () async => cycles.last,
      periodPrediction: () async => _prediction(DateTime(2030, 6, 20)),
      fertileWindow: (_) async => FertileWindow(
        windowStart: DateTime(2030, 6, 6),
        windowEnd: DateTime(2030, 6, 11),
        ovulationDate: DateTime(2030, 6, 11),
      ),
    );

    final result = await scheduler.reschedule(requestPermission: true);

    expect(result, isTrue);
    expect(notifications.initialized, isTrue);
    expect(notifications.permissionRequests, 1);
    expect(notifications.cancelCount, 1);
    expect(notifications.periodScheduled, DateTime(2030, 6, 17, 9, 15));
    expect(notifications.predictedPeriod, DateTime(2030, 6, 20));
    expect(notifications.fertileScheduled, DateTime(2030, 6, 4, 7, 30));
    expect(notifications.fertileStart, DateTime(2030, 6, 6));
    expect(notifications.ovulationScheduled, DateTime(2030, 6, 11, 10, 45));
  });

  test('does not invent a period reminder with insufficient history', () async {
    final notifications = _Notifications();
    var predictionRead = false;
    final scheduler = CycleReminderScheduler(
      notifications: notifications,
      notificationsEnabled: () async => true,
      settings: () async => const CycleReminderSettings(
        fertileEnabled: false,
        ovulationEnabled: false,
      ),
      cycles: () async => _completedCycles(2),
      activeCycle: () async => null,
      periodPrediction: () async {
        predictionRead = true;
        return _prediction(DateTime(2030, 6, 20));
      },
      fertileWindow: (_) async => throw UnimplementedError(),
    );

    await scheduler.reschedule();

    expect(predictionRead, isFalse);
    expect(notifications.periodScheduled, isNull);
  });

  test('master switch off cancels reminders and schedules nothing', () async {
    final notifications = _Notifications();
    final scheduler = CycleReminderScheduler(
      notifications: notifications,
      notificationsEnabled: () async => false,
      settings: () async => const CycleReminderSettings(),
      cycles: () async => throw StateError('must not load cycles'),
      activeCycle: () async => throw StateError('must not load active cycle'),
      periodPrediction: () async => throw StateError('must not predict'),
      fertileWindow: (_) async => throw StateError('must not predict'),
    );

    final result = await scheduler.reschedule();

    expect(result, isFalse);
    expect(notifications.cancelCount, 1);
    expect(notifications.periodScheduled, isNull);
  });
}

List<Cycle> _completedCycles(int count) => List.generate(
  count,
  (index) => Cycle(
    id: '$index',
    startDate: DateTime(2030, 1, 1).add(Duration(days: index * 28)),
    endDate: DateTime(2030, 1, 28).add(Duration(days: index * 28)),
    cycleLength: 28,
  ),
);

PredictionResult _prediction(DateTime date) => PredictionResult(
  predictedDate: date,
  confidenceScore: 0.8,
  variabilityScore: 0.1,
  predictionRangeStart: date.subtract(const Duration(days: 2)),
  predictionRangeEnd: date.add(const Duration(days: 2)),
  explanation: 'test',
);

class _Notifications implements CycleNotificationGateway {
  bool initialized = false;
  int permissionRequests = 0;
  int cancelCount = 0;
  DateTime? periodScheduled;
  DateTime? predictedPeriod;
  DateTime? fertileScheduled;
  DateTime? fertileStart;
  DateTime? ovulationScheduled;

  @override
  Future<void> initialize() async => initialized = true;

  @override
  Future<bool> requestPermissions() async {
    permissionRequests += 1;
    return true;
  }

  @override
  Future<void> cancelCycleReminders() async => cancelCount += 1;

  @override
  Future<void> schedulePeriodReminder({
    required DateTime scheduledDate,
    required DateTime predictedPeriodDate,
  }) async {
    periodScheduled = scheduledDate;
    predictedPeriod = predictedPeriodDate;
  }

  @override
  Future<void> scheduleFertileWindowReminder({
    required DateTime scheduledDate,
    required DateTime fertileWindowStart,
  }) async {
    fertileScheduled = scheduledDate;
    fertileStart = fertileWindowStart;
  }

  @override
  Future<void> scheduleOvulationReminder({
    required DateTime scheduledDate,
  }) async => ovulationScheduled = scheduledDate;
}
