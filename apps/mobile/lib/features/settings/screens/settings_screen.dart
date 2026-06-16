import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/constants/app_constants.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/features/privacy/screens/privacy_controls_screen.dart';
import 'package:cyra/features/settings/screens/appearance_screen.dart';
import 'package:cyra/features/settings/screens/notifications_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildSectionHeader('Account'),
          const SizedBox(height: AppSpacing.sm),
          _buildAccountSection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Privacy & Security'),
          const SizedBox(height: AppSpacing.sm),
          _buildPrivacySection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Appearance'),
          const SizedBox(height: AppSpacing.sm),
          _buildAppearanceSection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Notifications'),
          const SizedBox(height: AppSpacing.sm),
          _buildNotificationsSection(context, ref),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Data'),
          const SizedBox(height: AppSpacing.sm),
          _buildDataSection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Wearables'),
          const SizedBox(height: AppSpacing.sm),
          _buildWearablesSection(context, ref),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Units'),
          const SizedBox(height: AppSpacing.sm),
          _buildUnitsSection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Language'),
          const SizedBox(height: AppSpacing.sm),
          _buildLanguageSection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('About'),
          const SizedBox(height: AppSpacing.sm),
          _buildAboutSection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Support'),
          const SizedBox(height: AppSpacing.sm),
          _buildSupportSection(context),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.light.titleSmall?.copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.person_outline,
            label: 'Profile',
            subtitle: 'Name, email, date of birth',
            trailing: Text('Jotham', style: TextStyle(color: AppColors.slate, fontSize: 14)),
            onTap: () {},
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.sync_outlined,
            label: 'Sync Preferences',
            subtitle: 'iCloud / Google Drive sync settings',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.lock_outline,
            label: 'Privacy & Security',
            subtitle: 'Lock, PIN, private mode, data controls',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PrivacyControlsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.palette_outlined,
            label: 'Theme & Display',
            subtitle: 'Light, dark, system, text size, colors',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AppearanceScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsEnabledProvider);

    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.notifications_outlined,
            label: 'Notification Settings',
            subtitle: 'Period reminders, cycle alerts, privacy',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()),
            ),
          ),
          const Divider(height: 1),
          notificationsAsync.when(
            data: (enabled) {
              return _SettingsRow(
                icon: Icons.notifications_off_outlined,
                label: 'All Notifications',
                subtitle: 'Master toggle for all notifications',
                trailing: Switch.adaptive(
                  value: enabled,
                  activeTrackColor: AppColors.forestGreen,
                  onChanged: (v) => ref.read(notificationsEnabledProvider.notifier).setEnabled(v),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.file_download_outlined,
            label: 'Export Data',
            subtitle: 'Export all or selected data',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.delete_outline,
            label: 'Manage Data',
            subtitle: 'Delete individual or all records',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildWearablesSection(BuildContext context, WidgetRef ref) {
    final wearableAsync = ref.watch(wearableSyncEnabledProvider);

    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.watch_outlined,
            label: 'Connected Devices',
            subtitle: 'Apple Watch, Fitbit, Oura Ring',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
          const Divider(height: 1),
          wearableAsync.when(
            data: (enabled) {
              return _SettingsRow(
                icon: Icons.sync_outlined,
                label: 'Auto Sync',
                subtitle: 'Automatically sync wearable data',
                trailing: Switch.adaptive(
                  value: enabled,
                  activeTrackColor: AppColors.forestGreen,
                  onChanged: (v) => ref.read(wearableSyncEnabledProvider.notifier).setEnabled(v),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.straighten_outlined,
            label: 'Units System',
            subtitle: 'Metric or Imperial',
            trailing: Text('Metric', style: TextStyle(color: AppColors.slate, fontSize: 14)),
            onTap: () => _showUnitsPicker(context),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.thermostat_outlined,
            label: 'Temperature',
            subtitle: 'Celsius or Fahrenheit',
            trailing: Text('Celsius', style: TextStyle(color: AppColors.slate, fontSize: 14)),
            onTap: () => _showTemperaturePicker(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.language_outlined,
            label: 'App Language',
            subtitle: 'Change display language',
            trailing: Text('English', style: TextStyle(color: AppColors.slate, fontSize: 14)),
            onTap: () => _showLanguagePicker(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.info_outline,
            label: 'Version',
            trailing: Text(AppConstants.appVersion, style: TextStyle(color: AppColors.slate, fontSize: 14)),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.description_outlined,
            label: 'Licenses',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => showLicensePage(context: context),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.article_outlined,
            label: 'Terms of Service',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.medication_outlined,
            label: 'Medical Disclaimer',
            subtitle: 'This app is not a medical device',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.mail_outline,
            label: 'Contact Us',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.help_outline,
            label: 'FAQ',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.feedback_outlined,
            label: 'Send Feedback',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showUnitsPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Units System',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.straighten, color: AppColors.forestGreen),
              title: const Text('Metric'),
              subtitle: const Text('cm, kg'),
              trailing: Icon(Icons.check, color: AppColors.forestGreen),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              leading: Icon(Icons.straighten, color: AppColors.slate),
              title: const Text('Imperial'),
              subtitle: const Text('in, lb'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showTemperaturePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Temperature Unit',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.thermostat, color: AppColors.forestGreen),
              title: const Text('Celsius (°C)'),
              trailing: Icon(Icons.check, color: AppColors.forestGreen),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              leading: Icon(Icons.thermostat, color: AppColors.slate),
              title: const Text('Fahrenheit (°F)'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'App Language',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: AppColors.forestGreen),
              title: const Text('English'),
              trailing: Icon(Icons.check, color: AppColors.forestGreen),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            ListTile(
              leading: Icon(Icons.language, color: AppColors.slate),
              title: const Text('Spanish'),
              trailing: Text('Coming Soon', style: TextStyle(color: AppColors.slate, fontSize: 12)),
              enabled: false,
            ),
            ListTile(
              leading: Icon(Icons.language, color: AppColors.slate),
              title: const Text('French'),
              trailing: Text('Coming Soon', style: TextStyle(color: AppColors.slate, fontSize: 12)),
              enabled: false,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.forestGreen),
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
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: AppColors.slate,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
