import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/cycle_calendar.dart';
import 'package:cyra/core/utils/extensions.dart';

class _DayDetail {
  final DateTime date;
  final CycleDayStatus status;
  final double? temperature;
  final String? opkResult;
  final String? mucusType;
  final String? dayLabel;

  const _DayDetail({
    required this.date,
    required this.status,
    this.temperature,
    this.opkResult,
    this.mucusType,
    this.dayLabel,
  });
}

class OvulationCalendarScreen extends StatefulWidget {
  const OvulationCalendarScreen({super.key});

  @override
  State<OvulationCalendarScreen> createState() => _OvulationCalendarScreenState();
}

class _OvulationCalendarScreenState extends State<OvulationCalendarScreen> {
  late int _year;
  late int _month;
  DateTime? _selectedDate;

  Map<DateTime, CycleDayStatus> _dayStatuses = {};
  List<_DayDetail> _dayDetails = [];
  int currentCycleDay = 14;
  int cycleLength = 28;
  DateTime? lastPeriodStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _selectedDate = now;
    _loadData();
  }

  void _loadData() {
    lastPeriodStart = DateTime.now().subtract(const Duration(days: 13));
    final now = DateTime.now();

    _dayStatuses = {};
    _dayDetails = [];

    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final fertileStart = 8;
    final fertileEnd = 19;
    final ovulationDay = cycleLength - 14;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_year, _month, day);
      final cycleDay = lastPeriodStart != null ? date.dayOfCycle(lastPeriodStart!) : day;

      CycleDayStatus status;
      if (cycleDay >= 1 && cycleDay <= 5) {
        status = CycleDayStatus.period;
      } else if (cycleDay == ovulationDay) {
        status = CycleDayStatus.ovulation;
      } else if (cycleDay >= fertileStart && cycleDay <= fertileEnd) {
        status = CycleDayStatus.fertile;
      } else {
        status = CycleDayStatus.none;
      }

      _dayStatuses[date] = status;

      String? label;
      if (cycleDay == now.dayOfCycle(lastPeriodStart ?? now)) {
        label = 'Today';
      } else if (cycleDay == ovulationDay) {
        label = 'Ovulation Day';
      } else if (cycleDay >= fertileStart && cycleDay <= fertileEnd) {
        label = 'Fertile';
      }

      _dayDetails.add(_DayDetail(
        date: date,
        status: status,
        temperature: day % 3 == 0 ? 36.4 + (day % 7) * 0.1 : null,
        opkResult: cycleDay >= 8 && cycleDay <= 12 ? 'Positive' : null,
        mucusType: cycleDay == ovulationDay
            ? 'Egg White'
            : cycleDay == ovulationDay - 1
                ? 'Watery'
                : cycleDay >= fertileStart && cycleDay <= fertileEnd
                    ? 'Creamy'
                    : null,
        dayLabel: label,
      ));
    }
  }

  void _onMonthChanged(bool next) {
    setState(() {
      if (next) {
        if (_month == 12) {
          _month = 1;
          _year++;
        } else {
          _month++;
        }
      } else {
        if (_month == 1) {
          _month = 12;
          _year--;
        } else {
          _month--;
        }
      }
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cycle Calendar',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildCalendar(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          if (_selectedDate != null) _buildDayDetailCard(context, _selectedDate!, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildLegend(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _onMonthChanged(false),
                tooltip: 'Previous month',
              ),
              Text(
                DateFormat('MMMM yyyy').format(DateTime(_year, _month)),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _onMonthChanged(true),
                tooltip: 'Next month',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          CycleCalendar(
            year: _year,
            month: _month,
            dayStatuses: _dayStatuses,
            selectedDate: _selectedDate,
            onDaySelected: (date) {
              setState(() => _selectedDate = date);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetailCard(BuildContext context, DateTime date, bool isDark) {
    final detail = _dayDetails.firstWhere(
      (d) => d.date.isSameDay(date),
      orElse: () => _DayDetail(date: date, status: CycleDayStatus.none),
    );

    final cycleDay = lastPeriodStart != null ? date.dayOfCycle(lastPeriodStart!) : date.day;
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(date);
    final isToday = date.isSameDay(DateTime.now());

    return AppCard.highlighted(
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
                      dateStr,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Text(
                          'Cycle Day $cycleDay',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.forestGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.forestGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            child: Text(
                              'Today',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.forestGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _statusBadge(context, detail.status, isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _detailItem(
                context,
                Icons.device_thermostat_rounded,
                'BBT',
                detail.temperature != null
                    ? '${detail.temperature!.toStringAsFixed(1)}°C'
                    : '—',
                isDark,
              ),
              const SizedBox(width: AppSpacing.md),
              _detailItem(
                context,
                Icons.science_outlined,
                'OPK',
                detail.opkResult ?? '—',
                isDark,
              ),
              const SizedBox(width: AppSpacing.md),
              _detailItem(
                context,
                Icons.blur_circular_rounded,
                'Mucus',
                detail.mucusType ?? '—',
                isDark,
              ),
            ],
          ),
          if (detail.dayLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _statusColor(detail.status).withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: _statusColor(detail.status).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _dayDescription(detail.status, cycleDay),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _statusColor(detail.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.mistWhite,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.slate),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(BuildContext context, CycleDayStatus status, bool isDark) {
    final color = _statusColor(status);
    String label;
    switch (status) {
      case CycleDayStatus.period:
        label = 'Period';
      case CycleDayStatus.fertile:
        label = 'Fertile';
      case CycleDayStatus.ovulation:
        label = 'Ovulation';
      case CycleDayStatus.none:
        label = 'Non-fertile';
      default:
        label = 'Predicted';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _statusColor(CycleDayStatus status) {
    switch (status) {
      case CycleDayStatus.period:
      case CycleDayStatus.predictedPeriod:
        return const Color(0xFFE86B6B);
      case CycleDayStatus.fertile:
      case CycleDayStatus.predictedFertile:
        return AppColors.forestGreenLight;
      case CycleDayStatus.ovulation:
      case CycleDayStatus.predictedOvulation:
        return AppColors.softGold;
      case CycleDayStatus.none:
        return AppColors.slate;
    }
  }

  String _dayDescription(CycleDayStatus status, int cycleDay) {
    switch (status) {
      case CycleDayStatus.period:
        return 'Menstrual phase — Day $cycleDay of your cycle.';
      case CycleDayStatus.fertile:
        return 'Fertile window — Consider using protection if avoiding pregnancy.';
      case CycleDayStatus.ovulation:
        return 'Ovulation day — Peak fertility. Best chance for conception today.';
      case CycleDayStatus.predictedPeriod:
        return 'Period predicted around this date based on your cycle history.';
      case CycleDayStatus.predictedFertile:
        return 'Fertile window predicted in this range based on your cycle data.';
      case CycleDayStatus.predictedOvulation:
        return 'Ovulation predicted around this date. Track your signs to confirm.';
      case CycleDayStatus.none:
        return 'Non-fertile phase of your cycle.';
    }
  }

  Widget _buildLegend(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _legendDot(context, const Color(0xFFE86B6B), 'Period', isDark),
              _legendDot(context, AppColors.forestGreenLight, 'Fertile', isDark),
              _legendDot(context, AppColors.softGold, 'Ovulation', isDark),
              _legendDot(context, AppColors.slate, 'Non-fertile', isDark),
              _legendDot(context, AppColors.forestGreen.withValues(alpha: 0.5), 'Predicted', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(BuildContext context, Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }
}
