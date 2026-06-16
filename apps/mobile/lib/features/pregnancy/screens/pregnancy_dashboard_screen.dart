import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/pregnancy_week_widget.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/utils/date_utils.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/pregnancy/screens/kick_counter_screen.dart';
import 'package:cyra/features/pregnancy/screens/contraction_timer_screen.dart';
import 'package:cyra/features/pregnancy/screens/pregnancy_symptoms_screen.dart';
import 'package:cyra/features/pregnancy/screens/log_vitals_screen.dart';
import 'package:cyra/features/pregnancy/screens/week_detail_screen.dart';
import 'package:cyra/features/pregnancy/screens/setup_pregnancy_screen.dart';

final _pregnancyDashboardProvider =
    ChangeNotifierProvider<_PregnancyDashboardState>((ref) {
  return _PregnancyDashboardState();
});

class _PregnancyDashboardState extends ChangeNotifier {
  bool isLoading = true;
  bool hasPregnancy = false;

  DateTime? dueDate;
  String calculationMethod = 'lmp';
  DateTime? lastPeriodStart;
  DateTime? conceptionDate;

  int currentWeek = 0;
  int currentTrimester = 0;
  double babySizeCm = 0;
  String sizeComparison = '';

  String developmentMilestone = '';
  String maternalChange = '';

  double? latestWeight;
  String weightTrend = 'stable';
  int? bloodPressureSystolic;
  int? bloodPressureDiastolic;
  double? latestGlucose;

  int kickCount = 0;
  DateTime? kickSessionStart;

  bool hasActiveContraction = false;
  int contractionCount = 0;

  final List<String> _quickSymptoms = [
    'nausea',
    'fatigue',
    'back_pain',
    'heartburn',
  ];
  final Set<String> _selectedSymptoms = {};

  _PregnancyDashboardState() {
    _loadData();
  }

  void _loadData() {
    dueDate = DateTime.now().add(const Duration(days: 140));
    currentWeek = CycleDateUtils.getWeekOfPregnancy(dueDate!);
    currentTrimester = CycleDateUtils.getTrimester(currentWeek);
    babySizeCm = 5.0 + currentWeek * 1.2;
    sizeComparison = CycleDateUtils.weekToSizeComparison(currentWeek);

    developmentMilestone = _weekMilestone(currentWeek);
    maternalChange = _weekMaternalChange(currentWeek);

    latestWeight = 65.5;
    weightTrend = 'up';
    bloodPressureSystolic = 118;
    bloodPressureDiastolic = 76;
    latestGlucose = 5.2;

    kickCount = 8;

    hasPregnancy = true;
    isLoading = false;
    notifyListeners();
  }

  String _weekMilestone(int week) {
    const milestones = <int, String>{
      4: 'Baby\'s heart begins to beat',
      8: 'All major organs are forming',
      12: 'Fingers and toes are fully formed',
      16: 'Baby can hear your voice',
      20: 'You may feel the first flutters',
      24: 'Baby\'s senses are developing',
      28: 'Baby\'s eyes can open',
      32: 'Baby is practicing breathing',
      36: 'Baby is gaining weight rapidly',
      40: 'Baby is ready to meet you!',
    };
    for (final entry in milestones.entries.toList().reversed) {
      if (week >= entry.key) return entry.value;
    }
    return 'Baby is growing and developing';
  }

  String _weekMaternalChange(int week) {
    const changes = <int, String>{
      4: 'You may experience implantation spotting',
      8: 'Morning sickness and fatigue are common',
      12: 'Your uterus is expanding beyond your pelvis',
      16: 'Your energy may be returning',
      20: 'Your belly is becoming more noticeable',
      24: 'You may experience round ligament pain',
      28: 'Shortness of breath may begin',
      32: 'Braxton Hicks contractions may start',
      36: 'Pelvic pressure increases as baby drops',
      40: 'Your body is preparing for labor',
    };
    for (final entry in changes.entries.toList().reversed) {
      if (week >= entry.key) return entry.value;
    }
    return 'Your body is adapting to pregnancy';
  }

  void toggleSymptom(String id) {
    if (_selectedSymptoms.contains(id)) {
      _selectedSymptoms.remove(id);
    } else {
      _selectedSymptoms.add(id);
    }
    notifyListeners();
  }
}

