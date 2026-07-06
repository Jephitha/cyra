import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/date_utils.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/pregnancy/providers/pregnancy_providers.dart';

class SetupPregnancyScreen extends ConsumerStatefulWidget {
  const SetupPregnancyScreen({super.key});

  @override
  ConsumerState<SetupPregnancyScreen> createState() => _SetupPregnancyScreenState();
}

class _SetupPregnancyScreenState extends ConsumerState<SetupPregnancyScreen> {
  int _currentStep = 0;
  static const int _totalSteps = 3;

  String? _calculationMethod;
  DateTime? _lmpDate;
  DateTime? _conceptionDate;
  DateTime? _dueDateFromUltrasound;
  bool _isSaving = false;

  DateTime? get _computedDueDate {
    if (_calculationMethod == 'lmp' && _lmpDate != null) {
      return CycleDateUtils.calculateDueDate(_lmpDate!);
    }
    if (_calculationMethod == 'conception' && _conceptionDate != null) {
      return _conceptionDate!.add(const Duration(days: 266));
    }
    if (_calculationMethod == 'ultrasound') {
      return _dueDateFromUltrasound;
    }
    return null;
  }

  int get _currentWeek {
    final dueDate = _computedDueDate;
    if (dueDate == null) return 0;
    return CycleDateUtils.getWeekOfPregnancy(dueDate);
  }

  int get _currentTrimester {
    return CycleDateUtils.getTrimester(_currentWeek);
  }

