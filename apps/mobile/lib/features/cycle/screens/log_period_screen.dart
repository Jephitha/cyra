import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/flow_intensity_picker.dart';
import 'package:cyra/core/design/widgets/symptom_selector.dart';
import 'package:cyra/core/constants/cycle_constants.dart';
import 'package:cyra/core/utils/extensions.dart';

class LogPeriodScreen extends StatefulWidget {
  final DateTime? initialDate;

  const LogPeriodScreen({super.key, this.initialDate});

  @override
  State<LogPeriodScreen> createState() => _LogPeriodScreenState();
}

class _LogPeriodScreenState extends State<LogPeriodScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  DateTime _selectedDate = DateTime.now();
  bool _isSpotting = false;

  int? _flowIntensity;

  final Set<String> _selectedSymptoms = {};
  bool _showFullSymptoms = false;

  final TextEditingController _notesController = TextEditingController();

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

  void _goNext() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  void _save() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
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
                    : (isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.borderLight),
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
          'When did your period start?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
              side: BorderSide(
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
              Icons.water_drop_rounded,
              size: 36,
              color: AppColors.error.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'How heavy is your flow?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Tap a level to describe your flow today',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
          ),
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
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.5),
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
          _flowGuideRow(1, 'Light', const Color(0xFFFFB3BA), isDark),
          _flowGuideRow(2, 'Medium', const Color(0xFFFF6B6B), isDark),
          _flowGuideRow(3, 'Heavy', const Color(0xFFE04848), isDark),
          _flowGuideRow(4, 'Very Heavy', const Color(0xFFB71C1C), isDark),
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
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
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
            child: Icon(
              Icons.healing_outlined,
              size: 36,
              color: AppColors.sage,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Any symptoms?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Select all that apply',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildQuickSymptomGrid(isDark),
        const SizedBox(height: AppSpacing.lg),
        if (!_showFullSymptoms)
          Center(
            child: AppButton.ghost(
              'See all symptoms',
              icon: Icons.expand_more_rounded,
              onPressed: () => setState(() => _showFullSymptoms = true),
            ),
          ),
        if (_showFullSymptoms) ...[
          const SizedBox(height: AppSpacing.lg),
          SymptomSelector(
            symptoms: SymptomOption.defaultSymptoms(),
            selectedSymptomIds: _selectedSymptoms.toList(),
            onSelectionChanged: (ids) => setState(() => _selectedSymptoms.addAll(ids)),
            searchable: true,
          ),
        ],
      ],
    );
  }

  Widget _buildQuickSymptomGrid(bool isDark) {
    final quickSymptoms = ['cramps', 'headache', 'bloating', 'fatigue', 'back_pain', 'nausea'];

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
                  : (isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.mistWhite),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Any additional details you\'d like to remember',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
          ),
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
                onPressed: () {},
                icon: const Icon(Icons.photo_camera_outlined, size: 20),
                label: const Text('Photo'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  foregroundColor: AppColors.slate,
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
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
                onPressed: () {},
                icon: const Icon(Icons.mic_outlined, size: 20),
                label: const Text('Voice Note'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  foregroundColor: AppColors.slate,
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
              _reviewRow(
                Icons.water_drop_rounded,
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
                Icons.healing_outlined,
                'Symptoms',
                hasSymptoms ? _selectedSymptoms.map((s) => _symptomLabel(s)).join(', ') : 'None',
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
        const SizedBox(height: AppSpacing.xxl),
        AppButton.primary(
          'Save',
          icon: Icons.save_rounded,
          onPressed: _save,
          width: double.infinity,
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() => _currentStep = 0);
              _selectedDate = DateTime.now();
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

  Widget _reviewRow(IconData icon, String label, String value, String suffix, bool isDark) {
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
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
              ),
            if (_currentStep == 0)
              AppButton.ghost(
                'Back',
                icon: Icons.chevron_left,
                onPressed: _goBack,
              ),
            const Spacer(),
            AppButton.primary(
              _currentStep == _totalSteps - 1 ? 'Save' : 'Next',
              icon: _currentStep == _totalSteps - 1 ? Icons.check : Icons.chevron_right,
              onPressed: _currentStep == _totalSteps - 1 ? _save : _goNext,
            ),
          ],
        ),
      ),
    );
  }
}
