import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cyra/core/constants/app_constants.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/features/privacy/screens/privacy_controls_screen.dart';
import 'package:cyra/features/settings/screens/appearance_screen.dart';
import 'package:cyra/features/settings/screens/notifications_screen.dart';
import 'package:cyra/features/subscriptions/paywall_screen.dart';
import 'package:cyra/features/subscriptions/subscription_controller.dart';
import 'package:cyra/features/wearables/screens/wearables_hub_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(appSettingsNotifierProvider).value ??
        const <String, String>{};
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildSectionHeader('Account'),
          const SizedBox(height: AppSpacing.sm),
          _buildAccountSection(context, ref, settings),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Subscription'),
          const SizedBox(height: AppSpacing.sm),
          _buildSubscriptionSection(context, ref),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Privacy & Security'),
          const SizedBox(height: AppSpacing.sm),
          _buildPrivacySection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Appearance'),
          const SizedBox(height: AppSpacing.sm),
          _buildAppearanceSection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Tracking Features'),
          const SizedBox(height: AppSpacing.sm),
          _buildTrackingFeaturesSection(context, ref, settings),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Notifications'),
          const SizedBox(height: AppSpacing.sm),
          _buildNotificationsSection(context, ref),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Wearables'),
          const SizedBox(height: AppSpacing.sm),
          _buildWearablesSection(context, ref),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Units'),
          const SizedBox(height: AppSpacing.sm),
          _buildUnitsSection(context, ref, settings),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Language'),
          const SizedBox(height: AppSpacing.sm),
          _buildLanguageSection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('About'),
          const SizedBox(height: AppSpacing.sm),
          _buildAboutSection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Support'),
          const SizedBox(height: AppSpacing.sm),
          _buildSupportSection(context),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionControllerProvider);
    return AppCard.standard(
      child: _SettingsRow(
        icon: Icons.auto_awesome_outlined,
        label: 'Cyra Premium',
        subtitle: subscription.isPremium
            ? 'Active'
            : 'Wearable sync and advanced trends',
        trailing: Icon(Icons.chevron_right, color: AppColors.slate),
        onTap: () => _openPaywall(context),
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

  Widget _buildAccountSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> settings,
  ) {
    final profileName = settings['profile_name']?.trim();
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.person_outline,
            label: 'Profile',
            subtitle: 'Name, email, date of birth',
            trailing: Text(
              profileName == null || profileName.isEmpty
                  ? 'Not set'
                  : profileName,
              style: TextStyle(color: AppColors.slate, fontSize: 14),
            ),
            onTap: () => _showProfileEditDialog(context, ref, settings),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.sync_outlined,
            label: 'Sync Preferences',
            subtitle: 'iCloud / Google Drive sync settings',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => _showSyncSheet(context),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.login_rounded,
            label: 'Cloud Account',
            subtitle: 'Sign in to sync your data across devices',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => context.go('/sign-in'),
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
              MaterialPageRoute<void>(
                builder: (_) => const PrivacyControlsScreen(),
              ),
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
            subtitle: 'System theme, text size, accent colors',
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
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsScreen(),
              ),
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
                  onChanged: (v) => ref
                      .read(notificationsEnabledProvider.notifier)
                      .setEnabled(v),
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

  Widget _buildTrackingFeaturesSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> settings,
  ) {
    bool enabled(String key, {bool defaultValue = true}) {
      final value = settings[key];
      if (value == null) return defaultValue;
      return value == 'true';
    }

    Future<void> setFeature(String key, bool value) {
      return ref
          .read(appSettingsNotifierProvider.notifier)
          .setValue(key, value.toString());
    }

    Future<void> setOvulationTracking(bool value) async {
      final notifier = ref.read(appSettingsNotifierProvider.notifier);
      await notifier.setValue('feature_bbt', value.toString());
      await notifier.setValue('feature_mucus', value.toString());
      await notifier.setValue('feature_opk', value.toString());
    }

    final ovulationTrackingEnabled =
        enabled('feature_bbt') ||
        enabled('feature_mucus') ||
        enabled('feature_opk');

    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.auto_awesome_outlined,
            label: 'Ovulation Tracking',
            subtitle: 'Show BBT, mucus, and OPK logging together',
            trailing: Switch.adaptive(
              value: ovulationTrackingEnabled,
              activeTrackColor: AppColors.forestGreen,
              onChanged: setOvulationTracking,
            ),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.child_care_outlined,
            label: 'Pregnancy Mode',
            subtitle: 'Show pregnancy dashboard and tools',
            trailing: Switch.adaptive(
              value: enabled('feature_pregnancy', defaultValue: false),
              activeTrackColor: AppColors.forestGreen,
              onChanged: (value) => setFeature('feature_pregnancy', value),
            ),
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
            subtitle: 'Apple Health or Health Connect',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const WearablesHubScreen(),
              ),
            ),
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
                  onChanged: (v) {
                    if (v && !ref.read(isPremiumProvider)) {
                      _openPaywall(context);
                      return;
                    }
                    ref
                        .read(wearableSyncEnabledProvider.notifier)
                        .setEnabled(v);
                  },
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

  void _openPaywall(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PaywallScreen()));
  }

  Widget _buildUnitsSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> settings,
  ) {
    final units = settings['units_system'] == 'imperial'
        ? 'Imperial'
        : 'Metric';
    final temperature = settings['temperature_unit'] == 'fahrenheit'
        ? 'Fahrenheit'
        : 'Celsius';
    return AppCard.standard(
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.straighten_outlined,
            label: 'Units System',
            subtitle: 'Metric or Imperial',
            trailing: Text(
              units,
              style: TextStyle(color: AppColors.slate, fontSize: 14),
            ),
            onTap: () => _showUnitsPicker(context, ref, units),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.thermostat_outlined,
            label: 'Temperature',
            subtitle: 'Celsius or Fahrenheit',
            trailing: Text(
              temperature,
              style: TextStyle(color: AppColors.slate, fontSize: 14),
            ),
            onTap: () => _showTemperaturePicker(context, ref, temperature),
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
            trailing: Text(
              'English',
              style: TextStyle(color: AppColors.slate, fontSize: 14),
            ),
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
            trailing: Text(
              AppConstants.appVersion,
              style: TextStyle(color: AppColors.slate, fontSize: 14),
            ),
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
            onTap: () => _showInfoDialog(
              context,
              'Privacy Policy',
              'Cyra stores health information locally by default. Cloud and community data are sent only when you choose those features. You can export or delete your data from Privacy & Security.',
            ),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.article_outlined,
            label: 'Terms of Service',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => _showInfoDialog(
              context,
              'Terms of Service',
              'Use Cyra for personal tracking and education. Keep your device secure, provide accurate information, and do not use the app for emergencies or as a replacement for professional care.',
            ),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.medication_outlined,
            label: 'Medical Disclaimer',
            subtitle: 'This app is not a medical device',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => _showInfoDialog(
              context,
              'Medical Disclaimer',
              'Cyra is not a medical device and does not diagnose, treat, or prevent any condition. Predictions and insights are estimates. Seek qualified medical care for health concerns and emergency services for urgent symptoms.',
            ),
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
            onTap: () => _showInfoDialog(
              context,
              'Contact Us',
              'Email support@getmycyra.com and include the app version, device model, and steps that reproduce the issue. Do not include sensitive health data unless it is necessary.',
            ),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.help_outline,
            label: 'FAQ',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => _showInfoDialog(
              context,
              'Frequently Asked Questions',
              'Where is my data? Health records are stored locally by default.\n\nHow do I export or delete data? Open Settings → Privacy & Security.\n\nAre predictions medical advice? No. They are estimates based on your entries.',
            ),
          ),
          const Divider(height: 1),
          _SettingsRow(
            icon: Icons.feedback_outlined,
            label: 'Send Feedback',
            trailing: Icon(Icons.chevron_right, color: AppColors.slate),
            onTap: () => _showInfoDialog(
              context,
              'Send Feedback',
              'Send feedback to feedback@getmycyra.com. Include what you expected, what happened, and screenshots when possible.',
            ),
          ),
        ],
      ),
    );
  }

  void _showUnitsPicker(BuildContext context, WidgetRef ref, String selected) {
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
              trailing: selected == 'Metric'
                  ? Icon(Icons.check, color: AppColors.forestGreen)
                  : null,
              onTap: () async {
                await ref
                    .read(appSettingsNotifierProvider.notifier)
                    .setValue('units_system', 'metric');
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.straighten, color: AppColors.slate),
              title: const Text('Imperial'),
              subtitle: const Text('in, lb'),
              trailing: selected == 'Imperial'
                  ? Icon(Icons.check, color: AppColors.forestGreen)
                  : null,
              onTap: () async {
                await ref
                    .read(appSettingsNotifierProvider.notifier)
                    .setValue('units_system', 'imperial');
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showTemperaturePicker(
    BuildContext context,
    WidgetRef ref,
    String selected,
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
                'Temperature Unit',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.thermostat, color: AppColors.forestGreen),
              title: const Text('Celsius (°C)'),
              trailing: selected == 'Celsius'
                  ? Icon(Icons.check, color: AppColors.forestGreen)
                  : null,
              onTap: () async {
                await ref
                    .read(appSettingsNotifierProvider.notifier)
                    .setValue('temperature_unit', 'celsius');
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.thermostat, color: AppColors.slate),
              title: const Text('Fahrenheit (°F)'),
              trailing: selected == 'Fahrenheit'
                  ? Icon(Icons.check, color: AppColors.forestGreen)
                  : null,
              onTap: () async {
                await ref
                    .read(appSettingsNotifierProvider.notifier)
                    .setValue('temperature_unit', 'fahrenheit');
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
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
              trailing: Text(
                'Coming Soon',
                style: TextStyle(color: AppColors.slate, fontSize: 12),
              ),
              enabled: false,
            ),
            ListTile(
              leading: Icon(Icons.language, color: AppColors.slate),
              title: const Text('French'),
              trailing: Text(
                'Coming Soon',
                style: TextStyle(color: AppColors.slate, fontSize: 12),
              ),
              enabled: false,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showSyncSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sync Preferences',
                style: AppTypography.light.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'iCloud and Google Drive sync coming in a future update.',
                style: AppTypography.light.bodyMedium?.copyWith(
                  color: AppColors.slate,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: AppColors.onBrand,
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showProfileEditDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> settings,
  ) async {
    final nameController = TextEditingController(
      text: settings['profile_name'] ?? '',
    );
    final emailController = TextEditingController(
      text: settings['profile_email'] ?? '',
    );
    final dateController = TextEditingController(
      text: settings['profile_date_of_birth'] ?? '',
    );
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Edit Profile',
          style: AppTypography.light.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                controller: nameController,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                keyboardType: TextInputType.datetime,
                controller: dateController,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.slate)),
          ),
          TextButton(
            onPressed: () async {
              final notifier = ref.read(appSettingsNotifierProvider.notifier);
              await notifier.setValue(
                'profile_name',
                nameController.text.trim(),
              );
              await notifier.setValue(
                'profile_email',
                emailController.text.trim(),
              );
              await notifier.setValue(
                'profile_date_of_birth',
                dateController.text.trim(),
              );
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    nameController.dispose();
    emailController.dispose();
    dateController.dispose();
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
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
            vertical: AppSpacing.sm,
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
