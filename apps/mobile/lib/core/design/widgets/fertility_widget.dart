import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/constants/app_constants.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:intl/intl.dart';

class FertilityWidget extends StatelessWidget {
  final DateTime? ovulationDate;
  final DateTime? lastPeriodStart;
  final int cycleLength;
  final int currentCycleDay;
  final bool compact;

  const FertilityWidget({
    super.key,
    this.ovulationDate,
    this.lastPeriodStart,
    this.cycleLength = 28,
    this.currentCycleDay = 1,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (lastPeriodStart == null) {
      return _buildEmptyState(context);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fertileStart = AppConstants.fertileWindowStartDay;
    final fertileEnd = AppConstants.fertileWindowEndDay;
    final ovulationDay = ovulationDate != null
        ? ovulationDate!.dayOfCycle(lastPeriodStart!)
        : (fertileStart + fertileEnd) ~/ 2;
    final today = currentCycleDay;
    final daysToShow = cycleLength.clamp(28, 45);

    final predictedOvulationDate = lastPeriodStart!.add(
      Duration(days: ovulationDay - 1),
    );

    final probability = _calculateProbability(
      currentCycleDay,
      ovulationDay,
      fertileStart,
      fertileEnd,
    );

    return Padding(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Row(
              children: [
                Icon(
                  Icons.eco_outlined,
                  size: 20,
                  color: AppColors.forestGreen,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Fertile Window',
                  style: AppTypography.light.titleSmall?.copyWith(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          _buildTimelineBar(
            context,
            isDark,
            daysToShow,
            fertileStart,
            fertileEnd,
            ovulationDay,
            today,
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.md),
            _buildProbabilityIndicator(context, isDark, probability),
            const SizedBox(height: AppSpacing.sm),
            _buildLegend(context, isDark),
            if (predictedOvulationDate.isAfter(DateTime.now()))
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  'Predicted ovulation: ${DateFormat('MMM d').format(predictedOvulationDate)}',
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ),
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
              Icons.calendar_month_outlined,
              size: 40,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Track your cycles to see your fertile window',
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

  Widget _buildTimelineBar(
    BuildContext context,
    bool isDark,
    int daysToShow,
    int fertileStart,
    int fertileEnd,
    int ovulationDay,
    int today,
  ) {
    final barHeight = compact ? 28.0 : 36.0;
    final isTablet = context.isTablet;
    final baseWidth = isTablet
        ? 600.0
        : MediaQuery.of(context).size.width - (compact ? 48 : 64);
    final cellWidth = (baseWidth - 4) / daysToShow;
    final showLabels = daysToShow <= 35 && !compact;

    return SizedBox(
      height: barHeight + (showLabels ? 20 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: CustomPaint(
          painter: _FertilityBarPainter(
            daysToShow: daysToShow,
            fertileStart: fertileStart,
            fertileEnd: fertileEnd,
            ovulationDay: ovulationDay,
            today: today,
            cellWidth: cellWidth,
            barHeight: barHeight,
            showLabels: showLabels,
            isDark: isDark,
          ),
          size: Size(baseWidth, barHeight + (showLabels ? 20 : 0)),
        ),
      ),
    );
  }

  Widget _buildProbabilityIndicator(
    BuildContext context,
    bool isDark,
    double probability,
  ) {
    final probPercent = (probability * 100).round();
    Color probColor;
    if (probability >= 0.7) {
      probColor = AppColors.success;
    } else if (probability >= 0.3) {
      probColor = AppColors.softGold;
    } else {
      probColor = AppColors.slate;
    }

    return Row(
      children: [
        Text(
          'Ovulation probability: ',
          style: AppTypography.light.bodySmall?.copyWith(
            color: AppColors.slate,
          ),
        ),
        Text(
          '$probPercent%',
          style: AppTypography.light.bodySmall?.copyWith(
            color: probColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, bool isDark) {
    return Row(
      children: [
        _legendDot(AppColors.success.withValues(alpha: 0.6), 'Fertile'),
        const SizedBox(width: AppSpacing.lg),
        _legendDot(AppColors.softGold, 'Ovulation'),
        const SizedBox(width: AppSpacing.lg),
        _legendDot(AppColors.slate.withValues(alpha: 0.4), 'Non-fertile'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.light.labelSmall?.copyWith(
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }

  double _calculateProbability(
    int day,
    int ovulationDay,
    int fertileStart,
    int fertileEnd,
  ) {
    if (day < fertileStart) {
      return 0.1;
    }
    if (day >= fertileStart && day < ovulationDay) {
      final progress = (day - fertileStart) / (ovulationDay - fertileStart);
      return 0.3 + progress * 0.6;
    }
    if (day == ovulationDay) {
      return 0.9;
    }
    if (day > ovulationDay && day <= fertileEnd) {
      final regress = (day - ovulationDay) / (fertileEnd - ovulationDay);
      return 0.9 - regress * 0.6;
    }
    return 0.05;
  }
}

class _FertilityBarPainter extends CustomPainter {
  final int daysToShow;
  final int fertileStart;
  final int fertileEnd;
  final int ovulationDay;
  final int today;
  final double cellWidth;
  final double barHeight;
  final bool showLabels;
  final bool isDark;

  _FertilityBarPainter({
    required this.daysToShow,
    required this.fertileStart,
    required this.fertileEnd,
    required this.ovulationDay,
    required this.today,
    required this.cellWidth,
    required this.barHeight,
    required this.showLabels,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barTop = 0.0;

    for (int day = 1; day <= daysToShow; day++) {
      final x = (day - 1) * cellWidth;

      Color dayColor;
      if (day == ovulationDay) {
        dayColor = AppColors.softGold;
      } else if (day >= fertileStart && day <= fertileEnd) {
        final intensity = (day - fertileStart) / (fertileEnd - fertileStart);
        final greenIntensity = 0.3 + (1.0 - (intensity - 0.5).abs() * 2) * 0.5;
        dayColor = Color.lerp(
          AppColors.success.withValues(alpha: 0.4),
          AppColors.success.withValues(alpha: 0.85),
          greenIntensity.clamp(0.0, 1.0),
        )!;
      } else {
        dayColor = isDark
            ? AppColors.charcoal.withValues(alpha: 0.4)
            : AppColors.borderLight.withValues(alpha: 0.6);
      }

      final cellRect = Rect.fromLTWH(x, barTop, cellWidth - 1, barHeight);
      final rRect = RRect.fromRectAndRadius(cellRect, const Radius.circular(1));
      canvas.drawRRect(rRect, Paint()..color = dayColor);

      if (day == today) {
        final arrowX = x + cellWidth / 2;
        final arrowPaint = Paint()..color = AppColors.charcoal;
        final path = Path()
          ..moveTo(arrowX - 5, barHeight + 2)
          ..lineTo(arrowX, barHeight + 8)
          ..lineTo(arrowX + 5, barHeight + 2)
          ..close();
        canvas.drawPath(path, arrowPaint);
      }

      if (day == ovulationDay) {
        final starX = x + cellWidth / 2;
        final starPaint = Paint()..color = AppColors.softGold;
        final starPath = Path()
          ..moveTo(starX, barTop + 2)
          ..lineTo(starX + 4, barTop + 10)
          ..lineTo(starX - 6, barTop + 5)
          ..lineTo(starX + 6, barTop + 5)
          ..lineTo(starX - 4, barTop + 10)
          ..close();
        canvas.drawPath(starPath, starPaint);
      }

      if (showLabels) {
        final labelPaint = TextPainter(
          text: TextSpan(
            text: '$day',
            style: TextStyle(
              color: AppColors.slate.withValues(alpha: 0.6),
              fontSize: 9,
            ),
          ),
        )..layout();
        labelPaint.paint(
          canvas,
          Offset(x + cellWidth / 2 - labelPaint.width / 2, barHeight + 10),
        );
      }
    }

    if (today >= 1 && today <= daysToShow) {
      final todayX = (today - 1) * cellWidth + cellWidth / 2;
      final markerPaint = Paint()
        ..color = AppColors.charcoal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final markerRect = Rect.fromCircle(
        center: Offset(todayX, barHeight / 2),
        radius: barHeight / 2 - 2,
      );
      canvas.drawOval(markerRect, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FertilityBarPainter oldDelegate) {
    return oldDelegate.today != today ||
        oldDelegate.ovulationDay != ovulationDay ||
        oldDelegate.daysToShow != daysToShow ||
        oldDelegate.isDark != isDark;
  }
}
