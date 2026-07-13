import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';

enum _TimeRange { thisCycle, last3Months }

class FertilityChartScreen extends ConsumerWidget {
  const FertilityChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleAsync = ref.watch(activeCycleProvider);
    final ovulationAsync = ref.watch(ovulationDetectionProvider);

    return cycleAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => Scaffold(
        body: Center(
          child: Text(
            'No cycle data available',
            style: TextStyle(color: AppColors.slate),
          ),
        ),
      ),
      data: (activeCycle) {
        if (activeCycle == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Start logging your cycle first',
                style: TextStyle(color: AppColors.slate),
              ),
            ),
          );
        }

        return _FertilityChartBody(
          cycleId: activeCycle.id,
          ovulation: ovulationAsync.valueOrNull,
          isDark: isDark,
        );
      },
    );
  }
}

class _FertilityChartBody extends ConsumerStatefulWidget {
  final String cycleId;
  final OvulationResult? ovulation;
  final bool isDark;

  const _FertilityChartBody({
    required this.cycleId,
    required this.ovulation,
    required this.isDark,
  });

  @override
  ConsumerState<_FertilityChartBody> createState() =>
      _FertilityChartBodyState();
}

class _FertilityChartBodyState extends ConsumerState<_FertilityChartBody> {
  _TimeRange _selectedRange = _TimeRange.thisCycle;

  @override
  Widget build(BuildContext context) {
    final bbtAsync = ref.watch(bbtForCycleProvider(widget.cycleId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fertility Chart',
          style: TextStyle(
            color: widget.isDark
                ? AppColors.textPrimaryDark
                : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: bbtAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Failed to load chart data',
            style: TextStyle(color: AppColors.slate),
          ),
        ),
        data: (bbtRecords) {
          if (bbtRecords.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    size: 48,
                    color: AppColors.slate.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No BBT data yet',
                    style: TextStyle(color: AppColors.slate),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Start logging your temperature',
                    style: TextStyle(color: AppColors.slate, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          final bbtData = bbtRecords
              .map(
                (r) => BBTDataPoint(date: r.date, temperature: r.temperature),
              )
              .toList();

          return Column(
            children: [
              _buildTimeRangeSelector(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    AppCard.chart(
                      title: 'Basal Body Temperature',
                      child: BBTChart(
                        dataPoints: bbtData,
                        height: 280,
                        coverLineTemperature: null,
                        ovulationDate:
                            widget.ovulation?.confirmedOvulationDate ??
                            widget.ovulation?.estimatedOvulationDate,
                        showLegend: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildLegend(context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildStats(context, bbtData, widget.ovulation),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: _TimeRange.values.map((range) {
          final isSelected = _selectedRange == range;
          final label = range == _TimeRange.thisCycle
              ? 'This Cycle'
              : 'Last 3 Months';
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.forestGreen.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.forestGreen
                        : (widget.isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? AppColors.forestGreen : AppColors.slate,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(context, Icons.circle, AppColors.forestGreen, 'BBT'),
          _legendItem(context, Icons.circle, AppColors.softGold, 'OPK+'),
          _legendItem(context, Icons.circle, AppColors.sage, 'Mucus'),
          _legendItem(
            context,
            Icons.circle,
            AppColors.period,
            'Coverline',
          ),
        ],
      ),
    );
  }

  Widget _legendItem(
    BuildContext context,
    IconData icon,
    Color color,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.slate),
        ),
      ],
    );
  }

  Widget _buildStats(
    BuildContext context,
    List<BBTDataPoint> bbtData,
    OvulationResult? ovulation,
  ) {
    if (bbtData.isEmpty) return const SizedBox.shrink();

    final temps = bbtData.map((d) => d.temperature).toList();
    final avg = temps.reduce((a, b) => a + b) / temps.length;
    final low = temps.reduce((a, b) => a < b ? a : b);
    final high = temps.reduce((a, b) => a > b ? a : b);

    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _statItem(context, 'Average', '${avg.toStringAsFixed(1)}°C'),
              _statItem(context, 'Low', '${low.toStringAsFixed(1)}°C'),
              _statItem(context, 'High', '${high.toStringAsFixed(1)}°C'),
              _statItem(context, 'Readings', '${bbtData.length}'),
            ],
          ),
          if (ovulation?.isConfirmed == true) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: AppColors.forestGreen,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Ovulation confirmed (${(ovulation!.confidence * 100).toStringAsFixed(0)}% confidence)',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.forestGreen),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}
