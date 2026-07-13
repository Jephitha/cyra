import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/health_timeline.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/design/widgets/flow_intensity_picker.dart';
import 'package:cyra/core/design/widgets/privacy_lock.dart';
import 'package:cyra/core/design/widgets/fertility_widget.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/screens/prediction_detail_screen.dart';
import 'package:cyra/features/cycle/screens/cycle_history_screen.dart';
import 'package:cyra/features/cycle/screens/calendar_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';
import 'package:cyra/features/symptoms/screens/log_symptom_screen.dart';
import 'package:cyra/features/ovulation/screens/log_bbt_screen.dart';
import 'package:cyra/features/ovulation/screens/log_mucus_screen.dart';
import 'package:cyra/features/ovulation/screens/log_opk_screen.dart';
import 'package:cyra/features/pregnancy/screens/pregnancy_dashboard_screen.dart';
import 'package:cyra/features/pregnancy/providers/pregnancy_providers.dart';
import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cyclesAsync = ref.watch(allCyclesProvider);

    return Scaffold(
      body: cyclesAsync.when(
        loading: () => _buildLoadingState(context, isDark),
        error: (_, __) => _buildLoadingState(context, isDark),
        data: (cycles) {
          if (cycles.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return _buildPopulatedDashboard(context, ref, isDark);
        },
      ),
    );
  }

  Widget _buildPopulatedDashboard(BuildContext context, WidgetRef ref, bool isDark) {
    final activeCycleAsync = ref.watch(activeCycleProvider);
    final summaryAsync = ref.watch(cycleSummaryProvider);
    final predictionAsync = ref.watch(nextPeriodPredictionProvider);
    final insightsAsync = ref.watch(dashboardInsightsProvider);

    final activeCycle = activeCycleAsync.valueOrNull;
    final summary = summaryAsync.valueOrNull;
    final prediction = predictionAsync.valueOrNull;
    final insights = insightsAsync.valueOrNull;

    final now = DateTime.now();
    final cycleDay = activeCycle != null
        ? now.difference(activeCycle.startDate).inDays + 1
        : 1;
    final cycleLength = summary != null && summary.averageLength > 0
        ? summary.averageLength.round()
        : 28;
    final periodLength = summary != null && summary.averagePeriodLength > 0
        ? summary.averagePeriodLength.round()
        : 5;
    final variability = summary?.variabilityScore ?? 0.0;
    final phase = insights?.currentPhase ?? models.CyclePhase.follicular;

    final dateFormat = DateFormat('MMM d');

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allCyclesProvider);
        ref.invalidate(activeCycleProvider);
        ref.invalidate(cycleSummaryProvider);
        ref.invalidate(nextPeriodPredictionProvider);
        ref.invalidate(dashboardInsightsProvider);
      },
      color: AppColors.forestGreen,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxxxl, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          _buildTopSection(context, cycleDay, phase, isDark),
          const SizedBox(height: AppSpacing.lg),
          if (prediction != null)
            _buildPredictionCard(context, prediction, isDark, dateFormat),
          const SizedBox(height: AppSpacing.lg),
          _buildTodayLogCard(context, isDark, ref),
          const SizedBox(height: AppSpacing.lg),
          _buildOvulationTrackingCard(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildPregnancyCard(context, ref, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildCycleStatsGrid(context, cycleDay, cycleLength, periodLength, variability, isDark),
          const SizedBox(height: AppSpacing.lg),
          if (activeCycle != null)
            _RecentActivitySection(cycleId: activeCycle.id),
          if (activeCycle != null &&
              insights?.fertileWindow != null &&
              insights!.fertileWindow!.isInWindow) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildFertilityCard(context, activeCycle.startDate, cycleLength, cycleDay),
          ],
        ],
      ),
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
          _shimmerBlock(height: 120),
          const SizedBox(height: AppSpacing.lg),
          _shimmerBlock(height: 200),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: _shimmerBlock(height: 100)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _shimmerBlock(height: 100)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _shimmerBlock(height: 100)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _shimmerBlock(height: 100)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _shimmerBlock(height: 180),
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

  Widget _buildTopSection(BuildContext context, int cycleDay, models.CyclePhase phase, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Day $cycleDay of your cycle',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              CyclePhaseIndicator(
                phase: _mapPhase(phase),
                size: CyclePhaseIndicatorSize.medium,
              ),
            ],
          ),
        ),
        const PrivacyLockIcon(isLocked: true),
      ],
    );
  }

  CyclePhase _mapPhase(models.CyclePhase phase) {
    return switch (phase) {
      models.CyclePhase.menstrual => CyclePhase.menstrual,
      models.CyclePhase.follicular => CyclePhase.follicular,
      models.CyclePhase.ovulation => CyclePhase.ovulation,
      models.CyclePhase.luteal => CyclePhase.luteal,
    };
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildPredictionCard(BuildContext context, models.PredictionResult prediction, bool isDark, DateFormat dateFormat) {
    final daysUntil = DateTime.now().daysUntil(prediction.predictedDate);

    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const PredictionDetailScreen(),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Next period predicted in $daysUntil days',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${dateFormat.format(prediction.predictionRangeStart)} – ${dateFormat.format(prediction.predictionRangeEnd)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              ConfidenceBadge(
                confidence: prediction.confidenceScore,
                size: ConfidenceBadgeSize.medium,
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.slate,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            prediction.explanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayLogCard(BuildContext context, bool isDark, WidgetRef ref) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Log today',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'How is your flow?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FlowIntensityPicker(
            selectedValue: null,
            onChanged: (value) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LogPeriodScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LogPeriodScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.water_drop_rounded, size: 18),
                  label: const Text('Log Period'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.forestGreen,
                    side: const BorderSide(color: AppColors.forestGreen),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LogSymptomScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.healing_rounded, size: 18),
                  label: const Text('Log Symptoms'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.sage,
                    side: const BorderSide(color: AppColors.sage),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOvulationTrackingCard(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 20, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Ovulation Tracking',
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
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const LogBBTScreen()),
                  ),
                  icon: const Icon(Icons.device_thermostat_rounded, size: 16),
                  label: const Text('BBT', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.forestGreen,
                    side: const BorderSide(color: AppColors.forestGreen),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const LogMucusScreen()),
                  ),
                  icon: const Icon(Icons.opacity_rounded, size: 16),
                  label: const Text('Mucus', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.softGold,
                    side: const BorderSide(color: AppColors.softGold),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const LogOPKScreen()),
                  ),
                  icon: const Icon(Icons.science_rounded, size: 16),
                  label: const Text('OPK', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.sage,
                    side: const BorderSide(color: AppColors.sage),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyCard(BuildContext context, WidgetRef ref, bool isDark) {
    final pregnancyAsync = ref.watch(currentPregnancyProvider);
    
    return pregnancyAsync.when(
      loading: () => _buildPregnancyCardLoading(context, isDark),
      error: (_, __) => _buildPregnancyCardEmpty(context, isDark),
      data: (Pregnancy? pregnancy) {
        if (pregnancy == null) {
          return _buildPregnancyCardEmpty(context, isDark);
        }
        return _buildPregnancyCardActive(context, isDark, pregnancy);
      },
    );
  }

  Widget _buildPregnancyCardLoading(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.period.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.child_care_rounded, size: 24, color: AppColors.period),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pregnancy Mode', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: AppSpacing.xxs),
                Text('Loading...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyCardEmpty(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.period.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.child_care_rounded, size: 24, color: AppColors.period),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pregnancy Mode', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: AppSpacing.xxs),
                Text('Track your pregnancy journey',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PregnancyDashboardScreen()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.period,
              side: const BorderSide(color: AppColors.period),
            ),
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyCardActive(BuildContext context, bool isDark, Pregnancy pregnancy) {
    final weeks = pregnancy.currentWeek;
    final trimester = pregnancy.trimesterName;
    
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.period.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.child_care_rounded, size: 24, color: AppColors.period),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pregnancy Mode', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: AppSpacing.xxs),
                Text('Week $weeks • $trimester',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PregnancyDashboardScreen()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.period,
              side: const BorderSide(color: AppColors.period),
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleStatsGrid(BuildContext context, int cycleDay, int cycleLength, int periodLength, double variability, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            'Cycle Overview',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Cycle Day',
                value: '$cycleDay',
                icon: Icons.calendar_today_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Cycle Length',
                value: '$cycleLength days',
                icon: Icons.repeat_rounded,
                accentColor: AppColors.sage,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Period Length',
                value: '$periodLength days',
                icon: Icons.water_drop_rounded,
                accentColor: AppColors.period,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Variability',
                value: variability <= 0.07
                    ? 'Low'
                    : (variability <= 0.15 ? 'Moderate' : 'High'),
                icon: Icons.trending_flat_rounded,
                accentColor: variability <= 0.07
                    ? AppColors.success
                    : (variability <= 0.15
                        ? AppColors.softGold
                        : AppColors.error),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFertilityCard(BuildContext context, DateTime lastPeriodStart, int cycleLength, int cycleDay) {
    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: FertilityWidget(
        lastPeriodStart: lastPeriodStart,
        cycleLength: cycleLength,
        currentCycleDay: cycleDay,
        compact: true,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allCyclesProvider);
      },
      color: AppColors.forestGreen,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        children: [
          const SizedBox(height: AppSpacing.huge),
          Center(
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
                  child: Icon(
                    Icons.water_drop_rounded,
                    size: 40,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Welcome to Cyra!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Start by logging your first period.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                AppButton.primary(
                  'Log Your Period',
                  icon: Icons.add_rounded,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LogPeriodScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.secondary(
                  'Explore Calendar',
                  icon: Icons.calendar_month_rounded,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CalendarScreen(),
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
}

class _RecentActivitySection extends ConsumerWidget {
  final String cycleId;

  const _RecentActivitySection({required this.cycleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysAsync = ref.watch(cycleDaysProvider(cycleId));

    return daysAsync.when(
      data: (days) {
        final entries = _buildTimelineEntries(days);
        if (entries.isEmpty) return const SizedBox.shrink();

        return AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timeline_rounded,
                    size: 20,
                    color: AppColors.forestGreen,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              HealthTimeline(
                entries: entries,
                dotRadius: 6,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CycleHistoryScreen(),
                    ),
                  ),
                  child: Text(
                    'View full history',
                    style: TextStyle(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  List<TimelineEntry> _buildTimelineEntries(List<models.CycleDay> days) {
    final entries = <TimelineEntry>[];

    final sorted = List<models.CycleDay>.from(days)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final day in sorted.take(8)) {
      if (day.flowIntensity > 0) {
        entries.add(TimelineEntry(
          date: day.date,
          title: 'Period logged',
          description: _flowLabel(day.flowIntensity),
          type: TimelineEntryType.period,
        ));
      }
      if (day.spotting) {
        entries.add(TimelineEntry(
          date: day.date,
          title: 'Spotting',
          description: 'Light spotting noticed',
          type: TimelineEntryType.period,
        ));
      }
      if (day.temperature != null) {
        entries.add(TimelineEntry(
          date: day.date,
          title: 'Temperature logged',
          description: '${day.temperature!.toStringAsFixed(1)}°C',
          type: TimelineEntryType.journal,
        ));
      }
      if (day.notes != null && day.notes!.isNotEmpty) {
        entries.add(TimelineEntry(
          date: day.date,
          title: 'Note',
          description: day.notes!,
          type: TimelineEntryType.symptom,
        ));
      }
    }

    return entries.take(5).toList();
  }

  String _flowLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Light flow';
      case 2:
        return 'Medium flow';
      case 3:
        return 'Heavy flow';
      case 4:
        return 'Very heavy flow';
      case 5:
        return 'Spotting';
      default:
        return 'Flow logged';
    }
  }
}
