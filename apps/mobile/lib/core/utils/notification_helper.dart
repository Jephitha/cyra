import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cyra/core/notifications/cycle_notification_gateway.dart';
import 'package:cyra/core/security/privacy_service.dart';
import 'package:cyra/core/providers/security_providers.dart';

part 'notification_helper.g.dart';

class NotificationHelper implements CycleNotificationGateway {
  final FlutterLocalNotificationsPlugin _plugin;
  final PrivacyService _privacyService;

  static const String _channelId = 'cyra_cycle_reminders';
  static const String _channelName = 'Cycle Reminders';
  static const String _channelDescription =
      'Period, fertile window and medication reminders';

  static const String _fertileChannelId = 'cyra_fertile_window';
  static const String _fertileChannelName = 'Fertile Window';
  static const String _fertileChannelDescription =
      'Fertile window notifications';

  static const String _pillChannelId = 'cyra_pill_reminder';
  static const String _pillChannelName = 'Pill Reminder';
  static const String _pillChannelDescription = 'Daily pill reminders';
  static const MethodChannel _timeZoneChannel = MethodChannel(
    'com.getmycyra.app/timezone',
  );

  static const int _periodReminderId = 1000;
  static const int _fertileReminderId = 2000;
  static const int _ovulationReminderId = 2001;

  bool _initialized = false;

  NotificationHelper(this._plugin, this._privacyService);

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await _setLocalTimeZone();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createChannels();
    _initialized = true;
  }

  Future<void> _setLocalTimeZone() async {
    try {
      final name = await _timeZoneChannel.invokeMethod<String>(
        'getTimeZoneName',
      );
      if (name != null && name.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(name));
      }
    } catch (_) {
      // Unit tests, unsupported platforms, and unknown platform timezone names
      // keep tz.local as the safe fallback.
    }
  }

  Future<void> _createChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _fertileChannelId,
          _fertileChannelName,
          description: _fertileChannelDescription,
          importance: Importance.high,
          playSound: true,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _pillChannelId,
          _pillChannelName,
          description: _pillChannelDescription,
          importance: Importance.high,
          playSound: true,
        ),
      );
    }
  }

  @override
  Future<void> schedulePeriodReminder({
    required DateTime scheduledDate,
    required DateTime predictedPeriodDate,
  }) async {
    if (!scheduledDate.isAfter(DateTime.now())) return;

    final daysUntil = _calendarDaysBetween(scheduledDate, predictedPeriodDate);
    final title = _privacyService.sanitizeNotificationContent('Cyra');
    final body = daysUntil == 0
        ? _privacyService.sanitizeNotificationContent(
            'Your period is predicted to start today',
          )
        : _privacyService.sanitizeNotificationContent(
            'Your period is predicted in $daysUntil day${daysUntil > 1 ? 's' : ''}',
          );

    await _scheduleNotification(
      id: _periodReminderId,
      channelId: _channelId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: '/calendar',
    );
  }

  @override
  Future<void> scheduleFertileWindowReminder({
    required DateTime scheduledDate,
    required DateTime fertileWindowStart,
  }) async {
    if (!scheduledDate.isAfter(DateTime.now())) return;

    final title = _privacyService.sanitizeNotificationContent('Cyra');
    final daysUntil = _calendarDaysBetween(scheduledDate, fertileWindowStart);
    final body = _privacyService.sanitizeNotificationContent(
      daysUntil == 0
          ? 'Your fertile window is expected to open today'
          : 'Your fertile window is expected in $daysUntil day${daysUntil == 1 ? '' : 's'}',
    );

    await _scheduleNotification(
      id: _fertileReminderId,
      channelId: _fertileChannelId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: '/ovulation',
    );
  }

  @override
  Future<void> scheduleOvulationReminder({
    required DateTime scheduledDate,
  }) async {
    if (!scheduledDate.isAfter(DateTime.now())) return;
    await _scheduleNotification(
      id: _ovulationReminderId,
      channelId: _fertileChannelId,
      title: _privacyService.sanitizeNotificationContent('Cyra'),
      body: _privacyService.sanitizeNotificationContent(
        'Ovulation is estimated for today',
      ),
      scheduledDate: scheduledDate,
      payload: '/ovulation',
    );
  }

  int _calendarDaysBetween(DateTime scheduled, DateTime target) {
    final scheduledDay = DateTime(
      scheduled.year,
      scheduled.month,
      scheduled.day,
    );
    final date = DateTime(target.year, target.month, target.day);
    return date.difference(scheduledDay).inDays;
  }

  Future<void> schedulePillReminder({
    required int id,
    required TimeOfDay reminderTime,
    String? pillName,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final title = _privacyService.sanitizeNotificationContent('Cyra');
    final body = _privacyService.sanitizeNotificationContent(
      pillName != null
          ? 'Time to take $pillName'
          : 'Time to take your medication',
    );

    await _scheduleNotification(
      id: id,
      channelId: _pillChannelId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      androidAllowWhileIdle: true,
      repeatDaily: true,
    );
  }

  Future<void> sendImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final safeTitle = _privacyService.sanitizeNotificationContent(title);
    final safeBody = _privacyService.sanitizeNotificationContent(body);

    await _plugin.show(
      id,
      safeTitle,
      safeBody,
      _notificationDetails(),
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> cancelPeriodReminders() async {
    await _plugin.cancel(_periodReminderId);
  }

  Future<void> cancelFertileWindowReminders() async {
    await _plugin.cancel(_fertileReminderId);
    await _plugin.cancel(_ovulationReminderId);
  }

  @override
  Future<void> cancelCycleReminders() async {
    await cancelPeriodReminders();
    await cancelFertileWindowReminders();
  }

  Future<void> cancelPillReminders() async {
    await _plugin.cancel(3000);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  @override
  Future<bool> requestPermissions() async {
    var granted = true;
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      granted = await androidPlugin.requestNotificationsPermission() ?? false;
    }

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      granted =
          (await iosPlugin.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
              false) &&
          granted;
    }

    return granted;
  }

  Future<void> _scheduleNotification({
    required int id,
    required String channelId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool androidAllowWhileIdle = false,
    bool repeatDaily = false,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      _notificationDetails(channelId: channelId),
      androidScheduleMode: androidAllowWhileIdle
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
      payload: payload,
    );
  }

  NotificationDetails _notificationDetails({String channelId = _channelId}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'reminder',
      ),
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap navigation based on payload
  }
}

@Riverpod(keepAlive: true)
NotificationHelper notificationHelper(NotificationHelperRef ref) {
  final plugin = FlutterLocalNotificationsPlugin();
  final privacy = ref.read(privacyServiceProvider);
  return NotificationHelper(plugin, privacy);
}
