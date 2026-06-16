import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/cycle_calendar.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/constants/cycle_constants.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/cycle/screens/log_period_screen.dart';

final _calendarProvider = ChangeNotifierProvider<_CalendarState>((ref) {
  return _CalendarState();
});

class _CalendarState extends ChangeNotifier {
  int year;
  int month;
  DateTime? selectedDate;
  Map<DateTime, CycleDayStatus> dayStatuses = {};
  bool hasData = false;

  _CalendarState() : year = DateTime.now().year, month = DateTime.now().month {
    selectedDate = DateTime.now();
    _loadData();
  }

  CycleDayStatus _stringToStatus(String? phase) {
    switch (phase) {
      case 'menstrual':
        return CycleDayStatus.period;
      case 'fertile':
        return CycleDayStatus.fertile;
      case 'ovulation':
        return CycleDayStatus.ovulation;
      default:
        return CycleDayStatus.none;
    }
  }

  void _loadData() {
    final now = DateTime.now();
    final periodStart = now.subtract(const Duration(days: 13));

    for (int i = 0; i < 5; i++) {
      final d = periodStart.add(Duration(days: i));
      dayStatuses[DateTime(d.year, d.month, d.day)] = CycleDayStatus.period;
    }

    final fertileStart = periodStart.add(const Duration(days: 9));
    for (int i = 0; i < 5; i++) {
      final d = fertileStart.add(Duration(days: i));
      dayStatuses[DateTime(d.year, d.month, d.day)] = CycleDayStatus.fertile;
    }

    final ovulationDay = periodStart.add(const Duration(days: 14));
    dayStatuses[DateTime(ovulationDay.year, ovulationDay.month, ovulationDay.day)] =
        CycleDayStatus.ovulation;

    hasData = true;
    notifyListeners();
  }

  void previousMonth() {
    if (month == 1) {
      month = 12;
      year--;
    } else {
      month--;
    }
    selectedDate = DateTime(year, month, 1);
    notifyListeners();
  }

  void nextMonth() {
    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
    selectedDate = DateTime(year, month, 1);
    notifyListeners();
  }

  void goToToday() {
    final now = DateTime.now();
    year = now.year;
    month = now.month;
    selectedDate = now;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  int cycleDayForDate(DateTime date) {
    if (date == selectedDate) return DateTime.now().day - date.day + 14;
    final start = DateTime.now().subtract(const Duration(days: 13));
    final diff = date.startOfDay.difference(start.startOfDay).inDays;
    return diff < 0 ? 0 : diff + 1;
  }

  CyclePhase phaseForDate(DateTime date) {
    final start = DateTime.now().subtract(const Duration(days: 13));
    final day = date.startOfDay.difference(start.startOfDay).inDays + 1;

    if (day >= 1 && day <= 5) return CyclePhase.menstrual;
    if (day >= 6 && day <= 13) return CyclePhase.follicular;
    if (day >= 14 && day <= 15) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  String phaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Your period is here. Rest and take care of yourself.';
      case CyclePhase.follicular:
        return 'Energy is building. A great time for new beginnings.';
      case CyclePhase.ovulation:
        return 'Peak fertility window. Your body is preparing for conception.';
      case CyclePhase.luteal:
        return 'Hormones are shifting. You may notice PMS symptoms.';
    }
  }

  int? get flowIntensity {
    if (selectedDate == null) return null;
    if (dayStatuses[DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day)] ==
        CycleDayStatus.period) {
      return 2;
    }
    return null;
  }

  List<String> get selectedSymptoms {
    if (selectedDate == null) return [];
    return ['cramps', 'fatigue'];
  }

  double? get temperature {
    if (selectedDate == null) return null;
    return 36.5;
  }

  String? get notes {
    if (selectedDate == null) return null;
    return null;
  }
}

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_calendarProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Calendar'),
        actions: [
          TextButton(
            onPressed: () => ref.read(_calendarProvider.notifier).goToToday(),
            child: Text(
              'Today',
              style: TextStyle(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: state.hasData
          ? _buildContent(context, state, ref, isDark)
          : _buildEmptyState(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, _CalendarState state, WidgetRef ref, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: CycleCalendar(
            year: state.year,
            month: state.month,
            dayStatuses: state.dayStatuses,
            selectedDate: state.selectedDate,
            onDaySelected: (date) => ref.read(_calendarProvider.notifier).selectDate(date),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildLegend(context, isDark),
        const SizedBox(height: AppSpacing.lg),
        if (state.selectedDate != null)
          _buildSelectedDayDetail(context, state, isDark, ref),
        const SizedBox(height: AppSpacing.xxl),
        Center(
          child:           Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton.secondary(
                'Previous',
                icon: Icons.chevron_left,
                onPressed: () => ref.read(_calendarProvider.notifier).previousMonth(),
              ),
              const SizedBox(width: AppSpacing.md),
              AppButton.secondary(
                'Next',
                icon: Icons.chevron_right,
                onPressed: () => ref.read(_calendarProvider.notifier).nextMonth(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(AppColors.error, 'Period', isDark),
        const SizedBox(width: AppSpacing.lg),
        _legendDot(AppColors.forestGreenLight, 'Fertile', isDark),
        const SizedBox(width: AppSpacing.lg),
        _legendDot(AppColors.softGold, 'Ovulation', isDark),
      ],
    );
  }

  Widget _legendDot(Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDayDetail(BuildContext context, _CalendarState state, bool isDark, WidgetRef ref) {
    final date = state.selectedDate!;
    final dayOfWeek = DateFormat('EEE').format(date);
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    final cycleDay = state.cycleDayForDate(date);
    final phase = state.phaseForDate(date);
    final flow = state.flowIntensity;
    final symptoms = state.selectedSymptoms;
    final temp = state.temperature;
    final notesText = state.notes;

    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day $cycleDay — $dayOfWeek, ${DateFormat('MMM d').format(date)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    CyclePhaseIndicator(
                      phase: phase,
                      size: CyclePhaseIndicatorSize.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            state.phaseDescription(phase),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.slate,
            ),
          ),
          if (flow != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Flow Intensity',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: LinearProgressIndicator(
                value: flow / 4,
                backgroundColor: AppColors.error.withValues(alpha: 0.15),
                color: AppColors.error.withValues(alpha: 0.6 + (flow * 0.1)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              CycleConstants.flowLabels[flow] ?? 'Medium',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.error.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (symptoms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Symptoms',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: symptoms.map((s) {
                return Chip(
                  label: Text(
                    s.capitalize,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.sage.withValues(alpha: 0.12),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
          if (temp != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Icon(
                  Icons.device_thermostat_rounded,
                  size: 18,
                  color: AppColors.slate,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Temperature: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                Text(
                  '${temp.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (notesText != null && notesText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.charcoal.withValues(alpha: 0.2)
                    : AppColors.warmIvory.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes_rounded,
                    size: 18,
                    color: AppColors.slate,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      notesText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton.secondary(
            'Log data for this day',
            icon: Icons.add_rounded,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LogPeriodScreen(initialDate: date),
              ),
            ),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
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
                Icons.calendar_month_rounded,
                size: 40,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'No entries yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Tap a day to log your first entry',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton.primary(
              'Log Your Period',
              icon: Icons.add_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LogPeriodScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
