import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

class KickCounter extends StatefulWidget {
  final int kickCount;
  final DateTime? startTime;
  final VoidCallback? onKickLogged;
  final VoidCallback? onStartStop;

  const KickCounter({
    super.key,
    this.kickCount = 0,
    this.startTime,
    this.onKickLogged,
    this.onStartStop,
  });

  @override
  State<KickCounter> createState() => _KickCounterState();
}

class _KickCounterState extends State<KickCounter>
    with SingleTickerProviderStateMixin {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isRunning = false;

  static const int _kicksPerHourGoal = 10;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutBack),
    );

    if (widget.startTime != null) {
      _isRunning = true;
      _elapsed = DateTime.now().difference(widget.startTime!);
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(KickCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.kickCount > oldWidget.kickCount && _isRunning) {
      _triggerPulse();
      _hapticFeedback();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.startTime != null && mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(widget.startTime!);
        });
      }
    });
  }

  void _handleStartStop() {
    widget.onStartStop?.call();
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _elapsed = Duration.zero;
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _handleKickLog() {
    widget.onKickLogged?.call();
    _triggerPulse();
    _hapticFeedback();
  }

  void _triggerPulse() {
    _pulseController
      ..reset()
      ..forward().then((_) => _pulseController.reverse());
  }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _kicksPerHour {
    final hours = _elapsed.inMinutes / 60.0;
    if (hours <= 0) return 0;
    return widget.kickCount / hours;
  }

  double get _goalProgress {
    if (!_isRunning) return 0.0;
    return (_kicksPerHour / _kicksPerHourGoal).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasStarted = _isRunning || widget.kickCount > 0;

    if (!hasStarted && widget.startTime == null) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimerDisplay(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildCounter(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          if (_isRunning) _buildProgressIndicator(context, isDark),
          if (_isRunning) const SizedBox(height: AppSpacing.lg),
          _buildActions(context, isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.child_care_rounded,
              size: 48,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Tap Start to begin counting kicks',
              textAlign: TextAlign.center,
              style: AppTypography.light.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.3)
            : AppColors.mistWhite,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _formatDuration(_elapsed),
            style: AppTypography.light.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: _isRunning ? _handleKickLog : null,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.kickCount}',
              style: AppTypography.light.displaySmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.kickCount == 1 ? 'Kick' : 'Kicks',
              style: AppTypography.light.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, bool isDark) {
    final kph = _kicksPerHour;
    final progress = _goalProgress;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${kph.toStringAsFixed(1)} kicks/hour',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
            Text(
              'Goal: $_kicksPerHourGoal /hr',
              style: AppTypography.light.labelSmall?.copyWith(
                color: progress >= 1.0 ? AppColors.success : AppColors.slate,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: isDark
                ? AppColors.charcoal.withValues(alpha: 0.3)
                : AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation(
              progress >= 1.0 ? AppColors.success : AppColors.sage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isRunning)
          _buildKickButton(context, isDark)
        else
          _buildLargeStartButton(context, isDark),
        const SizedBox(width: AppSpacing.md),
        _buildStopButton(context, isDark),
      ],
    );
  }

  Widget _buildKickButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Material(
        color: AppColors.forestGreen,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: AppColors.forestGreen.withValues(alpha: 0.3),
        child: InkWell(
          onTap: _handleKickLog,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: const Center(
            child: Icon(
              Icons.child_care_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeStartButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: AppColors.success,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: AppColors.success.withValues(alpha: 0.3),
        child: InkWell(
          onTap: _handleStartStop,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStopButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.5)
            : AppColors.mistWhite,
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          onTap: _isRunning ? _handleStartStop : null,
          customBorder: const CircleBorder(),
          splashColor: AppColors.error.withValues(alpha: 0.1),
          highlightColor: AppColors.error.withValues(alpha: 0.05),
          child: Center(
            child: Icon(
              _isRunning ? Icons.stop_rounded : Icons.restart_alt_rounded,
              size: 24,
              color: _isRunning
                  ? AppColors.error
                  : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
            ),
          ),
        ),
      ),
    );
  }
}
