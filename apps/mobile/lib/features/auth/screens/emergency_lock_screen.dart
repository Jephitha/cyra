import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';

class EmergencyLockScreen extends ConsumerStatefulWidget {
  const EmergencyLockScreen({super.key});

  @override
  ConsumerState<EmergencyLockScreen> createState() =>
      _EmergencyLockScreenState();
}

class _EmergencyLockScreenState extends ConsumerState<EmergencyLockScreen>
    with SingleTickerProviderStateMixin {
  final _localAuth = LocalAuthentication();
  late AnimationController _animController;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _slideInAnimation;
  late Animation<double> _pulseAnimation;

  bool _activated = false;
  String _displayText = '';
  final _calculatorBuffer = StringBuffer();
  double _currentValue = 0;
  String _lastOperator = '';
  bool _shouldReset = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _slideInAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _activated = true);
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock Cyra',
        options: const AuthenticationOptions(stickyAuth: true),
      );

      if (authenticated && mounted) {
        ref.read(isEmergencyLockedProvider.notifier).deactivate();
        ref.read(authStateNotifierProvider.notifier).authenticate();
        if (mounted) context.go('/dashboard');
      }
    } catch (_) {}
  }

  void _onCalculatorDigit(String digit) {
    if (_shouldReset) {
      _calculatorBuffer.clear();
      _shouldReset = false;
    }
    if (_calculatorBuffer.length < 12) {
      _calculatorBuffer.write(digit);
      _updateDisplay();
    }
  }

  void _onCalculatorOperator(String op) {
    if (_calculatorBuffer.isNotEmpty) {
      _currentValue = double.tryParse(_calculatorBuffer.toString()) ?? 0;
      _calculatorBuffer.clear();
    }
    _lastOperator = op;
    _shouldReset = true;
  }

  void _onCalculatorEquals() {
    if (_lastOperator.isEmpty) return;
    final second = double.tryParse(_calculatorBuffer.toString()) ?? 0;
    double result = _currentValue;
    switch (_lastOperator) {
      case '+':
        result = _currentValue + second;
      case '-':
        result = _currentValue - second;
      case '×':
        result = _currentValue * second;
      case '÷':
        result = second != 0 ? _currentValue / second : 0;
    }
    _calculatorBuffer.clear();
    _calculatorBuffer.write(
      result == result.round()
          ? result.round().toString()
          : result.toStringAsFixed(2),
    );
    _currentValue = 0;
    _lastOperator = '';
    _shouldReset = true;
    _updateDisplay();
  }

  void _onCalculatorClear() {
    _calculatorBuffer.clear();
    _currentValue = 0;
    _lastOperator = '';
    _shouldReset = false;
    _updateDisplay();
  }

  void _updateDisplay() {
    setState(() {
      _displayText = _calculatorBuffer.isNotEmpty
          ? _calculatorBuffer.toString()
          : '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.decoySurface,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              return Opacity(
                opacity: _slideInAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, -(_slideInAnimation.value * 100)),
                  child: _buildCalculatorContent(),
                ),
              );
            },
          ),
          if (!_activated)
            AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return Opacity(
                  opacity: _fadeOutAnimation.value,
                  child: _buildOriginalContent(),
                );
              },
            ),
          if (_activated)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: GestureDetector(
                onLongPress: _unlock,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.shadow.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: AppColors.shadow.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOriginalContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.forestGreen, AppColors.forestGreenDark],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.onBrand.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    size: 40,
                    color: AppColors.onBrand.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Cyra is locked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBrand.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Privacy mode activated',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBrand.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorContent() {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          _buildCalculatorDisplay(),
          const SizedBox(height: AppSpacing.lg),
          _buildCalculatorGrid(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildCalculatorDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.onBrand,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          _displayText.isEmpty ? '0' : _displayText,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w300,
            color: AppColors.decoyInk,
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorGrid() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.xl,
      ),
      child: Column(
        children: [
          _buildCalculatorRow(['C', '±', '%', '÷']),
          _buildCalculatorRow(['7', '8', '9', '×']),
          _buildCalculatorRow(['4', '5', '6', '-']),
          _buildCalculatorRow(['1', '2', '3', '+']),
          _buildCalculatorRow(['0', '.', '=']),
        ],
      ),
    );
  }

  Widget _buildCalculatorRow(List<String> labels) {
    return Row(
      children: labels.map((label) {
        final isOperator = [
          '+',
          '-',
          '×',
          '÷',
          '=',
          'C',
          '±',
          '%',
        ].contains(label);
        final isZero = label == '0';
        return Expanded(
          flex: isZero ? 2 : 1,
          child: _buildCalculatorButton(label, isOperator),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorButton(String label, bool isOperator) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(3),
      child: Material(
        color: isOperator ? AppColors.decoyKey : AppColors.onBrand,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: () => _onCalculatorInput(label),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: isOperator ? FontWeight.w500 : FontWeight.w400,
                color: AppColors.decoyInk,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCalculatorInput(String label) {
    switch (label) {
      case 'C':
        _onCalculatorClear();
      case '=':
        _onCalculatorEquals();
      case '+':
      case '-':
      case '×':
      case '÷':
        _onCalculatorOperator(label);
      case '±':
        if (_calculatorBuffer.isNotEmpty) {
          final current = _calculatorBuffer.toString();
          _calculatorBuffer.clear();
          if (current.startsWith('-')) {
            _calculatorBuffer.write(current.substring(1));
          } else {
            _calculatorBuffer.write('-$current');
          }
          _updateDisplay();
        }
      case '%':
        if (_calculatorBuffer.isNotEmpty) {
          final value = double.tryParse(_calculatorBuffer.toString()) ?? 0;
          _calculatorBuffer.clear();
          _calculatorBuffer.write((value / 100).toString());
          _updateDisplay();
        }
      case '.':
        if (!_calculatorBuffer.toString().contains('.')) {
          _calculatorBuffer.write('.');
          _updateDisplay();
        }
      default:
        _onCalculatorDigit(label);
    }
  }
}
