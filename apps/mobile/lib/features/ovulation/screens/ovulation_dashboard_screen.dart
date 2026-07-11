import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';
import 'package:cyra/core/design/widgets/fertility_widget.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/models/cycle.dart' hide CyclePhase;
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';
import 'package:cyra/features/ovulation/screens/log_bbt_screen.dart';
import 'package:cyra/features/ovulation/screens/log_opk_screen.dart';
import 'package:cyra/features/ovulation/screens/log_mucus_screen.dart';
import 'package:cyra/features/ovulation/screens/fertility_chart_screen.dart';
import 'package:cyra/features/ovulation/screens/ovulation_calendar_screen.dart';

class OvulationDashboardScreen extends ConsumerWidget {
  const OvulationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleAsync = ref.watch(activeCycleProvider);
    final fertileWindowAsync = ref.watch(fertileWindowProvider);
    final ovulationAsync = ref.watch(ovulationDetectionProvider);

    return cycleAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => Scaffold(
        body: Center(
          child: _buildEmptyState(
            context,
            isDark,
            'Start logging your cycle first',
          ),
        ),
      ),
      data: (activeCycle) {
        if (activeCycle == null) {
          return Scaffold(
            body: Center(
              child: _buildEmptyState(
                context,
                isDark,
                'Start logging your cycle first',
              ),
            ),
          );
        }

        final cycleDay =
            DateTime.now().difference(activeCycle.startDate).inDays + 1;
        final fertileWindow = fertileWindowAsync.valueOrNull;
        final ovulation = ovulationAsync.valueOrNull;

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxxxl,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildFertileWindowCard(
                context,
                activeCycle.startDate,
                activeCycle.cycleLength,
                cycleDay,
                fertileWindow,
                isDark,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildBBTSection(context, ref, activeCycle, ovulation, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildOPKSection(context, ref, activeCycle, ovulation, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildCervicalMucusSection(
                context,
                ref,
                activeCycle,
                ovulation,
                isDark,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildOvulationStatusCard(context, ovulation, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildToolsSection(context, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 40,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ovulation Tracking',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const CyclePhaseIndicator(
          phase: CyclePhase.ovulation,
          size: CyclePhaseIndicatorSize.medium,
        ),
      ],
    );
  }

  Widget _buildFertileWindowCard(
    BuildContext context,
    DateTime lastPeriodStart,
    int cycleLength,
    int cycleDay,
    FertileWindow? fertileWindow,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: FertilityWidget(
        lastPeriodStart: lastPeriodStart,
        ovulationDate: fertileWindow?.ovulationDate,
        cycleLength: cycleLength,
        currentCycleDay: cycleDay,
        compact: false,
      ),
    );
  }

  Widget _buildBBTSection(
    BuildContext context,
    WidgetRef ref,
    Cycle activeCycle,
    OvulationResult? ovulation,
    bool isDark,
  ) {
    final bbtAsync = ref.watch(bbtForCycleProvider(activeCycle.id));

    return AppCard.chart(
      title: 'Basal Body Temperature',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bbtAsync.when(
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => _buildEmptyBBT(context, isDark),
            data: (bbtRecords) {
              if (bbtRecords.isEmpty) return _buildEmptyBBT(context, isDark);

              final bbtData = bbtRecords
                  .map(
                    (r) =>
                        BBTDataPoint(date: r.date, temperature: r.temperature),
                  )
                  .toList();

              return Column(
                children: [
                  BBTChart(
                    dataPoints: bbtData,
                    height: 180,
                    coverLineTemperature: null,
                    ovulationDate:
                        ovulation?.confirmedOvulationDate ??
                        ovulation?.estimatedOvulationDate,
                    showLegend: true,
                  ),
                  if (bbtRecords.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Icon(
                          Icons.device_thermostat_rounded,
                          size: 16,
                          color: AppColors.slate,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Last: ${bbtRecords.last.temperature.toStringAsFixed(1)}°C at ${bbtRecords.last.timeOfDay}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.slate),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.primary(
              'Log Temperature',
              icon: Icons.add_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LogBBTScreen()),
              ),
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBBT(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.device_thermostat_rounded,
            size: 24,
            color: AppColors.slate.withValues(alpha: 0.5),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'No BBT readings logged yet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }

  Widget _buildOPKSection(
    BuildContext context,
    WidgetRef ref,
    Cycle activeCycle,
    OvulationResult? ovulation,
    bool isDark,
  ) {
    final opkAsync = ref.watch(opkForCycleProvider(activeCycle.id));

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'OPK Results',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          opkAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildEmptyOPK(context, isDark),
            data: (opkResults) {
              if (opkResults.isEmpty) return _buildEmptyOPK(context, isDark);
              final latest = opkResults.last;
              final isPositive = latest.result == OPKResult.positive;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color:
                          (isPositive ? AppColors.forestGreen : AppColors.slate)
                              .withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color:
                            (isPositive
                                    ? AppColors.forestGreen
                                    : AppColors.slate)
                                .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.celebration_outlined
                              : Icons.remove_circle_outline,
                          size: 32,
                          color: isPositive
                              ? AppColors.forestGreen
                              : AppColors.slate,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latest.result.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.charcoal,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              isPositive
                                  ? 'Test line is as dark or darker than control'
                                  : 'Test line is lighter or absent',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.slate),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (opkResults.length > 1) ...[
                    const SizedBox(height: AppSpacing.md),
                    ...opkResults.reversed
                        .take(5)
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: Text(
                              '${r.date.toString().substring(0, 10)}: ${r.result.name}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.slate),
                            ),
                          ),
                        ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.secondary(
              'Log OPK Result',
              icon: Icons.add_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LogOPKScreen()),
              ),
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOPK(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.science_outlined,
            size: 24,
            color: AppColors.slate.withValues(alpha: 0.5),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'No OPK results logged yet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }

  Widget _buildCervicalMucusSection(
    BuildContext context,
    WidgetRef ref,
    Cycle activeCycle,
    OvulationResult? ovulation,
    bool isDark,
  ) {
    final mucusAsync = ref.watch(mucusForCycleProvider(activeCycle.id));

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.blur_circular_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Cervical Mucus',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          mucusAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildEmptyMucus(context, isDark),
            data: (mucusRecords) {
              if (mucusRecords.isEmpty) {
                return _buildEmptyMucus(context, isDark);
              }
              final latest = mucusRecords.last;
              final isFertile =
                  latest.type == CervicalMucusType.eggWhite ||
                  latest.type == CervicalMucusType.watery;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isFertile
                            ? [
                                AppColors.softGold.withValues(alpha: 0.15),
                                AppColors.softGold.withValues(alpha: 0.05),
                              ]
                            : [
                                AppColors.forestGreen.withValues(alpha: 0.1),
                                AppColors.forestGreen.withValues(alpha: 0.03),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isFertile
                              ? Icons.auto_awesome_rounded
                              : Icons.circle_rounded,
                          size: 32,
                          color: isFertile
                              ? AppColors.softGold
                              : AppColors.forestGreen,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latest.type.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.charcoal,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (isFertile)
                              Text(
                                'Fertile mucus',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.softGold),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (mucusRecords.length > 1) ...[
                    const SizedBox(height: AppSpacing.md),
                    ...mucusRecords.reversed
                        .take(5)
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: Text(
                              '${r.date.toString().substring(0, 10)}: ${r.type.name}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.slate),
                            ),
                          ),
                        ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.secondary(
              'Log Mucus',
              icon: Icons.add_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LogMucusScreen()),
              ),
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMucus(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.blur_circular_rounded,
            size: 24,
            color: AppColors.slate.withValues(alpha: 0.5),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'No mucus observations logged yet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }

  Widget _buildOvulationStatusCard(
    BuildContext context,
    OvulationResult? ovulation,
    bool isDark,
  ) {
    if (ovulation == null || !ovulation.isConfirmed) {
      return AppCard.standard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 24,
                color: AppColors.sage,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ovulation Not Yet Confirmed',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Keep logging BBT, OPK, and mucus for detection',
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

    return AppCard.highlighted(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 24,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ovulation Confirmed',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${(ovulation.confidence * 100).toStringAsFixed(0)}% confidence',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.forestGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tools',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard.interactive(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const FertilityChartScreen(),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  size: 20,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Fertility Chart',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.slate),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard.interactive(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const OvulationCalendarScreen(),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softGold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: AppColors.softGold,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Ovulation Calendar',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.slate),
            ],
          ),
        ),
      ],
    );
  }
}
