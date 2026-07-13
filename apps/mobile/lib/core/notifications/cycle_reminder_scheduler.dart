import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/notifications/cycle_notification_gateway.dart';
import 'package:cyra/core/notifications/cycle_reminder_settings.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/core/utils/notification_helper.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';

part 'cycle_reminder_scheduler.g.dart';

typedef CyclesLoader = Future<List<Cycle>> Function();
typedef ActiveCycleLoader = Future<Cycle?> Function();
typedef PeriodPredictionLoader = Future<PredictionResult> Function();
typedef FertileWindowLoader = Future<FertileWindow> Function(Cycle cycle);

class CycleReminderScheduler {
  CycleReminderScheduler({
    required CycleNotificationGateway notifications,
    required Future<bool> Function() notificationsEnabled,
    required Future<CycleReminderSettings> Function() settings,
    required CyclesLoader cycles,
    required ActiveCycleLoader activeCycle,
    required PeriodPredictionLoader periodPrediction,
    required FertileWindowLoader fertileWindow,
  }) : this._(
         notifications,
         notificationsEnabled,
         settings,
         cycles,
         activeCycle,
         periodPrediction,
         fertileWindow,
       );

  CycleReminderScheduler._(
    this._notifications,
    this._notificationsEnabled,
    this._settings,
    this._cycles,
    this._activeCycle,
    this._periodPrediction,
    this._fertileWindow,
  );

  final CycleNotificationGateway _notifications;
  final Future<bool> Function() _notificationsEnabled;
  final Future<CycleReminderSettings> Function() _settings;
  final CyclesLoader _cycles;
  final ActiveCycleLoader _activeCycle;
  final PeriodPredictionLoader _periodPrediction;
  final FertileWindowLoader _fertileWindow;

  Future<bool> reschedule({bool requestPermission = false}) async {
    await _notifications.initialize();
    await _notifications.cancelCycleReminders();

    if (!await _notificationsEnabled()) return false;
    if (requestPermission && !await _notifications.requestPermissions()) {
      return false;
    }

    final preferences = await _settings();
    final history = await _cycles();
    final completedCycles = history
        .where((cycle) => cycle.endDate != null && cycle.cycleLength > 0)
        .length;

    if (preferences.periodEnabled && completedCycles >= 3) {
      final prediction = await _periodPrediction();
      final date = prediction.predictedDate;
      await _notifications.schedulePeriodReminder(
        scheduledDate: _atTime(
          date.subtract(Duration(days: preferences.periodDaysBefore)),
          preferences.periodHour,
          preferences.periodMinute,
        ),
        predictedPeriodDate: date,
      );
    }

    final cycle = await _activeCycle();
    if (cycle == null) return true;
    final fertile = await _fertileWindow(cycle);

    if (preferences.fertileEnabled) {
      await _notifications.scheduleFertileWindowReminder(
        scheduledDate: _atTime(
          fertile.windowStart.subtract(
            Duration(days: preferences.fertileDaysBefore),
          ),
          preferences.fertileHour,
          preferences.fertileMinute,
        ),
        fertileWindowStart: fertile.windowStart,
      );
    }

    final ovulationDate = fertile.ovulationDate;
    if (preferences.ovulationEnabled && ovulationDate != null) {
      await _notifications.scheduleOvulationReminder(
        scheduledDate: _atTime(
          ovulationDate,
          preferences.ovulationHour,
          preferences.ovulationMinute,
        ),
      );
    }
    return true;
  }

  DateTime _atTime(DateTime date, int hour, int minute) =>
      DateTime(date.year, date.month, date.day, hour, minute);
}

@Riverpod(keepAlive: true)
CycleReminderScheduler cycleReminderScheduler(CycleReminderSchedulerRef ref) {
  final cycleRepository = ref.watch(cycleRepositoryProvider);
  final ovulationRepository = ref.watch(ovulationRepositoryProvider);
  return CycleReminderScheduler(
    notifications: ref.watch(notificationHelperProvider),
    notificationsEnabled: () => ref.read(notificationsEnabledProvider.future),
    settings: () => ref.read(cycleReminderSettingsNotifierProvider.future),
    cycles: () => cycleRepository.getAllCycles(limit: 12),
    activeCycle: cycleRepository.getActiveCycle,
    periodPrediction: cycleRepository.predictNextPeriod,
    fertileWindow: (cycle) => ovulationRepository.calculateFertileWindow(
      lastPeriodStart: cycle.startDate,
      cycleLength: cycle.cycleLength,
    ),
  );
}
