import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/design/widgets/health_timeline.dart';
import 'package:cyra/core/design/widgets/symptom_bar_chart.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/journal/models/journal_models.dart';
import 'package:cyra/features/journal/providers/journal_providers.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _cycleDetailProvider = FutureProvider.autoDispose
    .family<_CycleDetailData, String>((ref, cycleId) async {
      final cycles = await ref.watch(allCyclesProvider.future);
      final cycle = cycles.where((item) => item.id == cycleId).firstOrNull;
      if (cycle == null) throw StateError('Cycle not found');
      final end = cycle.endDate ?? DateTime.now();
      final results = await Future.wait<Object>([
        ref.watch(cycleDaysProvider(cycleId).future),
        ref.watch(bbtForCycleProvider(cycleId).future),
        ref.watch(symptomsInRangeProvider(cycle.startDate, end).future),
        ref.watch(
          journalEntriesByDateRangeProvider(cycle.startDate, end).future,
        ),
      ]);
      return _CycleDetailData(
        cycle: cycle,
        days: results[0] as List<CycleDay>,
        bbt: results[1] as List<BBTRecord>,
        symptoms: results[2] as List<SymptomEntry>,
        journals: results[3] as List<JournalEntry>,
        cycleNumber: cycles.length - cycles.indexOf(cycle),
      );
    });

class _CycleDetailData {
  const _CycleDetailData({
    required this.cycle,
    required this.days,
    required this.bbt,
    required this.symptoms,
    required this.journals,
    required this.cycleNumber,
  });
  final Cycle cycle;
  final List<CycleDay> days;
  final List<BBTRecord> bbt;
  final List<SymptomEntry> symptoms;
  final List<JournalEntry> journals;
  final int cycleNumber;
}

class CycleDetailScreen extends ConsumerWidget {
  const CycleDetailScreen({super.key, required this.cycleId});
  final String cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(_cycleDetailProvider(cycleId));
    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Detail')),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(_cycleDetailProvider(cycleId)),
            child: const Text('Could not load cycle. Try again'),
          ),
        ),
        data: (data) => _DetailBody(data: data),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.data});
  final _CycleDetailData data;

  @override
  Widget build(BuildContext context) {
    final cycle = data.cycle;
    final end =
        cycle.endDate ??
        cycle.startDate.add(Duration(days: cycle.cycleLength - 1));
    final flowDays = data.days.where((day) => day.flowIntensity > 0).toList();
    final averageFlow = flowDays.isEmpty
        ? 0.0
        : flowDays.map((day) => day.flowIntensity).reduce((a, b) => a + b) /
              flowDays.length;
    final symptomCounts = <String, int>{};
    for (final symptom in data.symptoms) {
      symptomCounts.update(
        symptom.symptomName,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final symptomBars = symptomCounts.entries
        .map(
          (entry) => SymptomBarData(
            label: entry.key,
            value: entry.value.toDouble(),
            color: AppColors.sage,
          ),
        )
        .toList();
    final timeline = <TimelineEntry>[
      TimelineEntry(
        date: cycle.startDate,
        title: 'Period started',
        description: '${flowDays.length} logged flow days',
        type: TimelineEntryType.period,
      ),
      for (final symptom in data.symptoms)
        TimelineEntry(
          date: symptom.date,
          title: symptom.symptomName,
          description: 'Severity ${symptom.severity}',
          type: TimelineEntryType.symptom,
        ),
    ]..sort((a, b) => a.date.compareTo(b.date));
    final bbtPoints = data.bbt
        .map(
          (record) =>
              BBTDataPoint(date: record.date, temperature: record.temperature),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Cycle ${data.cycleNumber}',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${DateFormat.yMMMd().format(cycle.startDate)} – ${DateFormat.yMMMd().format(end)}',
          style: TextStyle(color: AppColors.slate),
        ),
        if (cycle.notes?.isNotEmpty ?? false) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(cycle.notes!),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Period',
                value: '${cycle.periodLength} days',
                icon: Icons.sync_rounded,
                accentColor: AppColors.error,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Cycle',
                value: '${cycle.cycleLength} days',
                icon: Icons.repeat_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Avg Flow',
                value: averageFlow.toStringAsFixed(1),
                icon: Icons.speed_rounded,
                accentColor: AppColors.sage,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Body notes',
                value: '${data.symptoms.length}',
                icon: Icons.healing_outlined,
                accentColor: AppColors.softGold,
              ),
            ),
          ],
        ),
        if (bbtPoints.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard.chart(
            title: 'Basal Body Temperature',
            child: BBTChart(
              dataPoints: bbtPoints,
              height: 200,
              showLegend: true,
            ),
          ),
        ],
        if (symptomBars.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard.chart(
            title: 'Most Common Symptoms',
            child: SizedBox(
              height: 220,
              child: SymptomBarChart(
                symptoms: symptomBars,
                maxBars: 8,
                showValues: true,
              ),
            ),
          ),
        ],
        if (timeline.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard.standard(
            title: 'Timeline',
            child: HealthTimeline(entries: timeline),
          ),
        ],
        if (data.journals.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard.standard(
            title: 'Journal Entries',
            child: Column(
              children: [
                for (final entry in data.journals)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      entry.title ?? DateFormat.yMMMd().format(entry.date),
                    ),
                    subtitle: Text(entry.content ?? ''),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
