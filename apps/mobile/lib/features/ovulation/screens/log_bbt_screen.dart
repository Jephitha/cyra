import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';

class LogBBTScreen extends StatefulWidget {
  const LogBBTScreen({super.key});

  @override
  State<LogBBTScreen> createState() => _LogBBTScreenState();
}

class _LogBBTScreenState extends State<LogBBTScreen> {
  String _temperatureString = '36.7';
  String _measurementMethod = 'Oral';
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _notesController = TextEditingController();

  final List<String> _measurementMethods = [
    'Oral',
    'Vaginal',
    'Armpit',
    'Wearable',
  ];

  final List<BBTDataPoint> _recentData = [
    BBTDataPoint(date: DateTime(2026, 3, 1), temperature: 36.3),
    BBTDataPoint(date: DateTime(2026, 3, 2), temperature: 36.4),
    BBTDataPoint(date: DateTime(2026, 3, 3), temperature: 36.3),
    BBTDataPoint(date: DateTime(2026, 3, 4), temperature: 36.5),
    BBTDataPoint(date: DateTime(2026, 3, 5), temperature: 36.4),
    BBTDataPoint(date: DateTime(2026, 3, 6), temperature: 36.3),
    BBTDataPoint(date: DateTime(2026, 3, 7), temperature: 36.5),
    BBTDataPoint(date: DateTime(2026, 3, 8), temperature: 36.4),
    BBTDataPoint(date: DateTime(2026, 3, 9), temperature: 36.6),
    BBTDataPoint(date: DateTime(2026, 3, 10), temperature: 36.5),
    BBTDataPoint(date: DateTime(2026, 3, 11), temperature: 36.7),
    BBTDataPoint(date: DateTime(2026, 3, 12), temperature: 36.8),
    BBTDataPoint(date: DateTime(2026, 3, 13), temperature: 36.9),
    BBTDataPoint(date: DateTime(2026, 3, 14), temperature: 36.8),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    setState(() {
      if (_temperatureString.length < 5) {
        final cleaned = _temperatureString.replaceAll('.', '');
        final updated = cleaned + digit;
        if (updated.length >= 3) {
          _temperatureString =
              '${updated.substring(0, updated.length - 2)}.${updated.substring(updated.length - 2)}';
        } else {
          _temperatureString = updated;
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_temperatureString.length <= 4) {
        _temperatureString = '36.7';
      } else {
        final cleaned = _temperatureString.replaceAll('.', '');
        final updated = cleaned.substring(0, cleaned.length - 1);
        if (updated.length >= 3) {
          _temperatureString =
              '${updated.substring(0, updated.length - 2)}.${updated.substring(updated.length - 2)}';
        } else if (updated.length == 2) {
          _temperatureString = '0.$updated';
        } else if (updated.length == 1) {
          _temperatureString = '0.0$updated';
        } else {
          _temperatureString = '36.7';
        }
      }
    });
  }

  void _save() {
    Navigator.of(context).pop();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.forestGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Log BBT',
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
            _buildTemperatureDisplay(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildNumberPad(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildMeasurementMethod(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildTimePicker(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildNotesField(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildTipsSection(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildChartPreview(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              'Save',
              icon: Icons.save_rounded,
              onPressed: _save,
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureDisplay(BuildContext context, bool isDark) {
    return Semantics(
      label: 'Temperature: $_temperatureString degrees Celsius',
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.charcoal.withValues(alpha: 0.3)
                  : AppColors.warmIvory.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              children: [
                Text(
                  'Temperature',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: (Theme.of(context).textTheme.displayLarge ??
                          const TextStyle(fontSize: 48))
                      .copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w300,
                    height: 1.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_temperatureString),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '°C',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.slate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(BuildContext context, bool isDark) {
    return Semantics(
      label: 'Temperature number pad',
      child: Column(
        children: [
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
            ['', '0', 'del'],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((digit) {
                  if (digit == 'del') {
                    return _NumberPadButton(
                      label: Icons.backspace_outlined,
                      isIcon: true,
                      onPressed: _onDeletePressed,
                    );
                  }
                  if (digit.isEmpty) {
                    return const SizedBox(width: 72, height: 56);
                  }
                  return _NumberPadButton(
                    label: digit,
                    onPressed: () => _onDigitPressed(digit),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMeasurementMethod(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Measurement Method',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _measurementMethods.map((method) {
              final isSelected = _measurementMethod == method;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => setState(() => _measurementMethod = method),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.forestGreen.withValues(alpha: isDark ? 0.3 : 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.forestGreen
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      method,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.forestGreen)
                            : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isDark) {
    final timeString = _selectedTime.format(context);
    return InkWell(
      onTap: _pickTime,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, size: 20, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    timeString,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppColors.slate),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField(BuildContext context, bool isDark) {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Add notes (optional)',
        prefixIcon: Icon(Icons.edit_note_rounded, size: 20, color: AppColors.slate),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildTipsSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: isDark ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 20, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for accurate BBT',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Measure at the same time each day before getting out of bed. '
                  'Aim for at least 3-4 hours of uninterrupted sleep beforehand.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPreview(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Trend',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard.chart(
          child: BBTChart(
            dataPoints: _recentData,
            height: 140,
            showLegend: false,
          ),
        ),
      ],
    );
  }
}

class _NumberPadButton extends StatelessWidget {
  final dynamic label;
  final bool isIcon;
  final VoidCallback onPressed;

  const _NumberPadButton({
    required this.label,
    this.isIcon = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Semantics(
        button: true,
        label: isIcon ? 'Delete' : 'Digit $label',
        child: Material(
          color: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.mistWhite,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadius.md),
            splashColor: AppColors.forestGreen.withValues(alpha: 0.1),
            highlightColor: AppColors.forestGreen.withValues(alpha: 0.05),
            child: Container(
              width: 72,
              height: 56,
              alignment: Alignment.center,
              child: isIcon
                  ? Icon(label as IconData, size: 22, color: AppColors.slate)
                  : Text(
                      '$label',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
