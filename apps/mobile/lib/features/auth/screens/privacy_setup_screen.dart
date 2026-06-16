import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/providers/security_providers.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';

class PrivacySetupScreen extends ConsumerStatefulWidget {
  const PrivacySetupScreen({super.key});

  @override
  ConsumerState<PrivacySetupScreen> createState() => _PrivacySetupScreenState();
}

class _PrivacyStep {
  final String title;
  final String subtitle;

  const _PrivacyStep({required this.title, required this.subtitle});
}

class _PrivacySetupScreenState extends ConsumerState<PrivacySetupScreen> {
  int _currentStep = 0;
  bool _biometricAvailable = false;
  bool _biometricEnrolled = false;
  String _pin = '';
  String _confirmPin = '';
  bool _showPinError = false;
  bool _isLoading = false;

  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _localAuth = LocalAuthentication();

  final _steps = const [
    _PrivacyStep(
      title: 'What matters most to you?',
      subtitle: 'Choose the privacy features that fit your needs.',
    ),
    _PrivacyStep(
      title: 'Secure with Biometrics',
      subtitle: 'Use your fingerprint or face to unlock Cyra quickly.',
    ),
    _PrivacyStep(
      title: 'Set a Passcode',
      subtitle: 'Create a 4-6 digit PIN for an extra layer of security.',
    ),
    _PrivacyStep(
      title: "You're all set",
      subtitle: "Here's a summary of your privacy choices.",
    ),
  ];

