import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

/// The four phases of the menstrual cycle.
enum CyclePhase {
  /// Menstrual phase — soft red (#E86B6B).
  menstrual,

  /// Follicular phase — sage green (#7A9E7E).
  follicular,

  /// Ovulation phase — soft gold (#C9A94E).
  ovulation,

  /// Luteal phase — forest green (#1B4332).
  luteal,
}

extension on CyclePhase {
  Color get color {
    switch (this) {
      case CyclePhase.menstrual:
        return const Color(0xFFE86B6B);
      case CyclePhase.follicular:
        return AppColors.sage;
      case CyclePhase.ovulation:
        return AppColors.softGold;
      case CyclePhase.luteal:
        return AppColors.forestGreen;
    }
  }

  String get label {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Menstrual';
      case CyclePhase.follicular:
        return 'Follicular';
      case CyclePhase.ovulation:
        return 'Ovulation';
      case CyclePhase.luteal:
        return 'Luteal';
    }
  }
}

/// A widget that displays the current cycle phase.
///
/// Shows a colored dot and phase name. Supports optional label hiding
/// and three size options.
class CyclePhaseIndicator extends StatelessWidget {
  /// The cycle phase to display.
  final CyclePhase phase;

  /// Whether to show the phase name label. Defaults to true.
  final bool showLabel;

  /// The visual size. Defaults to [CyclePhaseIndicatorSize.medium].
  final CyclePhaseIndicatorSize size;

  const CyclePhaseIndicator({
    super.key,
    required this.phase,
    this.showLabel = true,
    this.size = CyclePhaseIndicatorSize.medium,
  });

  double get _dotSize {
    switch (size) {
      case CyclePhaseIndicatorSize.small:
        return 8;
      case CyclePhaseIndicatorSize.medium:
        return 10;
      case CyclePhaseIndicatorSize.large:
        return 14;
    }
  }

  double get _fontSize {
    switch (size) {
      case CyclePhaseIndicatorSize.small:
        return 12;
      case CyclePhaseIndicatorSize.medium:
        return 14;
      case CyclePhaseIndicatorSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Semantics(
      label: 'Cycle phase: ${phase.label}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: phase.color,
              shape: BoxShape.circle,
            ),
          ),
          if (showLabel) ...[
            SizedBox(width: size == CyclePhaseIndicatorSize.small ? AppSpacing.xs : AppSpacing.sm),
            Text(
              phase.label,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Visual size options for [CyclePhaseIndicator].
enum CyclePhaseIndicatorSize { small, medium, large }
