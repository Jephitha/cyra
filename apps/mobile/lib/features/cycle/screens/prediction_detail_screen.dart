import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/design/widgets/cycle_overview_chart.dart';
import 'package:cyra/core/constants/cycle_constants.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;

final _predictionDetailProvider = ChangeNotifierProvider<_PredictionDetailState>((ref) {
  return _PredictionDetailState();
});

class _PredictionDetailState extends ChangeNotifier {
  bool isLoading = true;

  models.PredictionResult prediction = models.PredictionResult(
    predictedDate: DateTime(2026, 4, 1),
    confidenceScore: 0.85,
    variabilityScore: 1.5,
    predictionRangeStart: DateTime(2026, 3, 30),
    predictionRangeEnd: DateTime(2026, 4, 4),
    explanation:
        'Based on your last 6 cycles with an average length of 28 days. '
        'Your cycles are very regular, varying by only 1-2 days.',
  );

  String currentPhase = 'Follicular';
  int trackedCycles = 6;
  int averageCycleLength = 28;
  double variabilityDays = 1.5;
  List<CycleLengthData> cycleHistory = [];

  _PredictionDetailState() {
    _loadData();
  }

  void _loadData() {
    cycleHistory = [
      const CycleLengthData(cycleNumber: 1, lengthDays: 28),
      const CycleLengthData(cycleNumber: 2, lengthDays: 29),
      const CycleLengthData(cycleNumber: 3, lengthDays: 27),
      const CycleLengthData(cycleNumber: 4, lengthDays: 28),
      const CycleLengthData(cycleNumber: 5, lengthDays: 30),
      const CycleLengthData(cycleNumber: 6, lengthDays: 28),
    ];

    isLoading = false;
    notifyListeners();
  }
}

class PredictionDetailScreen extends ConsumerWidget {
  const PredictionDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_predictionDetailProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prediction')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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

  Widget _buildMainDateCard(BuildContext context, _PredictionDetailState state, bool isDark) {
    final dateFormat = DateFormat('EEEE, MMMM d');
    final rangeFormat = DateFormat('MMM d');

    return AppCard.highlighted(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          Icon(
            Icons.water_drop_rounded,
            size: 32,
            color: AppColors.forestGreen,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Predicted Start',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.slate,
            ),
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

  Widget _buildConfidenceSection(BuildContext context, _PredictionDetailState state, bool isDark) {
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
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _confidenceReason(state),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
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

  Widget _buildExplanation(BuildContext context, _PredictionDetailState state, bool isDark) {
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
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
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
            Icons.water_drop_rounded,
            'Current phase: $currentPhase',
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
                      color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
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

  Widget _explanationRow(BuildContext context, IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.forestGreen,
        ),
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

  String get currentPhase {
    final now = DateTime.now();
    final cycleDay = now.day % 28;
    if (cycleDay <= 5) return 'Menstrual';
    if (cycleDay <= 13) return 'Follicular';
    if (cycleDay <= 15) return 'Ovulation';
    return 'Luteal';
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
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
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
          _bulletPoint(context, 'Share insights with your healthcare provider', isDark),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
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
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prediction copied to clipboard')));
  }
}
