import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/features/settings/providers/settings_notifier.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _periodReminder = true;
  bool _fertileWindowReminder = true;
  bool _ovulationReminder = true;
  bool _logReminder = false;
  bool _weeklyMilestone = false;
  bool _kickCounter = false;
  bool _appointmentReminder = false;
  bool _sensitiveContent = false;

  TimeOfDay _periodReminderTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _fertileWindowTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _ovulationTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _logReminderTime = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay _weeklyMilestoneTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _kickCounterTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _appointmentTime = const TimeOfDay(hour: 10, minute: 0);

  int _periodDaysBefore = 2;
  int _fertileDaysBefore = 1;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsEnabledProvider);
    final previewMode = ref.watch(notificationPreviewSettingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildMasterToggle(notificationsAsync),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Cycle Reminders'),
          const SizedBox(height: AppSpacing.sm),
          _buildCycleRemindersSection(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Pregnancy'),
          const SizedBox(height: AppSpacing.sm),
          _buildPregnancySection(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Privacy'),
          const SizedBox(height: AppSpacing.sm),
          _buildPrivacySection(context, ref, previewMode),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildMasterToggle(AsyncValue<bool> notificationsAsync) {
    return AppCard.standard(
      child: notificationsAsync.when(
        data: (enabled) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: enabled
                        ? AppColors.forestGreen.withValues(alpha: 0.12)
                        : AppColors.slate.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    enabled ? Icons.notifications_active : Icons.notifications_off,
                    color: enabled ? AppColors.forestGreen : AppColors.slate,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Notifications',
                        style: AppTypography.light.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        enabled ? 'Notifications are on' : 'Notifications are off',
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: AppColors.slate,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: enabled,
                  activeTrackColor: AppColors.forestGreen,
                  onChanged: (v) =>
                      ref.read(notificationsEnabledProvider.notifier).setEnabled(v),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading notification settings')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        title,
        style: AppTypography.light.titleSmall?.copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCycleRemindersSection() {
    return AppCard.standard(
      child: Column(
        children: [
          _buildNotificationRow(
            icon: Icons.water_drop_outlined,
            label: 'Period Prediction',
            subtitle: 'Notify $_periodDaysBefore days before',
            value: _periodReminder,
            onChanged: (v) => setState(() => _periodReminder = v),
            onTap: () => _showDaysBeforePicker(
              current: _periodDaysBefore,
              onSelected: (d) => setState(() => _periodDaysBefore = d),
            ),
            trailingExtra: _buildTimeChip(_periodReminderTime, (t) {
              if (t != null) setState(() => _periodReminderTime = t);
            }),
          ),
          const Divider(height: 1),
          _buildNotificationRow(
            icon: Icons.brightness_5_outlined,
            label: 'Fertile Window',
            subtitle: 'Notify $_fertileDaysBefore days before',
            value: _fertileWindowReminder,
            onChanged: (v) => setState(() => _fertileWindowReminder = v),
            onTap: () => _showDaysBeforePicker(
              current: _fertileDaysBefore,
              onSelected: (d) => setState(() => _fertileDaysBefore = d),
            ),
            trailingExtra: _buildTimeChip(_fertileWindowTime, (t) {
              if (t != null) setState(() => _fertileWindowTime = t);
            }),
          ),
          const Divider(height: 1),
          _buildNotificationRow(
            icon: Icons.wb_sunny_outlined,
            label: 'Ovulation Day',
            value: _ovulationReminder,
            onChanged: (v) => setState(() => _ovulationReminder = v),
            trailingExtra: _buildTimeChip(_ovulationTime, (t) {
              if (t != null) setState(() => _ovulationTime = t);
            }),
          ),
          const Divider(height: 1),
          _buildNotificationRow(
            icon: Icons.edit_calendar_outlined,
            label: 'Log Reminder',
            subtitle: 'Daily reminder to log your data',
            value: _logReminder,
            onChanged: (v) => setState(() => _logReminder = v),
            trailingExtra: _buildTimeChip(_logReminderTime, (t) {
              if (t != null) setState(() => _logReminderTime = t);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancySection() {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
            child: Text(
              'Pregnancy-related notifications will appear when a pregnancy is active.',
              style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildNotificationRow(
            icon: Icons.baby_changing_station_outlined,
            label: 'Weekly Milestone',
            value: _weeklyMilestone,
            onChanged: (v) => setState(() => _weeklyMilestone = v),
            trailingExtra: _buildTimeChip(_weeklyMilestoneTime, (t) {
              if (t != null) setState(() => _weeklyMilestoneTime = t);
            }),
          ),
          const Divider(height: 1),
          _buildNotificationRow(
            icon: Icons.monitor_heart_outlined,
            label: 'Kick Counter',
            subtitle: 'Reminder to track fetal movements',
            value: _kickCounter,
            onChanged: (v) => setState(() => _kickCounter = v),
            trailingExtra: _buildTimeChip(_kickCounterTime, (t) {
              if (t != null) setState(() => _kickCounterTime = t);
            }),
          ),
          const Divider(height: 1),
          _buildNotificationRow(
            icon: Icons.calendar_month_outlined,
            label: 'Appointment Reminder',
            value: _appointmentReminder,
            onChanged: (v) => setState(() => _appointmentReminder = v),
            trailingExtra: _buildTimeChip(_appointmentTime, (t) {
              if (t != null) setState(() => _appointmentTime = t);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(
    BuildContext context,
    WidgetRef ref,
    NotificationPreviewMode previewMode,
  ) {
    return AppCard.standard(
      child: Column(
        children: [
          _buildNotificationRow(
            icon: Icons.visibility_off_outlined,
            label: 'Show Sensitive Content',
            subtitle: 'Hide period/fertility text in notifications',
            value: _sensitiveContent,
            onChanged: (v) => setState(() => _sensitiveContent = v),
          ),
          const Divider(height: 1),
          _buildPreviewModeRow(context, ref, previewMode),
        ],
      ),
    );
  }

  Widget _buildNotificationRow({
    required IconData icon,
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    VoidCallback? onTap,
    Widget? trailingExtra,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.light.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: AppColors.slate,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailingExtra != null) ...[
                trailingExtra,
                const SizedBox(width: AppSpacing.sm),
              ],
              Switch.adaptive(
                value: value,
                activeTrackColor: AppColors.forestGreen,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewModeRow(
    BuildContext context,
    WidgetRef ref,
    NotificationPreviewMode current,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showPreviewModePicker(context, ref, current),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lock Screen Preview',
                      style: AppTypography.light.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'What shows on lock screen',
                      style: AppTypography.light.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                current.label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right, color: AppColors.slate, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(TimeOfDay time, ValueChanged<TimeOfDay?> onSelected) {
    return InkWell(
      onTap: () async {
        final selected = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.forestGreen,
                ),
              ),
              child: child!,
            );
          },
        );
        onSelected(selected);
      },
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.forestGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          time.format(context),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.forestGreen,
          ),
        ),
      ),
    );
  }

  void _showDaysBeforePicker({
    required int current,
    required ValueChanged<int> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Notify how many days before?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ...[0, 1, 2, 3, 5, 7].map((days) {
              final label = days == 0 ? 'Same day' : '$days days before';
              return ListTile(
                title: Text(label),
                trailing: current == days
                    ? Icon(Icons.check, color: AppColors.forestGreen)
                    : null,
                onTap: () {
                  onSelected(days);
                  Navigator.of(ctx).pop();
                },
              );
            }),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showPreviewModePicker(
    BuildContext context,
    WidgetRef ref,
    NotificationPreviewMode current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Lock Screen Preview',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ...NotificationPreviewMode.values.map((mode) {
              return ListTile(
                title: Text(mode.label),
                trailing: current == mode
                    ? Icon(Icons.check, color: AppColors.forestGreen)
                    : null,
                onTap: () {
                  ref.read(notificationPreviewSettingNotifierProvider.notifier).setPreviewMode(mode);
                  Navigator.of(ctx).pop();
                },
              );
            }),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
