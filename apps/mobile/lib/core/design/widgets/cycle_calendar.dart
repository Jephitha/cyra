import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

enum CycleDayStatus {
  period,
  fertile,
  ovulation,
  predictedPeriod,
  predictedFertile,
  predictedOvulation,
  none,
}

class CycleCalendar extends StatefulWidget {
  final int year;
  final int month;
  final Map<DateTime, CycleDayStatus> dayStatuses;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDaySelected;

  const CycleCalendar({
    super.key,
    required this.year,
    required this.month,
    this.dayStatuses = const {},
    this.selectedDate,
    this.onDaySelected,
  });

  @override
  State<CycleCalendar> createState() => _CycleCalendarState();
}

class _CycleCalendarState extends State<CycleCalendar> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    _year = widget.year;
    _month = widget.month;
  }

  @override
  void didUpdateWidget(CycleCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year || oldWidget.month != widget.month) {
      _year = widget.year;
      _month = widget.month;
    }
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
  }

  int _daysInMonth(int year, int month) {
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) return 29;
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) return 30;
    return 31;
  }

  int _firstWeekdayOffset(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    return firstDay.weekday % 7;
  }

  CycleDayStatus _statusForDate(DateTime date) {
    for (final entry in widget.dayStatuses.entries) {
      final key = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (key.year == date.year && key.month == date.month && key.day == date.day) {
        return entry.value;
      }
    }
    return CycleDayStatus.none;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    if (widget.selectedDate == null) return false;
    return date.year == widget.selectedDate!.year &&
        date.month == widget.selectedDate!.month &&
        date.day == widget.selectedDate!.day;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cycle calendar',
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.sm),
          _buildWeekdayHeaders(context),
          const SizedBox(height: AppSpacing.xs),
          _buildDaysGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final monthName = DateFormat('MMMM yyyy').format(DateTime(_year, _month));
    return Semantics(
      label: 'Calendar navigation',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            label: 'Previous month',
            child: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _previousMonth,
              tooltip: 'Previous month',
            ),
          ),
          Text(
            monthName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Semantics(
            label: 'Next month',
            child: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _nextMonth,
              tooltip: 'Next month',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    const headers = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Semantics(
      label: 'Weekday headers',
      child: Row(
        children: headers.map((day) {
          return Expanded(
            child: Center(
              child: Semantics(
                label: day,
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDaysGrid(BuildContext context) {
    final daysInMonth = _daysInMonth(_year, _month);
    final offset = _firstWeekdayOffset(_year, _month);
    final totalCells = offset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Semantics(
      label: 'Days grid',
      child: Column(
        children: List.generate(
          rows,
          (rowIndex) {
            return Row(
              children: List.generate(
                7,
                (colIndex) {
                  final cellIndex = rowIndex * 7 + colIndex;
                  final day = cellIndex - offset + 1;

                  if (day < 1 || day > daysInMonth) {
                    return Expanded(child: Container());
                  }

                  final date = DateTime(_year, _month, day);
                  final status = _statusForDate(date);
                  final isToday = _isToday(date);
                  final isSelected = _isSelected(date);

                  return Expanded(
                    child: _CalendarDayCell(
                      day: day,
                      status: status,
                      isToday: isToday,
                      isSelected: isSelected,
                      onTap: () => widget.onDaySelected?.call(date),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final int day;
  final CycleDayStatus status;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.day,
    required this.status,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasStatus = status != CycleDayStatus.none;
    final isPredicted = status == CycleDayStatus.predictedPeriod ||
        status == CycleDayStatus.predictedFertile ||
        status == CycleDayStatus.predictedOvulation;

    return Semantics(
      label: 'Day $day${hasStatus ? ', ${status.name}' : ''}${isToday ? ', today' : ''}',
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: _fillColor(context, hasStatus, isPredicted),
                shape: BoxShape.circle,
                border: isPredicted
                    ? Border.all(
                        color: _statusColor(context).withValues(alpha: 0.6),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: _textColor(context, hasStatus, isPredicted),
                      ),
                    ),
                    if (isToday && !isSelected)
                      Positioned(
                        bottom: 2,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    if (isSelected)
                      Positioned(
                        bottom: 2,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context) {
    switch (status) {
      case CycleDayStatus.period:
      case CycleDayStatus.predictedPeriod:
        return AppColors.error;
      case CycleDayStatus.fertile:
      case CycleDayStatus.predictedFertile:
        return AppColors.forestGreenLight;
      case CycleDayStatus.ovulation:
      case CycleDayStatus.predictedOvulation:
        return AppColors.softGold;
      case CycleDayStatus.none:
        return Colors.transparent;
    }
  }

  Color? _fillColor(BuildContext context, bool hasStatus, bool isPredicted) {
    if (isSelected) return Theme.of(context).colorScheme.primary;
    if (!hasStatus) return null;

    final color = _statusColor(context);
    if (isPredicted || status == CycleDayStatus.predictedPeriod ||
        status == CycleDayStatus.predictedFertile ||
        status == CycleDayStatus.predictedOvulation) {
      return color.withValues(alpha: 0.15);
    }
    if (status == CycleDayStatus.ovulation) {
      return color.withValues(alpha: 0.25);
    }
    if (status == CycleDayStatus.fertile) {
      return color.withValues(alpha: 0.2);
    }
    return color.withValues(alpha: 0.85);
  }

  Color _textColor(BuildContext context, bool hasStatus, bool isPredicted) {
    if (isSelected) return Colors.white;
    if (!hasStatus || isPredicted) return Theme.of(context).colorScheme.onSurface;
    if (status == CycleDayStatus.period) return Colors.white;
    if (status == CycleDayStatus.ovulation) return AppColors.softGoldDark;
    if (status == CycleDayStatus.fertile) return AppColors.forestGreen;
    return Theme.of(context).colorScheme.onSurface;
  }
}
