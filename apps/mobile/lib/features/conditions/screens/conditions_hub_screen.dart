import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/conditions/data/condition_data.dart';
import 'package:cyra/features/conditions/models/condition_models.dart';
import 'package:cyra/features/conditions/providers/condition_providers.dart';
import 'package:cyra/features/conditions/screens/condition_detail_screen.dart';

class ConditionsHubScreen extends ConsumerWidget {
  const ConditionsHubScreen({super.key});

  static const _conditionIcons = <String, IconData>{
    'pcos': Icons.monitor_heart_outlined,
    'endometriosis': Icons.healing_outlined,
    'pmdd': Icons.mood_bad_outlined,
    'adenomyosis': Icons.female_outlined,
    'fibroids': Icons.circle_outlined,
    'thyroid': Icons.biotech_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allConditionsAsync = ref.watch(allConditionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conditions',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: allConditionsAsync.when(
        data: (userConditions) => _buildContent(
          context, ref, isDark, userConditions,
        ),
        loading: () => _buildShimmer(isDark),
        error: (e, _) => _buildError(isDark, e.toString()),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    List<UserCondition> userConditions,
  ) {
    final activeConditions = userConditions.where((c) => c.isActive).toList();
    final activeTypeIds = userConditions.map((c) => c.conditionType).toSet();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _buildHeader(context, isDark),
        if (activeConditions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          _buildActiveSection(context, ref, isDark, activeConditions),
        ],
        const SizedBox(height: AppSpacing.xxl),
        _buildAllConditionsSection(
          context, ref, isDark, activeTypeIds, userConditions,
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildEducationSection(isDark),
        const SizedBox(height: AppSpacing.xxl),
        _buildDisclaimer(isDark),
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Conditions',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Track specific health conditions for personalized insights',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSection(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    List<UserCondition> activeConditions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle,
                size: 18, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Active Conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...activeConditions.map((condition) {
          final info = ConditionData.conditions[condition.conditionType];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard.interactive(
              onTap: () => _openDetail(context, condition.conditionType),
              child: _buildActiveConditionRow(
                context, isDark, condition, info,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActiveConditionRow(
    BuildContext context,
    bool isDark,
    UserCondition condition,
    ConditionInfo? info,
  ) {
    final icon = _conditionIcons[condition.conditionType] ?? Icons.medical_services_outlined;
    final name = info?.name ?? condition.conditionType;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: AppColors.forestGreen, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              if (info != null) ...[
                const SizedBox(height: 2),
                Text(
                  info.commonSymptoms.take(2).join(', '),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            'Active',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.forestGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllConditionsSection(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    Set<String> activeTypeIds,
    List<UserCondition> userConditions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Conditions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...ConditionData.allConditions
            .where((info) => info.isVisible)
            .map((info) {
          final isActive = activeTypeIds.contains(info.id);
          final existingCondition = userConditions.where(
            (c) => c.conditionType == info.id,
          ).firstOrNull;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard.interactive(
              onTap: () => _openDetail(context, info.id),
              child: _buildConditionCard(
                context, ref, isDark, info, isActive, existingCondition,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildConditionCard(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    ConditionInfo info,
    bool isActive,
    UserCondition? existingCondition,
  ) {
    final icon = _conditionIcons[info.id] ?? Icons.medical_services_outlined;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.forestGreen.withValues(alpha: 0.1)
                    : (isDark
                        ? AppColors.charcoal.withValues(alpha: 0.5)
                        : AppColors.mistWhite),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: isActive ? AppColors.forestGreen : AppColors.slate,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info.description.length > 80
                        ? '${info.description.substring(0, 80)}...'
                        : info.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            AppButton.ghost(
              isActive ? 'Manage Tracking' : 'Learn More',
              onPressed: () => _openDetail(context, info.id),
            ),
            const Spacer(),
            Switch(
              value: isActive,
              onChanged: (value) => _toggleCondition(
                context, ref, info, value, existingCondition,
              ),
              activeTrackColor: AppColors.forestGreen,
            ),
          ],
        ),
      ],
    );
  }

  void _toggleCondition(
    BuildContext context,
    WidgetRef ref,
    ConditionInfo info,
    bool value,
    UserCondition? existing,
  ) {
    if (value && existing == null) {
      ref.read(conditionManagerProvider.notifier).addCondition(
        UserCondition(
          id: 'cond_${DateTime.now().millisecondsSinceEpoch}',
          conditionType: info.id,
          isActive: true,
          trackedSymptoms: info.commonSymptoms,
        ),
      );
    } else if (!value && existing != null) {
      ref.read(conditionManagerProvider.notifier)
          .toggleCondition(existing.id, false);
    } else if (value && existing != null) {
      ref.read(conditionManagerProvider.notifier)
          .toggleCondition(existing.id, true);
    }
  }

  Widget _buildEducationSection(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 20, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'How Tracking Helps',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Consistent tracking of condition-specific symptoms helps you:\n\n'
            '• Identify patterns and triggers over time\n'
            '• Provide your healthcare provider with detailed data\n'
            '• Monitor treatment effectiveness\n'
            '• Recognize early warning signs of flare-ups\n'
            '• Make informed decisions about your health',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.slate,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 16, color: AppColors.softGold),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This information is for educational purposes. '
              'Consult your healthcare provider for medical advice.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.slate,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Shimmer.fromColors(
          baseColor: isDark ? AppColors.charcoal : AppColors.borderLight,
          highlightColor: isDark ? AppColors.surfaceDark : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ...List.generate(4, (_) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(bool isDark, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, String conditionType) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConditionDetailScreen(conditionType: conditionType),
      ),
    );
  }
}
