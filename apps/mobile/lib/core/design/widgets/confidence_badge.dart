import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

/// A badge widget displaying prediction confidence.
///
/// Takes a [confidence] value between 0.0 and 1.0 and renders a
/// color-coded pill with percentage text and an icon.
///
/// Color coding:
/// - >= 0.8: forest green (high confidence)
/// - 0.5–0.79: soft gold (medium confidence)
/// - < 0.5: slate (low confidence)
class ConfidenceBadge extends StatelessWidget {
  /// Confidence value between 0.0 and 1.0.
  final double confidence;

  /// The visual size of the badge. Defaults to [ConfidenceBadgeSize.medium].
  final ConfidenceBadgeSize size;

  const ConfidenceBadge({
    super.key,
    required this.confidence,
    this.size = ConfidenceBadgeSize.medium,
  }) : assert(confidence >= 0.0 && confidence <= 1.0);

  Color get _color {
    if (confidence >= 0.8) return AppColors.forestGreen;
    if (confidence >= 0.5) return AppColors.softGold;
    return AppColors.slate;
  }

  String get _label => '${(confidence * 100).round()}%';

  IconData get _icon {
    if (confidence >= 0.8) return Icons.check_circle;
    if (confidence >= 0.5) return Icons.info_outline;
    return Icons.help_outline;
  }

  double get _fontSize {
    switch (size) {
      case ConfidenceBadgeSize.small:
        return 11;
      case ConfidenceBadgeSize.medium:
        return 12;
      case ConfidenceBadgeSize.large:
        return 14;
    }
  }

  double get _iconSize {
    switch (size) {
      case ConfidenceBadgeSize.small:
        return 12;
      case ConfidenceBadgeSize.medium:
        return 14;
      case ConfidenceBadgeSize.large:
        return 16;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ConfidenceBadgeSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        );
      case ConfidenceBadgeSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case ConfidenceBadgeSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = _color.withValues(alpha: isDark ? 0.2 : 0.12);
    final textColor = isDark ? _color.withValues(alpha: 0.9) : _color;

    return Semantics(
      label: 'Confidence: $_label',
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        padding: _padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: _iconSize, color: textColor),
            SizedBox(width: size == ConfidenceBadgeSize.small ? 3 : AppSpacing.xs),
            Text(
              _label,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Visual size options for [ConfidenceBadge].
enum ConfidenceBadgeSize { small, medium, large }