  PrivacyConfig get _config => ref.read(privacySettingsProvider);

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final available = await _localAuth.canCheckBiometrics;
      final enrolled = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _biometricAvailable = available && enrolled;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _biometricAvailable = false);
      }
    }
  }

  Future<void> _goNext() async {
    if (_currentStep == 2) {
      if (_pin.length < 4) return;
      if (_pin != _confirmPin) {
        setState(() {
          _showPinError = true;
        });
        return;
      }
      setState(() => _isLoading = true);
      try {
        await ref.read(pinAuthServiceProvider).setPin(_pin);
        ref.read(privacySettingsProvider.notifier).updatePin(true);
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _showPinError = true;
          _isLoading = false;
        });
        return;
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _showPinError = false;
      });
    } else {
      ref.read(onboardingStateProvider.notifier).complete();
      await ref.read(authStateNotifierProvider.notifier).authenticate();
      if (!mounted) return;
      context.go('/dashboard');
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _showPinError = false;
      });
    } else {
      context.go('/onboarding');
    }
  }

  void _togglePrivacyOption(String key, bool value) {
    final notifier = ref.read(privacySettingsProvider.notifier);
    switch (key) {
      case 'biometric':
        notifier.updateBiometric(value);
      case 'privateMode':
        notifier.updatePrivateMode(value);
      case 'hiddenAppIcon':
        notifier.updateHiddenAppIcon(value);
      case 'emergencyLock':
        notifier.updateEmergencyLock(value);
    }
  }

  Future<void> _enrollBiometrics() async {
    setState(() => _isLoading = true);
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Secure Cyra with your biometrics',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (mounted) {
        setState(() {
          _biometricEnrolled = authenticated;
          _isLoading = false;
        });
        if (authenticated) {
          ref.read(privacySettingsProvider.notifier).updateBiometric(true);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressIndicator(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
                child: _buildStepContent(),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.charcoal,
            ),
            splashRadius: 20,
          ),
          const Spacer(),
          Text(
            'Privacy Setup',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.slate,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(
              _steps.length,
              (index) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? AppColors.forestGreen
                        : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Step ${_currentStep + 1} of ${_steps.length}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return Padding(
      key: ValueKey(_currentStep),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            _steps[_currentStep].title,
            style: const TextStyle(
                            fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _steps[_currentStep].subtitle,
            style: TextStyle(
                            fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Expanded(child: _buildStepBody()),
        ],
      ),
    );
  }

  Widget _buildStepBody() {
    switch (_currentStep) {
      case 0:
        return _buildPrivacyOptions();
      case 1:
        return _buildBiometricStep();
      case 2:
        return _buildPinStep();
      case 3:
        return _buildSummaryStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPrivacyOptions() {
    final options = [
      _PrivacyOption(
        key: 'biometric',
        icon: Icons.fingerprint,
        title: 'Biometric Lock',
        description:
            'Unlock Cyra with Face ID or fingerprint. Quick and secure.',
        enabled: _config.biometricEnabled,
      ),
      _PrivacyOption(
        key: 'privateMode',
        icon: Icons.visibility_off_rounded,
        title: 'Private Mode',
        description: 'Hide sensitive content from previews and notifications.',
        enabled: _config.privateModeEnabled,
      ),
      _PrivacyOption(
        key: 'hiddenAppIcon',
        icon: Icons.app_shortcut_outlined,
        title: 'Hide App Icon',
        description:
            'Replace the Cyra icon with a neutral icon on your home screen.',
        enabled: _config.hiddenAppIconEnabled,
      ),
      _PrivacyOption(
        key: 'emergencyLock',
        icon: Icons.shield_outlined,
        title: 'Emergency Privacy Gesture',
        description:
            'Quickly disguise Cyra as a calculator app with a secret gesture.',
        enabled: _config.emergencyLockEnabled,
      ),
    ];

    return ListView.separated(
      itemCount: options.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final option = options[index];
        return _PrivacyOptionCard(
          option: option,
          onToggle: (value) => _togglePrivacyOption(option.key, value),
        );
      },
    );
  }

  Widget _buildBiometricStep() {
    if (!_biometricAvailable) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smartphone_outlined,
              size: 64,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Biometrics not available',
              style: TextStyle(
                                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your device does not support biometric authentication.\nYou can set a passcode instead.',
              textAlign: TextAlign.center,
              style: TextStyle(
                                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.slate.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.forestGreen.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.fingerprint,
              size: 52,
              color: _biometricEnrolled
                  ? AppColors.forestGreen
                  : AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            _biometricEnrolled ? 'Biometrics Enrolled' : 'Enroll Biometrics',
            style: const TextStyle(
                            fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _biometricEnrolled
                ? 'Your biometric data is securely stored on your device.'
                : 'Use your fingerprint or Face ID to unlock Cyra.',
            textAlign: TextAlign.center,
            style: TextStyle(
                            fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          if (!_biometricEnrolled)
            AppButton.primary(
              'Enroll Now',
              onPressed: _isLoading ? null : _enrollBiometrics,
              isLoading: _isLoading,
              icon: Icons.fingerprint,
              width: 220,
            ),
        ],
      ),
    );
  }

  Widget _buildPinStep() {
    return Column(
      children: [
        _buildPinField(
          controller: _pinController,
          label: 'Enter PIN',
          value: _pin,
          onChanged: (v) {
            if (v.length <= 6) {
              setState(() {
                _pin = v;
                _showPinError = false;
              });
            }
          },
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildPinField(
          controller: _confirmPinController,
          label: 'Confirm PIN',
          value: _confirmPin,
          onChanged: (v) {
            if (v.length <= 6) {
              setState(() {
                _confirmPin = v;
                _showPinError = false;
              });
            }
          },
        ),
        if (_showPinError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 16, color: AppColors.error),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'PINs do not match. Please try again.',
                  style: TextStyle(
                                        fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
                        fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.mistWhite,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _showPinError ? AppColors.error : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              ...List.generate(6, (i) {
                final isFilled = i < value.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? AppColors.forestGreen
                        : AppColors.borderLight,
                    border: isFilled
                        ? null
                        : Border.all(
                            color: AppColors.slate.withValues(alpha: 0.3),
                          ),
                  ),
                );
              }),
              const SizedBox(height: 64),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '4-6 digits',
          style: TextStyle(
                        fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.slate.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    final items = [
      _SummaryItem(
        icon: _config.biometricEnabled
            ? Icons.fingerprint
            : Icons.fingerprint_outlined,
        title: 'Biometric Lock',
        value: _config.biometricEnabled ? 'Enabled' : 'Not set',
        enabled: _config.biometricEnabled,
      ),
      _SummaryItem(
        icon: _config.pinEnabled ? Icons.lock : Icons.lock_outline,
        title: 'Passcode',
        value: _config.pinEnabled ? 'Enabled' : 'Not set',
        enabled: _config.pinEnabled,
      ),
      _SummaryItem(
        icon: _config.privateModeEnabled
            ? Icons.visibility_off_rounded
            : Icons.visibility_outlined,
        title: 'Private Mode',
        value: _config.privateModeEnabled ? 'Active' : 'Off',
        enabled: _config.privateModeEnabled,
      ),
      _SummaryItem(
        icon: _config.hiddenAppIconEnabled
            ? Icons.app_shortcut_rounded
            : Icons.app_shortcut_outlined,
        title: 'Hidden App Icon',
        value: _config.hiddenAppIconEnabled ? 'Active' : 'Off',
        enabled: _config.hiddenAppIconEnabled,
      ),
      _SummaryItem(
        icon: _config.emergencyLockEnabled
            ? Icons.shield
            : Icons.shield_outlined,
        title: 'Emergency Privacy Gesture',
        value: _config.emergencyLockEnabled ? 'Active' : 'Off',
        enabled: _config.emergencyLockEnabled,
      ),
    ];

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.forestGreen.withValues(alpha: 0.1),
          ),
          child: const Icon(
            Icons.check,
            size: 36,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: item.enabled
                          ? AppColors.forestGreen
                          : AppColors.slate.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                                                    fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                    Text(
                      item.value,
                      style: TextStyle(
                                                fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: item.enabled
                            ? AppColors.forestGreen
                            : AppColors.slate.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final canProceed =
        _currentStep != 2 || (_pin.length >= 4 && _pin == _confirmPin);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AppButton.primary(
        _currentStep < _steps.length - 1 ? 'Continue' : 'Start Your Journey',
        onPressed: canProceed && !_isLoading ? _goNext : null,
        isLoading: _isLoading,
        width: double.infinity,
        height: 54,
      ),
    );
  }
}

class _PrivacyOption {
  final String key;
  final IconData icon;
  final String title;
  final String description;
  final bool enabled;

  const _PrivacyOption({
    required this.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.enabled,
  });
}

class _PrivacyOptionCard extends StatefulWidget {
  final _PrivacyOption option;
  final ValueChanged<bool> onToggle;

  const _PrivacyOptionCard({required this.option, required this.onToggle});

  @override
  State<_PrivacyOptionCard> createState() => _PrivacyOptionCardState();
}

class _PrivacyOptionCardState extends State<_PrivacyOptionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final option = widget.option;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: option.enabled
              ? AppColors.forestGreen.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    option.icon,
                    size: 24,
                    color: option.enabled
                        ? AppColors.forestGreen
                        : AppColors.slate,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: TextStyle(
                                                        fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                        if (_expanded) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            option.description,
                            style: TextStyle(
                                                            fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: AppColors.slate,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => widget.onToggle(!option.enabled),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: option.enabled
                            ? AppColors.forestGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: option.enabled
                              ? AppColors.forestGreen
                              : AppColors.slate.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: option.enabled
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final IconData icon;
  final String title;
  final String value;
  final bool enabled;

  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.enabled,
  });
}
