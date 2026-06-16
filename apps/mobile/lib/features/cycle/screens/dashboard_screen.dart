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
import 'package:cyra/core/design/widgets/pregnancy_week_widget.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/cycle/screens/prediction_detail_screen.dart';
import 'package:cyra/features/cycle/screens/cycle_history_screen.dart';
import 'package:cyra/features/cycle/screens/calendar_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';

final _dashboardProvider = ChangeNotifierProvider<_DashboardState>((ref) {
  return _DashboardState();
});

class _DashboardState extends ChangeNotifier {
  bool isLoading = true;
  bool isRefreshing = false;
  bool hasData = true;

  int currentCycleDay = 14;
  int totalCycleLength = 28;
  CyclePhase currentPhase = CyclePhase.follicular;

  DateTime? lastPeriodStart;
  int averageCycleLength = 28;
  int averagePeriodLength = 5;
  double variabilityScore = 3.2;

  models.PredictionResult? prediction;
  List<TimelineEntry> recentEntries = [];
  List<int> flowOptions = [1, 2, 3, 4];
  List<String> quickSymptoms = ['cramps', 'headache', 'bloating', 'fatigue'];
  Set<String> selectedSymptoms = {};
  String? notesText;

  bool inPregnancyMode = false;
  int pregnancyWeek = 0;
  int pregnancyTrimester = 0;

