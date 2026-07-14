import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/settings/providers/settings_notifier.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accentColor = ref.watch(accentColorSettingNotifierProvider);
    final textSize = ref.watch(textSizeSettingNotifierProvider);
    final fontStyle = ref.watch(fontStyleSettingNotifierProvider);
    final reduceMotion = ref.watch(reduceMotionSettingNotifierProvider);
    final highContrast = ref.watch(highContrastSettingNotifierProvider);
    final showCyclePhaseColors = ref.watch(
      showCyclePhaseColorsNotifierProvider,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildPreviewCard(context, accentColor, textSize, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Accent Color'),
          const SizedBox(height: AppSpacing.sm),
          _buildAccentColorSection(context, ref, accentColor),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Text Size'),
          const SizedBox(height: AppSpacing.sm),
          _buildTextSizeSection(context, ref, textSize, fontStyle),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Display Options'),
          const SizedBox(height: AppSpacing.sm),
          _buildDisplayOptionsSection(
            context,
            ref,
            showCyclePhaseColors,
            reduceMotion,
            highContrast,
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(
    BuildContext context,
    AppAccentColor accentColor,
    double textSize,
    bool isDark,
  ) {
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final subTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return AppCard.standard(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.color,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.sync_rounded,
                    color: AppColors.onBrand,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontSize: 14 * textSize,
                      ),
                    ),
                    Text(
                      'Current settings applied',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subTextColor,
                        fontSize: 12 * textSize,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: accentColor.color,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Cycle Day 14 — Fertile Window',
              style: TextStyle(
                fontSize: 14 * textSize,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your fertile window is expected to begin soon.',
              style: TextStyle(fontSize: 12 * textSize, color: subTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        title,
        style: AppTypography.light.titleSmall?.copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccentColorSection(
    BuildContext context,
    WidgetRef ref,
    AppAccentColor current,
  ) {
    return AppCard.standard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.md,
          alignment: WrapAlignment.center,
          children: AppAccentColor.values.map((color) {
            final isSelected = color == current;
            return GestureDetector(
              onTap: () => ref
                  .read(accentColorSettingNotifierProvider.notifier)
                  .setAccentColor(color),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.charcoal, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColors.onBrand,
                            size: 22,
                          )
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    color.label,
                    style: AppTypography.light.bodySmall?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.forestGreen
                          : AppColors.slate,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTextSizeSection(
    BuildContext context,
    WidgetRef ref,
    double textSize,
    FontStyleSetting fontStyle,
  ) {
    return AppCard.standard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_fields, size: 18, color: AppColors.slate),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Slider(
                    value: textSize,
                    min: 0.8,
                    max: 1.4,
                    divisions: 6,
                    activeColor: AppColors.forestGreen,
                    label: '${(textSize * 100).round()}%',
                    onChanged: (v) => ref
                        .read(textSizeSettingNotifierProvider.notifier)
                        .setTextSize(v),
                  ),
                ),
                Icon(Icons.text_fields, size: 28, color: AppColors.forestGreen),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Small',
                    style: TextStyle(fontSize: 11, color: AppColors.slate),
                  ),
                  Text(
                    'Large',
                    style: TextStyle(fontSize: 11, color: AppColors.slate),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Font size: ${(textSize * 100).round()}%',
              style: AppTypography.light.bodySmall?.copyWith(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'The quick brown fox jumps over the lazy dog. This text demonstrates the currently selected font size.',
              style: TextStyle(
                fontSize: 14 * textSize,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Font Style',
              style: AppTypography.light.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...FontStyleSetting.values.map((style) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                // ignore: deprecated_member_use
                child: RadioListTile<FontStyleSetting>(
                  value: style,
                  // ignore: deprecated_member_use
                  groupValue: fontStyle,
                  title: Text(style.label),
                  activeColor: AppColors.forestGreen,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  // ignore: deprecated_member_use
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(fontStyleSettingNotifierProvider.notifier)
                          .setFontStyle(v);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayOptionsSection(
    BuildContext context,
    WidgetRef ref,
    bool showPhaseColors,
    bool reduceMotion,
    bool highContrast,
  ) {
    return AppCard.standard(
      child: Column(
        children: [
          _ToggleRow(
            icon: Icons.palette_outlined,
            label: 'Show Cycle Phase Colors',
            value: showPhaseColors,
            onChanged: (v) => ref
                .read(showCyclePhaseColorsNotifierProvider.notifier)
                .toggle(),
          ),
          const Divider(height: 1),
          _ToggleRow(
            icon: Icons.reduce_capacity_outlined,
            label: 'Reduce Motion',
            subtitle: 'Minimize animations and transitions',
            value: reduceMotion,
            onChanged: (v) =>
                ref.read(reduceMotionSettingNotifierProvider.notifier).toggle(),
          ),
          const Divider(height: 1),
          _ToggleRow(
            icon: Icons.contrast_outlined,
            label: 'High Contrast',
            subtitle: 'Increase contrast for better readability',
            value: highContrast,
            onChanged: (v) =>
                ref.read(highContrastSettingNotifierProvider.notifier).toggle(),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.light.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  Text(
                    subtitle!,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.forestGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
