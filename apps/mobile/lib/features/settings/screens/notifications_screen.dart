import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/notifications/cycle_reminder_scheduler.dart';
import 'package:cyra/core/notifications/cycle_reminder_settings.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/core/utils/notification_helper.dart';
import 'package:cyra/features/settings/providers/settings_notifier.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(notificationsEnabledProvider);
    final reminders = ref.watch(cycleReminderSettingsNotifierProvider);
    final preview = ref.watch(notificationPreviewSettingNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _MasterToggle(enabled: enabled),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeader('Cycle reminders'),
          const SizedBox(height: AppSpacing.sm),
          reminders.when(
            data: (settings) => _CycleReminderCard(settings: settings),
            loading: () => AppCard.standard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, _) => AppCard.standard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text('Could not load cycle reminder settings.'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeader('Privacy'),
          const SizedBox(height: AppSpacing.sm),
          _PreviewCard(current: preview),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.xxl),
            const _SectionHeader('Debug testing'),
            const SizedBox(height: AppSpacing.sm),
            const _DebugNotificationCard(),
          ],
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeader('Pregnancy reminders'),
          const SizedBox(height: AppSpacing.sm),
          AppCard.standard(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Pregnancy reminders are not scheduled yet. They will only be offered when an active pregnancy can provide real milestone dates.',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

class _DebugNotificationCard extends ConsumerStatefulWidget {
  const _DebugNotificationCard();

  @override
  ConsumerState<_DebugNotificationCard> createState() =>
      _DebugNotificationCardState();
}

class _DebugNotificationCardState
    extends ConsumerState<_DebugNotificationCard> {
  bool _busy = false;
  int? _pendingCount;

  @override
  Widget build(BuildContext context) {
    return AppCard.standard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.science_outlined,
                color: AppColors.forestGreen,
              ),
              title: Text('Simulate cycle notification'),
              subtitle: Text(
                'Debug APK only. Sends one local test reminder now.',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _pendingCount == null
                        ? 'Pending scheduled reminders not checked'
                        : 'Pending scheduled reminders: $_pendingCount',
                    style: const TextStyle(color: AppColors.slate),
                  ),
                ),
                TextButton(
                  onPressed: _busy ? null : _refreshPendingCount,
                  child: const Text('Check'),
                ),
                FilledButton(
                  onPressed: _busy ? null : _sendTestNotification,
                  child: _busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendTestNotification() async {
    setState(() => _busy = true);
    try {
      final helper = ref.read(notificationHelperProvider);
      await helper.initialize();
      final granted = await helper.requestPermissions();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permission denied.')),
          );
        }
        return;
      }
      await helper.sendImmediateNotification(
        id: 9001,
        title: 'Cyra',
        body: 'Debug notification simulation',
        payload: '/settings/notifications',
      );
      await _refreshPendingCount(showSnack: false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debug notification sent.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _refreshPendingCount({bool showSnack = true}) async {
    setState(() => _busy = true);
    try {
      final helper = ref.read(notificationHelperProvider);
      await helper.initialize();
      final pending = await helper.getPendingNotifications();
      if (mounted) setState(() => _pendingCount = pending.length);
      if (showSnack && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pending.length} pending reminder(s).')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _MasterToggle extends ConsumerWidget {
  const _MasterToggle({required this.enabled});

  final AsyncValue<bool> enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard.standard(
      child: enabled.when(
        data: (isEnabled) => SwitchListTile.adaptive(
          secondary: Icon(
            isEnabled
                ? Icons.notifications_active_outlined
                : Icons.notifications_off_outlined,
            color: isEnabled ? AppColors.forestGreen : AppColors.slate,
          ),
          title: const Text('All notifications'),
          subtitle: Text(
            isEnabled
                ? 'Cycle reminders are scheduled locally'
                : 'Notifications are off',
          ),
          activeTrackColor: AppColors.forestGreen,
          value: isEnabled,
          onChanged: (value) => _setEnabled(context, ref, value),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Text('Could not load notification settings.'),
        ),
      ),
    );
  }

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    await ref.read(notificationsEnabledProvider.notifier).setEnabled(value);
    final scheduled = await ref
        .read(cycleReminderSchedulerProvider)
        .reschedule(requestPermission: value);
    if (!scheduled && value) {
      await ref.read(notificationsEnabledProvider.notifier).setEnabled(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification permission was not granted.'),
          ),
        );
      }
    }
  }
}

class _CycleReminderCard extends ConsumerWidget {
  const _CycleReminderCard({required this.settings});

