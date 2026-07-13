import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

/// A versatile card system for the Cyra app.
///
/// Provides [AppCard.standard], [AppCard.interactive], [AppCard.chart],
/// and [AppCard.highlighted] variants with dark mode support.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final double elevation;
  final Color? accentColor;
  final Color? backgroundColor;

  const AppCard._({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.title,
    this.elevation = 0,
    this.accentColor,
    this.backgroundColor,
  });

  /// Default white card with subtle shadow.
  factory AppCard.standard({
    Key? key,
    required Widget child,
    String? title,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return AppCard._(
      key: key,
      title: title,
      padding: padding,
      elevation: 0,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Tappable card with ripple effect.
  factory AppCard.interactive({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return AppCard._(
      key: key,
      onTap: onTap,
      padding: padding,
      elevation: 1,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Card for wrapping charts with an optional title header.
  factory AppCard.chart({
    Key? key,
    required Widget child,
    String? title,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return AppCard._(
      key: key,
      title: title,
      padding: padding,
      elevation: 0,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Card with left border accent in forest green for emphasized content.
  factory AppCard.highlighted({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return AppCard._(
      key: key,
      padding: padding,
      elevation: 1,
      accentColor: AppColors.forestGreen,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBg = backgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final effectivePadding = padding ?? const EdgeInsets.all(AppSpacing.lg);

    Widget cardBody = Container(
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: accentColor != null
            ? Border(
                left: BorderSide(
                  color: accentColor!,
                  width: 4,
                ),
              )
            : null,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: isDark
                      ? AppColors.shadow.withValues(alpha: 0.3)
                      : AppColors.shadow.withValues(alpha: 0.08),
                  blurRadius: elevation * 4,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(context, effectivePadding),
    );

    if (onTap != null) {
      cardBody = Material(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          splashColor: AppColors.forestGreen.withValues(alpha: 0.08),
          highlightColor: AppColors.forestGreen.withValues(alpha: 0.04),
          child: _buildContent(context, effectivePadding),
        ),
      );
    }

    return Semantics(
      container: true,
      label: title,
      child: cardBody,
    );
  }

  Widget _buildContent(BuildContext context, EdgeInsetsGeometry effectivePadding) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          Padding(
            padding: effectivePadding,
            child: child,
          ),
        ],
      );
    }

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}
