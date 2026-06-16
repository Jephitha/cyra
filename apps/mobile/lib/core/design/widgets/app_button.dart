import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

/// A comprehensive button system for the Cyra app.
///
/// Provides [AppButton.primary], [AppButton.secondary], [AppButton.ghost],
/// and [AppButton.icon] variants with loading, disabled, and dark mode support.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isDisabled;
  final double? width;
  final double height;
  final _AppButtonVariant _variant;
  final double _iconSize;

  const AppButton._({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isDisabled = false,
    this.width,
    this.height = 48,
    this._iconSize = 56,
    required this._variant,
  });

  /// Deep forest green filled button.
  ///
  /// [label] is the button text. [onPressed] is called on tap.
  /// [isLoading] shows a progress indicator. [icon] prefixes an icon.
  /// [isDisabled] forces disabled appearance regardless of [onPressed].
  factory AppButton.primary(
    String label, {
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool isDisabled = false,
    double? width,
    double height = 48,
  }) {
    return AppButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      isDisabled: isDisabled,
      width: width,
      height: height,
      variant: _AppButtonVariant.primary,
    );
  }

  /// Outlined button with forest green border.
  factory AppButton.secondary(
    String label, {
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool isDisabled = false,
    double? width,
    double height = 48,
  }) {
    return AppButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      isDisabled: isDisabled,
      width: width,
      height: height,
      variant: _AppButtonVariant.secondary,
    );
  }

  /// Text-only subtle button.
  factory AppButton.ghost(
    String label, {
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool isDisabled = false,
    double? width,
    double height = 44,
  }) {
    return AppButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      isDisabled: isDisabled,
      width: width,
      height: height,
      variant: _AppButtonVariant.ghost,
    );
  }

  /// Circular icon button for FAB-like actions.
  factory AppButton.icon(
    IconData icon, {
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double size = 56,
  }) {
    return AppButton._(
      key: key,
      label: '',
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      isDisabled: isDisabled,
      width: size,
      height: size,
      iconSize: size,
      variant: _AppButtonVariant.icon,
    );
  }

  bool get _isIconVariant => _variant == _AppButtonVariant.icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveDisabled = isDisabled || (onPressed == null && !isLoading);

    if (_isIconVariant) {
      return _buildIconButton(context, isDark, effectiveDisabled);
    }

    return _buildTextButton(isDark, effectiveDisabled);
  }

  Widget _buildTextButton(
    bool isDark,
    bool effectiveDisabled,
  ) {
    Widget child = _buildContent(isDark, effectiveDisabled);

    if (width != null) {
      child = SizedBox(width: width, child: child);
    }

    return Semantics(
      button: true,
      enabled: !effectiveDisabled,
      label: label,
      child: child,
    );
  }

  Widget _buildContent(
    bool isDark,
    bool effectiveDisabled,
  ) {
    switch (_variant) {
      case _AppButtonVariant.primary:
        return _renderPrimary(isDark, effectiveDisabled);
      case _AppButtonVariant.secondary:
        return _renderSecondary(isDark, effectiveDisabled);
      case _AppButtonVariant.ghost:
        return _renderGhost(isDark, effectiveDisabled);
      case _AppButtonVariant.icon:
        return const SizedBox.shrink();
    }
  }

  Widget _renderPrimary(
    bool isDark,
    bool effectiveDisabled,
  ) {
    final bgColor = effectiveDisabled
        ? (isDark ? AppColors.charcoal.withValues(alpha: 0.6) : AppColors.slate.withValues(alpha: 0.3))
        : AppColors.forestGreen;
    final textColor = effectiveDisabled
        ? (isDark ? AppColors.textSecondaryDark : AppColors.slate)
        : Colors.white;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: effectiveDisabled ? null : () => onPressed?.call(),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.08),
        child: _buttonLabel(textColor: textColor),
      ),
    );
  }

  Widget _renderSecondary(
    bool isDark,
    bool effectiveDisabled,
  ) {
    final borderColor = effectiveDisabled
        ? (isDark ? AppColors.charcoal : AppColors.borderLight)
        : AppColors.forestGreen;
    final textColor = effectiveDisabled
        ? (isDark ? AppColors.textSecondaryDark : AppColors.slate)
        : (isDark ? AppColors.forestGreenLight : AppColors.forestGreen);
    final bgColor = isDark ? AppColors.surfaceDark : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: bgColor,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: effectiveDisabled ? null : () => onPressed?.call(),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          splashColor: AppColors.forestGreen.withValues(alpha: 0.1),
          highlightColor: AppColors.forestGreen.withValues(alpha: 0.05),
          child: _buttonLabel(textColor: textColor),
        ),
      ),
    );
  }

  Widget _renderGhost(
    bool isDark,
    bool effectiveDisabled,
  ) {
    final textColor = effectiveDisabled
        ? (isDark ? AppColors.textSecondaryDark : AppColors.slate)
        : (isDark ? AppColors.forestGreenLight : AppColors.forestGreen);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: effectiveDisabled ? null : () => onPressed?.call(),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        splashColor: AppColors.forestGreen.withValues(alpha: 0.08),
        highlightColor: AppColors.forestGreen.withValues(alpha: 0.04),
        child: _buttonLabel(textColor: textColor),
      ),
    );
  }

  Widget _buttonLabel({required Color textColor}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: textColor),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    label,
                    style: AppTypography.light.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    bool isDark,
    bool effectiveDisabled,
  ) {
    final bgColor = effectiveDisabled
        ? (isDark ? AppColors.charcoal.withValues(alpha: 0.6) : AppColors.slate.withValues(alpha: 0.3))
        : AppColors.forestGreen;
    final iconColor = effectiveDisabled
        ? (isDark ? AppColors.textSecondaryDark : AppColors.slate)
        : Colors.white;

    return Semantics(
      button: true,
      enabled: !effectiveDisabled,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(_iconSize),
        elevation: effectiveDisabled ? 0 : 4,
        shadowColor: AppColors.forestGreen.withValues(alpha: 0.3),
        child: InkWell(
          onTap: effectiveDisabled ? null : () => onPressed?.call(),
          borderRadius: BorderRadius.circular(_iconSize),
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: _iconSize * 0.45),
            ),
          ),
        ),
      ),
    );
  }
}

enum _AppButtonVariant { primary, secondary, ghost, icon }
