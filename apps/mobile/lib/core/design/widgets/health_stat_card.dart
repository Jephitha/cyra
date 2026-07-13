import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

class HealthStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accentColor;
  final String? trend;
  final double? progress;
  final bool isLoading;

  const HealthStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor,
    this.trend,
    this.progress,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardAccent = accentColor ?? AppColors.sage;

    if (isLoading) {
      return _buildShimmerPlaceholder(context, isDark);
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildIconWithRing(context, isDark, cardAccent),
              const Spacer(),
              if (trend != null) _buildTrend(trend!, isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTypography.light.titleLarge?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.light.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithRing(BuildContext context, bool isDark, Color accent) {
    final ringSize = 40.0;
    final hasProgress = progress != null && progress! > 0;

    if (!hasProgress) {
      return Container(
        width: ringSize,
        height: ringSize,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: isDark ? 0.2 : 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: accent),
      );
    }

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(ringSize, ringSize),
            painter: _ProgressRingPainter(
              progress: progress!,
              color: accent,
              isDark: isDark,
            ),
          ),
          Icon(icon, size: 16, color: accent),
        ],
      ),
    );
  }

  Widget _buildTrend(String trend, bool isDark) {
    IconData iconData;
    Color trendColor;

    switch (trend) {
      case 'up':
        iconData = Icons.trending_up_rounded;
        trendColor = AppColors.success;
      case 'down':
        iconData = Icons.trending_down_rounded;
        trendColor = AppColors.error;
      default:
        iconData = Icons.trending_flat_rounded;
        trendColor = AppColors.slate;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Icon(iconData, size: 18, color: trendColor),
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context, bool isDark) {
    final baseColor = isDark
        ? AppColors.charcoal.withValues(alpha: 0.3)
        : AppColors.borderLight;
    final highlightColor = isDark
        ? AppColors.charcoal.withValues(alpha: 0.5)
        : AppColors.mistWhite;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.onBrand,
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.onBrand,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.onBrand,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.onBrand,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const strokeWidth = 3.0;

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
        -1.5708,
        6.28319 * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isDark != isDark;
  }
}
