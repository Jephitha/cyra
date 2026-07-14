import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/flow_intensity_picker.dart';
import 'package:cyra/core/design/widgets/symptom_selector.dart';
import 'package:cyra/core/constants/cycle_constants.dart';
import 'package:cyra/core/notifications/cycle_reminder_scheduler.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

enum _CyclePattern { predictable, varies, notSure }

class LogPeriodScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const LogPeriodScreen({super.key, this.initialDate});

  @override
  ConsumerState<LogPeriodScreen> createState() => _LogPeriodScreenState();
}

class _LogPeriodScreenState extends ConsumerState<LogPeriodScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  DateTime _selectedDate = DateTime.now();
  DateTime? _periodEndDate;
  bool _isSpotting = false;
  _CyclePattern? _cyclePattern;

  int? _flowIntensity;

  final Set<String> _selectedSymptoms = {};
  bool _showFullSymptoms = false;

  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _goNext() async {
    if (_currentStep == 0 && !await _confirmDateStepIfNeeded()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  Future<bool> _confirmDateStepIfNeeded() async {
    final periodLength = _loggedPeriodLength;
    if (periodLength == null || periodLength <= 5) return true;

    final longerThanBroadTypical = periodLength > 8;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Just checking your dates'),
        content: Text(
          longerThanBroadTypical
              ? 'You logged this period as $periodLength days long. That can happen, but it is longer than many people expect. Does that feel right for this period?'
              : 'You logged this period as $periodLength days long. Does that feel right for this period?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No, edit dates'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes, continue'),
          ),
        ],
      ),
    );

    if (confirmed == true && longerThanBroadTypical && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'If this is new for you, very heavy, or worrying, consider checking in with a clinician.',
          ),
        ),
      );
    }

    return confirmed == true;
  }

  int? get _loggedPeriodLength {
    if (_periodEndDate == null) return null;
    return _periodEndDate!.startOfDay
            .difference(_selectedDate.startOfDay)
            .inDays +
        1;
  }

  bool get _selectedDateIsToday =>
      _selectedDate.startOfDay == DateTime.now().startOfDay;

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final cycleRepo = ref.read(cycleRepositoryProvider);
      final symptomRepo = ref.read(symptomRepositoryProvider);
      final date = _selectedDate.startOfDay;
      final notes = _notesController.text.trim();
      final symptoms = _selectedSymptoms.toList();

      final isSpottingOnly = _flowIntensity == 5;
      final effectiveFlow = isSpottingOnly ? null : _flowIntensity;
      final spotting = _isSpotting || isSpottingOnly;

      await cycleRepo.logPeriodStart(date, flowIntensity: effectiveFlow);

      final activeCycle = await cycleRepo.getActiveCycle();
      if (activeCycle != null) {
        if (_periodEndDate != null) {
          final periodLength =
              _periodEndDate!.startOfDay.difference(date).inDays + 1;
          await cycleRepo.updateCycle(
            activeCycle.copyWith(periodLength: periodLength.clamp(1, 14)),
          );
        }
        final dayId = '${activeCycle.id}_${date.toIso8601String()}';
        await cycleRepo.saveCycleDay(
          CycleDay(
            id: dayId,
            cycleId: activeCycle.id,
            date: date,
            flowIntensity: effectiveFlow ?? 0,
            spotting: spotting,
            symptomsJson: symptoms.isNotEmpty ? jsonEncode(symptoms) : null,
            notes: notes.isNotEmpty ? notes : null,
          ),
        );
      }

      for (final symptomId in symptoms) {
        await symptomRepo.createSymptomEntry(
          SymptomEntry(
            id: '${symptomId}_${DateTime.now().microsecondsSinceEpoch}',
            date: date,
            symptomId: symptomId,
            symptomName: _symptomLabel(symptomId),
            severity: 2,
          ),
        );
      }

      if (_cyclePattern != null) {
        await ref
            .read(appSettingsNotifierProvider.notifier)
            .setValue('cycle_pattern_self_report', _cyclePattern!.name);
      }

      ref.invalidate(activeCycleProvider);
      ref.invalidate(allCyclesProvider);
      ref.invalidate(cycleSummaryProvider);
      ref.invalidate(nextPeriodPredictionProvider);
      if (activeCycle != null) {
        ref.invalidate(cycleDaysProvider(activeCycle.id));
      }

      try {
        final reminderScheduler = ref.read(cycleReminderSchedulerProvider);
        unawaited(_refreshReminders(reminderScheduler));
      } catch (_) {
        // Logging should not fail just because notification wiring is
        // unavailable in tests or temporarily unavailable on device.
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Period logged successfully.'),
            backgroundColor: AppColors.forestGreen,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _refreshReminders(CycleReminderScheduler scheduler) async {
    try {
      await scheduler.reschedule();
    } catch (_) {
      // Logging health data succeeds even if the OS notification service is
      // temporarily unavailable; startup will retry the schedule later.
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: _currentStep == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop || _currentStep == 0) return;
          _goBack();
        },
        child: Scaffold(
          appBar: _buildAppBar(context, isDark),
          body: Column(
            children: [
              _buildProgressIndicator(isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _buildStepContent(isDark),
                ),
              ),
              _buildBottomBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        'Log Period',
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _isSaving ? null : () => Navigator.of(context).maybePop(),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppColors.forestGreen
                    : (isDark
                          ? AppColors.charcoal.withValues(alpha: 0.3)
                          : AppColors.borderLight),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStepDate(isDark);
      case 1:
        return _buildStepFlow(isDark);
      case 2:
        return _buildStepSymptoms(isDark);
      case 3:
        return _buildStepNotes(isDark);
      case 4:
        return _buildStepReview(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepDate(bool isDark) {
    final cycles = ref.watch(allCyclesProvider).valueOrNull ?? const <Cycle>[];
    final isFirstCycle = cycles.isEmpty;
    final loggedLength = _loggedPeriodLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 36,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          _selectedDateIsToday
              ? 'When did this period start?'
              : 'When did your last period start?',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_rounded),
            label: Text(
              DateFormat('MMMM d, yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              side: BorderSide(color: AppColors.forestGreen, width: 1.5),
              foregroundColor: AppColors.forestGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_selectedDateIsToday)
          _buildGentleNote(
            icon: Icons.today_rounded,
            title: 'Today is day 1',
            message:
                'You can come back to add the last day when this period ends.',
            isDark: isDark,
          )
        else ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickEndDate,
              icon: const Icon(Icons.event_available_rounded),
              label: Text(
                _periodEndDate == null
                    ? 'Add end date (optional)'
                    : 'Ended ${DateFormat('MMMM d, yyyy').format(_periodEndDate!)}',
                style: const TextStyle(fontSize: 15),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.lg,
                ),
                side: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                foregroundColor: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.charcoal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),
          ),
          if (loggedLength != null && loggedLength > 5) ...[
            const SizedBox(height: AppSpacing.md),
            _buildGentleNote(
              icon: Icons.info_outline_rounded,
              title: '$loggedLength-day period',
              message: loggedLength > 8
                  ? 'Cyra will use this if it is right for you. If this is unusual, very heavy, or worrying, it may be worth checking in with a clinician.'
                  : 'Periods can be longer or shorter from one cycle to another. Cyra will ask once more before using this length.',
              isDark: isDark,
            ),
          ],
        ],
        if (isFirstCycle) ...[
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Do your periods usually come around the same time?',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This helps Cyra choose gentler reminders while it learns your pattern.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildPatternChip(
                label: 'Usually predictable',
                value: _CyclePattern.predictable,
                isDark: isDark,
              ),
              _buildPatternChip(
                label: 'Sometimes varies',
                value: _CyclePattern.varies,
                isDark: isDark,
              ),
              _buildPatternChip(
                label: 'Not sure yet',
                value: _CyclePattern.notSure,
                isDark: isDark,
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _isSpotting,
                onChanged: (val) => setState(() => _isSpotting = val ?? false),
                activeColor: AppColors.forestGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              "I'm spotting",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGentleNote({
    required IconData icon,
    required String title,
    required String message,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: isDark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternChip({
    required String label,
    required _CyclePattern value,
    required bool isDark,
  }) {
    final isSelected = _cyclePattern == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.forestGreen.withValues(alpha: 0.14),
      labelStyle: TextStyle(
        color: isSelected
            ? AppColors.forestGreen
            : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected
            ? AppColors.forestGreen.withValues(alpha: 0.4)
            : (isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      onSelected: (_) => setState(() => _cyclePattern = value),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Select period start date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.forestGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        if (_periodEndDate != null &&
            _periodEndDate!.startOfDay.isBefore(picked.startOfDay)) {
          _periodEndDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _periodEndDate ?? _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime.now(),
      helpText: 'Select period end date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.forestGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _periodEndDate = picked);
    }
  }

  Widget _buildStepFlow(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sync_rounded,
              size: 36,
              color: AppColors.error.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'How heavy is your flow?',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Tap a level to describe your flow today',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        FlowIntensityPicker(
          selectedValue: _flowIntensity,
          onChanged: (value) => setState(() => _flowIntensity = value),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildFlowVisualGuide(isDark),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _flowIntensity == 5,
                onChanged: (val) {
                  setState(() => _flowIntensity = val == true ? 5 : null);
                },
                activeColor: AppColors.forestGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Spotting only',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlowVisualGuide(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flow Guide',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.slate,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _flowGuideRow(1, 'Light', AppColors.periodLight, isDark),
          _flowGuideRow(2, 'Medium', AppColors.periodMedium, isDark),
          _flowGuideRow(3, 'Heavy', AppColors.periodHeavy, isDark),
          _flowGuideRow(4, 'Very Heavy', AppColors.periodVeryHeavy, isDark),
        ],
      ),
    );
  }

  Widget _flowGuideRow(int level, String label, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$level — $label',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepSymptoms(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.spa_outlined, size: 36, color: AppColors.sage),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'How did your body feel?',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Select anything you noticed. This is a check-in, not a diagnosis.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildQuickSymptomGrid(isDark),
        const SizedBox(height: AppSpacing.lg),
        if (!_showFullSymptoms)
          Center(
            child: AppButton.ghost(
              'See all body notes',
              icon: Icons.expand_more_rounded,
              onPressed: () => setState(() => _showFullSymptoms = true),
            ),
          ),
        if (_showFullSymptoms) ...[
          const SizedBox(height: AppSpacing.lg),
          SymptomSelector(
            symptoms: SymptomOption.defaultSymptoms(),
            selectedSymptomIds: _selectedSymptoms.toList(),
            onSelectionChanged: (ids) =>
                setState(() => _selectedSymptoms.addAll(ids)),
            searchable: true,
          ),
        ],
      ],
    );
  }

  Widget _buildQuickSymptomGrid(bool isDark) {
    final quickSymptoms = [
      'cramps',
      'headache',
      'bloating',
      'fatigue',
      'back_pain',
      'nausea',
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: quickSymptoms.map((id) {
        final isSelected = _selectedSymptoms.contains(id);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSymptoms.remove(id);
              } else {
                _selectedSymptoms.add(id);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.forestGreen.withValues(alpha: 0.1)
                  : (isDark
                        ? AppColors.charcoal.withValues(alpha: 0.2)
                        : AppColors.mistWhite),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: isSelected
                    ? AppColors.forestGreen.withValues(alpha: 0.4)
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              _symptomLabel(id),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.forestGreen
                    : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _symptomLabel(String id) {
    switch (id) {
      case 'cramps':
        return 'Cramps';
      case 'headache':
        return 'Headache';
      case 'bloating':
        return 'Bloating';
      case 'fatigue':
        return 'Fatigue';
      case 'back_pain':
        return 'Back Pain';
      case 'nausea':
        return 'Nausea';
      default:
        return id;
    }
  }

  Widget _buildStepNotes(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit_note_rounded,
              size: 36,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Add notes (optional)',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Any additional details you\'d like to remember',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: AppSpacing.xxl),
        TextField(
          controller: _notesController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'How are you feeling? Any notable changes?...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.photo_camera_outlined, size: 20),
                label: const Text('Photo (journal only)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  foregroundColor: AppColors.slate,
                  side: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.mic_outlined, size: 20),
                label: const Text('Voice Note (journal only)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  foregroundColor: AppColors.slate,
                  side: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepReview(bool isDark) {
    final dateStr = DateFormat('MMMM d, yyyy').format(_selectedDate);
    final endDateStr = _periodEndDate == null
        ? 'Not added'
        : DateFormat('MMMM d, yyyy').format(_periodEndDate!);
    final flowLabel = _flowIntensity != null
        ? CycleConstants.flowLabels[_flowIntensity] ?? 'Not set'
        : 'Not logged';
    final hasSymptoms = _selectedSymptoms.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 36,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Review & Save',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reviewRow(
                Icons.calendar_today_rounded,
                'Start Date',
                dateStr,
                _isSpotting ? ' (Spotting)' : '',
                isDark,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(height: 1),
              ),
              if (!_selectedDateIsToday) ...[
                _reviewRow(
                  Icons.event_available_rounded,
                  'End Date',
                  endDateStr,
                  '',
                  isDark,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Divider(height: 1),
                ),
              ],
              _reviewRow(
                Icons.sync_rounded,
                'Flow Intensity',
                flowLabel,
                '',
                isDark,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(height: 1),
              ),
              _reviewRow(
                Icons.spa_outlined,
                'Body notes',
                hasSymptoms
                    ? _selectedSymptoms.map((s) => _symptomLabel(s)).join(', ')
                    : 'None',
                '',
                isDark,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(height: 1),
              ),
              _reviewRow(
                Icons.notes_rounded,
                'Notes',
                _notesController.text.isEmpty ? 'None' : _notesController.text,
                '',
                isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() => _currentStep = 0);
              _selectedDate = DateTime.now();
              _periodEndDate = null;
              _flowIntensity = null;
              _selectedSymptoms.clear();
              _notesController.clear();
              _isSpotting = false;
            },
            child: Text(
              'Log another day',
              style: TextStyle(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _reviewRow(
    IconData icon,
    String label,
    String value,
    String suffix,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.slate),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '$value$suffix',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isDark) {
    final isLastStep = _currentStep == _totalSteps - 1;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Spacer(),
            AppButton.secondary(
              isLastStep ? 'Save' : 'Next',
              icon: isLastStep
                  ? Icons.check_rounded
                  : Icons.arrow_forward_rounded,
              onPressed: isLastStep ? _save : () => unawaited(_goNext()),
              isLoading: _isSaving && isLastStep,
              isDisabled: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