  final CycleReminderSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard.standard(
      child: Column(
        children: [
          _ReminderRow(
            icon: Icons.sync_outlined,
            title: 'Period prediction',
            subtitle: _daysBeforeLabel(settings.periodDaysBefore),
            time: TimeOfDay(
              hour: settings.periodHour,
              minute: settings.periodMinute,
            ),
            enabled: settings.periodEnabled,
            onToggle: (value) =>
                _save(ref, settings.copyWith(periodEnabled: value)),
            onDaysTap: () => _pickDays(
              context,
              settings.periodDaysBefore,
              (days) => _save(ref, settings.copyWith(periodDaysBefore: days)),
            ),
            onTimeTap: () => _pickTime(
              context,
              TimeOfDay(
                hour: settings.periodHour,
                minute: settings.periodMinute,
              ),
              (time) => _save(
                ref,
                settings.copyWith(
                  periodHour: time.hour,
                  periodMinute: time.minute,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          _ReminderRow(
            icon: Icons.brightness_5_outlined,
            title: 'Fertile window',
            subtitle: _daysBeforeLabel(settings.fertileDaysBefore),
            time: TimeOfDay(
              hour: settings.fertileHour,
              minute: settings.fertileMinute,
            ),
            enabled: settings.fertileEnabled,
            onToggle: (value) =>
                _save(ref, settings.copyWith(fertileEnabled: value)),
            onDaysTap: () => _pickDays(
              context,
              settings.fertileDaysBefore,
              (days) => _save(ref, settings.copyWith(fertileDaysBefore: days)),
            ),
            onTimeTap: () => _pickTime(
              context,
              TimeOfDay(
                hour: settings.fertileHour,
                minute: settings.fertileMinute,
              ),
              (time) => _save(
                ref,
                settings.copyWith(
                  fertileHour: time.hour,
                  fertileMinute: time.minute,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          _ReminderRow(
            icon: Icons.wb_sunny_outlined,
            title: 'Estimated ovulation day',
            subtitle: 'On the calculated day',
            time: TimeOfDay(
              hour: settings.ovulationHour,
              minute: settings.ovulationMinute,
            ),
            enabled: settings.ovulationEnabled,
            onToggle: (value) =>
                _save(ref, settings.copyWith(ovulationEnabled: value)),
            onTimeTap: () => _pickTime(
              context,
              TimeOfDay(
                hour: settings.ovulationHour,
                minute: settings.ovulationMinute,
              ),
              (time) => _save(
                ref,
                settings.copyWith(
                  ovulationHour: time.hour,
                  ovulationMinute: time.minute,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _daysBeforeLabel(int days) => days == 0
      ? 'On the calculated day'
      : '$days day${days == 1 ? '' : 's'} before';

  Future<void> _save(WidgetRef ref, CycleReminderSettings value) async {
    await ref.read(cycleReminderSettingsNotifierProvider.notifier).save(value);
    await ref.read(cycleReminderSchedulerProvider).reschedule();
  }

  Future<void> _pickDays(
    BuildContext context,
    int current,
    ValueChanged<int> onSelected,
  ) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('Notify how many days before?'),
            ),
            for (final days in [0, 1, 2, 3, 5, 7])
              ListTile(
                title: Text(days == 0 ? 'Same day' : '$days days before'),
                trailing: current == days
                    ? const Icon(Icons.check, color: AppColors.forestGreen)
                    : null,
                onTap: () => Navigator.of(context).pop(days),
              ),
          ],
        ),
      ),
    );
    if (result != null) onSelected(result);
  }

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay current,
    ValueChanged<TimeOfDay> onSelected,
  ) async {
    final result = await showTimePicker(context: context, initialTime: current);
    if (result != null) onSelected(result);
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.enabled,
    required this.onToggle,
    required this.onTimeTap,
    this.onDaysTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final TimeOfDay time;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTimeTap;
  final VoidCallback? onDaysTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: InkWell(
              onTap: enabled ? onDaysTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.slate),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: enabled ? onTimeTap : null,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(time.format(context)),
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeTrackColor: AppColors.forestGreen,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends ConsumerWidget {
  const _PreviewCard({required this.current});

  final NotificationPreviewMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard.standard(
      child: ListTile(
        leading: const Icon(Icons.lock_outline, color: AppColors.forestGreen),
        title: const Text('Lock screen preview'),
        subtitle: const Text('Choose how much detail notifications reveal'),
        trailing: Text(current.label),
        onTap: () async {
          final selected = await showModalBottomSheet<NotificationPreviewMode>(
            context: context,
            builder: (context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final mode in NotificationPreviewMode.values)
                    ListTile(
                      title: Text(mode.label),
                      trailing: current == mode
                          ? const Icon(
                              Icons.check,
                              color: AppColors.forestGreen,
                            )
                          : null,
                      onTap: () => Navigator.of(context).pop(mode),
                    ),
                ],
              ),
            ),
          );
          if (selected != null) {
            ref
                .read(notificationPreviewSettingNotifierProvider.notifier)
                .setPreviewMode(selected);
          }
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleSmall?.copyWith(
      color: AppColors.forestGreen,
      fontWeight: FontWeight.w700,
    ),
  );
}
