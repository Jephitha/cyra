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
  bool _skipBiometricStep = false;
  String _pin = '';
  String _confirmPin = '';
  bool _showPinError = false;
  bool _pinFocused = false;
  bool _confirmPinFocused = false;
  bool _isLoading = false;

  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  final _confirmPinFocusNode = FocusNode();
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
      subtitle: 'Create a 6 digit PIN for added security.',
    ),
    _PrivacyStep(
      title: "You're all set",
      subtitle: "Here's a summary of your privacy choices.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _pinFocusNode.addListener(() {
      if (mounted) setState(() => _pinFocused = _pinFocusNode.hasFocus);
    });
    _confirmPinFocusNode.addListener(() {
      if (mounted) setState(() => _confirmPinFocused = _confirmPinFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final enrolled = await _localAuth.canCheckBiometrics;
      final deviceSupported = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _biometricAvailable = enrolled;
          _skipBiometricStep = !deviceSupported || !enrolled;
          if (_skipBiometricStep) {
            _biometricEnrolled = false;
            ref.read(privacySettingsProvider.notifier).updateBiometric(false);
            if (_currentStep == 1) {
              _currentStep = 2;
            }
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _biometricAvailable = false;
          _skipBiometricStep = true;
          _biometricEnrolled = false;
        });
      }
    }
  }

  Future<void> _goNext() async {
    if (_currentStep == 2) {
      if (_pin.length < 5) return;
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
      ref.read(authStateNotifierProvider.notifier).ensureAuthenticated();
      ref
          .read(secureStorageServiceProvider)
          .storeString('privacy_setup_complete', 'true');
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
                duration: const Duration(milliseconds: 200),
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
                  duration: const Duration(milliseconds: 150),
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
      padding: EdgeInsets.symmetric(
        horizontal: _currentStep == 0 ? AppSpacing.md : AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: _currentStep == 0 ? AppSpacing.sm : AppSpacing.xl),
          Text(
            _steps[_currentStep].title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _steps[_currentStep].subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.slate,
            ),
          ),
          SizedBox(height: _currentStep == 0 ? AppSpacing.sm : AppSpacing.xxxl),
          Expanded(
            child: _buildStepBody(),
          ),
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
    return Consumer(
      builder: (context, consumerRef, child) {
        final config = consumerRef.watch(privacySettingsProvider);
        final options = [
          _PrivacyOption(
            key: 'biometric',
            icon: Icons.fingerprint,
            title: 'Biometric Lock',
            description:
                'Unlock Cyra with Face ID or fingerprint. Quick and secure.',
            enabled: _skipBiometricStep ? false : config.biometricEnabled,
          ),
          _PrivacyOption(
            key: 'privateMode',
            icon: Icons.visibility_off_rounded,
            title: 'Private Mode',
            description: 'Hide sensitive content from previews and notifications.',
            enabled: config.privateModeEnabled,
          ),
          _PrivacyOption(
            key: 'hiddenAppIcon',
            icon: Icons.app_shortcut_outlined,
            title: 'Hide App Icon',
            description:
                'Replace the Cyra icon with a neutral icon on your home screen.',
            enabled: config.hiddenAppIconEnabled,
          ),
          _PrivacyOption(
            key: 'emergencyLock',
            icon: Icons.shield_outlined,
            title: 'Emergency Privacy Gesture',
            description:
                'Quickly disguise Cyra as a calculator app with a secret gesture.',
            enabled: config.emergencyLockEnabled,
          ),
        ];

        return ListView.separated(
          itemCount: options.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final option = options[index];
            return _PrivacyOptionCard(
              option: option,
              onToggle: (value) => _togglePrivacyOption(option.key, value),
            );
          },
        );
      },
    );
  }

  Widget _buildBiometricStep() {
    if (_skipBiometricStep) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint_outlined,
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
              'Tap Continue to set a passcode',
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

    if (!_biometricAvailable) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint_outlined,
              size: 64,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No biometrics enrolled',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your device supports biometric authentication, but no fingerprints or faces are registered yet.\nRegister them in Settings, or set a passcode instead.',
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
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final compactMode = keyboardInset > 0;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset * 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPinField(
            controller: _pinController,
            focusNode: _pinFocusNode,
            label: 'Enter PIN',
            value: _pin,
            dense: compactMode,
            isFocused: _pinFocused,
            onChanged: (v) {
              if (v.length <= 5) {
                setState(() {
                  _pin = v;
                  _showPinError = false;
                });
              } else {
                _pinController.text = v.substring(0, 5);
                _pinController.selection = TextSelection.collapsed(offset: 5);
              }
            },
          ),
          SizedBox(height: compactMode ? 4 : AppSpacing.lg),
          _buildPinField(
            controller: _confirmPinController,
            focusNode: _confirmPinFocusNode,
            label: 'Confirm PIN',
            dense: compactMode,
            isFocused: _confirmPinFocused,
            value: _confirmPin,
            onChanged: (v) {
              if (v.length <= 5) {
                setState(() {
                  _confirmPin = v;
                  _showPinError = false;
                });
              } else {
                _confirmPinController.text = v.substring(0, 5);
                _confirmPinController.selection = TextSelection.collapsed(offset: 5);
              }
            },
          ),
          if (_showPinError)
            Padding(
              padding: EdgeInsets.only(top: compactMode ? 0 : AppSpacing.lg),
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
      ),
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String value,
    required bool dense,
    required bool isFocused,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.charcoal,
          ),
        ),
        SizedBox(height: dense ? 4 : AppSpacing.sm),
        GestureDetector(
          onTap: () => focusNode.requestFocus(),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mistWhite,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: _showPinError
                        ? AppColors.error
                        : isFocused
                            ? AppColors.forestGreen
                            : AppColors.borderLight,
                    width: isFocused ? 2 : 1,
                  ),
                ),
                height: dense ? 48 : 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(5, (i) {
                      final isFilled = i < value.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 80),
                        margin: EdgeInsets.symmetric(horizontal: dense ? 5 : 8),
                        width: dense ? 11 : 14,
                        height: dense ? 11 : 14,
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
                  ],
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.0,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    onEditingComplete: () {
                      if (focusNode == _pinFocusNode) {
                        _confirmPinFocusNode.requestFocus();
                      }
                    },
                    style: const TextStyle(fontSize: 1),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: onChanged,
                    buildCounter: (
                      _, {required currentLength, required isFocused, maxLength}
                    ) => null,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: dense ? 2 : AppSpacing.sm),
        Text(
          '5 digits',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.slate.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    return Consumer(
      builder: (context, consumerRef, child) {
        final config = consumerRef.watch(privacySettingsProvider);
        final biometricEnabled = _skipBiometricStep ? false : config.biometricEnabled;
        final items = [
          _SummaryItem(
            icon: biometricEnabled
                ? Icons.fingerprint
                : Icons.fingerprint_outlined,
            title: 'Biometric Lock',
            value: biometricEnabled ? 'Enabled' : 'Not set',
            enabled: biometricEnabled,
          ),
          _SummaryItem(
            icon: config.pinEnabled ? Icons.lock : Icons.lock_outline,
            title: 'Passcode',
            value: config.pinEnabled ? 'Enabled' : 'Not set',
            enabled: config.pinEnabled,
          ),
          _SummaryItem(
            icon: config.privateModeEnabled
                ? Icons.visibility_off_rounded
                : Icons.visibility_outlined,
            title: 'Private Mode',
            value: config.privateModeEnabled ? 'Active' : 'Off',
            enabled: config.privateModeEnabled,
          ),
          _SummaryItem(
            icon: config.hiddenAppIconEnabled
                ? Icons.app_shortcut_rounded
                : Icons.app_shortcut_outlined,
            title: 'Hidden App Icon',
            value: config.hiddenAppIconEnabled ? 'Active' : 'Off',
            enabled: config.hiddenAppIconEnabled,
          ),
          _SummaryItem(
            icon: config.emergencyLockEnabled
                ? Icons.shield
                : Icons.shield_outlined,
            title: 'Emergency Privacy Gesture',
            value: config.emergencyLockEnabled ? 'Active' : 'Off',
            enabled: config.emergencyLockEnabled,
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
      },
    );
  }

  Widget _buildBottomBar() {
    final canProceed =
        _currentStep != 2 || (_pin.length >= 5 && _pin == _confirmPin);
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final compactBottom = keyboardInset > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        compactBottom ? 2 : AppSpacing.lg,
        AppSpacing.xxl,
        compactBottom ? 4 : AppSpacing.xxxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
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
        height: compactBottom ? 42 : 54,
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

class _PrivacyOptionCard extends StatelessWidget {
  final _PrivacyOption option;
  final ValueChanged<bool> onToggle;

  const _PrivacyOptionCard({required this.option, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onToggle(!option.enabled),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: option.enabled
                ? AppColors.forestGreen.withAlpha(76)
                : AppColors.borderLight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                option.icon,
                size: 20,
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
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      option.description,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.enabled
                      ? AppColors.forestGreen
                      : Colors.transparent,
                  border: Border.all(
                    color: option.enabled
                        ? AppColors.forestGreen
                        : AppColors.slate.withAlpha(102),
                    width: 2,
                  ),
                ),
                child: option.enabled
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.onBrand,
                      )
                    : null,
              ),
            ],
          ),
        ),
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
