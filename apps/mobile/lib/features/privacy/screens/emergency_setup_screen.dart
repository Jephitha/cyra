import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';

class EmergencySetupScreen extends ConsumerStatefulWidget {
  const EmergencySetupScreen({super.key});

  @override
  ConsumerState<EmergencySetupScreen> createState() => _EmergencySetupScreenState();
}

class _EmergencySetupScreenState extends ConsumerState<EmergencySetupScreen> {
  // Persistent settings from provider
  String? _selectedTrigger;
  String _decoyAppName = 'Health Tracker';
  String _lockScreenMessage = 'This app is locked for your privacy.';
  bool _showTestResult = false;
  bool _testSuccess = false;

  final _triggerOptions = [
    {
      'id': 'triple_tap',
      'icon': Icons.touch_app_outlined,
      'title': 'Triple Tap',
      'subtitle': 'Triple tap on the app icon to activate',
    },
    {
      'id': 'shake',
      'icon': Icons.vibration_outlined,
      'title': 'Shake Gesture',
      'subtitle': 'Shake your phone to activate emergency lock',
    },
    {
      'id': 'emergency_pin',
      'icon': Icons.pin_outlined,
      'title': 'Quick PIN Entry',
      'subtitle': 'Enter a dedicated emergency PIN to lock',
    },
    {
      'id': 'accessibility',
      'icon': Icons.accessibility_new_outlined,
      'title': 'Accessibility Shortcut',
      'subtitle': 'Use accessibility shortcut to trigger lock',
    },
  ];

  @override
  void initState() {
    super.initState();
    final config = ref.read(privacySettingsProvider);
    _selectedTrigger = config.emergencyLockEnabled ? 'triple_tap' : null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Lock Setup'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildExplanationBanner(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Trigger Method'),
          const SizedBox(height: AppSpacing.sm),
          _buildTriggerOptions(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Decoy Configuration'),
          const SizedBox(height: AppSpacing.sm),
          _buildDecoyConfig(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Test Emergency Lock'),
          const SizedBox(height: AppSpacing.sm),
          _buildTestSection(),
          const SizedBox(height: AppSpacing.xxl),
          _buildActionButtons(),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildExplanationBanner() {
    return AppCard.highlighted(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.forestGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: AppTypography.light.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Emergency lock instantly hides all health data and shows a safe screen. '
                  'Use it when someone else is looking at your phone.',
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildTriggerOptions() {
    return AppCard.standard(
      child: Column(
        children: _triggerOptions.map((option) {
          final isSelected = _selectedTrigger == option['id'];
          return Column(
            children: [
              if (_triggerOptions.indexOf(option) > 0)
                const Divider(height: 1),
              Material(
                color: isSelected
                    ? AppColors.forestGreen.withValues(alpha: 0.06)
                    : Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedTrigger = option['id'] as String),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          size: 22,
                          color: isSelected
                              ? AppColors.forestGreen
                              : AppColors.slate,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['title'] as String,
                                style: AppTypography.light.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                option['subtitle'] as String,
                                style: AppTypography.light.bodySmall?.copyWith(
                                  color: AppColors.slate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ignore: deprecated_member_use
                        Radio<String>(
                          value: option['id'] as String,
                          // ignore: deprecated_member_use
                          groupValue: _selectedTrigger,
                          activeColor: AppColors.forestGreen,
                          // ignore: deprecated_member_use
                          onChanged: (v) =>
                              setState(() => _selectedTrigger = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDecoyConfig() {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'When emergency lock is active, the app will appear as:',
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  initialValue: _decoyAppName,
                  decoration: InputDecoration(
                    labelText: 'Decoy App Name',
                    hintText: 'Health Tracker',
                    prefixIcon: Icon(Icons.apps_outlined),
                  ),
                  onChanged: (v) => _decoyAppName = v,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  initialValue: _lockScreenMessage,
                  decoration: InputDecoration(
                    labelText: 'Lock Screen Message',
                    hintText: 'Message shown on locked screen',
                    prefixIcon: Icon(Icons.message_outlined),
                  ),
                  maxLines: 2,
                  onChanged: (v) => _lockScreenMessage = v,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection() {
    return AppCard.standard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AppButton.primary(
              'Test Emergency Lock',
              icon: Icons.shield_outlined,
              onPressed: _handleTest,
            ),
            if (_showTestResult) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      _testSuccess ? Icons.check_circle : Icons.error_outline,
                      color: _testSuccess ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _testSuccess
                            ? 'Emergency lock activated successfully. App is now in safe mode.'
                            : 'Test failed. Please check your configuration.',
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: _testSuccess
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_testSuccess) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: _handleDeactivateTest,
                  child: const Text('Deactivate Test Lock'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton.secondary(
            'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppButton.primary(
            'Save Settings',
            icon: Icons.save_outlined,
            onPressed: _handleSave,
          ),
        ),
      ],
    );
  }

  Future<void> _handleTest() async {
    try {
      ref.read(isEmergencyLockedProvider.notifier).activate();
      setState(() {
        _testSuccess = true;
        _showTestResult = true;
      });
    } catch (e) {
      setState(() {
        _testSuccess = false;
        _showTestResult = true;
      });
    }
  }

  Future<void> _handleDeactivateTest() async {
    try {
      ref.read(isEmergencyLockedProvider.notifier).deactivate();
      setState(() {
        _testSuccess = false;
        _showTestResult = false;
      });
      if (mounted) {
        _showSnackBar(context, 'Emergency lock deactivated');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(context, 'Failed to deactivate: ${e.toString()}', isError: true);
      }
    }
  }

  void _handleSave() {
    if (_selectedTrigger == null) {
      _showSnackBar(context, 'Please select a trigger method', isError: true);
      return;
    }

    // Persist via privacy settings provider
    ref.read(privacySettingsProvider.notifier).updateEmergencyLock(true);

    _showSnackBar(context, 'Emergency lock settings saved');
    Navigator.of(context).pop();
  }
}

void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : null,
      ),
    );
}
