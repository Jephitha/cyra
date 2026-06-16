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
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/design/widgets/symptom_bar_chart.dart';
import 'package:cyra/core/design/widgets/health_timeline.dart';
import 'package:cyra/core/constants/app_constants.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/insights/screens/topic_detail_screen.dart';
import 'package:cyra/features/insights/screens/health_tips_screen.dart';
import 'package:cyra/features/insights/screens/cycle_education_screen.dart';
import 'package:cyra/features/insights/screens/ai_disclaimer_screen.dart';
import 'package:cyra/features/insights/screens/insight_detail_card.dart';

final _insightsHubProvider = ChangeNotifierProvider<_InsightsHubState>((ref) {
  return _InsightsHubState();
});

class _InsightsHubState extends ChangeNotifier {
  bool isLoading = true;
  bool hasData = true;
  bool aiDisclaimerAccepted = false;
  bool emptyState = false;

  int symptomsLogged = 8;
  int daysTracked = 14;
  double moodAverage = 3.5;
  String keyInsight = 'Your symptoms are most intense during the luteal phase. Consider tracking stress levels for a clearer picture.';
  String healthTip = 'Stay hydrated during your luteal phase to reduce bloating and fatigue.';

  CyclePhase currentPhase = CyclePhase.luteal;
  int currentCycleDay = 22;
  int cycleLength = 28;

  models.PredictionResult? prediction;
  String fertileWindowStatus = 'Fertile window ended 3 days ago';
  String ovulationStatus = 'Ovulation confirmed on day 14';

  List<_ImpactfulSymptom> topSymptoms = [];
  String regularityStatus = 'Regular';
  String cycleTrend = 'Stable';
  int cycleCount = 6;
  double averageCycleLength = 28;

  List<_HealthTip> tips = [];
  List<String> exampleQuestions = [
    'Why is my cycle irregular?',
    'When am I most fertile?',
    'What does my symptom pattern mean?',
    'How can I manage period pain?',
  ];
  String askCyraResponse = '';

  _InsightsHubState() {
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    prediction = models.PredictionResult(
      predictedDate: DateTime.now().add(const Duration(days: 6)),
      confidenceScore: 0.88,
      variabilityScore: 1.5,
      predictionRangeStart: DateTime.now().add(const Duration(days: 4)),
      predictionRangeEnd: DateTime.now().add(const Duration(days: 8)),
      explanation: 'Based on your last 6 cycles with an average length of 28 days.',
    );

    topSymptoms = [
      _ImpactfulSymptom(
        name: 'Bloating',
        frequency: 12,
        severity: 3.2,
        phaseCorrelation: 'Luteal phase (days 19-22)',
      ),
      _ImpactfulSymptom(
        name: 'Fatigue',
        frequency: 10,
        severity: 3.8,
        phaseCorrelation: 'Late luteal phase (days 22-26)',
      ),
      _ImpactfulSymptom(
        name: 'Cramps',
        frequency: 8,
        severity: 2.5,
        phaseCorrelation: 'Menstrual phase (days 1-3)',
      ),
    ];

    tips = [
      _HealthTip(
        category: _TipCategory.nutrition,
        tip: 'Increase iron-rich foods during your menstrual phase to replenish what\'s lost.',
        phase: 'Menstrual',
      ),
      _HealthTip(
        category: _TipCategory.exercise,
        tip: 'Gentle yoga and stretching can help ease menstrual cramps.',
        phase: 'Menstrual',
      ),
      _HealthTip(
        category: _TipCategory.sleep,
        tip: 'Your progesterone rises in the luteal phase, which may affect sleep. Try a consistent bedtime.',
        phase: 'Luteal',
      ),
    ];

    isLoading = false;
    notifyListeners();
  }

  void acceptDisclaimer() {
    aiDisclaimerAccepted = true;
    notifyListeners();
  }

