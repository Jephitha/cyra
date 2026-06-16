import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/symptom_bar_chart.dart';
import 'package:cyra/core/design/widgets/symptom_selector.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

enum _DateRange { days7, days30, days90, custom }

class SymptomHistoryScreen extends ConsumerStatefulWidget {
  const SymptomHistoryScreen({super.key});

  @override
  ConsumerState<SymptomHistoryScreen> createState() =>
      _SymptomHistoryScreenState();
}

class _SymptomHistoryScreenState extends ConsumerState<SymptomHistoryScreen> {
  _DateRange _selectedRange = _DateRange.days30;
  bool _viewByCycle = false;
  String? _categoryFilter;

  DateTime get _rangeStart {
    switch (_selectedRange) {
      case _DateRange.days7:
        return DateTime.now().subtract(const Duration(days: 7));
      case _DateRange.days30:
        return DateTime.now().subtract(const Duration(days: 30));
      case _DateRange.days90:
        return DateTime.now().subtract(const Duration(days: 90));
      case _DateRange.custom:
        return _customStart;
    }
  }

  DateTime _customStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _customEnd = DateTime.now();

  final List<String> _categories = ['physical', 'emotional', 'lifestyle'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternsAsync = ref.watch(symptomPatternsProvider);
    final symptomsAsync = ref.watch(symptomsInRangeProvider(_rangeStart, DateTime.now()));

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(symptomPatternsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateRangeSelector(isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildFilterRow(isDark),
              const SizedBox(height: AppSpacing.lg),
              symptomsAsync.when(
                data: (symptoms) => patternsAsync.when(
                  data: (patterns) => _buildContent(isDark, symptoms, patterns),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _buildError(e),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => _buildError(e),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        'Symptoms',
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildDateRangeSelector(bool isDark) {
    final ranges = {
      _DateRange.days7: '7 days',
      _DateRange.days30: '30 days',
      _DateRange.days90: '90 days',
      _DateRange.custom: 'Custom',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ranges.entries.map((entry) {
          final isSelected = entry.key == _selectedRange;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedRange = entry.key);
                if (entry.key == _DateRange.custom) {
                  _pickCustomRange();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.forestGreen
                      : (isDark
                          ? AppColors.charcoal.withValues(alpha: 0.3)
                          : AppColors.mistWhite),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.forestGreen
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: Text(
                  ranges[entry.key]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterRow(bool isDark) {
    return Row(
      children: [
        _buildToggle('View by cycle', _viewByCycle, () {
          setState(() => _viewByCycle = !_viewByCycle);
        }, isDark),
        const Spacer(),
        DropdownButton<String?>(
          value: _categoryFilter,
          hint: const Text('All', style: TextStyle(fontSize: 13)),
          underline: const SizedBox(),
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          items: [
            const DropdownMenuItem(value: null, child: Text('All', style: TextStyle(fontSize: 13))),
            ..._categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.capitalize, style: const TextStyle(fontSize: 13)),
                )),
          ],
          onChanged: (val) => setState(() => _categoryFilter = val),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, bool value, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: value
              ? AppColors.forestGreen.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: value
                ? AppColors.forestGreen.withValues(alpha: 0.3)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: value ? AppColors.forestGreen : AppColors.slate,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: value ? AppColors.forestGreen : AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      bool isDark, List<SymptomEntry> symptoms, List<SymptomPattern> patterns) {
    if (symptoms.isEmpty) {
      return _buildEmptyState(isDark);
    }

    final filtered = _categoryFilter != null
        ? patterns.where((p) {
            final matching = symptoms.where((s) => s.symptomId == p.symptomId);
            return matching.any((s) => s.category == _categoryFilter);
          }).toList()
        : patterns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filtered.isNotEmpty)
          AppCard.chart(
            title: 'Most Common Symptoms',
            child: SizedBox(
              height: 220,
              child: SymptomBarChart(
                symptoms: filtered.take(8).map((p) {
                  return SymptomBarData(
                    label: p.symptomName,
                    value: p.frequency.toDouble(),
                    color: _symptomColor(p.symptomId),
                  );
                }).toList(),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Symptom Patterns',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (filtered.isEmpty)
          _buildEmptyState(isDark)
        else
          ...filtered.map((p) => _buildPatternCard(p, symptoms, isDark)),
      ],
    );
  }

  Widget _buildPatternCard(
      SymptomPattern pattern, List<SymptomEntry> allSymptoms, bool isDark) {
    final symptomLogs = allSymptoms
        .where((s) => s.symptomId == pattern.symptomId)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard.standard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _symptomIcon(pattern.symptomId),
                  size: 22,
                  color: _symptomColor(pattern.symptomId),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  pattern.symptomName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const Spacer(),
                _buildSeverityBadge(pattern.averageSeverity),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _statItem('Logged', '${pattern.frequency}x', isDark),
                const SizedBox(width: AppSpacing.xxl),
                _statItem('Avg Severity',
                    pattern.averageSeverity.toStringAsFixed(1), isDark),
                const SizedBox(width: AppSpacing.xxl),
                _statItem('Cycle Days',
                    pattern.commonCycleDays.isEmpty
                        ? 'N/A'
                        : '${pattern.commonCycleDays.first}-${pattern.commonCycleDays.last}',
                    isDark),
              ],
            ),
            if (pattern.correlation != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  pattern.correlation!,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.sage,
                  ),
                ),
              ),
            ],
            if (symptomLogs.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildSparkline(symptomLogs, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSparkline(List<SymptomEntry> logs, bool isDark) {
    if (logs.isEmpty) return const SizedBox.shrink();

    logs.sort((a, b) => a.date.compareTo(b.date));
    final maxVal = 3.0;

    return SizedBox(
      height: 40,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (logs.length - 1).toDouble().clamp(1, double.infinity),
          minY: 0,
          maxY: maxVal,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(logs.length,
                  (i) => FlSpot(i.toDouble(), logs[i].severity.toDouble())),
              isCurved: true,
              preventCurveOverShooting: true,
              color: AppColors.forestGreen,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.forestGreen.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(double avg) {
    final color = avg <= 1.5
        ? AppColors.success
        : avg <= 2.5
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        avg.toStringAsFixed(1),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 56,
              color: AppColors.slate.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Start logging symptoms to see patterns',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxxl),
        child: Text(
          'Something went wrong',
          style: TextStyle(color: AppColors.error),
        ),
      ),
    );
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _customStart, end: _customEnd),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                Theme.of(context).colorScheme.copyWith(primary: AppColors.forestGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _customStart = picked.start;
        _customEnd = picked.end;
      });
    }
  }

  Color _symptomColor(String id) {
    final symptoms = SymptomOption.defaultSymptoms();
    final match = symptoms.where((s) => s.id == id);
    return match.isNotEmpty ? match.first.color : AppColors.sage;
  }

  IconData _symptomIcon(String id) {
    final symptoms = SymptomOption.defaultSymptoms();
    final match = symptoms.where((s) => s.id == id);
    return match.isNotEmpty ? match.first.icon : Icons.healing_outlined;
  }
}
