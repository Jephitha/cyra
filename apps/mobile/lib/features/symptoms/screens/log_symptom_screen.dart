import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/symptom_selector.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

class LogSymptomScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const LogSymptomScreen({super.key, this.initialDate});

  @override
  ConsumerState<LogSymptomScreen> createState() => _LogSymptomScreenState();
}

class _LogSymptomScreenState extends ConsumerState<LogSymptomScreen> {
  late DateTime _selectedDate;
  final Set<String> _selectedSymptomIds = {};
  final Map<String, int> _severities = {};
  final Map<String, TextEditingController> _noteControllers = {};
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Physical', 'Emotional', 'Lifestyle'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    for (final c in _noteControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<SymptomOption> get _allSymptoms => SymptomOption.defaultSymptoms();

  List<SymptomOption> get _currentSymptoms {
    final category = _tabs[_selectedTabIndex].toLowerCase();
    return _allSymptoms.where((s) => s.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todaySymptomsAsync = ref.watch(
      symptomsForDateProvider(_selectedDate),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context, isDark),
        body: todaySymptomsAsync.when(
          data: (_) => _buildBody(isDark),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildBody(isDark),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        'Body Check-In',
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

  Widget _buildBody(bool isDark) {
    return Column(
      children: [
        _buildDateSelector(isDark),
        _buildCategoryTabs(isDark),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xxxxl,
            ),
            child: _currentSymptoms.isEmpty
                ? _buildEmptyCategory(isDark)
                : _buildSymptomGrid(isDark),
          ),
        ),
        _buildBottomBar(isDark),
      ],
    );
  }

  Widget _buildDateSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
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
          GestureDetector(
            onTap: _pickDate,
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ),
          if (_selectedDate.isSameDay(DateTime.now())) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                'Today',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.forestGreen,
                ),
              ),
            ),
          ],
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
      setState(() => _selectedDate = picked);
    }
  }

  Widget _buildCategoryTabs(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == _selectedTabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.forestGreen
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.forestGreen : AppColors.slate,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSymptomGrid(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SymptomSelector(
          symptoms: _currentSymptoms,
          selectedSymptomIds: _selectedSymptomIds.toList(),
          onSelectionChanged: (ids) {
            setState(() {
              _selectedSymptomIds
                ..clear()
                ..addAll(ids);
            });
          },
        ),
        if (_selectedSymptomsWithDetails.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Selected Symptoms',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._selectedSymptomsWithDetails.map((option) {
            return _buildSymptomChip(option, isDark);
          }),
        ],
      ],
    );
  }

  List<SymptomOption> get _selectedSymptomsWithDetails {
    final category = _tabs[_selectedTabIndex].toLowerCase();
    return _allSymptoms
        .where(
          (s) => _selectedSymptomIds.contains(s.id) && s.category == category,
        )
        .toList();
  }

  Widget _buildSymptomChip(SymptomOption option, bool isDark) {
    final severity = _severities[option.id] ?? 1;
    final controller = _noteControllers.putIfAbsent(
      option.id,
      () => TextEditingController(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.mistWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: option.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(option.icon, size: 20, color: option.color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                option.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                ),
              ),
              const Spacer(),
              _buildSeverityLabel(severity),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSeveritySlider(option.id, severity, option.color),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Add note...',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityLabel(int severity) {
    final labels = {1: 'Mild', 2: 'Moderate', 3: 'Severe'};
    final colors = {
      1: AppColors.success,
      2: AppColors.warning,
      3: AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors[severity]!.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        labels[severity]!,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colors[severity],
        ),
      ),
    );
  }

  Widget _buildSeveritySlider(String symptomId, int severity, Color color) {
    return Row(
      children: [
        Text('Mild', style: TextStyle(fontSize: 11, color: AppColors.slate)),
        Expanded(
          child: Slider(
            value: severity.toDouble(),
            min: 1,
            max: 3,
            divisions: 2,
            activeColor: color,
            inactiveColor: color.withValues(alpha: 0.2),
            onChanged: (val) {
              setState(() => _severities[symptomId] = val.round());
            },
          ),
        ),
        Text('Severe', style: TextStyle(fontSize: 11, color: AppColors.slate)),
      ],
    );
  }

  Widget _buildEmptyCategory(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.healing_outlined,
              size: 48,
              color: AppColors.slate.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No symptoms logged yet',
              style: TextStyle(fontSize: 16, color: AppColors.slate),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tap a symptom above to log it',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.slate.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
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
        child: AppButton.primary(
          'Save Check-In',
          icon: Icons.check,
          onPressed: _selectedSymptomIds.isEmpty ? null : _save,
          width: double.infinity,
        ),
      ),
    );
  }

  Future<void> _save() async {
    final entries = <SymptomEntry>[];
    final now = DateTime.now();

    for (final id in _selectedSymptomIds) {
      final option = _allSymptoms.firstWhere((s) => s.id == id);
      final notes = _noteControllers[id]?.text;
      entries.add(
        SymptomEntry(
          id: '${_selectedDate.toIso8601String()}_${id}_${now.microsecondsSinceEpoch}',
          date: _selectedDate,
          symptomId: id,
          symptomName: option.name,
          severity: _severities[id] ?? 1,
          notes: notes?.isNotEmpty == true ? notes : null,
          category: option.category,
        ),
      );
    }

    await ref.read(symptomLoggerProvider.notifier).saveSymptoms(entries);
    if (mounted) Navigator.of(context).maybePop(true);
  }
}
