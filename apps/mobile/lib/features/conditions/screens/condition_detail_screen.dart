import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/symptom_bar_chart.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/conditions/data/condition_data.dart';
import 'package:cyra/features/conditions/models/condition_models.dart';
import 'package:cyra/features/conditions/providers/condition_providers.dart';
import 'package:cyra/features/conditions/screens/condition_tracking_screen.dart';
class ConditionDetailScreen extends ConsumerStatefulWidget {
  final String conditionType;

  const ConditionDetailScreen({
    super.key,
    required this.conditionType,
  });

  @override
  ConsumerState<ConditionDetailScreen> createState() =>
      _ConditionDetailScreenState();
}

class _ConditionDetailScreenState
    extends ConsumerState<ConditionDetailScreen> {
  final Set<String> _selectedSymptoms = {};

  ConditionInfo get _info =>
      ConditionData.getCondition(widget.conditionType);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternsAsync = ref.watch(
        conditionPatternsProvider(widget.conditionType));
    final userConditionsAsync = ref.watch(allConditionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _info.name,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.track_changes_outlined,
                color: AppColors.forestGreen),
            tooltip: 'Track symptoms',
            onPressed: () => _openTracking(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildInfoHeader(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildDescription(isDark),
          const SizedBox(height: AppSpacing.xl),
          userConditionsAsync.when(
            data: (conditions) {
              final isActive = conditions.any(
                (c) => c.conditionType == widget.conditionType && c.isActive,
              );
              if (!isActive) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: AppButton.primary(
                    'Activate Tracking for ${_info.name}',
                    onPressed: () => _activateCondition(conditions),
                    width: double.infinity,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          _buildCommonSymptoms(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildTrackingRecommendations(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildManagementTips(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildWhenToSeeDoctor(isDark),
          const SizedBox(height: AppSpacing.xl),
          patternsAsync.when(
            data: (patterns) {
              if (patterns['hasData'] == true) {
                return _buildPatternSection(isDark, patterns);
              }
              return _buildNoPatternsYet(isDark);
            },
            loading: () => _buildPatternShimmer(isDark),
            error: (_, __) => _buildNoPatternsYet(isDark),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildEducationArticles(isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildDisclaimerBox(isDark),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildInfoHeader(bool isDark) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(
            _conditionIcon(),
            color: AppColors.forestGreen,
            size: 28,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _info.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              if (_info.prevalenceInfo != null) ...[
                const SizedBox(height: 4),
                Text(
                  _info.prevalenceInfo!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.sage,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  IconData _conditionIcon() {
    switch (widget.conditionType) {
      case 'pcos':
        return Icons.monitor_heart_outlined;
      case 'endometriosis':
        return Icons.healing_outlined;
      case 'pmdd':
        return Icons.mood_bad_outlined;
      case 'adenomyosis':
        return Icons.female_outlined;
      case 'fibroids':
        return Icons.circle_outlined;
      case 'thyroid':
        return Icons.biotech_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  Widget _buildDescription(bool isDark) {
    return Text(
      _info.description,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
        height: 1.6,
      ),
    );
  }

  Widget _buildCommonSymptoms(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Common Symptoms',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(_info.commonSymptoms.length, (i) {
          final symptom = _info.commonSymptoms[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_selectedSymptoms.contains(symptom)) {
                    _selectedSymptoms.remove(symptom);
                  } else {
                    _selectedSymptoms.add(symptom);
                  }
                });
              },
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _selectedSymptoms.contains(symptom)
                          ? AppColors.forestGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _selectedSymptoms.contains(symptom)
                            ? AppColors.forestGreen
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: 1.5,
                      ),
                    ),
                    child: _selectedSymptoms.contains(symptom)
                        ? Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      symptom,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrackingRecommendations(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes_outlined,
                  size: 18, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tracking Recommendations',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ..._info.trackingRecommendations.map((rec) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ',
                      style: TextStyle(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w600)),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.slate,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            'Start Tracking',
            icon: Icons.add_rounded,
            onPressed: () => _openTracking(context),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTips(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 18, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Management Tips',
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
            _info.managementTips,
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

  Widget _buildWhenToSeeDoctor(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_hospital_outlined,
                  size: 18, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'When to See a Doctor',
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
            _info.whenToSeeDoctor,
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

  Widget _buildPatternSection(
      bool isDark, Map<String, dynamic> patterns) {
    final insights = patterns['insights'] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome,
                size: 18, color: AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Pattern Recognition',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Based on your tracking, here are patterns we\'ve noticed:',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slate,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...insights.map((insight) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.tips_and_updates,
                  size: 16, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  insight,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: AppSpacing.lg),
        _buildSymptomFrequencyChart(isDark),
      ],
    );
  }

  Widget _buildSymptomFrequencyChart(bool isDark) {
    final conditionSymptoms = _info.commonSymptoms;
    final shortList = conditionSymptoms.take(6).toList();

    final mockValues = <double>[];
    for (int i = 0; i < shortList.length; i++) {
      mockValues.add((shortList.length - i) * 1.5 + 1);
    }

    final barData = List.generate(shortList.length, (i) {
      final labels = [
        'Irregular',
        'Hair growth',
        'Acne',
        'Weight',
        'Hair thinning',
        'Fertility',
        'Pain',
        'Flow',
        'Mood',
        'Fatigue',
      ];
      return SymptomBarData(
        label: shortList[i].length > 12
            ? '${shortList[i].substring(0, 10)}...'
            : shortList[i],
        value: mockValues[i],
        color: AppColors.forestGreen.withValues(
            alpha: 0.4 + (0.6 * (1 - i / shortList.length))),
      );
    });

    return SymptomBarChart(
      symptoms: barData,
      maxBars: 6,
    );
  }

  Widget _buildNoPatternsYet(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.3)
            : AppColors.mistWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_graph_outlined,
              size: 40, color: AppColors.slate.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No patterns yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start tracking your symptoms regularly and we\'ll identify patterns to help you understand your condition better.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.slate,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.secondary(
            'Start Tracking',
            icon: Icons.add_rounded,
            onPressed: () => _openTracking(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.charcoal : AppColors.borderLight,
      highlightColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  Widget _buildEducationArticles(bool isDark) {
    return AppCard.interactive(
      onTap: () {
        context.showSnackBar('Education articles coming soon');
      },
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.menu_book_outlined,
                color: AppColors.sage, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Related Education Articles',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Learn more about ${_info.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBox(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.08),
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

  void _activateCondition(List<UserCondition> existingConditions) {
    final existing = existingConditions.where(
      (c) => c.conditionType == widget.conditionType,
    ).firstOrNull;

    if (existing != null) {
      ref.read(conditionManagerProvider.notifier)
          .toggleCondition(existing.id, true);
    } else {
      ref.read(conditionManagerProvider.notifier).addCondition(
        UserCondition(
          id: 'cond_${DateTime.now().millisecondsSinceEpoch}',
          conditionType: widget.conditionType,
          isActive: true,
          trackedSymptoms: _info.commonSymptoms,
        ),
      );
    }
  }

  void _openTracking(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConditionTrackingScreen(
          conditionType: widget.conditionType,
        ),
      ),
    );
  }
}
