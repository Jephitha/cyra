import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/symptom_selector.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

class QuickLogScreen extends ConsumerStatefulWidget {
  const QuickLogScreen({super.key});

  @override
  ConsumerState<QuickLogScreen> createState() => _QuickLogScreenState();
}

class _QuickLogScreenState extends ConsumerState<QuickLogScreen> {
  int? _flowIntensity;
  final Set<String> _selectedSymptoms = {};
  final Map<String, int> _symptomSeverities = {};
  int _selectedMood = 3;
  double _sleepHours = 7.0;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  final List<_MoodFace> _moodFaces = const [
    _MoodFace(1, Icons.sentiment_very_dissatisfied_rounded),
    _MoodFace(2, Icons.sentiment_dissatisfied_rounded),
    _MoodFace(3, Icons.sentiment_neutral_rounded),
    _MoodFace(4, Icons.sentiment_satisfied_rounded),
    _MoodFace(5, Icons.sentiment_very_satisfied_rounded),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String id) {
    setState(() {
      if (_selectedSymptoms.contains(id)) {
        _selectedSymptoms.remove(id);
        _symptomSeverities.remove(id);
      } else {
        _selectedSymptoms.add(id);
        _symptomSeverities[id] = 1;
      }
    });
  }

  void _showSeverityPicker(String id, String name) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name severity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _severityOption(ctx, setSheetState, id, 1, 'Mild'),
                  _severityOption(ctx, setSheetState, id, 2, 'Moderate'),
                  _severityOption(ctx, setSheetState, id, 3, 'Severe'),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton.primary(
                    'Done',
                    onPressed: () => Navigator.of(ctx).pop(),
                    width: double.infinity,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _severityOption(
    BuildContext ctx,
    void Function(void Function()) setSheetState,
    String symptomId,
    int level,
    String label,
  ) {
    return ListTile(
      // ignore: deprecated_member_use
      leading: Radio<int>(
        value: level,
        // ignore: deprecated_member_use
        groupValue: _symptomSeverities[symptomId] ?? 1,
        activeColor: AppColors.forestGreen,
        // ignore: deprecated_member_use
        onChanged: (val) {
          setSheetState(() => _symptomSeverities[symptomId] = val!);
        },
      ),
      title: Text(label),
      trailing: _severityDot(level),
      onTap: () {
        setSheetState(() => _symptomSeverities[symptomId] = level);
      },
    );
  }

  Widget _severityDot(int level) {
    final colors = {
      1: AppColors.success,
      2: AppColors.warning,
      3: AppColors.error,
    };
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: colors[level]!.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternsAsync = ref.watch(symptomPatternsProvider);
    final streakAsync = ref.watch(symptomStreakProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context, isDark),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              streakAsync.when(
                data: (streak) {
                  if (streak > 0) {
                    return _buildStreakBanner(streak, isDark);
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Quick Check-in',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Takes less than 30 seconds',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildFlowSection(isDark),
              const SizedBox(height: AppSpacing.xl),
              patternsAsync.when(
                data: (patterns) => _buildSymptomsSection(isDark, patterns),
                loading: () => _buildSymptomsSection(isDark, []),
                error: (_, __) => _buildSymptomsSection(isDark, []),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildMoodSection(isDark),
              const SizedBox(height: AppSpacing.xxl),
              _buildSleepSection(isDark),
              const SizedBox(height: AppSpacing.xxl),
              _buildNotesSection(isDark),
              const SizedBox(height: AppSpacing.xxl),
              _buildActions(isDark),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        'Daily Check-in',
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

  Widget _buildStreakBanner(int streak, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.forestGreen.withValues(alpha: 0.1),
            AppColors.forestGreenLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.softGold,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streak-day streak!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                ),
              ),
              Text(
                'Keep it going',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Flow ──────────────────────────────────────────────────────────

  Widget _buildFlowSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Flow', Icons.water_drop_rounded, isDark),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(4, (index) {
            final level = index + 1;
            final isSelected = _flowIntensity == level;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _flowIntensity = level),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.error.withValues(alpha: 0.15)
                        : (isDark
                            ? AppColors.charcoal.withValues(alpha: 0.2)
                            : AppColors.mistWhite),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.error.withValues(alpha: 0.4)
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.water_drop_rounded,
                        size: 20,
                        color: isSelected
                            ? AppColors.error
                            : AppColors.slate,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        _flowLabel(level),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.error
                              : AppColors.slate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  String _flowLabel(int level) {
    switch (level) {
      case 1:
        return 'Light';
      case 2:
        return 'Medium';
      case 3:
        return 'Heavy';
      case 4:
        return 'Spotting';
      default:
        return '';
    }
  }

  // ── Symptoms ──────────────────────────────────────────────────────

  Widget _buildSymptomsSection(bool isDark, List<SymptomPattern> patterns) {
    final topSymptoms = patterns.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Symptoms', Icons.healing_outlined, isDark),
        const SizedBox(height: AppSpacing.sm),
        if (topSymptoms.isEmpty)
          _buildEmptySymptoms(isDark)
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: topSymptoms.map((p) {
              final isSelected = _selectedSymptoms.contains(p.symptomId);
              final severity = _symptomSeverities[p.symptomId] ?? 1;
              final color = _symptomColor(p.symptomId);
              return GestureDetector(
                onTap: () => _toggleSymptom(p.symptomId),
                onLongPress: () =>
                    _showSeverityPicker(p.symptomId, p.symptomName),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : (isDark
                            ? AppColors.charcoal.withValues(alpha: 0.2)
                            : AppColors.mistWhite),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: isSelected
                          ? color.withValues(alpha: 0.4)
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.symptomName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? color
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.slate),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: AppSpacing.xs),
                        _severityDot(severity),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildEmptySymptoms(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.15)
            : AppColors.mistWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Symptoms will appear here after you log a few',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }

  // ── Mood ──────────────────────────────────────────────────────────

  Widget _buildMoodSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Mood', Icons.mood_rounded, isDark),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_moodFaces.length, (index) {
            final face = _moodFaces[index];
            final rating = index + 1;
            final isSelected = _selectedMood == rating;
            return GestureDetector(
              onTap: () => setState(() => _selectedMood = rating),
              child: AnimatedScale(
                scale: isSelected ? 1.25 : 0.9,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  face.icon,
                  size: 34,
                  color: isSelected
                      ? _moodColor(rating)
                      : AppColors.slate.withValues(alpha: 0.4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _moodColor(int rating) {
    switch (rating) {
      case 1:
        return AppColors.error;
      case 2:
        return Colors.orange;
      case 3:
        return AppColors.warning;
      case 4:
        return AppColors.forestGreenLight;
      case 5:
        return AppColors.forestGreen;
      default:
        return AppColors.slate;
    }
  }

  // ── Sleep ─────────────────────────────────────────────────────────

  Widget _buildSleepSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Sleep', Icons.nights_stay_rounded, isDark),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text(
              '${_sleepHours.toStringAsFixed(0)}h',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Slider(
                value: _sleepHours,
                min: 3,
                max: 12,
                divisions: 9,
                activeColor: AppColors.forestGreen,
                inactiveColor:
                    AppColors.forestGreen.withValues(alpha: 0.2),
                label: '${_sleepHours.toStringAsFixed(0)} hours',
                onChanged: (val) => setState(() => _sleepHours = val),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Notes ─────────────────────────────────────────────────────────

  Widget _buildNotesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Notes', Icons.edit_note_rounded, isDark),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Anything to note?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  // ── Actions ───────────────────────────────────────────────────────

  Widget _buildActions(bool isDark) {
    return Column(
      children: [
        AppButton.primary(
          'Save',
          icon: Icons.check,
          isLoading: _isSaving,
          onPressed: _save,
          width: double.infinity,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.ghost(
          'Save what I have',
          onPressed: _saveIncomplete,
          width: double.infinity,
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await _doSave();
  }

  Future<void> _saveIncomplete() async {
    setState(() => _isSaving = true);
    await _doSave();
  }

  Future<void> _doSave() async {
    final now = DateTime.now();
    final repo = ref.read(symptomRepositoryProvider);

    // Save flow as a symptom entry
    if (_flowIntensity != null) {
      await repo.createSymptomEntry(SymptomEntry(
        id: 'flow_${now.microsecondsSinceEpoch}',
        date: now,
        symptomId: 'flow',
        symptomName: 'Flow',
        severity: _flowIntensity!,
        category: 'physical',
      ));
    }

    // Save selected symptoms
    for (final id in _selectedSymptoms) {
      final name = _symptomName(id);
      await repo.createSymptomEntry(SymptomEntry(
        id: '${id}_${now.microsecondsSinceEpoch}',
        date: now,
        symptomId: id,
        symptomName: name,
        severity: _symptomSeverities[id] ?? 1,
        category: _symptomCategory(id),
      ));
    }

    // Save mood
    final existing = await repo.getMoodForDate(now);
    final moodEntry = MoodEntry(
      id: existing?.id ?? 'mood_${now.microsecondsSinceEpoch}',
      date: now,
      moodRating: _selectedMood,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );
    if (existing != null) {
      await repo.updateMoodEntry(moodEntry);
    } else {
      await repo.createMoodEntry(moodEntry);
    }

    // Save sleep as a symptom entry
    await repo.createSymptomEntry(SymptomEntry(
      id: 'sleep_${now.microsecondsSinceEpoch}',
      date: now,
      symptomId: 'sleep_hours',
      symptomName: 'Sleep',
      severity: _sleepHours.round(),
      category: 'lifestyle',
    ));

    ref.invalidate(symptomStreakProvider);
    ref.invalidate(todaySymptomsProvider);

    if (mounted) {
      setState(() => _isSaving = false);
      context.showSnackBar('Check-in saved!');
      Navigator.of(context).maybePop(true);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Widget _sectionLabel(String label, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.forestGreen),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  Color _symptomColor(String id) {
    final symptoms = SymptomOption.defaultSymptoms();
    final match = symptoms.where((s) => s.id == id);
    return match.isNotEmpty ? match.first.color : AppColors.sage;
  }

  String _symptomName(String id) {
    final symptoms = SymptomOption.defaultSymptoms();
    final match = symptoms.where((s) => s.id == id);
    return match.isNotEmpty ? match.first.name : id;
  }

  String _symptomCategory(String id) {
    final symptoms = SymptomOption.defaultSymptoms();
    final match = symptoms.where((s) => s.id == id);
    return match.isNotEmpty ? match.first.category : 'physical';
  }
}

class _MoodFace {
  final int rating;
  final IconData icon;

  const _MoodFace(this.rating, this.icon);
}
