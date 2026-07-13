import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';
import 'package:cyra/features/pregnancy/providers/pregnancy_providers.dart';

class LogVitalsScreen extends ConsumerStatefulWidget {
  final String? initialSection;

  const LogVitalsScreen({super.key, this.initialSection});

  @override
  ConsumerState<LogVitalsScreen> createState() => _LogVitalsScreenState();
}

class _LogVitalsScreenState extends ConsumerState<LogVitalsScreen> {
  late String _activeSection;

  final _weightController = TextEditingController();
  bool _useLbs = false;

  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  final _glucoseController = TextEditingController();
  bool _glucoseFasting = true;
  final bool _useMgDl = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _notesController = TextEditingController();
  bool _isSaving = false;

  final List<String> _sections = ['weight', 'blood_pressure', 'glucose'];

  String _sectionLabel(String s) => switch (s) {
    'weight' => 'Weight',
    'blood_pressure' => 'Blood Pressure',
    'glucose' => 'Glucose',
    _ => 'Vitals',
  };

  @override
  void initState() {
    super.initState();
    _activeSection = widget.initialSection ?? 'weight';
  }

  @override
  void dispose() {
    _weightController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _glucoseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final pregnancy = ref.read(currentPregnancyProvider).valueOrNull;
      if (pregnancy == null) {
        if (mounted) {
          setState(() => _isSaving = false);
          context.showSnackBar('No active pregnancy found', isError: true);
        }
        return;
      }

      final repo = ref.read(pregnancyRepositoryProvider);
      final now = DateTime.now();
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final weight = double.tryParse(_weightController.text);
      final systolic = int.tryParse(_systolicController.text);
      final diastolic = int.tryParse(_diastolicController.text);
      final glucose = double.tryParse(_glucoseController.text);

      if (weight == null &&
          systolic == null &&
          diastolic == null &&
          glucose == null) {
        if (mounted) {
          setState(() => _isSaving = false);
          context.showSnackBar(
            'Please enter at least one measurement',
            isError: true,
          );
        }
        return;
      }

      await repo.saveMeasurement(
        FetalMeasurement(
          id: 'vitals_${dateTime.toIso8601String()}_${now.microsecondsSinceEpoch}',
          pregnancyId: pregnancy.id,
          date: dateTime,
          weight: weight,
          bloodPressureSystolic: systolic,
          bloodPressureDiastolic: diastolic,
          glucoseLevel: glucose,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        ),
      );

      ref.invalidate(latestMeasurementProvider);
      ref.invalidate(fetalMeasurementsProvider);

      if (mounted) {
        context.showSnackBar('Vitals saved successfully');
        Navigator.of(context).maybePop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        context.showSnackBar('Failed to save: $e', isError: true);
      }
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
            'Log Vitals',
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          children: [
            _buildSectionTabs(isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildActiveSection(isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildDateTimePicker(context, isDark),
            const SizedBox(height: AppSpacing.md),
            _buildNotesField(isDark),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              _isSaving ? 'Saving...' : 'Save',
              icon: Icons.save_rounded,
              onPressed: _isSaving ? null : _save,
              isLoading: _isSaving,
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTabs(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _sections.map((section) {
          final isSelected = _activeSection == section;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _activeSection = section),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.forestGreen.withValues(
                          alpha: isDark ? 0.3 : 0.12,
                        )
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.forestGreen
                        : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  _sectionLabel(section),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isDark ? AppColors.onBrand : AppColors.forestGreen)
                        : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.slate),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveSection(bool isDark) {
    switch (_activeSection) {
      case 'weight':
        return _buildWeightSection(isDark);
      case 'blood_pressure':
        return _buildBloodPressureSection(isDark);
      case 'glucose':
        return _buildGlucoseSection(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWeightSection(bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monitor_weight_rounded,
                size: 20,
                color: AppColors.sage,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Weight',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'kg',
                style: TextStyle(color: AppColors.slate, fontSize: 13),
              ),
              Switch(
                value: _useLbs,
                onChanged: (v) => setState(() => _useLbs = v),
                activeThumbColor: AppColors.forestGreen,
              ),
              Text(
                'lbs',
                style: TextStyle(
                  color: _useLbs ? AppColors.forestGreen : AppColors.slate,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: _useLbs ? 'Enter weight in lbs' : 'Enter weight in kg',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              suffixText: _useLbs ? 'lbs' : 'kg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodPressureSection(bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 20,
                color: AppColors.period,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Blood Pressure',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _systolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Systolic',
                    hintText: '120',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    suffixText: 'mmHg',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _diastolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Diastolic',
                    hintText: '80',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    suffixText: 'mmHg',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlucoseSection(bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bloodtype_rounded,
                size: 20,
                color: AppColors.softGold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Glucose',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Fasting',
                style: TextStyle(
                  color: _glucoseFasting
                      ? AppColors.forestGreen
                      : AppColors.slate,
                  fontSize: 13,
                ),
              ),
              Switch(
                value: _glucoseFasting,
                onChanged: (v) => setState(() => _glucoseFasting = v),
                activeThumbColor: AppColors.forestGreen,
              ),
              Text(
                'After meal',
                style: TextStyle(
                  color: !_glucoseFasting
                      ? AppColors.forestGreen
                      : AppColors.slate,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _glucoseController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: _useMgDl
                  ? 'Enter glucose in mg/dL'
                  : 'Enter glucose in mmol/L',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              suffixText: _useMgDl ? 'mg/dL' : 'mmol/L',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker(BuildContext context, bool isDark) {
    final dateStr = DateFormat('MMM d, yyyy').format(_selectedDate);
    final timeStr = _selectedTime.format(context);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: AppColors.forestGreen),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.charcoal.withValues(alpha: 0.2)
                    : AppColors.mistWhite,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AppColors.forestGreen,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: AppColors.forestGreen),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => _selectedTime = picked);
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.charcoal.withValues(alpha: 0.2)
                    : AppColors.mistWhite,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: AppColors.forestGreen,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField(bool isDark) {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Add notes (optional)',
        prefixIcon: Icon(
          Icons.edit_note_rounded,
          size: 20,
          color: AppColors.slate,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
