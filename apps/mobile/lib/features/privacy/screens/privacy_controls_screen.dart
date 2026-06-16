import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/core/security/biometric_auth_service.dart';
import 'package:cyra/core/security/data_export_service.dart';
import 'package:cyra/core/security/privacy_service.dart';
import 'package:cyra/features/privacy/screens/emergency_setup_screen.dart';
import 'package:cyra/features/settings/providers/settings_notifier.dart';

class PrivacyControlsScreen extends ConsumerStatefulWidget {
  const PrivacyControlsScreen({super.key});

  @override
  ConsumerState<PrivacyControlsScreen> createState() => _PrivacyControlsScreenState();
}

class _PrivacyControlsScreenState extends ConsumerState<PrivacyControlsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
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
    final biometricAsync = ref.watch(biometricEnabledProvider);
    final authService = ref.watch(biometricAuthServiceProvider);

    return biometricAsync.when(
      data: (enabled) {
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
                  context.showSnackBar('Biometric authentication is not available on this device', isError: true);
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
                ref.read(biometricEnabledProvider.notifier).setEnabled(value);
                context.showSnackBar(value ? 'Biometric lock enabled' : 'Biometric lock disabled');
              }
            },
          ),
        );
      },
      loading: () => const _SettingRow(
        icon: Icons.fingerprint,
        label: 'Biometric Lock',
        subtitle: 'Unlock with Face ID or fingerprint',
        trailing: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => _SettingRow(
        icon: Icons.fingerprint,
        label: 'Biometric Lock',
        subtitle: 'Unlock with Face ID or fingerprint',
        trailing: Icon(Icons.error_outline, color: AppColors.error, size: 20),
      ),
    );
  }

  Widget _buildPinToggle() {
    final pinAsync = ref.watch(pinEnabledProvider);
    final authService = ref.watch(biometricAuthServiceProvider);

    return pinAsync.when(
      data: (enabled) {
        return _SettingRow(
          icon: Icons.pin_outlined,
          label: 'PIN Code',
          subtitle: enabled ? 'Change your PIN code' : 'Set a PIN code for extra security',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (enabled)
                TextButton(
                  onPressed: () => _showPinChangeDialog(context, authService),
                  child: const Text('Change'),
                ),
              Switch.adaptive(
                value: enabled,
                activeTrackColor: AppColors.forestGreen,
                onChanged: (value) async {
                  if (value) {
                    final result = await _showPinSetupDialog(context, authService);
                    if (result == true && mounted) {
                      ref.read(pinEnabledProvider.notifier).setEnabled(true);
                      context.showSnackBar('PIN code enabled');
                    }
                  } else {
                    final confirmed = await _showConfirmDialog(
                      context,
                      title: 'Disable PIN Code?',
                      message: 'Your data will no longer be protected by a PIN. You can re-enable this at any time.',
                    );
                    if (confirmed == true && mounted) {
                      await authService.clearPinCode();
                      if (!mounted) return;
                      ref.read(pinEnabledProvider.notifier).setEnabled(false);
                      context.showSnackBar('PIN code disabled');
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
      loading: () => const _SettingRow(
        icon: Icons.pin_outlined,
        label: 'PIN Code',
        subtitle: 'Set a PIN code for extra security',
        trailing: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => _SettingRow(
        icon: Icons.pin_outlined,
        label: 'PIN Code',
        subtitle: 'Set a PIN code for extra security',
        trailing: Icon(Icons.error_outline, color: AppColors.error, size: 20),
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
    final privateMode =
        ref.watch(privateModeSettingProvider).valueOrNull ?? false;
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
            ref.read(privateModeSettingProvider.notifier).toggle();
            context.showSnackBar(value ? 'Private mode enabled' : 'Private mode disabled');
          }
        },
      ),
    );
  }

  Widget _buildHiddenAppIconToggle() {
    return _SettingRow(
      icon: Icons.apps_outlined,
      label: 'Hidden App Icon',
      subtitle: 'Change app icon to neutral "Health" icon',
      trailing: Switch.adaptive(
        value: false,
        activeTrackColor: AppColors.forestGreen,
        onChanged: (value) {
          context.showSnackBar('Hidden app icon requires platform-specific setup', isError: true);
        },
      ),
    );
  }

  Widget _buildEmergencyLockRow(BuildContext context) {
    return _SettingRow(
      icon: Icons.shield_outlined,
      label: 'Emergency Lock',
      subtitle: 'Configure emergency lock gesture',
      trailing: Icon(Icons.chevron_right, color: AppColors.slate),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const EmergencySetupScreen()),
      ),
    );
  }

  Widget _buildYourDataSection(BuildContext context) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            child: Text(
              'Manage your personal data. Exports are encrypted and saved locally.',
              style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
            ),
          ),
          const Divider(height: 1),
          _buildExportAllButton(),
          const Divider(height: 1),
          _buildExportDateRangeButton(),
          const Divider(height: 1),
          _buildDeleteDateRangeButton(context),
          const Divider(height: 1),
          _buildDeleteAllButton(context),
        ],
      ),
    );
  }

  Widget _buildExportAllButton() {
    return _ActionRow(
      icon: Icons.file_download_outlined,
      label: 'Export All Data',
      subtitle: 'Download a complete JSON archive of your data',
      onTap: () => _handleExportAll(),
    );
  }

  Widget _buildExportDateRangeButton() {
    return _ActionRow(
      icon: Icons.date_range_outlined,
      label: 'Export Date Range',
      subtitle: 'Export data for a specific date range',
      onTap: () => _handleExportDateRange(),
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

  Future<void> _handleExportAll() async {
    try {
      final authService = ref.read(biometricAuthServiceProvider);
      final authenticated = await authService.authenticateWithBiometricsOrPin(
        reason: 'Authenticate to export your data',
      );
      if (!authenticated) {
        if (mounted) context.showSnackBar('Authentication required to export data', isError: true);
        return;
      }

      final exportService = ref.read(dataExportServiceProvider);
      final file = await exportService.exportAllDataAsJson();

      if (mounted) {
        context.showSnackBar('Data exported successfully: ${file.path.split('/').last}');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Export failed: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _handleExportDateRange() async {
    final range = await _showDateRangePicker(context);
    if (range == null || !mounted) return;

    try {
      final authService = ref.read(biometricAuthServiceProvider);
      final authenticated = await authService.authenticateWithBiometricsOrPin(
        reason: 'Authenticate to export your data',
      );
      if (!authenticated) {
        if (mounted) context.showSnackBar('Authentication required to export data', isError: true);
        return;
      }

      final exportService = ref.read(dataExportServiceProvider);
      final file = await exportService.exportDateRange(range.start, range.end);

      if (mounted) {
        context.showSnackBar('Data exported successfully: ${file.path.split('/').last}');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Export failed: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _handleDeleteDateRange(BuildContext context) async {
    final range = await _showDateRangePicker(context);
    if (range == null || !context.mounted) return;

    final confirmed = await _showConfirmDialog(
      context,
      title: 'Delete Data Range?',
      message: 'This will permanently delete all health data from '
          '${DateFormat.yMd().format(range.start)} to ${DateFormat.yMd().format(range.end)}. '
          'This action cannot be undone.',
      isDestructive: true,
      confirmLabel: 'Delete Range',
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final authService = ref.read(biometricAuthServiceProvider);
      final authenticated = await authService.authenticateWithBiometricsOrPin(
        reason: 'Authenticate to delete data',
      );
      if (!authenticated) {
        if (context.mounted) context.showSnackBar('Authentication required to delete data', isError: true);
        return;
      }

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
      message: 'This will permanently delete ALL your health data, including cycles, symptoms, journal entries, '
          'and all other recorded information. This action cannot be undone.',
      isDestructive: true,
      confirmLabel: 'Continue',
    );
    if (firstConfirm != true || !context.mounted) return;

    final secondConfirm = await _showConfirmDialog(
      context,
      title: 'Are you absolutely sure?',
      message: 'All your data will be permanently erased. This includes years of health tracking data.',
      isDestructive: true,
      confirmLabel: 'Delete Everything',
    );
    if (secondConfirm != true || !context.mounted) return;

    try {
      final authService = ref.read(biometricAuthServiceProvider);
      final authenticated = await authService.authenticateWithBiometricsOrPin(
        reason: 'Authenticate to delete all data',
      );
      if (!authenticated) {
        if (context.mounted) context.showSnackBar('Authentication required to delete all data', isError: true);
        return;
      }

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

  Future<bool?> _showPinSetupDialog(BuildContext context, BiometricAuthService authService) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => _PinSetupDialog(authService: authService),
    );
  }

  Future<void> _showPinChangeDialog(BuildContext context, BiometricAuthService authService) async {
    final verified = await authService.authenticateWithBiometricsOrPin(
      reason: 'Verify your identity to change PIN',
    );
    if (!verified) {
      if (context.mounted) context.showSnackBar('Verification failed', isError: true);
      return;
    }
    if (context.mounted) {
      await _showPinSetupDialog(context, authService);
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
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.forestGreen,
            ),
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
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.subtitle,
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
        ),
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
    final currentDuration = ref.watch(autoLockDurationNotifierProvider);
    final durationOptions = <Duration, String>{
      Duration.zero: 'Immediately',
      const Duration(minutes: 1): '1 min',
      const Duration(minutes: 5): '5 min',
      const Duration(minutes: 15): '15 min',
      const Duration(minutes: 30): '30 min',
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: durationOptions[currentDuration] ?? '5 min',
        isDense: true,
        style: AppTypography.light.bodyMedium?.copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w500,
        ),
        items: durationOptions.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.value,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (value) {
          final duration = durationOptions.entries
              .firstWhere((e) => e.value == value,
                  orElse: () => MapEntry(const Duration(minutes: 5), '5 min'))
              .key;
          ref.read(autoLockDurationNotifierProvider.notifier).setDuration(duration);
        },
      ),
    );
  }
}

class _PinSetupDialog extends ConsumerStatefulWidget {
  final BiometricAuthService authService;

  const _PinSetupDialog({required this.authService});

  @override
  ConsumerState<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends ConsumerState<_PinSetupDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePin = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set PIN Code'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter a 4-8 digit PIN code to secure your app.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _pinController,
              obscureText: _obscurePin,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'PIN',
                counterText: '',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePin ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePin = !_obscurePin),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter a PIN';
                if (value.length < 4) return 'PIN must be at least 4 digits';
                if (!RegExp(r'^\d+$').hasMatch(value)) return 'PIN must contain only digits';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                counterText: '',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) {
                if (value != _pinController.text) return 'PINs do not match';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            try {
              await widget.authService.setPinCode(_pinController.text);
              if (context.mounted) Navigator.of(context).pop(true);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to set PIN: $e')),
                );
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