  void onAskCyra(String question) {
    final responses = {
      'Why is my cycle irregular?': 'Cycle irregularity can be influenced by stress, significant weight changes, hormonal imbalances, or conditions like PCOS. Based on your logs, your cycle length varies by 1-3 days, which is within normal range.',
      'When am I most fertile?': 'Based on your average 28-day cycle, your fertile window is approximately days 8-19, with ovulation around day 14. This is when you\'re most likely to conceive.',
      'What does my symptom pattern mean?': 'Your logged symptoms show a pattern: bloating and fatigue peak in the luteal phase, while cramps occur at the start of menstruation. This pattern is common and consistent with normal hormonal fluctuations.',
      'How can I manage period pain?': 'Based on your logged data, your cramps are mild to moderate. Over-the-counter anti-inflammatories, heat therapy, gentle exercise, and adequate hydration may help. Consult your healthcare provider for persistent pain.',
    };
    askCyraResponse = responses[question] ?? 'I can help with cycle-related questions. Try asking about your cycle regularity, fertile window, or symptom patterns.';
    notifyListeners();
  }
}

enum _TipCategory { nutrition, exercise, sleep, stress, symptomManagement }

class _HealthTip {
  final _TipCategory category;
  final String tip;
  final String phase;
  const _HealthTip({required this.category, required this.tip, required this.phase});
}

class _ImpactfulSymptom {
  final String name;
  final int frequency;
  final double severity;
  final String phaseCorrelation;
  const _ImpactfulSymptom({
    required this.name,
    required this.frequency,
    required this.severity,
    required this.phaseCorrelation,
  });
}

