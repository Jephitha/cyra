import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/reports/models/report_models.dart';
import 'package:cyra/features/reports/providers/report_providers.dart';
import 'package:cyra/features/reports/screens/generate_report_screen.dart';
import 'package:cyra/features/reports/screens/report_preview_screen.dart';

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(allReportsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Health Reports')),
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorState(context, e.toString()),
        data: (reports) => reports.isEmpty
            ? _buildEmptyState(context, ref, isDark)
            : _buildReportsList(context, ref, reports, isDark),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToGenerate(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildReportsList(BuildContext context, WidgetRef ref,
      List<HealthReport> reports, bool isDark) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        final typeLabel = _reportTypeLabel(report.reportType);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Dismissible(
            key: Key(report.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child:
                  const Icon(Icons.delete_outline, color: AppColors.onBrand, size: 28),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Report'),
                  content: const Text(
                      'Are you sure you want to delete this report?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.error),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) {
              ref
                  .read(reportGeneratorProvider.notifier)
                  .deleteReport(report.id);
            },
            child: AppCard.interactive(
              onTap: () => _navigateToPreview(context, ref, report),
              child: Row(
                children: [
                  _buildReportTypeIcon(report.reportType),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeLabel,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.charcoal,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '${dateFormat.format(report.dateRangeStart)} - '
                          '${dateFormat.format(report.dateRangeEnd)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.slate),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 12, color: AppColors.slate),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              timeFormat.format(report.createdAt ?? report.dateRangeStart),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.slate),
                            ),
                            if (report.fileSize != null) ...[
                              const SizedBox(width: AppSpacing.md),
                              Icon(Icons.storage_rounded,
                                  size: 12, color: AppColors.slate),
                              const SizedBox(width: AppSpacing.xxs),
                              Text(
                                _formatFileSize(report.fileSize!),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: AppColors.slate),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    color: AppColors.forestGreen,
                    onPressed: () => _shareReport(context, ref, report),
                    tooltip: 'Share',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'cycle_summary':
        icon = Icons.repeat_rounded;
        color = AppColors.forestGreen;
      case 'fertility_report':
        icon = Icons.favorite_rounded;
        color = AppColors.period;
      case 'symptom_report':
        icon = Icons.healing_rounded;
        color = AppColors.sage;
      default:
        icon = Icons.description_rounded;
        color = AppColors.softGold;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, WidgetRef ref, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_rounded,
                  size: 44, color: AppColors.forestGreen),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'No reports yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Generate a health summary to share with your doctor.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.slate),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton.primary(
              'Generate New Report',
              icon: Icons.add_rounded,
              onPressed: () => _navigateToGenerate(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(error, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _navigateToGenerate(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const GenerateReportScreen()),
    );
  }

  void _navigateToPreview(
      BuildContext context, WidgetRef ref, HealthReport report) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReportPreviewScreen(report: report),
      ),
    );
  }

  Future<void> _shareReport(
      BuildContext context, WidgetRef ref, HealthReport report) async {
    if (report.filePath == null) return;

    try {
      final repo = ref.read(reportRepositoryProvider);
      final file = await repo.decryptReportFile(report.filePath!);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Cyra Health Report - ${_reportTypeLabel(report.reportType)}',
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

  String _reportTypeLabel(String type) {
    switch (type) {
      case 'cycle_summary':
        return 'Cycle Summary';
      case 'fertility_report':
        return 'Fertility Report';
      case 'symptom_report':
        return 'Symptom Report';
      case 'full_history':
        return 'Full History';
      default:
        return type;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
