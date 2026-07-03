import 'dart:convert';

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
import 'package:cyra/core/prediction/cycle_predictor.dart';
import 'package:cyra/core/prediction/ovulation_detector.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart' as models;
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _year = now.year;
      _month = now.month;
      _selectedDate = now;
    });
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  Map<DateTime, CycleDayStatus> _buildDayStatuses(
    models.Cycle activeCycle,
    List<models.CycleDay> cycleDays,
    int cycleLength,
  ) {
    final statuses = <DateTime, CycleDayStatus>{};

    for (final day in cycleDays) {
      final d = DateTime(day.date.year, day.date.month, day.date.day);
      if (day.flowIntensity > 0 || day.spotting) {
        statuses[d] = CycleDayStatus.period;
      }
    }

    final detector = OvulationDetector();
    final (fertileStart, fertileEnd) = detector.calculateFertileWindow(
      periodStart: activeCycle.startDate,
      cycleLength: cycleLength,
    );

    final ovulationDate = fertileEnd;

    for (DateTime d = fertileStart;
        !d.isAfter(fertileEnd);
        d = d.add(const Duration(days: 1))) {
      final key = DateTime(d.year, d.month, d.day);
      if (statuses[key] == null) {
        statuses[key] = CycleDayStatus.fertile;
      }
    }

    final ovKey = DateTime(
      ovulationDate.year,
      ovulationDate.month,
      ovulationDate.day,
    );
    if (statuses[ovKey] == CycleDayStatus.fertile) {
      statuses[ovKey] = CycleDayStatus.ovulation;
    }

    final nextStart = activeCycle.startDate
        .add(Duration(days: cycleLength));
    final nextEnd = nextStart.add(const Duration(days: 5));
    for (DateTime d = nextStart;
        !d.isAfter(nextEnd);
        d = d.add(const Duration(days: 1))) {
      final key = DateTime(d.year, d.month, d.day);
      if (statuses[key] == null) {
        statuses[key] = CycleDayStatus.predictedPeriod;
      }
    }

    return statuses;
  }

  int _cycleDayForDate(DateTime date, models.Cycle activeCycle) {
    final diff = date.startOfDay.difference(activeCycle.startDate.startOfDay).inDays;
    return diff < 0 ? 0 : diff + 1;
  }

  CyclePhase _phaseForDate(int cycleDay, int cycleLength) {
    final predictor = CyclePredictor();
    return _mapPhase(predictor.getCyclePhase(cycleDay, cycleLength));
  }

  CyclePhase _mapPhase(models.CyclePhase phase) {
    return switch (phase) {
      models.CyclePhase.menstrual => CyclePhase.menstrual,
      models.CyclePhase.follicular => CyclePhase.follicular,
      models.CyclePhase.ovulation => CyclePhase.ovulation,
      models.CyclePhase.luteal => CyclePhase.luteal,
    };
  }

  String _phaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Your period is here. Rest and take care of yourself.';
      case CyclePhase.follicular:
        return 'Energy is building. A great time for new beginnings.';
      case CyclePhase.ovulation:
        return 'Peak fertility window. Your body is preparing for conception.';
      case CyclePhase.luteal:
        return 'Hormones are shifting. You may notice mood changes, bloating, or soreness in the days before your period.';
    }
  }

  List<String> _parseSymptoms(String? symptomsJson) {
    if (symptomsJson == null || symptomsJson.isEmpty) return [];
    try {
      final list = jsonDecode(symptomsJson) as List<dynamic>;
      return list.cast<String>();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeCycleAsync = ref.watch(activeCycleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Calendar'),
        actions: [
          TextButton(
            onPressed: _goToToday,
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
      body: activeCycleAsync.when(
        loading: () => const Center(child: Text('Loading...')),
        error: (_, __) => _buildEmptyState(context),
        data: (activeCycle) {
          if (activeCycle == null) return _buildEmptyState(context);
          final summary = ref.watch(cycleSummaryProvider).valueOrNull;
          return _buildContent(context, isDark, activeCycle, summary);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isDark,
    models.Cycle activeCycle,
    models.CycleSummary? summary,
  ) {
    final cycleLength = summary != null && summary.averageLength > 0
        ? summary.averageLength.round()
        : activeCycle.cycleLength;

    final cycleDaysAsync = ref.watch(cycleDaysProvider(activeCycle.id));
    final cycleDays = cycleDaysAsync.valueOrNull ?? [];

    final dayStatuses = _buildDayStatuses(activeCycle, cycleDays, cycleLength);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: CycleCalendar(
            year: _year,
            month: _month,
            dayStatuses: dayStatuses,
            selectedDate: _selectedDate,
            onDaySelected: _selectDate,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildLegend(context, isDark),
        const SizedBox(height: AppSpacing.lg),
        if (_selectedDate != null)
          _buildSelectedDayDetail(
            context,
            isDark,
            activeCycle,
            cycleLength,
            cycleDays,
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

  Widget _buildSelectedDayDetail(
    BuildContext context,
    bool isDark,
    models.Cycle activeCycle,
    int cycleLength,
    List<models.CycleDay> cycleDays,
  ) {
    final date = _selectedDate!;
    final dayOfWeek = DateFormat('EEE').format(date);
    final cycleDay = _cycleDayForDate(date, activeCycle);
    final phase = _phaseForDate(cycleDay, cycleLength);

    final dayData = cycleDays
        .where((d) => d.date.startOfDay == date.startOfDay)
        .toList();

    final flow = dayData.isNotEmpty ? dayData.first.flowIntensity : null;
    final spotting = dayData.isNotEmpty ? dayData.first.spotting : false;
    final symptoms = dayData.isNotEmpty
        ? _parseSymptoms(dayData.first.symptomsJson)
        : <String>[];
    final temp = dayData.isNotEmpty ? dayData.first.temperature : null;
    final notesText = dayData.isNotEmpty ? dayData.first.notes : null;

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
            _phaseDescription(phase),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
            ),
          ),
          if (flow != null && flow > 0) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Flow Intensity',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
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
          if (spotting) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Spotting',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
              ),
            ),
          ],
          if (symptoms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Symptoms',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
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
                  color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Temperature: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
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
                    color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
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
              MaterialPageRoute<void>(
                builder: (_) => LogPeriodScreen(initialDate: date),
              ),
            ),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              'Log your first period to see your cycle calendar',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
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
          ],
        ),
      ),
    );
  }
}