class InsightsHubScreen extends ConsumerWidget {
  const InsightsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_insightsHubProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) return _buildLoadingState(context);

    if (state.emptyState) return _buildEmptyState(context, state, ref, isDark);

    if (!state.aiDisclaimerAccepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AIDisclaimerScreen(
              onAccept: () => ref.read(_insightsHubProvider.notifier).acceptDisclaimer(),
            ),
          ),
        );
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.forestGreen,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxxxl, AppSpacing.lg, AppSpacing.xxxl),
          children: [
            _buildHeader(context, state, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildWeeklySummary(context, state, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildSmartPredictions(context, state, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildSymptomInsights(context, state, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildCycleInsights(context, state, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildPersonalizedTips(context, state, isDark, ref),
            const SizedBox(height: AppSpacing.lg),
            _buildAskCyra(context, state, isDark, ref),
            const SizedBox(height: AppSpacing.xxl),
            _buildDisclaimer(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, _InsightsHubState state, WidgetRef ref, bool isDark) {
    return Scaffold(
      body: Center(
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
              const SizedBox(height: AppSpacing.xxxl),
              AppButton.primary(
                'Start Tracking',
                icon: Icons.add_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _InsightsHubState state, bool isDark) {
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
        CyclePhaseIndicator(
          phase: state.currentPhase,
          size: CyclePhaseIndicatorSize.medium,
        ),
      ],
    );
  }

  Widget _buildWeeklySummary(BuildContext context, _InsightsHubState state, bool isDark) {
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
          Row(
            children: [
              HealthStatCard(
                label: 'Symptoms Logged',
                value: '${state.symptomsLogged}',
                icon: Icons.healing_outlined,
                accentColor: AppColors.sage,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: HealthStatCard(
                  label: 'Days Tracked',
                  value: '${state.daysTracked}',
                  icon: Icons.calendar_today_rounded,
                  accentColor: AppColors.forestGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: HealthStatCard(
                  label: 'Mood Average',
                  value: state.moodAverage.toStringAsFixed(1),
                  icon: Icons.favorite_outlined,
                  accentColor: AppColors.softGold,
                ),
              ),
            ],
          ),
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
                    state.keyInsight,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, size: 16, color: AppColors.sage),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  state.healthTip,
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: AppColors.slate,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartPredictions(BuildContext context, _InsightsHubState state, bool isDark) {
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
          if (state.prediction != null) ...[
            _PredictionRow(
              icon: Icons.water_drop_rounded,
              label: 'Next Period',
              value: 'In ${DateTime.now().daysUntil(state.prediction!.predictedDate)} days',
              badge: ConfidenceBadge(confidence: state.prediction!.confidenceScore),
              isDark: isDark,
            ),
            const Divider(height: AppSpacing.xxl),
          ],
          _PredictionRow(
            icon: Icons.schedule_rounded,
            label: 'Fertile Window',
            value: state.fertileWindowStatus,
            isDark: isDark,
          ),
          const Divider(height: AppSpacing.xxl),
          _PredictionRow(
            icon: Icons.circle_outlined,
            label: 'Ovulation',
            value: state.ovulationStatus,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
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

  Widget _buildSymptomInsights(BuildContext context, _InsightsHubState state, bool isDark) {
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
          Text(
            'Your Top Symptoms',
            style: AppTypography.light.labelMedium?.copyWith(
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...state.topSymptoms.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _ImpactfulSymptomCard(symptom: s, isDark: isDark),
          )),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
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

  Widget _buildCycleInsights(BuildContext context, _InsightsHubState state, bool isDark) {
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
                  value: state.regularityStatus,
                  icon: Icons.check_circle_outlined,
                  accentColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: HealthStatCard(
                  label: 'Trend',
                  value: state.cycleTrend,
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
                MaterialPageRoute(
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

  Widget _buildPersonalizedTips(BuildContext context, _InsightsHubState state, bool isDark, WidgetRef ref) {
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
        ...state.tips.map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _TipCard(tip: tip, isDark: isDark),
        )),
        AppButton.ghost(
          'View all tips',
          icon: Icons.arrow_forward,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HealthTipsScreen()),
          ),
          height: 40,
        ),
      ],
    );
  }

  Widget _buildAskCyra(BuildContext context, _InsightsHubState state, bool isDark, WidgetRef ref) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.chat_rounded, size: 18, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Ask Cyra',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ask a question about your cycle',
            style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.md),
          ...state.exampleQuestions.map((q) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref.read(_insightsHubProvider.notifier).onAskCyra(q),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, size: 16, color: AppColors.slate),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          q,
                          style: AppTypography.light.bodySmall?.copyWith(
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
          if (state.askCyraResponse.isNotEmpty) ...[
            const Divider(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.smart_toy_outlined, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Cyra',
                        style: AppTypography.light.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    state.askCyraResponse,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'This is not medical advice. Consult your healthcare provider for personal medical concerns.',
                    style: AppTypography.light.labelSmall?.copyWith(
                      color: AppColors.slate,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
  final _ImpactfulSymptom symptom;
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
                symptom.name,
                style: AppTypography.light.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              const Spacer(),
              _SeverityBadge(severity: symptom.severity),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${symptom.frequency} times this cycle \u00b7 Severity ${symptom.severity.toStringAsFixed(1)}',
            style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.repeat_rounded, size: 14, color: AppColors.sage),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Correlates with: ${symptom.phaseCorrelation}',
                style: AppTypography.light.labelSmall?.copyWith(color: AppColors.sage),
              ),
            ],
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

class _TipCard extends StatelessWidget {
  final _HealthTip tip;
  final bool isDark;

  const _TipCard({required this.tip, required this.isDark});

  IconData _categoryIcon() {
    switch (tip.category) {
      case _TipCategory.nutrition:
        return Icons.restaurant_outlined;
      case _TipCategory.exercise:
        return Icons.fitness_center_outlined;
      case _TipCategory.sleep:
        return Icons.bedtime_outlined;
      case _TipCategory.stress:
        return Icons.self_improvement_outlined;
      case _TipCategory.symptomManagement:
        return Icons.healing_outlined;
    }
  }

  Color _categoryColor() {
    switch (tip.category) {
      case _TipCategory.nutrition:
        return AppColors.forestGreen;
      case _TipCategory.exercise:
        return AppColors.sage;
      case _TipCategory.sleep:
        return const Color(0xFF5B6ABF);
      case _TipCategory.stress:
        return AppColors.softGold;
      case _TipCategory.symptomManagement:
        return const Color(0xFFE86B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _categoryColor().withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(_categoryIcon(), size: 20, color: _categoryColor()),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.tip,
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    CyclePhaseIndicator(
                      phase: CyclePhase.luteal,
                      size: CyclePhaseIndicatorSize.small,
                      showLabel: false,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      tip.phase,
                      style: AppTypography.light.labelSmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
