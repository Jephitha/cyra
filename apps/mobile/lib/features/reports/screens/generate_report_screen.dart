import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/reports/providers/report_providers.dart';

final _selectedTypeProvider = StateProvider<String>((ref) => 'cycle_summary');

final _datePresetProvider = StateProvider<String>((ref) => '3months');

final _customStartProvider = StateProvider<DateTime?>((ref) => null);

final _customEndProvider = StateProvider<DateTime?>((ref) => null);

final _isGeneratingProvider = StateProvider<bool>((ref) => false);

final _generatedFileProvider = StateProvider<File?>((ref) => null);

class GenerateReportScreen extends ConsumerWidget {
  const GenerateReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(_selectedTypeProvider);
    final datePreset = ref.watch(_datePresetProvider);
    final isGenerating = ref.watch(_isGeneratingProvider);
    final generatedFile = ref.watch(_generatedFileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate Report')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          _buildReportTypes(context, ref, selectedType, isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildDateRangeSection(context, ref, datePreset, isDark),
          const SizedBox(height: AppSpacing.xl),
          if (generatedFile != null)
            _buildShareSection(context, ref, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildGenerateButton(context, ref, selectedType, datePreset, isGenerating),
          const SizedBox(height: AppSpacing.lg),
          _buildPrivacyNote(context, isDark),
        ],
      ),
    );
  }

  Widget _buildReportTypes(
      BuildContext context, WidgetRef ref, String selected, bool isDark) {
    final types = [
      _ReportTypeConfig(
        'cycle_summary',
        'Cycle Summary',
        Icons.repeat_rounded,
        AppColors.forestGreen,
        'Overview of your cycles, averages, and predictions.',
      ),
      _ReportTypeConfig(
        'fertility_report',
        'Fertility Report',
        Icons.favorite_rounded,
        AppColors.period,
        'BBT, OPK results, and fertile window analysis.',
      ),
      _ReportTypeConfig(
        'symptom_report',
        'Symptom Report',
        Icons.healing_rounded,
        AppColors.sage,
        'Symptom patterns, severity trends, and correlations.',
      ),
      _ReportTypeConfig(
        'full_history',
        'Full History',
        Icons.description_rounded,
        AppColors.softGold,
        'Comprehensive report of all tracked health data.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Report Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                )),
        const SizedBox(height: AppSpacing.md),
        ...types.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard.interactive(
                onTap: () =>
                    ref.read(_selectedTypeProvider.notifier).state = type.id,
                backgroundColor: selected == type.id
                    ? type.color.withValues(alpha: 0.06)
                    : null,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: selected == type.id
                            ? type.color.withValues(alpha: 0.15)
                            : (isDark
                                ? AppColors.charcoal.withValues(alpha: 0.3)
                                : AppColors.mistWhite),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(type.icon,
                          color: selected == type.id
                              ? type.color
                              : AppColors.slate,
                          size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.charcoal,
                                  )),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(type.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.slate)),
                        ],
                      ),
                    ),
                    if (selected == type.id)
                      Icon(Icons.check_circle_rounded,
                          color: type.color, size: 22),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildDateRangeSection(
      BuildContext context, WidgetRef ref, String preset, bool isDark) {
    final presets = [
      _DatePreset('3months', '3 Months'),
      _DatePreset('6months', '6 Months'),
      _DatePreset('1year', '1 Year'),
      _DatePreset('custom', 'Custom Range'),
    ];

    final customStart = ref.watch(_customStartProvider);
    final customEnd = ref.watch(_customEndProvider);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Range',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                )),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: presets.map((p) {
            final isSelected = preset == p.id;
            return ChoiceChip(
              label: Text(p.label),
              selected: isSelected,
              onSelected: (_) {
                ref.read(_datePresetProvider.notifier).state = p.id;
                ref.read(_generatedFileProvider.notifier).state = null;
              },
              selectedColor: AppColors.forestGreen.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.forestGreen : null,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
        if (preset == 'custom') ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          customStart ?? DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      ref.read(_customStartProvider.notifier).state = picked;
                      ref.read(_generatedFileProvider.notifier).state = null;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.mistWhite,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                          color:
                              isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.slate)),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          customStart != null
                              ? dateFormat.format(customStart)
                              : 'Select date',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: customEnd ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      ref.read(_customEndProvider.notifier).state = picked;
                      ref.read(_generatedFileProvider.notifier).state = null;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.mistWhite,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                          color:
                              isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('End',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.slate)),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          customEnd != null
                              ? dateFormat.format(customEnd)
                              : 'Select date',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context, WidgetRef ref,
      String type, String preset, bool isGenerating) {
    return AppButton.primary(
      isGenerating ? 'Generating...' : 'Generate PDF',
      icon: isGenerating ? null : Icons.picture_as_pdf_rounded,
      isLoading: isGenerating,
      onPressed: isGenerating
          ? null
          : () => _generateReport(context, ref, type, preset),
      width: double.infinity,
    );
  }

  Future<void> _generateReport(BuildContext context, WidgetRef ref,
      String type, String preset) async {
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (preset) {
      case '3months':
        start = now.subtract(const Duration(days: 90));
      case '6months':
        start = now.subtract(const Duration(days: 180));
      case '1year':
        start = now.subtract(const Duration(days: 365));
      case 'custom':
        final customStart = ref.read(_customStartProvider);
        final customEnd = ref.read(_customEndProvider);
        if (customStart == null || customEnd == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select start and end dates.')),
          );
          return;
        }
        start = customStart;
        end = customEnd;
      default:
        start = now.subtract(const Duration(days: 90));
    }

    ref.read(_isGeneratingProvider.notifier).state = true;

    try {
      final generator = ref.read(reportGeneratorProvider.notifier);
      File file;

      switch (type) {
        case 'cycle_summary':
          file = await generator.generateCycleSummary(start, end);
        case 'fertility_report':
          file = await generator.generateFertilityReport(start, end);
        case 'symptom_report':
          file = await generator.generateSymptomReport(start, end);
        case 'full_history':
          file = await generator.generateFullHistory();
        default:
          file = await generator.generateCycleSummary(start, end);
      }

      ref.read(_generatedFileProvider.notifier).state = file;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report generated successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        ref.read(_isGeneratingProvider.notifier).state = false;
      }
    }
  }

  Widget _buildShareSection(
      BuildContext context, WidgetRef ref, bool isDark) {
    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  size: 20, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Text('Report Generated',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            'Share Report',
            icon: Icons.share_rounded,
            onPressed: () => _shareReport(context, ref),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Future<void> _shareReport(BuildContext context, WidgetRef ref) async {
    final file = ref.read(_generatedFileProvider);
    if (file == null) return;

    try {
      final repo = ref.read(reportRepositoryProvider);
      final decrypted = await repo.decryptReportFile(file.path);
      await Share.shareXFiles(
        [XFile(decrypted.path)],
        subject: 'Cyra Health Report',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildPrivacyNote(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color: AppColors.softGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline,
              size: 18, color: AppColors.softGold),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This report is generated on-device and stored encrypted.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.charcoal,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTypeConfig {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String description;

  const _ReportTypeConfig(
      this.id, this.label, this.icon, this.color, this.description);
}

class _DatePreset {
  final String id;
  final String label;

  const _DatePreset(this.id, this.label);
}
