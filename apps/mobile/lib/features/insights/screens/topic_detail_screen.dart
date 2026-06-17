import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/features/insights/providers/insight_providers.dart';

final Map<String, InsightTopic> _topicMap = {
  'prediction': InsightTopic.periodPrediction,
  'ovulation': InsightTopic.ovulationDetection,
  'symptoms': InsightTopic.symptomCorrelation,
  'cycle_regularity': InsightTopic.cycleRegularity,
  'fertility': InsightTopic.fertilityWindow,
  'conception': InsightTopic.conceptionTips,
  'pregnancy': InsightTopic.pregnancyMilestone,
};

final Map<String, _TopicMeta> _topicMeta = {
  'prediction': _TopicMeta('Period Prediction', Icons.water_drop_rounded, AppColors.forestGreen),
  'ovulation': _TopicMeta('Ovulation Insights', Icons.circle_outlined, AppColors.softGold),
  'symptoms': _TopicMeta('Symptom Patterns', Icons.healing_outlined, AppColors.sage),
  'cycle_regularity': _TopicMeta('Cycle Regularity', Icons.repeat_rounded, AppColors.forestGreenLight),
  'fertility': _TopicMeta('Fertility Insights', Icons.schedule_rounded, AppColors.softGoldLight),
  'conception': _TopicMeta('Conception Tips', Icons.favorite_outlined, AppColors.forestGreen),
  'pregnancy': _TopicMeta('Pregnancy Milestones', Icons.child_care_outlined, AppColors.sage),
};

class _TopicMeta {
  final String title;
  final IconData icon;
  final Color color;
  const _TopicMeta(this.title, this.icon, this.color);
}

class TopicDetailScreen extends ConsumerWidget {
  final String topic;

  const TopicDetailScreen({super.key, required this.topic});

  InsightTopic? get _insightTopic => _topicMap[topic];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightTopic = _insightTopic;
    if (insightTopic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Insight Details')),
        body: const Center(child: Text('Topic not found')),
      );
    }

    final insightAsync = ref.watch(topicInsightProvider(insightTopic));
    final meta = _topicMeta[topic]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          meta.title,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: insightAsync.when(
        data: (TopicInsight insight) => _buildInsightContent(context, insight, meta, isDark),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace? _) => Center(child: Text('Failed to load: $e')),
      ),
    );
  }

  Widget _buildInsightContent(
    BuildContext context,
    TopicInsight insight,
    _TopicMeta meta,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl),
      children: [
        _buildTopicHeader(context, meta, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildSummaryCard(context, insight.summary, isDark),
        const SizedBox(height: AppSpacing.lg),
        if (insight.confidence > 0)
          _buildConfidenceCard(context, insight.confidence, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildDetailedExplanation(context, insight.detailedExplanation, isDark),
        const SizedBox(height: AppSpacing.lg),
        if (insight.relatedTopics != null && insight.relatedTopics!.isNotEmpty)
          _buildRelatedTopics(context, insight.relatedTopics!, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildSources(context),
        const SizedBox(height: AppSpacing.lg),
        _buildDisclaimerBanner(context),
      ],
    );
  }

  Widget _buildTopicHeader(BuildContext context, _TopicMeta meta, bool isDark) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: meta.color.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(meta.icon, size: 24, color: meta.color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meta.title,
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

  Widget _buildSummaryCard(BuildContext context, String summary, bool isDark) {
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

  Widget _buildConfidenceCard(BuildContext context, double confidence, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confidence',
                  style: AppTypography.light.labelMedium?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ConfidenceBadge(confidence: confidence, size: ConfidenceBadgeSize.large),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedExplanation(BuildContext context, String explanation, bool isDark) {
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

  Widget _buildRelatedTopics(BuildContext context, List<String> related, bool isDark) {
    final relatedMeta = related
        .map((name) => _topicMap.entries.firstWhere(
              (e) => e.value.name == name,
              orElse: () => const MapEntry('', InsightTopic.periodPrediction),
            ))
        .where((e) => e.key.isNotEmpty)
        .toList();

    if (relatedMeta.isEmpty) return const SizedBox.shrink();

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
        ...relatedMeta.map((entry) {
          final meta = _topicMeta[entry.key]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => TopicDetailScreen(topic: entry.key),
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
                      Icon(meta.icon, size: 18, color: AppColors.sage),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        meta.title,
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
          );
        }),
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
            child: RichText(
              text: TextSpan(
                style: AppTypography.light.labelSmall?.copyWith(color: AppColors.slate, height: 1.4),
                children: [
                  const TextSpan(text: 'Based on your logged data and medical guidelines from the '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://www.acog.org'), mode: LaunchMode.externalApplication),
                      child: Text(
                        'American College of Obstetricians and Gynecologists (ACOG)',
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          decoration: TextDecoration.underline,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' and the '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://www.who.int'), mode: LaunchMode.externalApplication),
                      child: Text(
                        'World Health Organization (WHO)',
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          decoration: TextDecoration.underline,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
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
