import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/health_timeline.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';
import 'package:cyra/core/design/widgets/symptom_bar_chart.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart';

final _cycleDetailProvider = ChangeNotifierProvider.family<_CycleDetailState, int>((ref, cycleId) {
  return _CycleDetailState(cycleId);
});

class _CycleDetailState extends ChangeNotifier {
  final int cycleId;
  bool isLoading = true;

  int cycleNumber = 3;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 42));
  DateTime endDate = DateTime.now().subtract(const Duration(days: 14));
  int cycleLength = 28;
  int periodLength = 5;
  double averageFlowIntensity = 2.3;
  int symptomCount = 7;
  String notes = 'This cycle had some notable PMS symptoms in the luteal phase. Mood swings were more pronounced than usual.';

  List<BBTDataPoint> bbtData = [];
  List<SymptomBarData> symptomData = [];
  List<TimelineEntry> timelineEntries = [];
  List<_JournalEntry> journalEntries = [];

  _CycleDetailState(this.cycleId) {
    _loadData();
  }

  void _loadData() {
    bbtData = [
      BBTDataPoint(date: DateTime(2026, 3, 1), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 3, 2), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 3, 3), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 3, 4), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 3, 5), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 3, 6), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 3, 7), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 3, 8), temperature: 36.6),
      BBTDataPoint(date: DateTime(2026, 3, 9), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 3, 10), temperature: 36.7),
      BBTDataPoint(date: DateTime(2026, 3, 11), temperature: 36.8),
      BBTDataPoint(date: DateTime(2026, 3, 12), temperature: 36.9),
      BBTDataPoint(date: DateTime(2026, 3, 13), temperature: 36.8),
      BBTDataPoint(date: DateTime(2026, 3, 14), temperature: 36.7),
    ];

    symptomData = [
      const SymptomBarData(label: 'Cramps', value: 8, color: Color(0xFFE57373)),
      const SymptomBarData(label: 'Fatigue', value: 6, color: Color(0xFF9575CD)),
      const SymptomBarData(label: 'Bloating', value: 5, color: Color(0xFFBA68C8)),
      const SymptomBarData(label: 'Headache', value: 4, color: Color(0xFFF06292)),
      const SymptomBarData(label: 'Mood Swings', value: 7, color: Color(0xFF4FC3F7)),
      const SymptomBarData(label: 'Back Pain', value: 3, color: Color(0xFFE57373)),
    ];

    timelineEntries = [
      TimelineEntry(
        date: startDate,
        title: 'Period started',
        description: 'Medium flow',
        type: TimelineEntryType.period,
      ),
      TimelineEntry(
        date: startDate.add(const Duration(days: 2)),
        title: 'Cramps logged',
        description: 'Moderate severity',
        type: TimelineEntryType.symptom,
      ),
      TimelineEntry(
        date: startDate.add(const Duration(days: 5)),
        title: 'Period ended',
        description: '5 days total',
        type: TimelineEntryType.period,
      ),
      TimelineEntry(
        date: startDate.add(const Duration(days: 14)),
        title: 'Ovulation detected',
        description: 'Day 14',
        type: TimelineEntryType.ovulation,
      ),
      TimelineEntry(
        date: startDate.add(const Duration(days: 20)),
        title: 'Mood Swings',
        description: 'Increased irritability',
        type: TimelineEntryType.symptom,
      ),
    ];

    journalEntries = [
      _JournalEntry(
        date: startDate,
        text: 'Cycle started today. Cramps are moderate, used heating pad.',
      ),
      _JournalEntry(
        date: startDate.add(const Duration(days: 7)),
        text: 'Feeling more energetic today. Went for a 30min walk.',
      ),
      _JournalEntry(
        date: startDate.add(const Duration(days: 14)),
        text: 'Noticed EWCM today. Possible ovulation.',
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}

class _JournalEntry {
  final DateTime date;
  final String text;

  const _JournalEntry({required this.date, required this.text});
}

class CycleDetailScreen extends ConsumerWidget {
  final int cycleId;

  const CycleDetailScreen({super.key, required this.cycleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_cycleDetailProvider(cycleId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cycle Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cycle ${state.cycleNumber}'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildHeader(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildStatsGrid(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          if (state.bbtData.isNotEmpty)
            AppCard.chart(
              title: 'Basal Body Temperature',
              child: BBTChart(
                dataPoints: state.bbtData,
                height: 200,
                showLegend: true,
              ),
            ),
          if (state.bbtData.isNotEmpty) const SizedBox(height: AppSpacing.lg),
          if (state.symptomData.isNotEmpty)
            AppCard.chart(
              title: 'Most Common Symptoms',
              child: SizedBox(
                height: 220,
                child: SymptomBarChart(
                  symptoms: state.symptomData,
                  maxBars: 8,
                  showValues: true,
                ),
              ),
            ),
          if (state.symptomData.isNotEmpty) const SizedBox(height: AppSpacing.lg),
          AppCard.standard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            title: 'Timeline',
            child: HealthTimeline(
              entries: state.timelineEntries,
              dotRadius: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.journalEntries.isNotEmpty)
            _buildJournalSection(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _CycleDetailState state, bool isDark) {
    final format = DateFormat('MMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle ${state.cycleNumber}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${format.format(state.startDate)} – ${format.format(state.endDate)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
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
            '${state.cycleLength} days',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, _CycleDetailState state, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: HealthStatCard(
            label: 'Period Length',
            value: '${state.periodLength} days',
            icon: Icons.water_drop_rounded,
            accentColor: const Color(0xFFE86B6B),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: HealthStatCard(
            label: 'Cycle Length',
            value: '${state.cycleLength} days',
            icon: Icons.repeat_rounded,
            accentColor: AppColors.forestGreen,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: HealthStatCard(
            label: 'Avg Flow',
            value: state.averageFlowIntensity.toStringAsFixed(1),
            icon: Icons.speed_rounded,
            accentColor: AppColors.sage,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: HealthStatCard(
            label: 'Symptoms',
            value: '${state.symptomCount}',
            icon: Icons.healing_outlined,
            accentColor: AppColors.softGold,
          ),
        ),
      ],
    );
  }

  Widget _buildJournalSection(BuildContext context, _CycleDetailState state, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      title: 'Journal Entries',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: state.journalEntries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(entry.date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM d').format(entry.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.slate,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        entry.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
