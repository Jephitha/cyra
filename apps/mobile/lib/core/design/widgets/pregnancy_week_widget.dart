import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

class PregnancyWeekWidget extends StatelessWidget {
  final int currentWeek;
  final int currentTrimester;
  final double? babySizeCm;
  final String? sizeComparison;
  final String? developmentMilestone;
  final bool compact;

  const PregnancyWeekWidget({
    super.key,
    required this.currentWeek,
    required this.currentTrimester,
    this.babySizeCm,
    this.sizeComparison,
    this.developmentMilestone,
    this.compact = false,
  });

  static const _totalWeeks = 40;

  Color _trimesterColor(int trimester) {
    switch (trimester) {
      case 1:
        return AppColors.sage;
      case 2:
        return AppColors.softGold;
      case 3:
        return const Color(0xFFE57373);
      default:
        return AppColors.sage;
    }
  }

  String _trimesterLabel(int trimester) {
    switch (trimester) {
      case 1:
        return '1st Trimester';
      case 2:
        return '2nd Trimester';
      case 3:
        return '3rd Trimester';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentWeek < 1 || currentWeek > 42) {
      return _buildEmptyState(context);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trimesterColor = _trimesterColor(currentTrimester);
    final progress = (currentWeek / _totalWeeks).clamp(0.0, 1.0);
    final weeksRemaining = (_totalWeeks - currentWeek).clamp(0, _totalWeeks);

    return Padding(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Row(
              children: [
                Icon(Icons.child_care_rounded, size: 20, color: trimesterColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Pregnancy Progress',
                  style: AppTypography.light.titleSmall?.copyWith(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCircularProgress(context, isDark, progress, trimesterColor),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _buildInfoColumn(context, isDark, weeksRemaining, trimesterColor)),
            ],
          ),
          if (!compact && babySizeCm != null && sizeComparison != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildSizeComparison(context, isDark),
          ],
          if (!compact && developmentMilestone != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildMilestone(context, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 40,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Enter your due date to begin tracking',
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

  Widget _buildCircularProgress(
    BuildContext context,
    bool isDark,
    double progress,
    Color trimesterColor,
  ) {
    final size = compact ? 72.0 : 96.0;
    final strokeWidth = compact ? 6.0 : 8.0;

    return Semantics(
      value: 'Week $currentWeek of $_totalWeeks',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _WeekProgressPainter(
                  progress: progress,
                  color: trimesterColor,
                  strokeWidth: strokeWidth,
                  isDark: isDark,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$currentWeek',
                  style: (compact
                          ? AppTypography.light.titleMedium
                          : AppTypography.light.headlineSmall)
                      ?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'of $_totalWeeks',
                  style: AppTypography.light.labelSmall?.copyWith(
                    color: AppColors.slate,
                    fontSize: compact ? 9 : 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    bool isDark,
    int weeksRemaining,
    Color trimesterColor,
  ) {
    final sizeInfo = babySizeCm != null && sizeComparison != null
        ? '${babySizeCm!.toStringAsFixed(1)} cm · $sizeComparison'
        : null;
    final milestoneDisplay = compact ? developmentMilestone : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: trimesterColor.withValues(alpha: isDark ? 0.3 : 0.15),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            _trimesterLabel(currentTrimester),
            style: AppTypography.light.labelSmall?.copyWith(
              color: trimesterColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$weeksRemaining weeks remaining',
          style: AppTypography.light.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (sizeInfo != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            sizeInfo,
            style: AppTypography.light.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
        if (milestoneDisplay != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            milestoneDisplay,
            style: AppTypography.light.bodySmall?.copyWith(
              color: AppColors.sage,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildSizeComparison(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(
            Icons.straighten_rounded,
            size: 20,
            color: AppColors.sage,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Baby\'s Size',
                  style: AppTypography.light.labelSmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${babySizeCm!.toStringAsFixed(1)} cm',
                  style: AppTypography.light.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            sizeComparison!,
            style: AppTypography.light.bodyMedium?.copyWith(
              color: AppColors.sage,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestone(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.mistWhite,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: AppColors.softGold,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Development Milestone',
                  style: AppTypography.light.labelSmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  developmentMilestone!,
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool isDark;

  _WeekProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final bgPaint = Paint()
      ..color = isDark
          ? AppColors.charcoal.withValues(alpha: 0.3)
          : AppColors.borderLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      if (progress < 1.0) {
        final dotAngle = startAngle + sweepAngle;
        final dotX = center.dx + radius * math.cos(dotAngle);
        final dotY = center.dy + radius * math.sin(dotAngle);
        canvas.drawCircle(
          Offset(dotX, dotY),
          strokeWidth / 2 + 1,
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeekProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isDark != isDark;
  }
}
