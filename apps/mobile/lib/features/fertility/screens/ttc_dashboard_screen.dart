import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/fertility/screens/log_intercourse_screen.dart';

final _ttcDashboardProvider =
    ChangeNotifierProvider<_TTCDashboardState>((ref) {
  return _TTCDashboardState();
});

class _IntercourseEntry {
  final DateTime date;
  final String timeOfDay;
  final bool unprotected;
  final String? notes;
  final bool isDuringFertileWindow;

  const _IntercourseEntry({
    required this.date,
    required this.timeOfDay,
    required this.unprotected,
    this.notes,
    required this.isDuringFertileWindow,
  });
}

class _TTCDashboardState extends ChangeNotifier {
  bool isLoading = true;

  int currentCycleDay = 14;
  int cycleLength = 28;
  DateTime? lastPeriodStart;
  DateTime? ovulationDate;
  bool isFertileToday = true;
  double conceptionProbability = 0.35;
  bool ovulationConfirmed = false;

  List<_IntercourseEntry> intercourseEntries = [];
  int totalIntercourseCount = 6;
  int fertileWindowIntercourseCount = 3;

  _TTCDashboardState() {
    _loadData();
  }

  void _loadData() {
    lastPeriodStart = DateTime.now().subtract(const Duration(days: 13));
    ovulationDate = DateTime.now().subtract(const Duration(days: 1));

    intercourseEntries = [
      _IntercourseEntry(
        date: DateTime.now().subtract(const Duration(days: 0)),
        timeOfDay: 'Morning',
        unprotected: true,
        isDuringFertileWindow: true,
      ),
      _IntercourseEntry(
        date: DateTime.now().subtract(const Duration(days: 2)),
        timeOfDay: 'Evening',
        unprotected: true,
        isDuringFertileWindow: true,
      ),
      _IntercourseEntry(
        date: DateTime.now().subtract(const Duration(days: 4)),
        timeOfDay: 'Afternoon',
        unprotected: true,
        isDuringFertileWindow: true,
      ),
      _IntercourseEntry(
        date: DateTime.now().subtract(const Duration(days: 7)),
        timeOfDay: 'Morning',
        unprotected: false,
        notes: 'Low libido',
        isDuringFertileWindow: false,
      ),
      _IntercourseEntry(
        date: DateTime.now().subtract(const Duration(days: 10)),
        timeOfDay: 'Evening',
        unprotected: true,
        isDuringFertileWindow: false,
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}

class TTCDashboardScreen extends ConsumerWidget {
  const TTCDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_ttcDashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
          _buildHeader(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildFertilityStatusCard(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildCycleTimelineCard(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildIntercourseLogCard(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildTipsSection(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildDisclaimer(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _TTCDashboardState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trying to Conceive',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        CyclePhaseIndicator(
          phase: CyclePhase.ovulation,
          size: CyclePhaseIndicatorSize.medium,
        ),
      ],
    );
  }

  Widget _buildFertilityStatusCard(
    BuildContext context,
    _TTCDashboardState state,
    bool isDark,
  ) {
    String actionRecommendation;
    if (state.isFertileToday && state.conceptionProbability >= 0.3) {
      actionRecommendation = 'Optimal timing — consider intercourse today';
    } else if (state.isFertileToday) {
      actionRecommendation = 'Consider intercourse today';
    } else if (state.conceptionProbability > 0.1) {
      actionRecommendation = 'Fertile window approaching — prepare';
    } else {
      actionRecommendation = 'Rest and prepare for next cycle';
    }

    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                state.isFertileToday
                    ? Icons.celebration_outlined
                    : Icons.calendar_month_outlined,
                size: 20,
                color: state.isFertileToday ? AppColors.forestGreen : AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                state.isFertileToday
                    ? 'Day ${state.currentCycleDay} — Fertile Day'
                    : 'Day ${state.currentCycleDay} — Not Fertile',
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
              _statusChip(
                context,
                'Conception Probability',
                '${(state.conceptionProbability * 100).round()}%',
                state.conceptionProbability >= 0.3
                    ? AppColors.forestGreen
                    : state.conceptionProbability >= 0.1
                        ? AppColors.softGold
                        : AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.sm),
              _statusChip(
                context,
                'Fertile Window',
                state.isFertileToday ? 'Open' : 'Closed',
                state.isFertileToday ? AppColors.forestGreen : AppColors.slate,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (state.isFertileToday ? AppColors.forestGreen : AppColors.slate)
                  .withValues(alpha: isDark ? 0.15 : 0.06),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: state.isFertileToday ? AppColors.forestGreen : AppColors.slate,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    actionRecommendation,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: state.isFertileToday ? AppColors.forestGreen : AppColors.slate,
                      fontWeight: FontWeight.w500,
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

  Widget _statusChip(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleTimelineCard(
    BuildContext context,
    _TTCDashboardState state,
    bool isDark,
  ) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'This Cycle Timeline',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildCycleBar(context, state, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildCycleStats(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildCycleBar(BuildContext context, _TTCDashboardState state, bool isDark) {
    final days = state.cycleLength.clamp(28, 35);
    final fertileStart = 8;
    final fertileEnd = 19;
    final ovulationDay = state.cycleLength - 14;

    return SizedBox(
      height: 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: CustomPaint(
          painter: _CycleTimelinePainter(
            days: days,
            fertileStart: fertileStart,
            fertileEnd: fertileEnd,
            ovulationDay: ovulationDay,
            currentDay: state.currentCycleDay,
            intercourseDays: state.intercourseEntries
                .map((e) => e.date.dayOfCycle(state.lastPeriodStart!))
                .where((d) => d > 0 && d <= days)
                .toSet()
                .toList(),
            isDark: isDark,
          ),
          size: Size(MediaQuery.of(context).size.width - 64, 32),
        ),
      ),
    );
  }

  Widget _buildCycleStats(BuildContext context, _TTCDashboardState state, bool isDark) {
    return Row(
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
            value: '${state.cycleLength} days',
            icon: Icons.repeat_rounded,
            accentColor: AppColors.sage,
          ),
        ),
      ],
    );
  }

  Widget _buildIntercourseLogCard(
    BuildContext context,
    _TTCDashboardState state,
    bool isDark,
  ) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_outlined, size: 20, color: const Color(0xFFE86B6B)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Intercourse Log',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${state.totalIntercourseCount} times this cycle, ${state.fertileWindowIntercourseCount} during fertile window',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.intercourseEntries.isNotEmpty)
            ...state.intercourseEntries.take(3).map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (entry.isDuringFertileWindow
                                ? AppColors.forestGreen
                                : AppColors.slate)
                            .withValues(alpha: isDark ? 0.2 : 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 16,
                        color: entry.isDuringFertileWindow
                            ? AppColors.forestGreen
                            : AppColors.slate,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM d, yyyy').format(entry.date),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${entry.timeOfDay} · ${entry.unprotected ? "Unprotected" : "Protected"}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.slate,
                                ),
                              ),
                              if (entry.isDuringFertileWindow) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.forestGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(AppRadius.xl),
                                  ),
                                  child: Text(
                                    'Fertile',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.forestGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.secondary(
              'Log Intercourse',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LogIntercourseScreen(),
                  ),
                );
              },
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection(
    BuildContext context,
    _TTCDashboardState state,
    bool isDark,
  ) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 20, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tips for TTC',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _tipRow(
            context,
            Icons.schedule_rounded,
            'Timing is key',
            'Have intercourse every 1-2 days during your fertile window for optimal chances.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _tipRow(
            context,
            Icons.self_improvement_rounded,
            'Manage stress',
            'High stress can affect ovulation. Consider meditation, gentle exercise, and adequate sleep.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _tipRow(
            context,
            Icons.restaurant_rounded,
            'Nutrition matters',
            'A balanced diet rich in folate, zinc, and omega-3s supports reproductive health.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _tipRow(
            context,
            Icons.menu_book_rounded,
            'Learn more',
            'Explore our education hub for articles on fertility, conception, and reproductive health.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View all articles',
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

  Widget _tipRow(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.forestGreen),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.softGold,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This app is for educational purposes. Consult a fertility specialist for medical advice.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleTimelinePainter extends CustomPainter {
  final int days;
  final int fertileStart;
  final int fertileEnd;
  final int ovulationDay;
  final int currentDay;
  final List<int> intercourseDays;
  final bool isDark;

  _CycleTimelinePainter({
    required this.days,
    required this.fertileStart,
    required this.fertileEnd,
    required this.ovulationDay,
    required this.currentDay,
    required this.intercourseDays,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / days;

    for (int day = 1; day <= days; day++) {
      final x = (day - 1) * cellWidth;

      Color dayColor;
      if (day >= fertileStart && day <= fertileEnd) {
        if (day == ovulationDay) {
          dayColor = AppColors.softGold.withValues(alpha: 0.7);
        } else {
          dayColor = AppColors.forestGreenLight.withValues(alpha: 0.4);
        }
      } else if (day <= 5) {
        dayColor = const Color(0xFFE86B6B).withValues(alpha: 0.3);
      } else {
        dayColor = isDark
            ? AppColors.charcoal.withValues(alpha: 0.3)
            : AppColors.borderLight.withValues(alpha: 0.6);
      }

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, cellWidth - 1, size.height),
        const Radius.circular(2),
      );
      canvas.drawRRect(rRect, Paint()..color = dayColor);
    }

    for (final day in intercourseDays) {
      if (day < 1 || day > days) continue;
      final x = (day - 1) * cellWidth + cellWidth / 2;
      final paint = Paint()..color = const Color(0xFFE86B6B);
      canvas.drawCircle(Offset(x, size.height / 2), 4, paint);
    }

    if (currentDay >= 1 && currentDay <= days) {
      final x = (currentDay - 1) * cellWidth + cellWidth / 2;
      final markerPaint = Paint()
        ..color = AppColors.charcoal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(x, size.height / 2), size.height / 2 - 2, markerPaint);
    }
  }

  @override
  bool shouldRepaint(_CycleTimelinePainter oldDelegate) =>
      oldDelegate.days != days ||
      oldDelegate.currentDay != currentDay ||
      oldDelegate.intercourseDays != intercourseDays;
}
