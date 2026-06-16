import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cyra/core/security/privacy_service.dart';
import 'package:cyra/core/providers/security_providers.dart';

part 'notification_helper.g.dart';

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _plugin;
  final PrivacyService _privacyService;

  static const String _channelId = 'cyra_cycle_reminders';
  static const String _channelName = 'Cycle Reminders';
  static const String _channelDescription = 'Period, fertile window and medication reminders';

  static const String _fertileChannelId = 'cyra_fertile_window';
  static const String _fertileChannelName = 'Fertile Window';
  static const String _fertileChannelDescription = 'Fertile window notifications';

  static const String _pillChannelId = 'cyra_pill_reminder';
  static const String _pillChannelName = 'Pill Reminder';
  static const String _pillChannelDescription = 'Daily pill reminders';

  NotificationHelper(this._plugin, this._privacyService);

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
  }

  Future<void> _createChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

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

  Future<void> schedulePeriodReminder({
    required int id,
    required DateTime scheduledDate,
    required DateTime periodStartDate,
    int cycleLength = 28,
    int daysBeforeReminder = 2,
  }) async {
    final predictedDate = periodStartDate.add(Duration(days: cycleLength));
    final reminderDate = predictedDate.subtract(Duration(days: daysBeforeReminder));

    if (reminderDate.isBefore(DateTime.now())) return;

    final daysUntil = reminderDate.difference(DateTime.now()).inDays;
    final title = _privacyService.sanitizeNotificationContent('Cyra');
    final body = daysUntil == 0
        ? _privacyService.sanitizeNotificationContent('Your period is predicted to start today')
        : _privacyService.sanitizeNotificationContent(
            'Your period is predicted in $daysUntil day${daysUntil > 1 ? 's' : ''}');

    await _scheduleNotification(
      id: id,
      channelId: _channelId,
      title: title,
      body: body,
      scheduledDate: reminderDate,
    );
  }

  Future<void> scheduleFertileWindowReminder({
    required int id,
    required DateTime scheduledDate,
    required DateTime cycleStartDate,
    int cycleLength = 28,
    int fertileWindowDay = 8,
  }) async {
    final ovulationDay = cycleLength - 14;
    final fertileStart = cycleStartDate.add(Duration(days: fertileWindowDay - 1));
    final fertilePeak = cycleStartDate.add(Duration(days: ovulationDay - 1));

    final title = _privacyService.sanitizeNotificationContent('Cyra');
    String body;

    final daysSinceFertileStart = DateTime.now().difference(fertileStart).inDays;
    if (daysSinceFertileStart <= 0) {
      body = _privacyService.sanitizeNotificationContent('Your fertile window is opening soon');
    } else if (fertilePeak.isAfter(DateTime.now())) {
      final daysToPeak = fertilePeak.difference(DateTime.now()).inDays;
      body = _privacyService.sanitizeNotificationContent(
        'Fertile window open. Ovulation expected in ~$daysToPeak day${daysToPeak != 1 ? 's' : ''}');
    } else {
      return;
    }

    await _scheduleNotification(
      id: id,
      channelId: _fertileChannelId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );
  }

  Future<void> schedulePillReminder({
    required int id,
    required TimeOfDay reminderTime,
    String? pillName,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year, now.month, now.day, reminderTime.hour, reminderTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final title = _privacyService.sanitizeNotificationContent('Cyra');
    final body = _privacyService.sanitizeNotificationContent(
      pillName != null ? 'Time to take $pillName' : 'Time to take your medication');

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
    await _plugin.cancel(1000);
    await _plugin.cancel(1001);
    await _plugin.cancel(1002);
  }

  Future<void> cancelFertileWindowReminders() async {
    await _plugin.cancel(2000);
    await _plugin.cancel(2001);
  }

  Future<void> cancelPillReminders() async {
    await _plugin.cancel(3000);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return true;
  }

  Future<void> _scheduleNotification({
    required int id,
    required String channelId,
    required String title,
    required String body,
    required DateTime scheduledDate,
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
      matchDateTimeComponents:
          repeatDaily ? DateTimeComponents.time : null,
      payload: null,
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
  final helper = NotificationHelper(plugin, privacy);
  helper.initialize();
  return helper;
}
