import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/pregnancy_week_widget.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/features/pregnancy/data/weekly_milestones.dart';
import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';
import 'package:cyra/features/pregnancy/providers/pregnancy_providers.dart';
import 'package:cyra/features/pregnancy/screens/kick_counter_screen.dart';
import 'package:cyra/features/pregnancy/screens/contraction_timer_screen.dart';
import 'package:cyra/features/pregnancy/screens/pregnancy_symptoms_screen.dart';
import 'package:cyra/features/pregnancy/screens/log_vitals_screen.dart';
import 'package:cyra/features/pregnancy/screens/week_detail_screen.dart';
import 'package:cyra/features/pregnancy/screens/setup_pregnancy_screen.dart';

class PregnancyDashboardScreen extends ConsumerWidget {
  const PregnancyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregnancyAsync = ref.watch(currentPregnancyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return pregnancyAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => _buildEmptyState(context, ref, isDark),
      data: (pregnancy) {
        if (pregnancy == null) return _buildEmptyState(context, ref, isDark);
        return _buildPopulatedDashboard(context, ref, pregnancy, isDark);
      },
    );
  }

  Widget _buildPopulatedDashboard(
    BuildContext context,
    WidgetRef ref,
    Pregnancy pregnancy,
    bool isDark,
  ) {
    final milestone = PregnancyData.getMilestone(pregnancy.currentWeek);
    final measurementAsync = ref.watch(latestMeasurementProvider);
    final measurement = measurementAsync.valueOrNull;
    final weeksRemaining =
        pregnancy.dueDate.difference(DateTime.now()).inDays ~/ 7;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xxxxl,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          _buildWeekHeader(context, pregnancy, milestone, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildTodayInfoCard(
            context,
            pregnancy,
            milestone,
            weeksRemaining,
            isDark,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildVitalsSection(context, measurement, isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildKickCounterCard(context, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildContractionTimerCard(context, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildSymptomsCard(context, isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildWeekNavigation(context, pregnancy, milestone, isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, bool isDark) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.child_care_rounded,
                  size: 44,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Welcome to Your Pregnancy Journey',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Enter your due date to begin tracking your pregnancy journey.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton.primary(
                'Set Up Pregnancy',
                icon: Icons.add_rounded,
                onPressed: () async {
                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => const SetupPregnancyScreen(),
                    ),
                  );
                  if (result == true) ref.invalidate(currentPregnancyProvider);
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekHeader(
    BuildContext context,
    Pregnancy pregnancy,
    WeeklyMilestone milestone,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: PregnancyWeekWidget(
        currentWeek: pregnancy.currentWeek,
        currentTrimester: pregnancy.currentTrimester,
        babySizeCm: milestone.babyLengthCm,
        sizeComparison: milestone.babySizeComparison,
        developmentMilestone: milestone.developmentSummary,
        compact: false,
      ),
    );
  }

  Widget _buildTodayInfoCard(
    BuildContext context,
    Pregnancy pregnancy,
    WeeklyMilestone milestone,
    int weeksRemaining,
    bool isDark,
  ) {
    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "Today's Update",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "You're in week ${pregnancy.currentWeek} of your pregnancy",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.sage),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  milestone.developmentSummary,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 16,
                color: const Color(0xFFE86B6B),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  milestone.maternalChanges,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.warmIvory.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_rounded,
                  size: 16,
                  color: AppColors.forestGreen,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$weeksRemaining weeks until your due date',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsSection(
    BuildContext context,
    FetalMeasurement? measurement,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 18,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Your Vitals',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const LogVitalsScreen(initialSection: 'weight'),
                  ),
                ),
                child: HealthStatCard(
                  label: 'Weight',
                  value: measurement?.weight != null
                      ? '${measurement!.weight!.toStringAsFixed(1)} kg'
                      : '--',
                  icon: Icons.monitor_weight_rounded,
                  accentColor: AppColors.sage,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const LogVitalsScreen(initialSection: 'blood_pressure'),
                  ),
                ),
                child: HealthStatCard(
                  label: 'Blood Pressure',
                  value: measurement?.bloodPressureSystolic != null
                      ? '${measurement!.bloodPressureSystolic}/${measurement.bloodPressureDiastolic}'
                      : '--',
                  icon: Icons.favorite_rounded,
                  accentColor: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const LogVitalsScreen(initialSection: 'glucose'),
                  ),
                ),
                child: HealthStatCard(
                  label: 'Glucose',
                  value: measurement?.glucoseLevel != null
                      ? '${measurement!.glucoseLevel!.toStringAsFixed(1)} mmol/L'
                      : '--',
                  icon: Icons.bloodtype_rounded,
                  accentColor: AppColors.success,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  Widget _buildKickCounterCard(BuildContext context, bool isDark) {
    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const KickCounterScreen()),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              size: 24,
              color: AppColors.softGold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kick Counter',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Count your baby\'s kicks',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildContractionTimerCard(BuildContext context, bool isDark) {
    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ContractionTimerScreen()),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE86B6B).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timer_rounded,
              size: 24,
              color: const Color(0xFFE86B6B),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contraction Timer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Time your contractions',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildSymptomsCard(BuildContext context, bool isDark) {
    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const PregnancySymptomsScreen(),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.healing_rounded, size: 24, color: AppColors.sage),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregnancy Symptoms',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Track how you\'re feeling',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation(
    BuildContext context,
    Pregnancy pregnancy,
    WeeklyMilestone milestone,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Journey',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard.interactive(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => WeekDetailScreen(week: pregnancy.currentWeek),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Text(
                    '${pregnancy.currentWeek}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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
                      'Week ${pregnancy.currentWeek} — ${milestone.babySizeComparison}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${milestone.babyLengthCm} cm • ${milestone.babyWeightG.toStringAsFixed(0)} g',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                    ),
                  ],
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
