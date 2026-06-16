import 'dart:async';
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

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with SingleTickerProviderStateMixin {
  final _localAuth = LocalAuthentication();
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _biometricAvailable = false;
  bool _useBiometrics = true;
  bool _showPinEntry = false;
  String _enteredPin = '';
  bool _showError = false;
  bool _isAuthenticating = false;
  bool _isLockedOut = false;
  int _lockoutTimerSeconds = 0;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );
    _animController.forward();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _animController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final available = await _localAuth.canCheckBiometrics;
      final enrolled = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _biometricAvailable = available && enrolled;
          _useBiometrics = _biometricAvailable;
        });
        if (_biometricAvailable &&
            ref.read(privacySettingsProvider).biometricEnabled) {
          _authenticateWithBiometrics();
        } else {
          setState(() => _showPinEntry = true);
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _biometricAvailable = false;
          _showPinEntry = true;
        });
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock Cyra',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (mounted) {
        setState(() => _isAuthenticating = false);

        if (authenticated) {
          ref.read(authStateNotifierProvider.notifier).authenticate();
          ref.read(failedPinAttemptsProvider.notifier).reset();
          if (context.mounted) context.go('/dashboard');
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  void _onPinDigit(String digit) {
    if (_isLockedOut) return;
    if (_enteredPin.length >= 6) return;

    setState(() {
      _enteredPin += digit;
      _showError = false;
    });

    if (_enteredPin.length >= 4) {
      _verifyPin();
    }
  }

  void _onDeleteDigit() {
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _showError = false;
    });
  }

  Future<void> _verifyPin() async {
    final pinAuth = ref.read(pinAuthServiceProvider);
    final isValid = await pinAuth.verifyPin(_enteredPin);

    if (isValid) {
      await ref.read(authStateNotifierProvider.notifier).authenticate();
      if (!mounted) return;
      ref.read(failedPinAttemptsProvider.notifier).reset();
      context.go('/dashboard');
    } else {
      final attempts = ref.read(failedPinAttemptsProvider);
      ref.read(failedPinAttemptsProvider.notifier).increment();
      final newAttempts = attempts + 1;

      setState(() {
        _showError = true;
        _enteredPin = '';
      });

      if (newAttempts >= 5) {
        _startLockout();
      }
    }
  }

  void _startLockout() {
    setState(() {
      _isLockedOut = true;
      _lockoutTimerSeconds = 30;
    });

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _lockoutTimerSeconds--;
        if (_lockoutTimerSeconds <= 0) {
          _isLockedOut = false;
          timer.cancel();
          ref.read(failedPinAttemptsProvider.notifier).reset();
        }
      });
    });
  }

  void _toggleAuthMode() {
    setState(() {
      if (_useBiometrics) {
        _showPinEntry = true;
        _useBiometrics = false;
      } else {
        _useBiometrics = true;
        _showPinEntry = false;
        _authenticateWithBiometrics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final failedAttempts = ref.watch(failedPinAttemptsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLockIcon(),
                    const SizedBox(height: AppSpacing.xxxl),
                    const Text(
                      'Cyra',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your private health companion',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.slate.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxxl),
                    if (_showPinEntry) _buildPinEntry(),
                    if (!_showPinEntry && _biometricAvailable)
                      _buildBiometricButton(),
                    if (_showError)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.lg),
                        child: _buildErrorMessage(failedAttempts),
                      ),
                    if (_isLockedOut)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.lg),
                        child: _buildLockoutMessage(),
                      ),
                    const SizedBox(height: AppSpacing.xxxl),
                    if (_biometricAvailable)
                      TextButton(
                        onPressed: _isLockedOut ? null : _toggleAuthMode,
                        child: Text(
                          _useBiometrics ? 'Use Passcode' : 'Use Face ID',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isLockedOut
                                ? AppColors.slate.withValues(alpha: 0.4)
                                : AppColors.forestGreen,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildEmergencyContact(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.forestGreen.withValues(alpha: 0.1),
      ),
      child: CustomPaint(
        painter: _LockRingPainter(),
        child: Center(
          child: Icon(
            Icons.lock_outline_rounded,
            size: 36,
            color: AppColors.forestGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildPinEntry() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _enteredPin.length
                    ? AppColors.forestGreen
                    : Colors.transparent,
                border: Border.all(
                  color: i < _enteredPin.length
                      ? AppColors.forestGreen
                      : AppColors.slate.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        _buildNumpad(),
      ],
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        _buildNumpadRow(['1', '2', '3']),
        _buildNumpadRow(['4', '5', '6']),
        _buildNumpadRow(['7', '8', '9']),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 80),
            _buildNumpadKey('0'),
            _buildNumpadDeleteKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumpadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((d) => _buildNumpadKey(d)).toList(),
    );
  }

  Widget _buildNumpadKey(String digit) {
    return Container(
      width: 80,
      height: 64,
      margin: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onPinDigit(digit),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          splashColor: AppColors.forestGreen.withValues(alpha: 0.1),
          highlightColor: AppColors.forestGreen.withValues(alpha: 0.05),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumpadDeleteKey() {
    return Container(
      width: 80,
      height: 64,
      margin: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onDeleteDigit,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          splashColor: AppColors.forestGreen.withValues(alpha: 0.1),
          highlightColor: AppColors.forestGreen.withValues(alpha: 0.05),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 22,
              color: AppColors.slate,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return Column(
      children: [
        if (_isAuthenticating) ...[
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Authenticating...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.slate,
            ),
          ),
        ] else ...[
          AppButton.primary(
            'Unlock with Biometrics',
            onPressed: _authenticateWithBiometrics,
            icon: Icons.fingerprint,
            width: 280,
          ),
        ],
      ],
    );
  }

  Widget _buildErrorMessage(int failedAttempts) {
    final remaining = 5 - failedAttempts;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 16, color: AppColors.error),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Incorrect passcode',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        if (remaining > 0) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$remaining attempts remaining',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.slate.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLockoutMessage() {
    final minutes = (_lockoutTimerSeconds / 60).floor();
    final seconds = _lockoutTimerSeconds % 60;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 16, color: AppColors.warning),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Too many attempts',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Try again in ${minutes}m ${seconds.toString().padLeft(2, '0')}s',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.slate.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContact() {
    final config = ref.watch(privacySettingsProvider);
    if (config.emergencyContactName.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const Divider(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Emergency contact: ${config.emergencyContactName}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.slate.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _LockRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.forestGreen.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width - 8,
        height: size.height - 8,
      ),
      0,
      3.14159 * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
