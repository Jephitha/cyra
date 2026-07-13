import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

class FlowIntensityPicker extends StatelessWidget {
  final int? selectedValue;
  final ValueChanged<int>? onChanged;

  const FlowIntensityPicker({
    super.key,
    this.selectedValue,
    this.onChanged,
  });

  static const _flowLabels = ['Light', 'Medium', 'Heavy', 'Very Heavy'];
  static const _flowIcons = [
    Icons.water_drop_outlined,
    Icons.water_drop_outlined,
    Icons.water_drop,
    Icons.water,
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Flow intensity picker',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4,
            (index) {
              final value = index + 1;
              final isSelected = selectedValue == value;
              return _PickerOption(
                label: _flowLabels[index],
                icon: _flowIcons[index],
                isSelected: isSelected,
                selectedColor: AppColors.error,
                onTap: () => onChanged?.call(value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SymptomSeverityPicker extends StatelessWidget {
  final int? selectedValue;
  final ValueChanged<int>? onChanged;

  const SymptomSeverityPicker({
    super.key,
    this.selectedValue,
    this.onChanged,
  });

  static const _severityLabels = ['Mild', 'Moderate', 'Severe'];
  static const _severityColors = [
    AppColors.forestGreen,
    AppColors.softGold,
    AppColors.error,
  ];
  static const _severityIcons = [
    Icons.sentiment_satisfied_outlined,
    Icons.sentiment_neutral_outlined,
    Icons.sentiment_dissatisfied_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Symptom severity picker',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            3,
            (index) {
              final value = index + 1;
              final isSelected = selectedValue == value;
              final color = _severityColors[index];
              return _PickerOption(
                label: _severityLabels[index],
                icon: _severityIcons[index],
                isSelected: isSelected,
                selectedColor: color,
                unselectedColor: color,
                onTap: () => onChanged?.call(value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DateRangePicker extends StatefulWidget {
  final DateTime? from;
  final DateTime? to;
  final ValueChanged<DateTime>? onFromChanged;
  final ValueChanged<DateTime>? onToChanged;

  const DateRangePicker({
    super.key,
    this.from,
    this.to,
    this.onFromChanged,
    this.onToChanged,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom
        ? widget.from ?? DateTime.now().subtract(const Duration(days: 28))
        : widget.to ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
      helpText: isFrom ? 'Select start date' : 'Select end date',
    );

    if (picked == null) return;

    if (isFrom) {
      if (widget.to != null && picked.isAfter(widget.to!)) {
        _showRangeError();
        return;
      }
      widget.onFromChanged?.call(picked);
    } else {
      if (widget.from != null && picked.isBefore(widget.from!)) {
        _showRangeError();
        return;
      }
      widget.onToChanged?.call(picked);
    }
  }

  void _showRangeError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('End date must be after start date'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return Semantics(
      label: 'Date range picker',
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'From date',
              child: _DateField(
                label: 'From',
                date: widget.from,
                displayText: widget.from != null
                    ? dateFormat.format(widget.from!)
                    : 'Select date',
                onTap: () => _pickDate(isFrom: true),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Icon(
              Icons.arrow_forward,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'To date',
              child: _DateField(
                label: 'To',
                date: widget.to,
                displayText: widget.to != null
                    ? dateFormat.format(widget.to!)
                    : 'Select date',
                onTap: () => _pickDate(isFrom: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String displayText;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.displayText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              displayText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: date != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay>? onChanged;

  const TimePicker({
    super.key,
    this.selectedTime,
    this.onChanged,
  });

  static const _times = [
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 6, minute: 30),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 7, minute: 30),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 8, minute: 30),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 9, minute: 30),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 22, minute: 0),
  ];

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Time picker',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _times.map(
            (time) {
              final isSelected = selectedTime != null &&
                  selectedTime!.hour == time.hour &&
                  selectedTime!.minute == time.minute;
              return _PickerOption(
                label: _formatTimeOfDay(time),
                isSelected: isSelected,
                selectedColor: AppColors.forestGreen,
                onTap: () => onChanged?.call(time),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final Color selectedColor;
  final Color? unselectedColor;
  final VoidCallback onTap;

  const _PickerOption({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.selectedColor,
    this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isSelected
        ? selectedColor
        : (unselectedColor ?? Theme.of(context).colorScheme.onSurface).withValues(alpha: 0.3);
    final bgColor = isSelected
        ? selectedColor.withValues(alpha: isDark ? 0.3 : 0.12)
        : Colors.transparent;
    final textColor = isSelected
        ? (isDark ? AppColors.onBrand : selectedColor)
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Semantics(
        label: '$label${isSelected ? ', selected' : ''}',
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