  void _goNext() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _completeSetup() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(pregnancyRepositoryProvider);
      final dueDate = _computedDueDate!;
      await repo.createPregnancy(dueDate,
          conceptionDate: _conceptionDate);
      ref.invalidate(currentPregnancyProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        context.showSnackBar('Failed to start pregnancy tracking: $e', isError: true);
      }
    }
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _calculationMethod != null;
      case 1:
        if (_calculationMethod == 'lmp') return _lmpDate != null;
        if (_calculationMethod == 'conception') return _conceptionDate != null;
        if (_calculationMethod == 'ultrasound') return _dueDateFromUltrasound != null;
        return false;
      case 2:
        return _computedDueDate != null;
      default:
        return false;
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
            'Set Up Pregnancy',
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
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final stepNum = index + 1;
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent
                        ? AppColors.forestGreen
                        : (isDark
                            ? AppColors.charcoal.withValues(alpha: 0.3)
                            : AppColors.borderLight),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : Text(
                            '$stepNum',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: isCurrent || isCompleted
                                      ? Colors.white
                                      : AppColors.slate,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                  ),
                ),
                if (index < _totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index < _currentStep
                            ? AppColors.forestGreen
                            : (isDark
                                ? AppColors.charcoal.withValues(alpha: 0.3)
                                : AppColors.borderLight),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStepMethod(isDark);
      case 1:
        return _buildStepDates(isDark);
      case 2:
        return _buildStepReview(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepMethod(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 36,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'How did you calculate your due date?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Select the method you used to estimate your due date',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _methodOption(
          context,
          Icons.date_range_rounded,
          'From my last period',
          'Calculate based on the first day of your last menstrual period',
          'lmp',
          isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        _methodOption(
          context,
          Icons.opacity_rounded,
          'From conception date',
          'Calculate based on a known ovulation or conception date',
          'conception',
          isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        _methodOption(
          context,
          Icons.health_and_safety_rounded,
          'From ultrasound',
          'Already have a due date from your healthcare provider',
          'ultrasound',
          isDark,
        ),
      ],
    );
  }

  Widget _methodOption(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String method,
    bool isDark,
  ) {
    final isSelected = _calculationMethod == method;

    return GestureDetector(
      onTap: () => setState(() => _calculationMethod = method),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.forestGreen.withValues(alpha: 0.08)
              : (isDark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? AppColors.forestGreen
                : (isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.forestGreen.withValues(alpha: 0.15)
                    : (isDark
                        ? AppColors.charcoal.withValues(alpha: 0.3)
                        : AppColors.mistWhite),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? AppColors.forestGreen : AppColors.slate, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppColors.forestGreen
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.charcoal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.forestGreen,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDates(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_calendar_rounded,
              size: 36,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          _dateStepTitle(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _dateStepDescription(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _pickDateForMethod(),
            icon: const Icon(Icons.calendar_today_rounded),
            label: Text(
              _dateButtonLabel(),
              style: const TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              side: const BorderSide(
                color: AppColors.forestGreen,
                width: 1.5,
              ),
              foregroundColor: AppColors.forestGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
        ),
        if (_computedDueDate != null && _calculationMethod != 'ultrasound') ...[
          const SizedBox(height: AppSpacing.xxl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.warmIvory.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event_rounded,
                  size: 20,
                  color: AppColors.forestGreen,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculated Due Date',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.slate),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        DateFormat('MMMM d, yyyy').format(_computedDueDate!),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppColors.forestGreen,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _dateStepTitle() {
    switch (_calculationMethod) {
      case 'lmp':
        return 'When did your last period start?';
      case 'conception':
        return 'When did conception occur?';
      case 'ultrasound':
        return 'What is your due date?';
      default:
        return 'Enter the date';
    }
  }

  String _dateStepDescription() {
    switch (_calculationMethod) {
      case 'lmp':
        return 'Enter the first day of your last menstrual period';
      case 'conception':
        return 'Enter the date of conception or ovulation';
      case 'ultrasound':
        return 'Enter the due date provided by your healthcare provider';
      default:
        return '';
    }
  }

  String _dateButtonLabel() {
    if (_calculationMethod == 'lmp' && _lmpDate != null) {
      return DateFormat('MMMM d, yyyy').format(_lmpDate!);
    }
    if (_calculationMethod == 'conception' && _conceptionDate != null) {
      return DateFormat('MMMM d, yyyy').format(_conceptionDate!);
    }
    if (_calculationMethod == 'ultrasound' && _dueDateFromUltrasound != null) {
      return DateFormat('MMMM d, yyyy').format(_dueDateFromUltrasound!);
    }
    return 'Select date';
  }

  Future<void> _pickDateForMethod() async {
    DateTime initialDate;
    DateTime firstDate;
    DateTime lastDate;

    if (_calculationMethod == 'ultrasound') {
      initialDate = _dueDateFromUltrasound ??
          DateTime.now().add(const Duration(days: 140));
      firstDate = DateTime.now();
      lastDate = DateTime.now().add(const Duration(days: 300));
    } else if (_calculationMethod == 'conception') {
      initialDate = _conceptionDate ??
          DateTime.now().subtract(const Duration(days: 60));
      firstDate =
          DateTime.now().subtract(const Duration(days: 180));
      lastDate = DateTime.now().add(const Duration(days: 14));
    } else {
      initialDate = _lmpDate ??
          DateTime.now().subtract(const Duration(days: 60));
      firstDate =
          DateTime.now().subtract(const Duration(days: 180));
      lastDate = DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: _dateStepTitle(),
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
      setState(() {
        switch (_calculationMethod) {
          case 'lmp':
            _lmpDate = picked;
            break;
          case 'conception':
            _conceptionDate = picked;
            break;
          case 'ultrasound':
            _dueDateFromUltrasound = picked;
            break;
        }
      });
    }
  }

  Widget _buildStepReview(bool isDark) {
    final dueDate = _computedDueDate;
    if (dueDate == null) return const SizedBox.shrink();

    final week = _currentWeek;
    final trimester = _currentTrimester;
    final comparison = CycleDateUtils.weekToSizeComparison(week);
    final trimesterLabel = _trimesterLabel(trimester);
    final dueDateStr = DateFormat('MMMM d, yyyy').format(dueDate);
    final daysRemaining = dueDate.difference(DateTime.now()).inDays;
    final weeksRemaining = (daysRemaining / 7).floor();
    final methodLabel = _methodLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 36,
              color: AppColors.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Review & Confirm',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              _reviewRow(
                context,
                Icons.event_rounded,
                'Due Date',
                dueDateStr,
                AppColors.forestGreen,
              ),
              const Divider(height: AppSpacing.xxl),
              _reviewRow(
                context,
                Icons.child_care_rounded,
                'Current Week',
                'Week $week',
                AppColors.sage,
              ),
              const Divider(height: AppSpacing.xxl),
              _reviewRow(
                context,
                Icons.straighten_rounded,
                'Baby\'s Size',
                comparison,
                AppColors.softGold,
              ),
              const Divider(height: AppSpacing.xxl),
              _reviewRow(
                context,
                Icons.category_rounded,
                'Trimester',
                trimesterLabel,
                _trimesterColor(trimester),
              ),
              const Divider(height: AppSpacing.xxl),
              _reviewRow(
                context,
                Icons.timer_outlined,
                'Time Remaining',
                '$weeksRemaining weeks',
                AppColors.slate,
              ),
              const Divider(height: AppSpacing.xxl),
              _reviewRow(
                context,
                Icons.info_outline_rounded,
                'Calculation Method',
                methodLabel,
                AppColors.slate,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton.primary(
          _isSaving ? 'Starting...' : 'Start Tracking',
          icon: Icons.rocket_launch_rounded,
          onPressed: _isSaving ? null : _completeSetup,
          isLoading: _isSaving,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _reviewRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color accentColor,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: accentColor),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _methodLabel() {
    switch (_calculationMethod) {
      case 'lmp':
        return 'Last Menstrual Period';
      case 'conception':
        return 'Conception Date';
      case 'ultrasound':
        return 'Ultrasound';
      default:
        return '';
    }
  }

  String _trimesterLabel(int trimester) {
    switch (trimester) {
      case 1:
        return '1st Trimester';
      case 2:
        return '2nd Trimester';
      case 3:
        return '3rd Trimester';
      default:
        return '';
    }
  }

  Color _trimesterColor(int trimester) {
    switch (trimester) {
      case 1:
        return AppColors.sage;
      case 2:
        return AppColors.softGold;
      case 3:
        return const Color(0xFFE57373);
      default:
        return AppColors.sage;
    }
  }

  Widget _buildBottomBar(bool isDark) {
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
            if (_currentStep > 0)
              AppButton.ghost(
                'Back',
                icon: Icons.chevron_left,
                onPressed: _goBack,
              )
            else
              AppButton.ghost(
                'Cancel',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            const Spacer(),
            AppButton.primary(
              _currentStep == _totalSteps - 1
                  ? 'Start Tracking'
                  : 'Continue',
              icon: _currentStep == _totalSteps - 1
                  ? Icons.rocket_launch_rounded
                  : Icons.chevron_right,
              onPressed: _canProceed ? _goNext : null,
            ),
          ],
        ),
      ),
    );
  }
}
