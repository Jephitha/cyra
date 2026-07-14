import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/security/biometric_auth_service.dart';
import 'package:cyra/core/security/app_icon_service.dart';
import 'package:cyra/core/security/data_export_service.dart';
import 'package:cyra/core/security/privacy_service.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';
import 'package:cyra/features/privacy/screens/emergency_setup_screen.dart';
import 'package:cyra/features/privacy/widgets/health_data_export_sheet.dart';

class PrivacyControlsScreen extends ConsumerStatefulWidget {
  const PrivacyControlsScreen({super.key});

  @override
  ConsumerState<PrivacyControlsScreen> createState() =>
      _PrivacyControlsScreenState();
}

class _PrivacyControlsScreenState extends ConsumerState<PrivacyControlsScreen> {
  @override
  void initState() {
    super.initState();
    _syncHiddenAppIcon();
  }

  Future<void> _syncHiddenAppIcon() async {
    try {
      final hidden = await ref
          .read(appIconServiceProvider)
          .isHiddenAppIconEnabled();
      if (mounted) {
        ref.read(privacySettingsProvider.notifier).updateHiddenAppIcon(hidden);
      }
    } on AppIconException {
      // Keep the in-memory setting if the launcher cannot report its state.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildSectionHeader(context, 'Lock & Security'),
          const SizedBox(height: AppSpacing.sm),
          _buildLockSecuritySection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader(context, 'Data Privacy'),
          const SizedBox(height: AppSpacing.sm),
          _buildDataPrivacySection(context),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader(context, 'Your Data'),
          const SizedBox(height: AppSpacing.sm),
          _buildYourDataSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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

  Widget _buildLockSecuritySection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _buildBiometricToggle(),
          const Divider(height: 1),
          _buildPinToggle(),
          const Divider(height: 1),
          _buildAutoLockPicker(),
        ],
      ),
    );
  }

  Widget _buildBiometricToggle() {
    final enabled = ref.watch(
      privacySettingsProvider.select((c) => c.biometricEnabled),
    );
    final authService = ref.watch(biometricAuthServiceProvider);

    return _SettingRow(
      icon: Icons.fingerprint,
      label: 'Biometric Lock',
      subtitle: 'Unlock with Face ID or fingerprint',
      trailing: Switch.adaptive(
        value: enabled,
        activeTrackColor: AppColors.forestGreen,
        onChanged: (value) async {
          if (value) {
            final available = await authService.isBiometricAvailable();
            if (!available && mounted) {
              context.showSnackBar(
                'Biometric authentication is not available on this device',
                isError: true,
              );
              return;
            }
            final authenticated = await authService.authenticateWithBiometrics(
              reason: 'Enable biometric lock',
            );
            if (!authenticated && mounted) {
              context.showSnackBar('Authentication failed', isError: true);
              return;
            }
          }
          if (mounted) {
            ref.read(privacySettingsProvider.notifier).updateBiometric(value);
            context.showSnackBar(
              value ? 'Biometric lock enabled' : 'Biometric lock disabled',
            );
          }
        },
      ),
    );
  }

  Widget _buildPinToggle() {
    final enabled = ref.watch(
      privacySettingsProvider.select((c) => c.pinEnabled),
    );
    final authService = ref.watch(biometricAuthServiceProvider);

    return _SettingRow(
      icon: Icons.pin_outlined,
      label: 'PIN Code',
      subtitle: enabled
          ? 'Change your PIN code'
          : 'Set a PIN code for extra security',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (enabled)
            TextButton(
              onPressed: () => context.push('/settings/pin'),
              child: const Text('Change'),
            ),
          Switch.adaptive(
            value: enabled,
            activeTrackColor: AppColors.forestGreen,
            onChanged: (value) async {
              if (value) {
                final result = await context.push<bool>('/settings/pin');
                if (result == true && mounted) {
                  ref.read(privacySettingsProvider.notifier).updatePin(true);
                  context.showSnackBar('PIN code enabled');
                }
              } else {
                final confirmed = await _showConfirmDialog(
                  context,
                  title: 'Disable PIN Code?',
                  message:
                      'Your data will no longer be protected by a PIN. You can re-enable this at any time.',
                );
                if (confirmed == true && mounted) {
                  await authService.clearPinCode();
                  if (!mounted) return;
                  ref.read(privacySettingsProvider.notifier).updatePin(false);
                  context.showSnackBar('PIN code disabled');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAutoLockPicker() {
    return _SettingRow(
      icon: Icons.timer_outlined,
      label: 'Auto-Lock Timer',
      subtitle: 'Lock app after inactivity',
      trailing: _AutoLockDropdown(),
    );
  }

  Widget _buildDataPrivacySection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        children: [
          _buildPrivateModeToggle(),
          const Divider(height: 1),
          _buildHiddenAppIconToggle(),
          const Divider(height: 1),
          _buildEmergencyLockRow(context),
        ],
      ),
    );
  }

  Widget _buildPrivateModeToggle() {
    final privateMode = ref.watch(
      privacySettingsProvider.select((c) => c.privateModeEnabled),
    );
    final privacyService = ref.watch(privacyServiceProvider);

    return _SettingRow(
      icon: Icons.visibility_off_outlined,
      label: 'Private Mode',
      subtitle: 'Hide sensitive content from notification previews',
      trailing: Switch.adaptive(
        value: privateMode,
        activeTrackColor: AppColors.forestGreen,
        onChanged: (value) async {
          if (value) {
            await privacyService.enablePrivateMode();
          } else {
            await privacyService.disablePrivateMode();
          }
          if (mounted) {
            ref.read(privacySettingsProvider.notifier).updatePrivateMode(value);
            context.showSnackBar(
              value ? 'Private mode enabled' : 'Private mode disabled',
            );
          }
        },
      ),
    );
  }

  Widget _buildHiddenAppIconToggle() {
    final hiddenAppIcon = ref.watch(
      privacySettingsProvider.select((c) => c.hiddenAppIconEnabled),
    );

    return _SettingRow(
      icon: Icons.apps_outlined,
      label: 'Hidden App Icon',
      subtitle: 'Change the home screen icon to a neutral weather symbol',
      trailing: Switch.adaptive(
        value: hiddenAppIcon,
        activeTrackColor: AppColors.forestGreen,
        onChanged: (value) async {
          try {
            await ref.read(appIconServiceProvider).setHiddenAppIcon(value);
            if (!mounted) return;
            ref
                .read(privacySettingsProvider.notifier)
                .updateHiddenAppIcon(value);
            context.showSnackBar(
              value
                  ? 'Weather home screen icon enabled'
                  : 'Cyra home screen icon restored',
            );
          } on AppIconException catch (error) {
            if (!mounted) return;
            context.showSnackBar(error.message, isError: true);
          }
        },
      ),
    );
  }

  Widget _buildEmergencyLockRow(BuildContext context) {
    final emergencyLock = ref.watch(
      privacySettingsProvider.select((c) => c.emergencyLockEnabled),
    );

    return _SettingRow(
      icon: Icons.shield_outlined,
      label: 'Emergency Lock',
      subtitle: emergencyLock
          ? 'Double tap the Home lock icon to activate'
          : 'Enable the Home lock icon emergency gesture',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emergencyLock)
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EmergencySetupScreen(),
                ),
              ),
              child: const Text('Configure'),
            ),
          Switch.adaptive(
            value: emergencyLock,
            activeTrackColor: AppColors.forestGreen,
            onChanged: (value) {
              ref
                  .read(privacySettingsProvider.notifier)
                  .updateEmergencyLock(value);
              if (value) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EmergencySetupScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYourDataSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              'Create a readable health summary or manage your stored data.',
              style: AppTypography.light.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ),
          const Divider(height: 1),
          _ActionRow(
            icon: Icons.picture_as_pdf_outlined,
            label: 'Export my data',
            subtitle: 'Create a readable PDF for you or your care team',
            onTap: _showPdfExportSheet,
          ),
          const Divider(height: 1),
          _buildDeleteDateRangeButton(context),
          const Divider(height: 1),
          _buildDeleteAllButton(context),
        ],
      ),
    );
  }

  void _showPdfExportSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const HealthDataExportSheet(),
    );
  }

  Widget _buildDeleteDateRangeButton(BuildContext context) {
    return _ActionRow(
      icon: Icons.delete_sweep_outlined,
      label: 'Delete Date Range',
      subtitle: 'Remove data for a specific date range',
      textColor: AppColors.warning,
      onTap: () => _handleDeleteDateRange(context),
    );
  }

  Widget _buildDeleteAllButton(BuildContext context) {
    return _ActionRow(
      icon: Icons.delete_forever_outlined,
      label: 'Delete All Data',
      subtitle: 'Permanently remove all your health data',
      textColor: AppColors.error,
      onTap: () => _handleDeleteAll(context),
    );
  }

  Future<void> _handleDeleteDateRange(BuildContext context) async {
    final range = await _showDateRangePicker(context);
    if (range == null || !context.mounted) return;

    final confirmed = await _showConfirmDialog(
      context,
      title: 'Delete Data Range?',
      message:
          'This will permanently delete all health data from '
          '${DateFormat.yMd().format(range.start)} to ${DateFormat.yMd().format(range.end)}. '
          'This action cannot be undone.',
      isDestructive: true,
      confirmLabel: 'Delete Range',
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final exportService = ref.read(dataExportServiceProvider);
      await exportService.deleteDateRange(range.start, range.end);

      if (context.mounted) {
        context.showSnackBar('Data range deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('Delete failed: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _handleDeleteAll(BuildContext context) async {
    final firstConfirm = await _showConfirmDialog(
      context,
      title: 'Delete All Data?',
      message:
          'This will permanently delete ALL your health data, including cycles, symptoms, journal entries, '
          'and all other recorded information. This action cannot be undone.',
      isDestructive: true,
      confirmLabel: 'Continue',
    );
    if (firstConfirm != true || !context.mounted) return;

    final secondConfirm = await _showConfirmDialog(
      context,
      title: 'Are you absolutely sure?',
      message:
          'All your data will be permanently erased. This includes years of health tracking data.',
      isDestructive: true,
      confirmLabel: 'Delete Everything',
    );
    if (secondConfirm != true || !context.mounted) return;

    try {
      final exportService = ref.read(dataExportServiceProvider);
      await exportService.deleteAllData();

      if (context.mounted) {
        context.showSnackBar('All data has been permanently deleted');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('Delete failed: ${e.toString()}', isError: true);
      }
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    bool isDestructive = false,
    String confirmLabel = 'Confirm',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: AppColors.error)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  Future<DateTimeRange?> _showDateRangePicker(BuildContext context) {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.forestGreen),
          ),
          child: child!,
        );
      },
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Widget? trailing;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? textColor;
  final VoidCallback? onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = textColor ?? AppColors.forestGreen;

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
              Icon(icon, size: 22, color: effectiveColor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.light.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: effectiveColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.light.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.chevron_right, color: AppColors.slate, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutoLockDropdown extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMinutes = ref.watch(
      privacySettingsProvider.select((c) => c.autoLockMinutes),
    );
    final durationOptions = <int, String>{
      0: 'Immediately',
      1: '1 min',
      5: '5 min',
      15: '15 min',
      30: '30 min',
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: durationOptions[currentMinutes] ?? '5 min',
        isDense: true,
        style: AppTypography.light.bodyMedium?.copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w500,
        ),
        items: durationOptions.entries.map((entry) {
          return DropdownMenuItem(value: entry.value, child: Text(entry.value));
        }).toList(),
        onChanged: (value) {
          final minutes = durationOptions.entries
              .firstWhere(
                (e) => e.value == value,
                orElse: () => const MapEntry(5, '5 min'),
              )
              .key;
          ref.read(privacySettingsProvider.notifier).updateAutoLock(minutes);
        },
      ),
    );
  }
}
