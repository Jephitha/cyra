import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/cycle_calendar.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';

class OvulationCalendarScreen extends ConsumerWidget {
  const OvulationCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleAsync = ref.watch(activeCycleProvider);
    final fertileWindowAsync = ref.watch(fertileWindowProvider);

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
        return _OvulationCalendarBody(
          activeCycle: activeCycle,
          fertileWindow: fertileWindowAsync.valueOrNull,
          isDark: isDark,
        );
      },
    );
  }
}

class _OvulationCalendarBody extends ConsumerStatefulWidget {
  final Cycle activeCycle;
  final FertileWindow? fertileWindow;
  final bool isDark;

  const _OvulationCalendarBody({
    required this.activeCycle,
    required this.fertileWindow,
    required this.isDark,
  });

  @override
  ConsumerState<_OvulationCalendarBody> createState() =>
      _OvulationCalendarBodyState();
}

class _OvulationCalendarBodyState
    extends ConsumerState<_OvulationCalendarBody> {
  late int _year;
  late int _month;
  DateTime? _selectedDate;

  final Map<DateTime, CycleDayStatus> _dayStatuses = {};
  final Map<DateTime, double?> _temperatures = {};
  final Map<DateTime, String?> _opkResults = {};
  final Map<DateTime, String?> _mucusTypes = {};
  DateTime? _lastPeriodStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _selectedDate = now;
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(ovulationRepositoryProvider);
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    _lastPeriodStart = widget.activeCycle.startDate;

    final bbtData = await repo.getBBTForCycle(widget.activeCycle.id);
    final opkData = await repo.getOPKRange(
      widget.activeCycle.startDate,
      widget.activeCycle.endDate ?? DateTime.now(),
    );
    final mucusData = await repo.getMucusRange(
      widget.activeCycle.startDate,
      widget.activeCycle.endDate ?? DateTime.now(),
    );
    final cycleDays = await ref.read(
      cycleDaysProvider(widget.activeCycle.id).future,
    );

    final fertileStart = widget.fertileWindow?.windowStart;
    final fertileEnd = widget.fertileWindow?.windowEnd;
    final ovulationDate = widget.fertileWindow?.ovulationDate;

    if (!mounted) return;

    setState(() {
      _dayStatuses.clear();
      _temperatures.clear();
      _opkResults.clear();
      _mucusTypes.clear();

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(_year, _month, day);
        final loggedCycleDay = cycleDays
            .where((entry) => entry.date.isSameDay(date))
            .firstOrNull;

        CycleDayStatus status;
        if (loggedCycleDay != null &&
            (loggedCycleDay.flowIntensity > 0 || loggedCycleDay.spotting)) {
          status = CycleDayStatus.period;
        } else if (ovulationDate?.isSameDay(date) ?? false) {
          status = CycleDayStatus.ovulation;
        } else if (fertileStart != null &&
            fertileEnd != null &&
            !date.isBefore(fertileStart) &&
            !date.isAfter(fertileEnd)) {
          status = CycleDayStatus.fertile;
        } else {
          status = CycleDayStatus.none;
        }
        _dayStatuses[date] = status;

        // BBT
        final bbtForDay = bbtData.where((b) => b.date.isSameDay(date)).toList();
        _temperatures[date] = bbtForDay.isNotEmpty
            ? bbtForDay.first.temperature
            : null;

        // OPK
        final opkForDay = opkData.where((o) => o.date.isSameDay(date)).toList();
        _opkResults[date] = opkForDay.isNotEmpty
            ? (opkForDay.first.result == OPKResult.positive
                  ? 'Positive'
                  : 'Negative')
            : null;

        // Mucus
        final mucusForDay = mucusData
            .where((m) => m.date.isSameDay(date))
            .toList();
        _mucusTypes[date] = mucusForDay.isNotEmpty
            ? mucusForDay.first.type.name
            : null;
      }
    });
  }

  void _previousMonth() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year--;
      } else {
        _month--;
      }
    });
    _loadData();
  }

  void _nextMonth() {
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year++;
      } else {
        _month++;
      }
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ovulation Calendar',
          style: TextStyle(
            color: widget.isDark
                ? AppColors.textPrimaryDark
                : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildCalendar(context),
          const SizedBox(height: AppSpacing.lg),
          if (_selectedDate != null) _buildDayDetail(context),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildMonthHeader(context),
          CycleCalendar(
            year: _year,
            month: _month,
            selectedDate: _selectedDate,
            onDaySelected: (date) => setState(() => _selectedDate = date),
            dayStatuses: _dayStatuses,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    final monthName = DateFormat('MMMM yyyy').format(DateTime(_year, _month));
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          Text(
            monthName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetail(BuildContext context) {
    final day = _selectedDate!;
    final cycleDay = _lastPeriodStart != null
        ? day.dayOfCycle(_lastPeriodStart!)
        : null;
    final temp = _temperatures[day];
    final opk = _opkResults[day];
    final mucus = _mucusTypes[day];
    final status = _dayStatuses[day];

    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                DateFormat('EEEE, MMMM d').format(day),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (day.isSameDay(DateTime.now())) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (cycleDay != null) ...[
            _detailRow(context, 'Cycle Day', 'Day $cycleDay'),
            _detailRow(context, 'Status', status?.name ?? 'none'),
          ],
          if (temp != null)
            _detailRow(context, 'Temperature', '${temp.toStringAsFixed(1)}°C'),
          if (opk != null) _detailRow(context, 'OPK', opk),
          if (mucus != null) _detailRow(context, 'Mucus', mucus),
          if (temp == null && opk == null && mucus == null)
            Text(
              'No ovulation data logged for this day',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
