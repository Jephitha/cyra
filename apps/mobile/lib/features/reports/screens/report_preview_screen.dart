import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/reports/models/report_models.dart';
import 'package:cyra/features/reports/providers/report_providers.dart';

class ReportPreviewScreen extends ConsumerStatefulWidget {
  final HealthReport report;

  const ReportPreviewScreen({super.key, required this.report});

  @override
  ConsumerState<ReportPreviewScreen> createState() =>
      _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends ConsumerState<ReportPreviewScreen> {
  bool _isDecrypting = true;
  String? _decryptedPath;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    if (widget.report.filePath == null) {
      setState(() {
        _error = 'No file associated with this report.';
        _isDecrypting = false;
      });
      return;
    }

    try {
      final repo = ref.read(reportRepositoryProvider);
      final file = await repo.decryptReportFile(widget.report.filePath!);

      setState(() {
        _decryptedPath = file.path;
        _isDecrypting = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to decrypt report: $e';
        _isDecrypting = false;
      });
    }
  }

  Future<void> _shareReport() async {
    if (_decryptedPath == null) return;

    try {
      await Share.shareXFiles(
        [XFile(_decryptedPath!)],
        subject:
            'Cyra Health Report - ${_reportTypeLabel(widget.report.reportType)}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _exportAsJson() async {
    try {
      final repo = ref.read(reportRepositoryProvider);
      final reportData = await repo.getReport(widget.report.id);

      if (reportData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report data not found.')),
          );
        }
        return;
      }

      final jsonData = {
        'reportId': reportData.id,
        'reportType': reportData.reportType,
        'dateRangeStart': reportData.dateRangeStart.toIso8601String(),
        'dateRangeEnd': reportData.dateRangeEnd.toIso8601String(),
        'generatedAt': DateTime.now().toIso8601String(),
        'filePath': reportData.filePath,
        'fileSize': reportData.fileSize,
      };

      final dir = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${dir.path}/exports');
      if (!await exportDir.exists()) await exportDir.create(recursive: true);

      final exportFile = File(
        '${exportDir.path}/report_${widget.report.id}_export.json',
      );
      await exportFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(jsonData),
      );

      await Share.shareXFiles(
        [XFile(exportFile.path)],
        subject: 'Cyra Report Data (JSON)',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteReport() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text(
            'Are you sure you want to delete this report? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(reportGeneratorProvider.notifier)
          .deleteReport(widget.report.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(_reportTypeLabel(widget.report.reportType)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteReport,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: _isDecrypting
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppSpacing.lg),
                  Text('Decrypting report...'),
                ],
              ),
            )
          : _error != null
              ? _buildErrorState(context, _error!)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                      AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
                  children: [
                    _buildSummaryCards(context, dateFormat, isDark),
                    const SizedBox(height: AppSpacing.xl),
                    _buildPreviewCard(context, isDark),
                    const SizedBox(height: AppSpacing.xl),
                    _buildActions(context),
                  ],
                ),
    );
  }

  Widget _buildSummaryCards(
      BuildContext context, DateFormat dateFormat, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Report Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const SizedBox(height: AppSpacing.md),
        AppCard.standard(
          child: Column(
            children: [
              _summaryRow(context, 'Report Type',
                  _reportTypeLabel(widget.report.reportType), isDark),
              const Divider(height: AppSpacing.lg),
              _summaryRow(
                  context,
                  'Date Range',
                  '${dateFormat.format(widget.report.dateRangeStart)} - '
                  '${dateFormat.format(widget.report.dateRangeEnd)}',
                  isDark),
              const Divider(height: AppSpacing.lg),
              _summaryRow(
                  context,
                  'Generated',
                  widget.report.createdAt != null
                      ? DateFormat('MMM d, yyyy – h:mm a')
                          .format(widget.report.createdAt!)
                      : 'Unknown',
                  isDark),
              const Divider(height: AppSpacing.lg),
              _summaryRow(
                  context,
                  'File Size',
                  widget.report.fileSize != null
                      ? _formatFileSize(widget.report.fileSize!)
                      : 'Unknown',
                  isDark),
              const Divider(height: AppSpacing.lg),
              _summaryRow(
                  context,
                  'Encrypted',
                  widget.report.filePath != null ? 'Yes' : 'No',
                  isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
      BuildContext context, String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.slate)),
        Text(value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color:
                      isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                )),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.mistWhite,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: _decryptedPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          File(_decryptedPath!),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => _buildPdfPlaceholder(
                              context, isDark),
                        ),
                      ),
                      if (!_isPdfImage(_decryptedPath!))
                        _buildPdfPlaceholder(context, isDark),
                    ],
                  ),
                )
              : _buildPdfPlaceholder(context, isDark),
        ),
      ],
    );
  }

  Widget _buildPdfPlaceholder(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.borderLight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf_rounded,
                size: 64, color: AppColors.forestGreen.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.md),
            Text('PDF Preview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.slate,
                    )),
            const SizedBox(height: AppSpacing.sm),
            Text('Open the file to view the full report.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate,
                    )),
            const SizedBox(height: AppSpacing.lg),
            AppButton.secondary(
              'Open File',
              icon: Icons.open_in_new_rounded,
              onPressed: _shareReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          'Share Report',
          icon: Icons.share_rounded,
          onPressed: _shareReport,
          width: double.infinity,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.secondary(
          'Export as JSON',
          icon: Icons.code_rounded,
          onPressed: _exportAsJson,
          width: double.infinity,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.ghost(
          'Delete Report',
          icon: Icons.delete_outline,
          onPressed: _deleteReport,
          width: double.infinity,
        ),
      ],
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
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              'Retry',
              onPressed: () {
                setState(() {
                  _isDecrypting = true;
                  _error = null;
                });
                _loadReport();
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isPdfImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].contains(ext);
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
