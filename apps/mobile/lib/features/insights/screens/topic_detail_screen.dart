import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/design/widgets/cycle_overview_chart.dart';
import 'package:cyra/core/design/widgets/symptom_bar_chart.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/utils/extensions.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _topicTitle(),
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textPrimaryDark
                : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
            tooltip: 'Share insight',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          _buildTopicHeader(context),
          const SizedBox(height: AppSpacing.lg),
          _buildSummaryCard(context),
          const SizedBox(height: AppSpacing.lg),
          _buildDataSection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildDetailedExplanation(context),
          const SizedBox(height: AppSpacing.lg),
          _buildPersonalizedSection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildRelatedTopics(context),
          const SizedBox(height: AppSpacing.lg),
          _buildSources(context),
          const SizedBox(height: AppSpacing.lg),
          _buildDisclaimerBanner(context),
        ],
      ),
    );
  }

  String _topicTitle() {
    switch (topic) {
      case 'prediction':
        return 'Period Prediction';
      case 'ovulation':
        return 'Ovulation Insights';
      case 'symptoms':
        return 'Symptom Patterns';
      case 'cycle_regularity':
        return 'Cycle Regularity';
      case 'fertility':
        return 'Fertility Insights';
      default:
        return 'Insight Details';
    }
  }

  IconData _topicIcon() {
    switch (topic) {
      case 'prediction':
        return Icons.water_drop_rounded;
      case 'ovulation':
        return Icons.circle_outlined;
      case 'symptoms':
        return Icons.healing_outlined;
      case 'cycle_regularity':
        return Icons.repeat_rounded;
      case 'fertility':
        return Icons.schedule_rounded;
      default:
        return Icons.auto_awesome;
    }
  }

  Color _topicColor() {
    switch (topic) {
      case 'prediction':
        return AppColors.forestGreen;
      case 'ovulation':
        return AppColors.softGold;
      case 'symptoms':
        return AppColors.sage;
      case 'cycle_regularity':
        return AppColors.forestGreenLight;
      case 'fertility':
        return AppColors.softGoldLight;
      default:
        return AppColors.forestGreen;
    }
  }

  Widget _buildTopicHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _topicColor();

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(_topicIcon(), size: 24, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _topicTitle(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Based on your logged data',
                style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String summary;
    switch (topic) {
      case 'prediction':
        summary = 'Your next period is predicted to start in about 6 days, based on your average 28-day cycle. '
            'Your cycles are regular with low variability.';
      case 'ovulation':
        summary = 'Ovulation is estimated around day 14 of your cycle. Your BBT chart shows a sustained '
            'temperature rise confirming ovulation occurred.';
      case 'symptoms':
        summary = 'Your most frequently reported symptoms correlate strongly with specific cycle phases. '
            'Bloating and fatigue peak in the luteal phase, while cramps occur during menstruation.';
      case 'cycle_regularity':
        summary = 'Your cycle length averages 28 days with minimal variation of 1-3 days. '
            'This is considered a regular cycle pattern.';
      case 'fertility':
        summary = 'Your fertile window spans approximately days 8-19 of your cycle, with peak fertility '
            'around ovulation on day 14.';
      default:
        summary = 'Based on your tracked data, patterns are emerging that can help you understand your cycle better.';
    }

    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            summary,
            style: AppTypography.light.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (topic) {
      case 'prediction':
        return _buildPredictionData(context, isDark);
      case 'ovulation':
        return _buildOvulationData(context, isDark);
      case 'symptoms':
        return _buildSymptomData(context, isDark);
      case 'cycle_regularity':
        return _buildCycleRegularityData(context, isDark);
      case 'fertility':
        return _buildFertilityData(context, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPredictionData(BuildContext context, bool isDark) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final predicted = DateTime.now().add(const Duration(days: 6));
    final rangeStart = DateTime.now().add(const Duration(days: 4));
    final rangeEnd = DateTime.now().add(const Duration(days: 8));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop_rounded, size: 20, color: AppColors.forestGreen),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Next Period Prediction',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Column(
                  children: [
                    Text(
                      'In ${DateTime.now().daysUntil(predicted)} days',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${dateFormat.format(rangeStart)} \u2013 ${dateFormat.format(rangeEnd)}',
                      style: AppTypography.light.bodyMedium?.copyWith(color: AppColors.slate),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ConfidenceBadge(confidence: 0.88, size: ConfidenceBadgeSize.large),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard.chart(
          title: 'Confidence Breakdown',
          child: Column(
            children: [
              _ConfidenceBar(label: 'Cycle regularity', value: 0.92, color: AppColors.forestGreen),
              const SizedBox(height: AppSpacing.sm),
              _ConfidenceBar(label: 'Data completeness', value: 0.85, color: AppColors.sage),
              const SizedBox(height: AppSpacing.sm),
              _ConfidenceBar(label: 'Historical accuracy', value: 0.78, color: AppColors.softGold),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOvulationData(BuildContext context, bool isDark) {
    final bbtData = [
      BBTDataPoint(date: DateTime(2026, 6, 1), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 6, 2), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 6, 3), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 6, 4), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 6, 5), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 6, 6), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 6, 7), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 6, 8), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 6, 9), temperature: 36.6),
      BBTDataPoint(date: DateTime(2026, 6, 10), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 6, 11), temperature: 36.7),
      BBTDataPoint(date: DateTime(2026, 6, 12), temperature: 36.9),
      BBTDataPoint(date: DateTime(2026, 6, 13), temperature: 36.8),
      BBTDataPoint(date: DateTime(2026, 6, 14), temperature: 36.9),
      BBTDataPoint(date: DateTime(2026, 6, 15), temperature: 36.8),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature Chart',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        BBTChart(
          dataPoints: bbtData,
          height: 200,
          showLegend: true,
          coverLineTemperature: 36.6,
          ovulationDate: DateTime(2026, 6, 12),
        ),
      ],
    );
  }

  Widget _buildSymptomData(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptom Frequency',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 260,
          child: SymptomBarChart(
            symptoms: [
              const SymptomBarData(label: 'Bloating', value: 12, color: AppColors.sage),
              const SymptomBarData(label: 'Fatigue', value: 10, color: AppColors.softGold),
              const SymptomBarData(label: 'Cramps', value: 8, color: AppColors.error),
              const SymptomBarData(label: 'Headache', value: 6, color: AppColors.forestGreenLight),
              const SymptomBarData(label: 'Nausea', value: 4, color: AppColors.slate),
            ],
            maxBars: 5,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phase Correlation Details',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _CorrelationRow(
                phase: CyclePhase.luteal,
                symptom: 'Bloating, Fatigue',
                intensity: 'High',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _CorrelationRow(
                phase: CyclePhase.menstrual,
                symptom: 'Cramps, Headache',
                intensity: 'Moderate',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
              _CorrelationRow(
                phase: CyclePhase.follicular,
                symptom: 'Minimal symptoms',
                intensity: 'Low',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCycleRegularityData(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Average Length',
                value: '28 days',
                icon: Icons.repeat_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: HealthStatCard(
                label: 'Variability',
                value: 'Low',
                icon: Icons.trending_flat_rounded,
                accentColor: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard.chart(
          title: 'Cycle History',
          child: SizedBox(
            height: 200,
            child: CycleOverviewChart(
              cycleHistory: [
                const CycleLengthData(cycleNumber: 1, lengthDays: 27),
                const CycleLengthData(cycleNumber: 2, lengthDays: 29),
                const CycleLengthData(cycleNumber: 3, lengthDays: 28),
                const CycleLengthData(cycleNumber: 4, lengthDays: 28),
                const CycleLengthData(cycleNumber: 5, lengthDays: 27),
                const CycleLengthData(cycleNumber: 6, lengthDays: 29),
              ],
              showAverageLine: true,
              height: 180,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFertilityData(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 20, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Fertile Window',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _FertilityStat(label: 'Window Opens', value: 'Day 8', isDark: isDark),
              const SizedBox(width: AppSpacing.sm),
              _FertilityStat(label: 'Ovulation', value: 'Day 14', isDark: isDark),
              const SizedBox(width: AppSpacing.sm),
              _FertilityStat(label: 'Window Closes', value: 'Day 19', isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedExplanation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String explanation;
    switch (topic) {
      case 'prediction':
        explanation = 'Period prediction uses your historical cycle data to estimate when your next period will start. '
            'The algorithm analyzes the length of your previous cycles, identifies patterns, and calculates a predicted date '
            'with a confidence range. Factors that influence prediction accuracy include cycle regularity, the number of '
            'cycles tracked, and how consistently you log your period start dates.\n\n'
            'For most people with regular cycles (varying by less than 7 days), predictions become increasingly accurate '
            'after tracking 3-6 cycles. Your current cycle data shows low variability, which supports reliable predictions.';
      case 'ovulation':
        explanation = 'Ovulation typically occurs around day 14 of a 28-day cycle, but can vary significantly between '
            'individuals and from cycle to cycle. Ovulation is confirmed through a sustained rise in basal body temperature '
            '(BBT) of at least 0.2\u00B0C for three consecutive days following the temperature dip.\n\n'
            'Your logged BBT data shows a clear thermal shift, indicating that ovulation has occurred. The fertile window '
            'spans approximately 6 days: the 5 days before ovulation and the day of ovulation itself.';
      case 'symptoms':
        explanation = 'Symptom patterns across the menstrual cycle are influenced by fluctuating hormone levels. '
            'Estrogen dominates the follicular phase, peaking just before ovulation, while progesterone rises after '
            'ovulation during the luteal phase.\n\n'
            'Your data shows that bloating and fatigue peak during the luteal phase when progesterone levels are highest. '
            'Cramps correlate strongly with the menstrual phase, when prostaglandins cause uterine contractions. '
            'Tracking these patterns can help you anticipate and manage symptoms proactively.';
      case 'cycle_regularity':
        explanation = 'Cycle regularity is determined by the variation in length between your cycles. A regular cycle '
            'varies by less than 7 days from cycle to cycle. Your cycles show variation of 1-3 days, which falls within '
            'the normal range for regular cycles.\n\n'
            'Factors that can affect cycle regularity include stress, changes in sleep patterns, significant weight changes, '
            'travel, illness, and hormonal contraceptives. Tracking consistently helps distinguish between normal variation '
            'and changes that may warrant medical attention.';
      case 'fertility':
        explanation = 'The fertile window is the period during which intercourse can result in pregnancy. Sperm can survive '
            'in the reproductive tract for up to 5 days, while an egg remains viable for approximately 12-24 hours after '
            'ovulation. This means the fertile window begins 5 days before ovulation and ends on the day of ovulation.\n\n'
            'For your 28-day cycle, the fertile window spans days 8-19, with peak fertility around day 14. '
            'Tracking additional fertility signs such as cervical mucus changes, cervical position, and BBT can help '
            'identify your fertile window with greater precision.';
      default:
        explanation = 'Understanding your menstrual cycle patterns empowers you to make informed decisions about your health. '
            'Regular tracking helps identify what is normal for your body and recognize when something changes.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.article_outlined, size: 20, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Detailed Explanation',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          explanation,
          style: AppTypography.light.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalizedSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String personalization;
    switch (topic) {
      case 'prediction':
        personalization = 'Based on your 6 cycles averaging 28 days, your next period is predicted within a '
            '4-day window. Your low variability (1-3 days) means you can expect reliable predictions going forward.';
      case 'ovulation':
        personalization = 'Your BBT chart confirms ovulation around day 14 with a clear thermal shift. '
            'Your luteal phase length of 14 days is within the normal range of 10-16 days.';
      case 'symptoms':
        personalization = 'Your symptom data shows a clear pattern: bloating and fatigue peak in the luteal phase '
            '(days 19-22), while cramps occur at the start of menstruation (days 1-3). Consider planning '
            'self-care around these phases.';
      case 'cycle_regularity':
        personalization = 'Your cycles have varied by only 1-3 days over the last 6 cycles, indicating excellent '
            'regularity. This low variability supports accurate predictions and suggests stable hormonal patterns.';
      case 'fertility':
        personalization = 'With your regular 28-day cycle, your fertile window is consistently around days 8-19. '
            'Your BBT data and cycle tracking provide reliable fertility awareness information.';
      default:
        personalization = 'Continue tracking to receive more personalized insights about your cycle patterns.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outlined, size: 20, color: AppColors.softGold),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'What This Means for You',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.softGold.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  personalization,
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedTopics(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<_RelatedTopic> related;
    switch (topic) {
      case 'prediction':
        related = [
          _RelatedTopic(topic: 'cycle_regularity', label: 'Cycle Regularity', icon: Icons.repeat_rounded),
          _RelatedTopic(topic: 'ovulation', label: 'Ovulation Insights', icon: Icons.circle_outlined),
        ];
      case 'ovulation':
        related = [
          _RelatedTopic(topic: 'fertility', label: 'Fertility Insights', icon: Icons.schedule_rounded),
          _RelatedTopic(topic: 'symptoms', label: 'Symptom Patterns', icon: Icons.healing_outlined),
        ];
      case 'symptoms':
        related = [
          _RelatedTopic(topic: 'cycle_regularity', label: 'Cycle Regularity', icon: Icons.repeat_rounded),
          _RelatedTopic(topic: 'prediction', label: 'Period Prediction', icon: Icons.water_drop_rounded),
        ];
      case 'cycle_regularity':
        related = [
          _RelatedTopic(topic: 'prediction', label: 'Period Prediction', icon: Icons.water_drop_rounded),
          _RelatedTopic(topic: 'symptoms', label: 'Symptom Patterns', icon: Icons.healing_outlined),
        ];
      case 'fertility':
        related = [
          _RelatedTopic(topic: 'ovulation', label: 'Ovulation Insights', icon: Icons.circle_outlined),
          _RelatedTopic(topic: 'prediction', label: 'Period Prediction', icon: Icons.water_drop_rounded),
        ];
      default:
        related = [];
    }

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link_rounded, size: 20, color: AppColors.sage),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Related Topics',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...related.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => TopicDetailScreen(topic: r.topic),
                ),
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(r.icon, size: 18, color: AppColors.sage),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      r.label,
                      style: AppTypography.light.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, size: 18, color: AppColors.slate),
                  ],
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSources(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.source_outlined, size: 16, color: AppColors.slate),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Based on your logged data and medical guidelines from the American College of Obstetricians '
              'and Gynecologists (ACOG) and the World Health Organization (WHO).',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.slate,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outlined, size: 18, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This information is for educational purposes only and is based on pattern recognition from '
              'your logged data. It does not constitute medical advice. Always consult a qualified healthcare '
              'provider for personal medical concerns, diagnoses, or treatment decisions.',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.charcoal,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ConfidenceBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate)),
            Text(
              '${(value * 100).round()}%',
              style: AppTypography.light.bodySmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.borderLight,
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _CorrelationRow extends StatelessWidget {
  final CyclePhase phase;
  final String symptom;
  final String intensity;
  final bool isDark;

  const _CorrelationRow({
    required this.phase,
    required this.symptom,
    required this.intensity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CyclePhaseIndicator(phase: phase, showLabel: true, size: CyclePhaseIndicatorSize.small),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            symptom,
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: intensity == 'High'
                ? AppColors.sage
                : intensity == 'Moderate'
                    ? AppColors.softGold
                    : AppColors.slate,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Text(
            intensity,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _FertilityStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _FertilityStat({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.softGold.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.softGold,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: AppTypography.light.labelSmall?.copyWith(color: AppColors.slate),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedTopic {
  final String topic;
  final String label;
  final IconData icon;
  const _RelatedTopic({
    required this.topic,
    required this.label,
    required this.icon,
  });
}
