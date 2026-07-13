import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart' as indicator;
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/insights/providers/insight_providers.dart';
import 'package:cyra/features/insights/models/insight_models.dart';
import 'package:cyra/features/insights/screens/topic_detail_screen.dart';
import 'package:cyra/features/insights/screens/health_tips_screen.dart';
import 'package:cyra/features/insights/screens/ai_disclaimer_screen.dart';

final _insightsHubProvider = ChangeNotifierProvider<_InsightsHubState>((ref) {
  return _InsightsHubState();
});

class _InsightsHubState extends ChangeNotifier {
  bool aiDisclaimerAccepted = false;

  void acceptDisclaimer() {
    aiDisclaimerAccepted = true;
    notifyListeners();
  }
}

class InsightsHubScreen extends ConsumerWidget {
  const InsightsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_insightsHubProvider);
    final dashboardAsync = ref.watch(dashboardInsightsProvider);
    final weeklyAsync = ref.watch(weeklySummaryProvider);
    final tipAsync = ref.watch(healthTipProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!state.aiDisclaimerAccepted) {
      return AIDisclaimerScreen(
        onAccept: () => ref.read(_insightsHubProvider.notifier).acceptDisclaimer(),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dashboardInsightsProvider.future),
        color: AppColors.forestGreen,
        child: dashboardAsync.when(
          data: (dashboard) {
            if (dashboard.nextPeriod.confidenceScore < 0.01) {
              return _buildEmptyState(context, isDark, ref);
            }
            return _buildContent(context, dashboard, weeklyAsync, tipAsync, isDark, ref);
          },
          loading: () => _buildLoadingState(context, isDark),
          error: (_, __) => _buildEmptyState(context, isDark, ref),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DashboardInsights dashboard,
    AsyncValue<WeeklySummary> weeklyAsync,
    AsyncValue<String> tipAsync,
    bool isDark,
    WidgetRef ref,
  ) {

    final prediction = dashboard.nextPeriod;
    final regularity = dashboard.regularity;
    final topSymptoms = dashboard.topSymptoms;
    final fertileWindow = dashboard.fertileWindow;

    String fertileWindowStatus = 'Track your cycle to see your fertile window';
    if (fertileWindow != null) {
      if (fertileWindow.isInWindow) {
        fertileWindowStatus = 'In fertile window';
      } else {
        fertileWindowStatus = 'Fertile window: ${_formatDate(fertileWindow.windowStart)} - ${_formatDate(fertileWindow.windowEnd)}';
      }
    }

    String ovulationStatus = 'Insufficient data';
    if (fertileWindow?.ovulationDate != null) {
      ovulationStatus = 'Ovulation around ${_formatDate(fertileWindow!.ovulationDate!)}';
    }

    final symptomsLogged = topSymptoms.fold<int>(0, (int a, ImpactfulSymptom b) => a + b.frequency);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxxxl, AppSpacing.lg, AppSpacing.xxxl),
      children: [
        _buildHeader(context, dashboard.currentPhase, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildWeeklySummary(context, dashboard.weeklySummary, symptomsLogged, topSymptoms.length, weeklyAsync, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildSmartPredictions(context, prediction, fertileWindowStatus, ovulationStatus, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildSymptomInsights(context, topSymptoms, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildCycleInsights(context, regularity, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildPersonalizedTips(context, tipAsync, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildDisclaimer(context, isDark),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    final baseColor = isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.borderLight;
    final highlightColor = isDark ? AppColors.charcoal.withValues(alpha: 0.5) : AppColors.mistWhite;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.xxxxl),
          _shimmerBlock(height: 24, width: 200),
          const SizedBox(height: AppSpacing.sm),
          _shimmerBlock(height: 18, width: 140),
          const SizedBox(height: AppSpacing.xxl),
          _shimmerBlock(height: 180),
          const SizedBox(height: AppSpacing.lg),
          _shimmerBlock(height: 140),
          const SizedBox(height: AppSpacing.lg),
          _shimmerBlock(height: 200),
        ],
      ),
    );
  }

  Widget _shimmerBlock({required double height, double? width}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.onBrand,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.auto_awesome, size: 40, color: AppColors.forestGreen),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Your AI Insights',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Track your cycles to unlock personalized AI insights about your patterns and health.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              'Start Tracking',
              icon: Icons.add_rounded,
              onPressed: () => Navigator.of(context).pushNamed('/calendar'),
            ),
          ],
        ),
      ),
    );
  }

  indicator.CyclePhase _toIndicatorPhase(models.CyclePhase phase) {
    switch (phase) {
      case models.CyclePhase.menstrual: return indicator.CyclePhase.menstrual;
      case models.CyclePhase.follicular: return indicator.CyclePhase.follicular;
      case models.CyclePhase.ovulation: return indicator.CyclePhase.ovulation;
      case models.CyclePhase.luteal: return indicator.CyclePhase.luteal;
    }
  }

  Widget _buildHeader(BuildContext context, models.CyclePhase phase, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.forestGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'AI Insights',
              style: AppTypography.light.titleMedium?.copyWith(
                color: AppColors.slate,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Your Intelligence Center',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        indicator.CyclePhaseIndicator(
          phase: _toIndicatorPhase(phase),
          size: indicator.CyclePhaseIndicatorSize.medium,
        ),
      ],
    );
  }

  Widget _buildWeeklySummary(
    BuildContext context,
    String weeklySummary,
    int symptomsLogged,
    int uniqueSymptoms,
    AsyncValue<WeeklySummary> weeklyAsync,
    bool isDark,
  ) {
    final weekly = weeklyAsync.asData?.value;

    return AppCard.highlighted(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Your Week in Review',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (weekly != null) ...[
            Row(
              children: [
                HealthStatCard(
                  label: 'Symptoms Logged',
                  value: '${weekly.symptomCount}',
                  icon: Icons.healing_outlined,
                  accentColor: AppColors.sage,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: HealthStatCard(
                    label: 'Mood Average',
                    value: weekly.moodAverage.toStringAsFixed(1),
                    icon: Icons.favorite_outlined,
                    accentColor: AppColors.softGold,
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                HealthStatCard(
                  label: 'Symptoms Logged',
                  value: '$symptomsLogged',
                  icon: Icons.healing_outlined,
                  accentColor: AppColors.sage,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: HealthStatCard(
                    label: 'Unique Types',
                    value: '$uniqueSymptoms',
                    icon: Icons.category_outlined,
                    accentColor: AppColors.forestGreen,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outlined, size: 18, color: AppColors.softGold),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    weekly?.keyInsight ?? weeklySummary,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (weekly?.tip != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.tips_and_updates_outlined, size: 16, color: AppColors.sage),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    weekly!.tip!,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: AppColors.slate,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmartPredictions(
    BuildContext context,
    models.PredictionResult prediction,
    String fertileWindowStatus,
    String ovulationStatus,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Smart Predictions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (prediction.predictedDate != DateTime.now()) ...[
            _PredictionRow(
              icon: Icons.water_drop_rounded,
              label: 'Next Period',
              value: 'In ${DateTime.now().daysUntil(prediction.predictedDate)} days',
              badge: ConfidenceBadge(confidence: prediction.confidenceScore),
              isDark: isDark,
            ),
            const Divider(height: AppSpacing.xxl),
          ],
          _PredictionRow(
            icon: Icons.schedule_rounded,
            label: 'Fertile Window',
            value: fertileWindowStatus,
            isDark: isDark,
          ),
          const Divider(height: AppSpacing.xxl),
          _PredictionRow(
            icon: Icons.circle_outlined,
            label: 'Ovulation',
            value: ovulationStatus,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TopicDetailScreen(topic: 'prediction'),
                ),
              ),
              child: Text(
                'View details',
                style: TextStyle(color: AppColors.forestGreen, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomInsights(
    BuildContext context,
    List<ImpactfulSymptom> topSymptoms,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.healing_outlined, size: 20, color: AppColors.sage),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Symptom Insights',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (topSymptoms.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Text(
                  'Track more symptoms to see patterns',
                  style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ),
            ),
          ] else ...[
            Text(
              'Your Top Symptoms',
              style: AppTypography.light.labelMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...topSymptoms.take(3).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ImpactfulSymptomCard(symptom: s, isDark: isDark),
            )),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TopicDetailScreen(topic: 'symptoms'),
                ),
              ),
              child: Text(
                'See all patterns',
                style: TextStyle(color: AppColors.forestGreen, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleInsights(
    BuildContext context,
    CycleRegularityResult regularity,
    bool isDark,
  ) {
    final regularityLabel = switch (regularity.regularity) {
      CycleRegularity.regular => 'Regular',
      CycleRegularity.slightlyIrregular => 'Slightly Irregular',
      CycleRegularity.irregular => 'Irregular',
    };
    final trendLabel = regularity.trend ?? 'Stable';

    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.repeat_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Cycle Insights',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: HealthStatCard(
                  label: 'Regularity',
                  value: regularityLabel,
                  icon: Icons.check_circle_outlined,
                  accentColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: HealthStatCard(
                  label: 'Trend',
                  value: trendLabel,
                  icon: Icons.trending_flat_rounded,
                  accentColor: AppColors.sage,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TopicDetailScreen(topic: 'cycle_regularity'),
                ),
              ),
              child: Text(
                'View cycle analysis',
                style: TextStyle(color: AppColors.forestGreen, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedTips(
    BuildContext context,
    AsyncValue<String> tipAsync,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, size: 20, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Personalized Tips',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        tipAsync.when(
          data: (tip) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard.standard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.softGold.withValues(alpha: isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(Icons.tips_and_updates_outlined, size: 20, color: AppColors.softGold),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTypography.light.bodySmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        AppButton.ghost(
          'View all tips',
          icon: Icons.arrow_forward,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const HealthTipsScreen()),
          ),
          height: 40,
        ),
      ],
    );
  }

  Widget _buildDisclaimer(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        'AI insights are educational and based on pattern recognition from your logged data. '
        'They are not medical diagnoses. Always consult a healthcare provider for medical advice.',
        textAlign: TextAlign.center,
        style: AppTypography.light.labelSmall?.copyWith(
          color: AppColors.slate.withValues(alpha: 0.6),
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _PredictionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ConfidenceBadge? badge;
  final bool isDark;

  const _PredictionRow({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.sage),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.light.labelMedium?.copyWith(color: AppColors.slate),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: AppTypography.light.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (badge != null) badge!,
      ],
    );
  }
}

class _ImpactfulSymptomCard extends StatelessWidget {
  final ImpactfulSymptom symptom;
  final bool isDark;

  const _ImpactfulSymptomCard({required this.symptom, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                symptom.symptomName,
                style: AppTypography.light.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              const Spacer(),
              _SeverityBadge(severity: symptom.averageSeverity),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${symptom.frequency} times this cycle \u00b7 Severity ${symptom.averageSeverity.toStringAsFixed(1)}',
            style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final double severity;
  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = severity >= 3.5 ? AppColors.softGold : (severity >= 2.5 ? AppColors.sage : AppColors.slate);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        severity.toStringAsFixed(1),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
