import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/design/widgets/cycle_overview_chart.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/cycle/providers/cycle_providers.dart';

final _predictionDetailProvider =
    FutureProvider.autoDispose<_PredictionDetailState>((ref) async {
      final prediction = await ref.watch(nextPeriodPredictionProvider.future);
      final cycles = await ref.watch(allCyclesProvider.future);
      final activeCycle = await ref.watch(activeCycleProvider.future);
      final average = cycles.isEmpty
          ? 28
          : (cycles.map((cycle) => cycle.cycleLength).reduce((a, b) => a + b) /
                    cycles.length)
                .round();
      var phase = 'Unknown';
      if (activeCycle != null) {
        final day = DateTime.now().difference(activeCycle.startDate).inDays + 1;
        if (day <= activeCycle.periodLength) {
          phase = 'Menstrual';
        } else if (day < activeCycle.cycleLength - 15) {
          phase = 'Follicular';
        } else if (day <= activeCycle.cycleLength - 13) {
          phase = 'Ovulation';
        } else {
          phase = 'Luteal';
        }
      }
      return _PredictionDetailState(
        prediction: prediction,
        currentPhase: phase,
        trackedCycles: cycles.length,
        averageCycleLength: average,
        variabilityDays: prediction.variabilityScore,
        cycleHistory: [
          for (var index = cycles.length - 1; index >= 0; index--)
            CycleLengthData(
              cycleNumber: cycles.length - index,
              lengthDays: cycles[index].cycleLength,
            ),
        ],
      );
    });

class _PredictionDetailState {
  const _PredictionDetailState({
    required this.prediction,
    required this.currentPhase,
    required this.trackedCycles,
    required this.averageCycleLength,
    required this.variabilityDays,
    required this.cycleHistory,
  });
  final models.PredictionResult prediction;
  final String currentPhase;
  final int trackedCycles;
  final int averageCycleLength;
  final double variabilityDays;
  final List<CycleLengthData> cycleHistory;
}

class PredictionDetailScreen extends ConsumerWidget {
  const PredictionDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(_predictionDetailProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return stateAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Prediction')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: const Text('Prediction')),
        body: Center(
          child: TextButton(
            onPressed: () => ref.invalidate(_predictionDetailProvider),
            child: const Text('Could not load prediction. Try again'),
          ),
        ),
      ),
      data: (state) => _buildContent(context, state, isDark),
    );
  }

  Widget _buildContent(
    BuildContext context,
    _PredictionDetailState state,
    bool isDark,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Next Period'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _sharePrediction(context, state),
            tooltip: 'Share prediction',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildMainDateCard(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildConfidenceSection(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildExplanation(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          AppCard.chart(
            title: 'Cycle Length History',
            child: CycleOverviewChart(
              cycleHistory: state.cycleHistory,
              showAverageLine: true,
              height: 220,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildEducationSection(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildDisclaimer(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildMainDateCard(
    BuildContext context,
    _PredictionDetailState state,
    bool isDark,
  ) {
    final dateFormat = DateFormat('EEEE, MMMM d');
    final rangeFormat = DateFormat('MMM d');

    return AppCard.highlighted(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          Icon(Icons.sync_rounded, size: 32, color: AppColors.forestGreen),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Predicted Start',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            dateFormat.format(state.prediction.predictedDate),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${rangeFormat.format(state.prediction.predictionRangeStart)} – '
            '${rangeFormat.format(state.prediction.predictionRangeEnd)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceSection(
    BuildContext context,
    _PredictionDetailState state,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          ConfidenceBadge(
            confidence: state.prediction.confidenceScore,
            size: ConfidenceBadgeSize.large,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(state.prediction.confidenceScore * 100).round()}% Confidence',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _confidenceReason(state),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _confidenceReason(_PredictionDetailState state) {
    if (state.prediction.confidenceScore >= 0.8) {
      return 'Your cycles are very regular with minimal variation.';
    }
    if (state.prediction.confidenceScore >= 0.5) {
      return 'Your cycles show moderate regularity. Tracking more cycles will improve predictions.';
    }
    return 'Your cycles vary significantly. More data will help refine predictions.';
  }

  Widget _buildExplanation(
    BuildContext context,
    _PredictionDetailState state,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Why this prediction?',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _explanationRow(
            context,
            Icons.history_rounded,
            'Based on your last ${state.trackedCycles} cycles',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _explanationRow(
            context,
            Icons.repeat_rounded,
            'Average cycle length: ${state.averageCycleLength} days',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _explanationRow(
            context,
            Icons.trending_flat_rounded,
            'Your cycles vary by ${state.variabilityDays.toStringAsFixed(0)} days',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _explanationRow(
            context,
            Icons.sync_rounded,
            'Current phase: ${state.currentPhase}',
            isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.charcoal.withValues(alpha: 0.2)
                  : AppColors.warmIvory.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: AppColors.softGold,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    state.prediction.explanation,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.charcoal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _explanationRow(
    BuildContext context,
    IconData icon,
    String text,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.forestGreen),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationSection(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 20,
                color: AppColors.softGold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Why does this matter?',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Knowing when to expect your next period helps you plan ahead, '
            'manage symptoms, and understand your body\'s natural rhythm. '
            'Regular predictions become more accurate the more data you track.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.slate,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tracking consistently helps you:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _bulletPoint(context, 'Identify patterns in your cycle', isDark),
          _bulletPoint(context, 'Recognize PMS and symptom trends', isDark),
          _bulletPoint(context, 'Plan for upcoming periods', isDark),
          _bulletPoint(
            context,
            'Share insights with your healthcare provider',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _bulletPoint(BuildContext context, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.forestGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: AppColors.softGold,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This is a prediction, not certainty',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Cycle predictions are estimates based on your logged data. '
                  'Individual cycles may vary. Cyra is not a medical device and '
                  'should not be used as a sole method of birth control or for '
                  'diagnosing medical conditions.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sharePrediction(BuildContext context, _PredictionDetailState state) {
    final dateFormat = DateFormat('MMMM d, yyyy');
    final shareText =
        'My next period is predicted to start on '
        '${dateFormat.format(state.prediction.predictedDate)} '
        '(with ${(state.prediction.confidenceScore * 100).round()}% confidence). '
        'Tracked with Cyra.';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prediction copied to clipboard')),
    );
  }
}
