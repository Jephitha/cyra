class CycleReminderSettings {
  const CycleReminderSettings({
    this.periodEnabled = true,
    this.periodDaysBefore = 2,
    this.periodHour = 8,
    this.periodMinute = 0,
    this.fertileEnabled = true,
    this.fertileDaysBefore = 1,
    this.fertileHour = 8,
    this.fertileMinute = 0,
    this.ovulationEnabled = true,
    this.ovulationHour = 8,
    this.ovulationMinute = 0,
  });

  final bool periodEnabled;
  final int periodDaysBefore;
  final int periodHour;
  final int periodMinute;
  final bool fertileEnabled;
  final int fertileDaysBefore;
  final int fertileHour;
  final int fertileMinute;
  final bool ovulationEnabled;
  final int ovulationHour;
  final int ovulationMinute;

  CycleReminderSettings copyWith({
    bool? periodEnabled,
    int? periodDaysBefore,
    int? periodHour,
    int? periodMinute,
    bool? fertileEnabled,
    int? fertileDaysBefore,
    int? fertileHour,
    int? fertileMinute,
    bool? ovulationEnabled,
    int? ovulationHour,
    int? ovulationMinute,
  }) {
    return CycleReminderSettings(
      periodEnabled: periodEnabled ?? this.periodEnabled,
      periodDaysBefore: periodDaysBefore ?? this.periodDaysBefore,
      periodHour: periodHour ?? this.periodHour,
      periodMinute: periodMinute ?? this.periodMinute,
      fertileEnabled: fertileEnabled ?? this.fertileEnabled,
      fertileDaysBefore: fertileDaysBefore ?? this.fertileDaysBefore,
      fertileHour: fertileHour ?? this.fertileHour,
      fertileMinute: fertileMinute ?? this.fertileMinute,
      ovulationEnabled: ovulationEnabled ?? this.ovulationEnabled,
      ovulationHour: ovulationHour ?? this.ovulationHour,
      ovulationMinute: ovulationMinute ?? this.ovulationMinute,
    );
  }

  static CycleReminderSettings fromMap(Map<String, String> values) {
    int integer(String key, int fallback) =>
        int.tryParse(values[key] ?? '') ?? fallback;
    bool boolean(String key, bool fallback) =>
        values[key] == null ? fallback : values[key] == 'true';

    return CycleReminderSettings(
      periodEnabled: boolean('period_reminder_enabled', true),
      periodDaysBefore: integer('period_reminder_days_before', 2),
      periodHour: integer('period_reminder_hour', 8),
      periodMinute: integer('period_reminder_minute', 0),
      fertileEnabled: boolean('fertile_reminder_enabled', true),
      fertileDaysBefore: integer('fertile_reminder_days_before', 1),
      fertileHour: integer('fertile_reminder_hour', 8),
      fertileMinute: integer('fertile_reminder_minute', 0),
      ovulationEnabled: boolean('ovulation_reminder_enabled', true),
      ovulationHour: integer('ovulation_reminder_hour', 8),
      ovulationMinute: integer('ovulation_reminder_minute', 0),
    );
  }

  Map<String, String> toMap() => {
    'period_reminder_enabled': periodEnabled.toString(),
    'period_reminder_days_before': periodDaysBefore.toString(),
    'period_reminder_hour': periodHour.toString(),
    'period_reminder_minute': periodMinute.toString(),
    'fertile_reminder_enabled': fertileEnabled.toString(),
    'fertile_reminder_days_before': fertileDaysBefore.toString(),
    'fertile_reminder_hour': fertileHour.toString(),
    'fertile_reminder_minute': fertileMinute.toString(),
    'ovulation_reminder_enabled': ovulationEnabled.toString(),
    'ovulation_reminder_hour': ovulationHour.toString(),
    'ovulation_reminder_minute': ovulationMinute.toString(),
  };
}
