import 'dart:io';

import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/security/data_export_service.dart';
import 'package:cyra/core/security/health_data_pdf_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class HealthDataExportSheet extends ConsumerStatefulWidget {
  const HealthDataExportSheet({super.key});

  @override
  ConsumerState<HealthDataExportSheet> createState() =>
      _HealthDataExportSheetState();
}

class _HealthDataExportSheetState extends ConsumerState<HealthDataExportSheet> {
  final _nameController = TextEditingController();
  late DateTimeRange _range;
  bool _includeDailyLog = true;
  bool _includeJournals = false;
  bool _isGenerating = false;
  File? _generatedFile;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(
      start: DateTime(now.year, now.month - 6, now.day),
      end: now,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Export my data',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close export',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Text(
              'A readable summary for you or your care team. Generated privately on this device.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name on report (optional)',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range_outlined),
              title: const Text('Date range'),
              subtitle: Text(
                '${DateFormat('d MMM yyyy').format(_range.start)} – '
                '${DateFormat('d MMM yyyy').format(_range.end)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _chooseRange,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _includeDailyLog,
              title: const Text('Include detailed daily log'),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() => _includeDailyLog = value ?? true);
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _includeJournals,
              title: const Text('Include journal entries'),
              subtitle: const Text(
                'Personal writing is excluded unless you deliberately include it.',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() => _includeJournals = value ?? false);
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (_generatedFile == null)
              AppButton.primary(
                'Generate PDF',
                icon: Icons.picture_as_pdf_outlined,
                isLoading: _isGenerating,
                onPressed: _isGenerating ? null : _generate,
                width: double.infinity,
              )
            else
              _buildGeneratedActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedActions(ThemeData theme) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(child: Text('Your PDF is ready')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareFile(savePrompt: false),
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _shareFile(savePrompt: true),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Save to device'),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Future<void> _chooseRange() async {
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _range,
    );
    if (selected != null && mounted) setState(() => _range = selected);
  }

  Future<void> _generate() async {
    setState(() {
      _isGenerating = true;
      _error = null;
    });
    try {
      final file = await ref
          .read(dataExportServiceProvider)
          .exportHealthDataPdf(
            HealthDataPdfRequest(
              start: _range.start,
              end: _range.end,
              name: _nameController.text,
              includeDailyLog: _includeDailyLog,
              includeJournalEntries: _includeJournals,
            ),
          );
      if (!mounted) return;
      setState(() => _generatedFile = file);
    } on DataExportException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _shareFile({required bool savePrompt}) async {
    final file = _generatedFile;
    if (file == null) return;
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: savePrompt ? 'Save Cyra health summary' : 'Cyra health summary',
      text: savePrompt
          ? 'Choose Files or Downloads to save this PDF to your device.'
          : 'Cycle and symptom summary generated by Cyra.',
    );
  }
}
