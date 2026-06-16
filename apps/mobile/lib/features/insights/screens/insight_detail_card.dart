import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/features/insights/screens/topic_detail_screen.dart';

enum InsightType {
  prediction,
  ovulation,
  symptom,
  cycleRegularity,
  fertility,
  general,
}

class InsightDetailCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final InsightType type;
  final double confidence;
  final String mainValue;
  final String explanation;
  final String? trend;
  final bool isExpanded;
  final String topicRoute;

  const InsightDetailCard({
    super.key,
    required this.title,
    required this.icon,
    required this.type,
    required this.confidence,
    required this.mainValue,
    required this.explanation,
    this.trend,
    this.isExpanded = false,
    required this.topicRoute,
  });

  Color get _typeColor {
    switch (type) {
      case InsightType.prediction:
        return AppColors.forestGreen;
      case InsightType.ovulation:
        return AppColors.softGold;
      case InsightType.symptom:
        return AppColors.sage;
      case InsightType.cycleRegularity:
        return AppColors.forestGreenLight;
      case InsightType.fertility:
        return AppColors.softGoldLight;
      case InsightType.general:
        return AppColors.slate;
    }
  }

  IconData get _trendIcon {
    if (trend == null) return Icons.trending_flat_rounded;
    switch (trend!) {
      case 'up':
        return Icons.trending_up_rounded;
      case 'down':
        return Icons.trending_down_rounded;
      default:
        return Icons.trending_flat_rounded;
    }
  }

  Color get _trendColor {
    if (trend == null) return AppColors.slate;
    switch (trend!) {
      case 'up':
        return AppColors.success;
      case 'down':
        return AppColors.error;
      default:
        return AppColors.slate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _typeColor;

    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TopicDetailScreen(topic: topicRoute),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(context, color, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildConfidenceGauge(context, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildMainValue(context, isDark),
          const SizedBox(height: AppSpacing.sm),
          if (isExpanded) _buildExpandedContent(context, isDark, color),
          _buildFooter(context, isDark),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ConfidenceBadge(confidence: confidence, size: ConfidenceBadgeSize.small),
      ],
    );
  }

  Widget _buildConfidenceGauge(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidence',
              style: AppTypography.light.labelSmall?.copyWith(color: AppColors.slate),
            ),
            Text(
              '${(confidence * 100).round()}%',
              style: AppTypography.light.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _typeColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        _ConfidenceArc(
          confidence: confidence,
          color: _typeColor,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildMainValue(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          mainValue,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trend != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(_trendIcon, size: 20, color: _trendColor),
        ],
        const Spacer(),
        Icon(Icons.chevron_right, size: 20, color: AppColors.slate),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context, bool isDark, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        explanation,
        style: AppTypography.light.bodySmall?.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(Icons.touch_app_outlined, size: 14, color: AppColors.slate.withValues(alpha: 0.5)),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Tap for details',
          style: AppTypography.light.labelSmall?.copyWith(
            color: AppColors.slate.withValues(alpha: 0.5),
          ),
        ),
        const Spacer(),
        Icon(Icons.auto_awesome, size: 14, color: AppColors.forestGreen.withValues(alpha: 0.5)),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'AI Insight',
          style: AppTypography.light.labelSmall?.copyWith(
            color: AppColors.forestGreen.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ConfidenceArc extends StatelessWidget {
  final double confidence;
  final Color color;
  final bool isDark;

  const _ConfidenceArc({
    required this.confidence,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: LinearProgressIndicator(
        value: confidence,
        backgroundColor: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.borderLight,
        color: color,
        minHeight: 6,
      ),
    );
  }
}
