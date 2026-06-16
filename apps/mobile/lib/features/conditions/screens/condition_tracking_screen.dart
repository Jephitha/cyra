import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/symptom_selector.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/conditions/data/condition_data.dart';
import 'package:cyra/features/conditions/models/condition_models.dart';
import 'package:cyra/features/conditions/providers/condition_providers.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

class ConditionTrackingScreen extends ConsumerStatefulWidget {
  final String conditionType;

  const ConditionTrackingScreen({
    super.key,
    required this.conditionType,
  });

  @override
  ConsumerState<ConditionTrackingScreen> createState() =>
      _ConditionTrackingScreenState();
}

class _ConditionTrackingScreenState
    extends ConsumerState<ConditionTrackingScreen> {
  late DateTime _selectedDate;
  late List<SymptomOption> _conditionSymptoms;
  final Set<String> _selectedSymptoms = {};
  final Map<String, int> _severities = {};
  int _painLevel = 0;
  double _weightKg = 0;
  int _moodRating = 3;
  String _bleedingPattern = 'none';
  bool _isSaving = false;

  static const List<String> _bleedingOptions = [
    'none', 'spotting', 'light', 'moderate', 'heavy', 'very_heavy',
  ];

  ConditionInfo get _info =>
      ConditionData.getCondition(widget.conditionType);

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _conditionSymptoms = _buildConditionSymptoms();
  }

  List<SymptomOption> _buildConditionSymptoms() {
    final baseSymptoms = SymptomOption.defaultSymptoms();
    final conditionSymptomNames = _info.commonSymptoms
        .map((s) => s.toLowerCase())
        .toList();

    final matched = baseSymptoms.where((s) {
      return conditionSymptomNames.any((cs) => s.name.toLowerCase().contains(cs)
          || cs.contains(s.name.toLowerCase()));
    }).toList();

    if (matched.isEmpty) {
      return baseSymptoms.where((s) =>
        _defaultConditionSymptomIds().contains(s.id)
      ).toList();
    }

    return matched;
  }

  List<String> _defaultConditionSymptomIds() {
    switch (widget.conditionType) {
      case 'pcos':
        return ['acne', 'fatigue', 'mood_swings', 'sleep_quality', 'stress_level', 'weight_changes', 'hair_changes'];
      case 'endometriosis':
        return ['cramps', 'back_pain', 'bloating', 'fatigue', 'nausea', 'pain_during_sex'];
      case 'pmdd':
        return ['mood_swings', 'anxiety', 'irritability', 'sadness', 'fatigue', 'sleep_quality'];
      case 'adenomyosis':
        return ['cramps', 'back_pain', 'bloating', 'heavy_bleeding', 'fatigue'];
      case 'fibroids':
        return ['cramps', 'back_pain', 'bloating', 'heavy_bleeding', 'frequent_urination', 'constipation'];
      case 'thyroid':
        return ['fatigue', 'sleep_quality', 'stress_level', 'mood_swings', 'weight_changes', 'hair_changes'];
      default:
        return ['cramps', 'fatigue', 'bloating', 'mood_swings'];
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
            'Track ${_info.name}',
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline,
                  color: AppColors.forestGreen),
              onPressed: () => _showInfo(context, isDark),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSelector(isDark),
              const SizedBox(height: AppSpacing.xl),
              _buildSymptomSelector(isDark),
              if (_needsPainTracker()) ...[
                const SizedBox(height: AppSpacing.xl),
                _buildPainTracker(isDark),
              ],
              if (_needsWeightTracker()) ...[
                const SizedBox(height: AppSpacing.xl),
                _buildWeightTracker(isDark),
              ],
              if (_needsMoodTracker()) ...[
                const SizedBox(height: AppSpacing.xl),
                _buildMoodTracker(isDark),
              ],
              if (_needsBleedingTracker()) ...[
                const SizedBox(height: AppSpacing.xl),
                _buildBleedingTracker(isDark),
              ],
              const SizedBox(height: AppSpacing.xxxl),
              AppButton.primary(
                _isSaving ? 'Saving...' : 'Save Entry',
                isLoading: _isSaving,
                onPressed: _isSaving ? null : _saveEntry,
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildDisclaimer(isDark),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(bool isDark) {
    return Row(
      children: [
        Icon(Icons.calendar_today,
            size: 16, color: AppColors.forestGreen),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _pickDate,
          icon: Icon(Icons.edit_calendar,
              size: 16, color: AppColors.forestGreen),
          label: Text(
            DateFormat('MMM d, yyyy').format(_selectedDate),
            style: TextStyle(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list_alt_outlined,
                size: 18, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Symptoms',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SymptomSelector(
          symptoms: _conditionSymptoms,
          selectedSymptomIds: _selectedSymptoms.toList(),
          onSelectionChanged: (updated) {
            setState(() => _selectedSymptoms.addAll(updated));
          },
        ),
      ],
    );
  }

  bool _needsPainTracker() {
    return widget.conditionType == 'endometriosis'
        || widget.conditionType == 'adenomyosis'
        || widget.conditionType == 'fibroids';
  }

  Widget _buildPainTracker(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.whatshot,
                  size: 18, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Pain Level',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              _painLevel == 0 ? 'No pain' : '$_painLevel/10',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: _painLevel == 0
                    ? AppColors.sage
                    : _painLevel < 4
                        ? AppColors.softGold
                        : _painLevel < 7
                            ? AppColors.warning
                            : AppColors.error,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Slider(
            value: _painLevel.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            activeColor: _painLevel == 0
                ? AppColors.sage
                : _painLevel < 4
                    ? AppColors.softGold
                    : _painLevel < 7
                        ? AppColors.warning
                        : AppColors.error,
            label: _painLevel.toString(),
            onChanged: (value) =>
                setState(() => _painLevel = value.round()),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('None',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.slate)),
              Text('Moderate',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.slate)),
              Text('Severe',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.slate)),
            ],
          ),
        ],
      ),
    );
  }

  bool _needsWeightTracker() {
    return widget.conditionType == 'pcos'
        || widget.conditionType == 'thyroid';
  }

  Widget _buildWeightTracker(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monitor_weight_outlined,
                  size: 18, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Weight',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter weight',
                    suffixText: 'kg',
                    isDense: true,
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      setState(() => _weightKg = parsed);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _needsMoodTracker() {
    return widget.conditionType == 'pmdd'
        || widget.conditionType == 'thyroid'
        || widget.conditionType == 'pcos';
  }

  Widget _buildMoodTracker(bool isDark) {
    const moodLabels = ['Very Low', 'Low', 'Neutral', 'Good', 'Great'];
    const moodIcons = [
      Icons.sentiment_very_dissatisfied_rounded,
      Icons.sentiment_dissatisfied_rounded,
      Icons.sentiment_neutral_rounded,
      Icons.sentiment_satisfied_rounded,
      Icons.sentiment_very_satisfied_rounded,
    ];
    const moodColors = [
      AppColors.error,
      AppColors.warning,
      AppColors.slate,
      AppColors.sage,
      AppColors.forestGreen,
    ];

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mood_outlined,
                  size: 18, color: moodColors[_moodRating - 1]),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Mood',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final rating = i + 1;
              final isSelected = _moodRating == rating;
              return GestureDetector(
                onTap: () => setState(() => _moodRating = rating),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? moodColors[i].withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: isSelected
                        ? Border.all(
                            color: moodColors[i].withValues(alpha: 0.5))
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        moodIcons[i],
                        size: 32,
                        color: isSelected
                            ? moodColors[i]
                            : AppColors.slate,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        moodLabels[i],
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? moodColors[i] : AppColors.slate,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  bool _needsBleedingTracker() {
    return widget.conditionType == 'fibroids'
        || widget.conditionType == 'adenomyosis'
        || widget.conditionType == 'endometriosis'
        || widget.conditionType == 'pcos';
  }

  Widget _buildBleedingTracker(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined,
                  size: 18, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Bleeding Pattern',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _bleedingOptions.map((option) {
              final isSelected = _bleedingPattern == option;
              return ChoiceChip(
                label: Text(_bleedingLabel(option)),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _bleedingPattern = option),
                selectedColor: AppColors.error.withValues(alpha: 0.15),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _bleedingLabel(String option) {
    switch (option) {
      case 'none':
        return 'None';
      case 'spotting':
        return 'Spotting';
      case 'light':
        return 'Light';
      case 'moderate':
        return 'Moderate';
      case 'heavy':
        return 'Heavy';
      case 'very_heavy':
        return 'Very Heavy';
      default:
        return option;
    }
  }

  Widget _buildDisclaimer(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 16, color: AppColors.softGold),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This information is for educational purposes. '
              'Consult your healthcare provider for medical advice.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.slate,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveEntry() async {
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(symptomRepositoryProvider);

      for (final symptomId in _selectedSymptoms) {
        final severity = _severities[symptomId] ?? 1;
        await repo.createSymptomEntry(SymptomEntry(
          id: 'sym_${DateTime.now().millisecondsSinceEpoch}_$symptomId',
          date: _selectedDate,
          symptomId: symptomId,
          symptomName: symptomId,
          severity: severity,
          createdAt: DateTime.now(),
        ));
      }

      if (_needsPainTracker() && _painLevel > 0) {
        await repo.createSymptomEntry(SymptomEntry(
          id: 'sym_pain_${DateTime.now().millisecondsSinceEpoch}',
          date: _selectedDate,
          symptomId: 'pain_level',
          symptomName: 'Pain Level',
          severity: _painLevel,
          createdAt: DateTime.now(),
        ));
      }

      if (_needsMoodTracker()) {
        final moodSymptomRepo = ref.read(symptomRepositoryProvider);
        final existing = await moodSymptomRepo.getMoodForDate(_selectedDate);
        final moodEntry = MoodEntry(
          id: existing?.id ??
              'mood_${DateTime.now().millisecondsSinceEpoch}',
          date: _selectedDate,
          moodRating: _moodRating,
          createdAt: existing?.createdAt ?? DateTime.now(),
        );
        if (existing != null) {
          await moodSymptomRepo.updateMoodEntry(moodEntry);
        } else {
          await moodSymptomRepo.createMoodEntry(moodEntry);
        }
      }

      if (_needsWeightTracker() && _weightKg > 0) {
        await repo.createSymptomEntry(SymptomEntry(
          id: 'wgt_${DateTime.now().millisecondsSinceEpoch}',
          date: _selectedDate,
          symptomId: 'weight',
          symptomName: 'Weight',
          severity: _weightKg.round(),
          notes: '$_weightKg kg',
          createdAt: DateTime.now(),
        ));
      }

      if (_needsBleedingTracker() && _bleedingPattern != 'none') {
        await repo.createSymptomEntry(SymptomEntry(
          id: 'bleed_${DateTime.now().millisecondsSinceEpoch}',
          date: _selectedDate,
          symptomId: 'bleeding_$_bleedingPattern',
          symptomName: 'Bleeding: ${_bleedingLabel(_bleedingPattern)}',
          severity: _bleedingOptions.indexOf(_bleedingPattern),
          createdAt: DateTime.now(),
        ));
      }

      if (context.mounted) {
        context.showSnackBar('Entry saved successfully');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('Failed to save entry', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showInfo(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Tracking ${_info.name}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        content: Text(
          '${_info.description}\n\n'
          'Tracking your ${_info.name.toLowerCase()}-specific symptoms helps identify triggers, '
          'monitor treatment effectiveness, and provide valuable data for your healthcare provider.\n\n'
          'This information is for educational purposes. '
          'Consult your healthcare provider for medical advice.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slate,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
