import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

class Contraction {
  final DateTime startTime;
  final Duration duration;
  final double intensity;

  const Contraction({
    required this.startTime,
    required this.duration,
    required this.intensity,
  });
}

class ContractionTimer extends StatefulWidget {
  final List<Contraction> contractions;
  final VoidCallback? onStartContraction;
  final VoidCallback? onEndContraction;

  const ContractionTimer({
    super.key,
    this.contractions = const [],
    this.onStartContraction,
    this.onEndContraction,
  });

  @override
  State<ContractionTimer> createState() => _ContractionTimerState();
}

class _ContractionTimerState extends State<ContractionTimer>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;
  DateTime? _currentStartTime;
  Duration _currentDuration = Duration.zero;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
    _pulseController.stop();
  }

  Duration? get _averageDuration {
    if (widget.contractions.isEmpty) return null;
    final totalMicros = widget.contractions.fold<int>(
      0,
      (sum, c) => sum + c.duration.inMicroseconds,
    );
    return Duration(microseconds: totalMicros ~/ widget.contractions.length);
  }

  Duration? get _averageFrequency {
    if (widget.contractions.length < 2) return null;
    final sorted = List<Contraction>.from(widget.contractions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final gaps = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      gaps.add(
        sorted[i].startTime.difference(sorted[i - 1].startTime).inSeconds,
      );
    }
    final avgSeconds = gaps.reduce((a, b) => a + b) ~/ gaps.length;
    return Duration(seconds: avgSeconds);
  }

  void _handleStartStop() {
    setState(() {
      if (_isActive) {
        _isActive = false;
        _timer?.cancel();
        _pulseController.stop();
        widget.onEndContraction?.call();
      } else {
        _isActive = true;
        _currentStartTime = DateTime.now();
        _currentDuration = Duration.zero;
        _startTimer();
        _pulseController.repeat(reverse: true);
        widget.onStartContraction?.call();
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentStartTime != null && mounted) {
        setState(() {
          _currentDuration = DateTime.now().difference(_currentStartTime!);
        });
      }
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatFrequency(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    if (minutes > 0) {
      return 'Every ${minutes}m ${seconds}s';
    }
    return 'Every ${seconds}s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasContractions = widget.contractions.isNotEmpty || _isActive;

    if (!hasContractions) {
      return _buildEmptyState(context);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avgDuration = _averageDuration;
    final avgFrequency = _averageFrequency;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimerSection(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          if (avgFrequency != null)
            _buildStatChip(
              context,
              Icons.repeat_rounded,
              _formatFrequency(avgFrequency),
              AppColors.sage,
            ),
          if (avgDuration != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildStatChip(
              context,
              Icons.timer_outlined,
              'Avg: ${_formatDuration(avgDuration)}',
              AppColors.softGold,
            ),
          ],
          if (widget.contractions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildRecentList(context, isDark),
          ],
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
              Icons.timer_outlined,
              size: 48,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Tap Start when a contraction begins',
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

  Widget _buildTimerSection(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _isActive ? 'Contraction in progress' : 'Ready',
          style: AppTypography.light.bodyMedium?.copyWith(
            color: _isActive ? AppColors.error : AppColors.slate,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isActive ? _pulseAnimation.value : 1.0,
              child: child,
            );
          },
          child: Text(
            _formatDuration(_currentDuration),
            style: AppTypography.light.displaySmall?.copyWith(
              color: _isActive
                  ? AppColors.error
                  : (isDark ? AppColors.textPrimaryDark : AppColors.charcoal),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildControlButton(context, isDark),
      ],
    );
  }

  Widget _buildControlButton(BuildContext context, bool isDark) {
    return Semantics(
      button: true,
      label: _isActive ? 'End contraction' : 'Start contraction',
      child: GestureDetector(
        onTap: _handleStartStop,
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isActive ? AppColors.error : AppColors.success,
            boxShadow: [
              BoxShadow(
                color: (_isActive ? AppColors.error : AppColors.success)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _isActive ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: 40,
              color: AppColors.onBrand,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: AppTypography.light.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentList(BuildContext context, bool isDark) {
    final recent = widget.contractions.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Recent Contractions',
          style: AppTypography.light.labelMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...recent.map((c) => _buildContractionRow(context, isDark, c)),
      ],
    );
  }

  Widget _buildContractionRow(BuildContext context, bool isDark, Contraction c) {
    final timeStr = '${c.startTime.hour.toString().padLeft(2, '0')}:${c.startTime.minute.toString().padLeft(2, '0')}';
    final intensityStars = '★' * c.intensity.round();
    final intensityEmpty = '☆' * (5 - c.intensity.round());

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.charcoal.withValues(alpha: 0.2)
              : AppColors.mistWhite,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Text(
              timeStr,
              style: AppTypography.light.bodySmall?.copyWith(
                color: AppColors.slate,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                _formatDuration(c.duration),
                style: AppTypography.light.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$intensityStars$intensityEmpty',
              style: AppTypography.light.bodySmall?.copyWith(
                color: AppColors.softGold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