class PregnancyDashboardScreen extends ConsumerWidget {
  const PregnancyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_pregnancyDashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasPregnancy) {
      return _buildEmptyState(context, ref, isDark);
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xxxxl,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          _buildWeekHeader(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildTodayInfoCard(context, state, isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildVitalsSection(context, state, isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildKickCounterCard(context, state, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildContractionTimerCard(context, state, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildSymptomsCard(context, state, isDark, ref),
          const SizedBox(height: AppSpacing.xl),
          _buildWeekNavigation(context, state, isDark),
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton.primary(
                'Set Up Pregnancy',
                icon: Icons.add_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const SetupPregnancyScreen(),
                    ),
                  );
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
    _PregnancyDashboardState state,
    bool isDark,
  ) {
    final weeksRemaining = (40 - state.currentWeek).clamp(0, 40);

    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: PregnancyWeekWidget(
        currentWeek: state.currentWeek,
        currentTrimester: state.currentTrimester,
        babySizeCm: state.babySizeCm,
        sizeComparison: state.sizeComparison,
        developmentMilestone: state.developmentMilestone,
        compact: false,
      ),
    );
  }

  Widget _buildTodayInfoCard(
    BuildContext context,
    _PregnancyDashboardState state,
    bool isDark,
  ) {
    final weeksRemaining = state.dueDate != null
        ? (state.dueDate!.difference(DateTime.now()).inDays / 7).floor()
        : 0;

    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.today_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
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
            "You're in week ${state.currentWeek} of your pregnancy",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: AppColors.sage,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  state.developmentMilestone,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
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
                  state.maternalChange,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
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
    _PregnancyDashboardState state,
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LogVitalsScreen(initialSection: 'weight'),
                    ),
                  );
                },
                child: HealthStatCard(
                  label: 'Weight',
                  value: state.latestWeight != null
                      ? '${state.latestWeight!.toStringAsFixed(1)} kg'
                      : '--',
                  icon: Icons.monitor_weight_rounded,
                  accentColor: AppColors.sage,
                  trend: state.weightTrend,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LogVitalsScreen(initialSection: 'blood_pressure'),
                    ),
                  );
                },
                child: HealthStatCard(
                  label: 'Blood Pressure',
                  value: state.bloodPressureSystolic != null
                      ? '${state.bloodPressureSystolic}/${state.bloodPressureDiastolic}'
                      : '--',
                  icon: Icons.favorite_rounded,
                  accentColor: state.bloodPressureSystolic != null &&
                          state.bloodPressureSystolic! < 120 &&
                          state.bloodPressureDiastolic! < 80
                      ? AppColors.success
                      : AppColors.softGold,
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LogVitalsScreen(initialSection: 'glucose'),
                    ),
                  );
                },
                child: HealthStatCard(
                  label: 'Glucose',
                  value: state.latestGlucose != null
                      ? '${state.latestGlucose!.toStringAsFixed(1)} mmol/L'
                      : '--',
                  icon: Icons.bloodtype_rounded,
                  accentColor: state.latestGlucose != null &&
                          state.latestGlucose! < 5.3
                      ? AppColors.success
                      : AppColors.softGold,
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

  Widget _buildKickCounterCard(
    BuildContext context,
    _PregnancyDashboardState state,
    bool isDark,
  ) {
    return AppCard.interactive(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const KickCounterScreen(),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_care_rounded,
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
                  state.kickCount > 0
                      ? 'Last session: ${state.kickCount} kicks'
                      : 'Track your baby\'s movements',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Text(
              'Log Kicks',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractionTimerCard(
    BuildContext context,
    _PregnancyDashboardState state,
    bool isDark,
  ) {
    return AppCard.interactive(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ContractionTimerScreen(),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_rounded,
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
                  state.hasActiveContraction
                      ? 'Timer active — ${state.contractionCount} contractions logged'
                      : 'Track contractions when they begin',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: state.hasActiveContraction
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.forestGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Text(
              state.hasActiveContraction ? 'Active' : 'Start Timing',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: state.hasActiveContraction
                    ? AppColors.error
                    : AppColors.forestGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsCard(
    BuildContext context,
    _PregnancyDashboardState state,
    bool isDark,
    WidgetRef ref,
  ) {
    return AppCard.interactive(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const PregnancySymptomsScreen(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.healing_outlined,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Symptoms',
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
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: state._quickSymptoms.map((id) {
              final isSelected = state._selectedSymptoms.contains(id);
              return GestureDetector(
                onTap: () =>
                    ref.read(_pregnancyDashboardProvider.notifier).toggleSymptom(id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.forestGreen.withValues(alpha: 0.1)
                        : (isDark
                            ? AppColors.charcoal.withValues(alpha: 0.2)
                            : AppColors.mistWhite),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.forestGreen.withValues(alpha: 0.4)
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    _symptomLabel(id),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.forestGreen
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.slate),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.secondary(
              'Log Symptom',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PregnancySymptomsScreen(),
                  ),
                );
              },
              height: 36,
            ),
          ),
        ],
      ),
    );
  }

  String _symptomLabel(String id) {
    switch (id) {
      case 'nausea':
        return 'Nausea';
      case 'fatigue':
        return 'Fatigue';
      case 'back_pain':
        return 'Back Pain';
      case 'heartburn':
        return 'Heartburn';
      default:
        return id;
    }
  }

  Widget _buildWeekNavigation(
    BuildContext context,
    _PregnancyDashboardState state,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            'Your Pregnancy Journey',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 40,
            itemBuilder: (context, index) {
              final week = index + 1;
              final isCurrent = week == state.currentWeek;
              final comparison =
                  CycleDateUtils.weekToSizeComparison(week);
              final trimester = CycleDateUtils.getTrimester(week);
              final trimesterColor = _trimesterColor(trimester);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          WeekDetailScreen(week: week),
                    ),
                  );
                },
                child: Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.forestGreen
                        : (isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight),
                    borderRadius:
                        BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isCurrent
                          ? AppColors.forestGreen
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? Colors.white.withValues(alpha: 0.2)
                              : trimesterColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$week',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: isCurrent
                                      ? Colors.white
                                      : trimesterColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        comparison,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: isCurrent
                                  ? Colors.white
                                  : AppColors.slate,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _trimesterColor(int trimester) {
    switch (trimester) {
      case 1:
        return AppColors.sage;
      case 2:
        return AppColors.softGold;
      case 3:
        return const Color(0xFFE57373);
      default:
        return AppColors.sage;
    }
  }
}
