abstract interface class CycleNotificationGateway {
  Future<void> initialize();

  Future<bool> requestPermissions();

  Future<void> cancelCycleReminders();

  Future<void> schedulePeriodReminder({
    required DateTime scheduledDate,
    required DateTime predictedPeriodDate,
  });

  Future<void> scheduleFertileWindowReminder({
    required DateTime scheduledDate,
    required DateTime fertileWindowStart,
  });

  Future<void> scheduleOvulationReminder({required DateTime scheduledDate});
}
