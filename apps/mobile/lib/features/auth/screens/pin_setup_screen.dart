import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/providers/security_providers.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';

enum PinScreenMode { setup, verify }

class PinSetupScreen extends ConsumerStatefulWidget {
  final PinScreenMode mode;
  final String? currentPin;

  const PinSetupScreen({
    super.key,
    this.mode = PinScreenMode.setup,
    this.currentPin,
  });

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen>
    with SingleTickerProviderStateMixin {
  final _localAuth = LocalAuthentication();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _showError = false;
  String _errorMessage = '';
  bool _isLockedOut = false;
  int _failedAttempts = 0;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 20),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_isLockedOut) return;

    setState(() {
      if (_isConfirming) {
        if (_confirmPin.length < 6) {
          _confirmPin += digit;
          _showError = false;
        }
      } else {
        if (_pin.length < 6) {
          _pin += digit;
          _showError = false;
        }
      }
    });

    if (_isConfirming && _confirmPin.length >= 4) {
      _validateConfirmation();
    } else if (!_isConfirming && _pin.length >= 4) {
      if (widget.mode == PinScreenMode.verify) {
        _verifyPin();
      } else {
        setState(() => _isConfirming = true);
      }
    }
  }

  void _onDeletePressed() {
    setState(() {
      if (_isConfirming && _confirmPin.isNotEmpty) {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
      } else if (!_isConfirming && _pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      } else if (_isConfirming && _confirmPin.isEmpty) {
        _isConfirming = false;
        _pin = '';
      }
      _showError = false;
    });
  }

  Future<void> _validateConfirmation() async {
    if (_pin == _confirmPin) {
      await ref.read(pinAuthServiceProvider).setPin(_pin);
      if (!mounted) return;
      ref.read(privacySettingsProvider.notifier).updatePin(true);
      context.pop(true);
    } else {
      _triggerError('PINs do not match. Try again.');
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    final verified = await ref.read(pinAuthServiceProvider).verifyPin(_pin);

    if (verified) {
      ref.read(failedPinAttemptsProvider.notifier).reset();
      if (!mounted) return;
      context.pop(true);
    } else {
      _failedAttempts++;
      ref.read(failedPinAttemptsProvider.notifier).increment();

      if (_failedAttempts >= 5) {
        _startLockout();
      } else {
        _triggerError(
          'Incorrect PIN. ${5 - _failedAttempts} attempts remaining.',
        );
        setState(() => _pin = '');
      }
    }
  }

  void _triggerError(String message) {
    setState(() {
      _showError = true;
      _errorMessage = message;
    });
    _shakeController.forward(from: 0.0);
  }

  void _startLockout() {
    setState(() {
      _isLockedOut = true;
      _showError = true;
      _errorMessage = 'Too many attempts. Try again in 30 seconds.';
      _pin = '';
    });

    int seconds = 30;
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      seconds--;
      if (seconds <= 0) {
        setState(() {
          _isLockedOut = false;
          _showError = false;
          _failedAttempts = 0;
        });
        ref.read(failedPinAttemptsProvider.notifier).reset();
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Too many attempts. Try again in $seconds seconds.';
          });
        }
      }
    });
  }

  Future<void> _handleForgotPin() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Reset your PIN using biometrics',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated && mounted) {
        await ref.read(pinAuthServiceProvider).clearPin();
        if (!mounted) return;
        ref.read(privacySettingsProvider.notifier).updatePin(false);
        context.pop(true);
      }
    } catch (_) {
      // Biometric auth failed
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.mode == PinScreenMode.setup
              ? 'Set Passcode'
              : 'Enter Passcode',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _buildHeader(),
            const SizedBox(height: AppSpacing.xxxxl),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: _buildDotIndicator(),
            ),
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: _buildErrorMessage(),
              ),
            const Spacer(flex: 3),
            _buildNumpad(),
            const SizedBox(height: AppSpacing.xxl),
            if (widget.mode == PinScreenMode.verify && _pin.isEmpty)
              TextButton(
                onPressed: _isLockedOut ? null : _handleForgotPin,
                child: Text(
                  'Forgot passcode?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _isLockedOut
                        ? AppColors.slate.withValues(alpha: 0.4)
                        : AppColors.forestGreen,
                  ),
                ),
              ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.forestGreen.withValues(alpha: 0.1),
          ),
          child: Icon(
            _isConfirming ? Icons.lock_outline_rounded : Icons.pin_outlined,
            size: 28,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          _isConfirming
              ? 'Confirm your passcode'
              : widget.mode == PinScreenMode.verify
              ? 'Enter your passcode'
              : 'Create a passcode',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _isConfirming
              ? 'Enter the same passcode again'
              : widget.mode == PinScreenMode.verify
              ? 'Enter your 4-6 digit passcode'
              : 'Choose a 4-6 digit passcode',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator() {
    final currentLength = _isConfirming ? _confirmPin.length : _pin.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 7),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < currentLength
                ? AppColors.forestGreen
                : Colors.transparent,
            border: Border.all(
              color: i < currentLength
                  ? AppColors.forestGreen
                  : AppColors.slate.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: i < currentLength
              ? Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 16, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
        ],
      ),
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
            _buildKey('0'),
            _buildDeleteKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumpadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((d) => _buildKey(d)).toList(),
    );
  }

  Widget _buildKey(String digit) {
    return Container(
      width: 80,
      height: 64,
      margin: const EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLockedOut ? null : () => _onDigitPressed(digit),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          splashColor: AppColors.forestGreen.withValues(alpha: 0.1),
          highlightColor: AppColors.forestGreen.withValues(alpha: 0.05),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Container(
      width: 80,
      height: 64,
      margin: const EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onDeletePressed,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          splashColor: AppColors.forestGreen.withValues(alpha: 0.1),
          highlightColor: AppColors.forestGreen.withValues(alpha: 0.05),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 24,
              color: AppColors.slate,
            ),
          ),
        ),
      ),
    );
  }
}