  _DashboardState() {
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    lastPeriodStart = DateTime.now().subtract(const Duration(days: 13));

    prediction = models.PredictionResult(
      predictedDate: DateTime.now().add(const Duration(days: 14)),
      confidenceScore: 0.85,
      variabilityScore: 1.5,
      predictionRangeStart: DateTime.now().add(const Duration(days: 12)),
      predictionRangeEnd: DateTime.now().add(const Duration(days: 16)),
      explanation:
          'Based on your last 6 cycles with an average length of 28 days. '
          'Your cycles are very regular, varying by only 1-2 days.',
    );

    recentEntries = [
      TimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 2)),
        title: 'Period started',
        description: 'Medium flow',
        type: TimelineEntryType.period,
      ),
      TimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 5)),
        title: 'Cramps',
        description: 'Mild, managed with heat pack',
        type: TimelineEntryType.symptom,
      ),
      TimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 7)),
        title: 'Temperature logged',
        description: '36.5°C',
        type: TimelineEntryType.journal,
      ),
      TimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 10)),
        title: 'Ovulation detected',
        description: 'Day 14 of cycle',
        type: TimelineEntryType.ovulation,
      ),
      TimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 14)),
        title: 'Fertile window',
        description: 'Days 10-17',
        type: TimelineEntryType.fertility,
      ),
    ];

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    isRefreshing = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isRefreshing = false;
    notifyListeners();
  }

  void toggleSymptom(String id) {
    if (selectedSymptoms.contains(id)) {
      selectedSymptoms.remove(id);
    } else {
      selectedSymptoms.add(id);
    }
    notifyListeners();
  }

  void setNotes(String text) {
    notesText = text;
    notifyListeners();
  }

  void logFlow(int value) {}
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(_dashboardProvider.notifier).refresh(),
        color: AppColors.forestGreen,
        child: state.isLoading ? _buildLoadingState(context) : _buildContent(context, state, ref, isDark),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  Widget _buildContent(BuildContext context, _DashboardState state, WidgetRef ref, bool isDark) {
    if (!state.hasData) {
      return _buildEmptyState(context, ref);
    }

    final dateFormat = DateFormat('MMM d');

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxxxl, AppSpacing.lg, AppSpacing.xxxl),
      children: [
        _buildTopSection(context, state, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildPredictionCard(context, state, isDark, dateFormat),
        const SizedBox(height: AppSpacing.lg),
        _buildTodayLogCard(context, state, isDark, ref),
        const SizedBox(height: AppSpacing.lg),
        _buildCycleStatsGrid(context, state, isDark),
        const SizedBox(height: AppSpacing.lg),
        _buildRecentActivity(context, state, isDark, ref),
        if (_shouldShowFertilityWindow(state)) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildFertilityCard(context, state, isDark),
        ],
        if (state.inPregnancyMode) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildPregnancyCard(context, state, isDark),
        ],
      ],
    );
  }

  Widget _buildTopSection(BuildContext context, _DashboardState state, bool isDark) {
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
                'Day ${state.currentCycleDay} of your cycle',
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
          ),
        ),
        const PrivacyLockIcon(isLocked: true),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildPredictionCard(BuildContext context, _DashboardState state, bool isDark, DateFormat dateFormat) {
    if (state.prediction == null) return const SizedBox.shrink();

    final prediction = state.prediction!;
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

  Widget _buildTodayLogCard(BuildContext context, _DashboardState state, bool isDark, WidgetRef ref) {
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
            onChanged: (value) {},
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Any symptoms?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: state.quickSymptoms.map((id) {
              final isSelected = state.selectedSymptoms.contains(id);
              final symptom = _quickSymptomLabel(id);
              return FilterChip(
                label: Text(symptom),
                selected: isSelected,
                onSelected: (_) => ref.read(_dashboardProvider.notifier).toggleSymptom(id),
                selectedColor: AppColors.forestGreen.withValues(alpha: 0.15),
                checkmarkColor: AppColors.forestGreen,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppColors.forestGreen : AppColors.slate,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.forestGreen.withValues(alpha: 0.4)
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.ghost(
            'See all symptoms',
            icon: Icons.more_horiz,
            onPressed: () {},
            height: 36,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 44,
            child: TextField(
              onChanged: (text) => ref.read(_dashboardProvider.notifier).setNotes(text),
              decoration: InputDecoration(
                hintText: 'Add notes...',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'See full log',
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
  }

  String _quickSymptomLabel(String id) {
    switch (id) {
      case 'cramps':
        return 'Cramps';
      case 'headache':
        return 'Headache';
      case 'bloating':
        return 'Bloating';
      case 'fatigue':
        return 'Fatigue';
      default:
        return id;
    }
  }

  Widget _buildCycleStatsGrid(BuildContext context, _DashboardState state, bool isDark) {
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
                value: '${state.currentCycleDay}',
                icon: Icons.calendar_today_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Cycle Length',
                value: '${state.averageCycleLength} days',
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
                value: '${state.averagePeriodLength} days',
                icon: Icons.water_drop_rounded,
                accentColor: const Color(0xFFE86B6B),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Variability',
                value: state.variabilityScore <= 3
                    ? 'Low'
                    : (state.variabilityScore <= 7 ? 'Moderate' : 'High'),
                icon: Icons.trending_flat_rounded,
                accentColor: state.variabilityScore <= 3
                    ? AppColors.success
                    : (state.variabilityScore <= 7
                        ? AppColors.softGold
                        : AppColors.error),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, _DashboardState state, bool isDark, WidgetRef ref) {
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
            entries: state.recentEntries,
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
  }

  bool _shouldShowFertilityWindow(_DashboardState state) {
    return state.lastPeriodStart != null && state.currentCycleDay >= 6 && state.currentCycleDay <= 22;
  }

  Widget _buildFertilityCard(BuildContext context, _DashboardState state, bool isDark) {
    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: FertilityWidget(
        lastPeriodStart: state.lastPeriodStart,
        cycleLength: state.averageCycleLength,
        currentCycleDay: state.currentCycleDay,
        compact: true,
      ),
    );
  }

  Widget _buildPregnancyCard(BuildContext context, _DashboardState state, bool isDark) {
    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: PregnancyWeekWidget(
        currentWeek: state.pregnancyWeek,
        currentTrimester: state.pregnancyTrimester,
        compact: true,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(_dashboardProvider.notifier).refresh(),
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
