import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';

class LogIntercourseScreen extends StatefulWidget {
  const LogIntercourseScreen({super.key});

  @override
  State<LogIntercourseScreen> createState() => _LogIntercourseScreenState();
}

class _LogIntercourseScreenState extends State<LogIntercourseScreen> {
  DateTime _selectedDate = DateTime.now();
  String _timeOfDay = 'Evening';
  bool _unprotected = true;
  final TextEditingController _notesController = TextEditingController();

  int currentCycleDay = 14;
  int cycleLength = 28;

  final List<String> _timeOptions = ['Morning', 'Afternoon', 'Evening'];

  bool get _isInFertileWindow {
    final ovulationDay = cycleLength - 14;
    return currentCycleDay >= ovulationDay - 5 && currentCycleDay <= ovulationDay + 1;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Select date',
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
      setState(() => _selectedDate = picked);
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
            'Log Intercourse',
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
            _buildCycleDayBanner(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildDatePicker(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildTimePicker(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildUnprotectedToggle(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildNotesField(context, isDark),
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

  Widget _buildCycleDayBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isInFertileWindow
              ? AppColors.forestGreen.withValues(alpha: 0.3)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        color: _isInFertileWindow
            ? AppColors.forestGreen.withValues(alpha: 0.06)
            : (isDark ? AppColors.charcoal.withValues(alpha: 0.15) : AppColors.mistWhite),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: _isInFertileWindow ? AppColors.forestGreen : AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cycle Day $currentCycleDay',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Fertile window: ${_isInFertileWindow ? "open" : "closed"}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _isInFertileWindow ? AppColors.forestGreen : AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
            decoration: BoxDecoration(
              color: (_isInFertileWindow ? AppColors.forestGreen : AppColors.slate)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Text(
              _isInFertileWindow ? 'Fertile' : 'Not Fertile',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _isInFertileWindow ? AppColors.forestGreen : AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isDark) {
    return InkWell(
      onTap: _pickDate,
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
            Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    DateFormat('MMMM d, yyyy').format(_selectedDate),
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

  Widget _buildTimePicker(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time of Day',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _timeOptions.map((time) {
              final isSelected = _timeOfDay == time;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => setState(() => _timeOfDay = time),
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
                      time,
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

  Widget _buildUnprotectedToggle(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _unprotected ? Icons.favorite_rounded : Icons.shield_outlined,
            size: 20,
            color: _unprotected ? const Color(0xFFE86B6B) : AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unprotected',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _unprotected
                      ? 'No contraception used'
                      : 'Protection was used',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _unprotected,
            onChanged: (val) => setState(() => _unprotected = val),
            activeTrackColor: AppColors.forestGreen,
            inactiveThumbColor: AppColors.slate,
          ),
        ],
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
}
