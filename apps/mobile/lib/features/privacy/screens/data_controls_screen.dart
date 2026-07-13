import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/providers/security_providers.dart';

class DataControlsScreen extends ConsumerStatefulWidget {
  const DataControlsScreen({super.key});

  @override
  ConsumerState<DataControlsScreen> createState() => _DataControlsScreenState();
}

class _DataControlsScreenState extends ConsumerState<DataControlsScreen> {
  DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;
  bool _showClearConfirmation = false;
  final _understandController = TextEditingController();

  @override
  void dispose() {
    _understandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildDataSummary(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Calendar'),
          const SizedBox(height: AppSpacing.sm),
          _buildCalendar(),
          if (_selectedDay != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildDayDetail(),
          ],
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Data Types'),
          const SizedBox(height: AppSpacing.sm),
          _buildDataTypeCards(),
          const SizedBox(height: AppSpacing.xxl),
          _buildSectionHeader('Export'),
          const SizedBox(height: AppSpacing.sm),
          _buildExportSection(),
          const SizedBox(height: AppSpacing.xxl),
          _buildClearAllSection(),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        title,
        style: AppTypography.light.titleSmall?.copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDataSummary() {
    return AppCard.highlighted(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryStat(label: 'Cycles', value: '12'),
            _SummaryStat(label: 'Symptoms', value: '143'),
            _SummaryStat(label: 'Journal', value: '28'),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = _daysInMonth(_calendarMonth.year, _calendarMonth.month);
    final offset = _firstWeekdayOffset(
      _calendarMonth.year,
      _calendarMonth.month,
    );
    final monthName = DateFormat('MMMM yyyy').format(_calendarMonth);

    return AppCard.standard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() {
                    _calendarMonth = DateTime(
                      _calendarMonth.year,
                      _calendarMonth.month - 1,
                    );
                  }),
                ),
                Text(
                  monthName,
                  style: AppTypography.light.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() {
                    _calendarMonth = DateTime(
                      _calendarMonth.year,
                      _calendarMonth.month + 1,
                    );
                  }),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                Row(
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: AppTypography.light.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xs),
                ...List.generate(((offset + daysInMonth) / 7).ceil(), (
                  rowIndex,
                ) {
                  return Row(
                    children: List.generate(7, (colIndex) {
                      final cellIndex = rowIndex * 7 + colIndex;
                      final day = cellIndex - offset + 1;
                      if (day < 1 || day > daysInMonth) {
                        return Expanded(child: Container());
                      }
                      final date = DateTime(
                        _calendarMonth.year,
                        _calendarMonth.month,
                        day,
                      );
                      final isSelected =
                          _selectedDay != null && _selectedDay!.isSameDay(date);
                      final isToday = _isToday(date);
                      final hasData = _hasDataForDate(date);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDay = date),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.forestGreen
                                  : hasData
                                  ? AppColors.forestGreen.withValues(
                                      alpha: 0.12,
                                    )
                                  : null,
                              shape: BoxShape.circle,
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '$day',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? AppColors.onBrand
                                            : null,
                                      ),
                                    ),
                                    if (isToday && !isSelected)
                                      Positioned(
                                        bottom: 2,
                                        child: Container(
                                          width: 4,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                            color: AppColors.forestGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetail() {
    final dateStr = DateFormat.yMMMMd().format(_selectedDay!);
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.light.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedDay = null),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Close'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildRecordRow('Period', 'Day 3', Icons.water_drop),
          const Divider(height: 1),
          _buildRecordRow('Symptoms', 'Headache, Fatigue', Icons.healing),
          const Divider(height: 1),
          _buildRecordRow('Journal', '1 entry', Icons.article_outlined),
        ],
      ),
    );
  }

  Widget _buildRecordRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.light.bodyMedium)),
          Text(
            value,
            style: AppTypography.light.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          InkWell(
            onTap: () => _handleSwipeDelete(label),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Icon(
                Icons.delete_outline,
                size: 18,
                color: AppColors.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTypeCards() {
    return Column(
      children: [
        _DataTypeCard(
          icon: Icons.water_drop,
          label: 'Cycle Data',
          count: '12 cycles',
          color: AppColors.forestGreen,
          onDeleteAll: () => _handleDeleteDataType('Cycle Data'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _DataTypeCard(
          icon: Icons.healing,
          label: 'Symptoms',
          count: '143 logged',
          color: AppColors.forestGreenLight,
          onDeleteAll: () => _handleDeleteDataType('Symptoms'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _DataTypeCard(
          icon: Icons.article_outlined,
          label: 'Journal Entries',
          count: '28 entries',
          color: AppColors.sage,
          onDeleteAll: () => _handleDeleteDataType('Journal Entries'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _DataTypeCard(
          icon: Icons.monitor_heart_outlined,
          label: 'Health Metrics',
          count: '89 records',
          color: AppColors.softGold,
          onDeleteAll: () => _handleDeleteDataType('Health Metrics'),
        ),
      ],
    );
  }

  Widget _buildExportSection() {
    return AppCard.standard(
      child: Column(
        children: [
          _buildExportRow(
            icon: Icons.file_download_outlined,
            label: 'Export as JSON',
            onTap: () => _handleExport('json'),
          ),
          const Divider(height: 1),
          _buildExportRow(
            icon: Icons.file_download_outlined,
            label: 'Export as CSV',
            onTap: () => _handleExport('csv'),
          ),
          const Divider(height: 1),
          _buildExportRow(
            icon: Icons.date_range_outlined,
            label: 'Export Date Range',
            onTap: () => _handleExportDateRange(),
          ),
        ],
      ),
    );
  }

  Widget _buildExportRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.light.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.slate, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearAllSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DANGER ZONE',
          style: AppTypography.light.titleSmall?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard.standard(
          backgroundColor: AppColors.error.withValues(alpha: 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.error, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Clearing all data is permanent and cannot be undone.',
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!_showClearConfirmation) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: AppButton.primary(
                    'Clear All Data',
                    icon: Icons.delete_forever,
                    onPressed: () =>
                        setState(() => _showClearConfirmation = true),
                  ),
                ),
              ] else ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type "I understand" to confirm:',
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _understandController,
                        decoration: InputDecoration(
                          hintText: 'I understand',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.secondary(
                              'Cancel',
                              onPressed: () {
                                setState(() {
                                  _showClearConfirmation = false;
                                  _understandController.clear();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppButton.primary(
                              'Delete Everything',
                              onPressed:
                                  _understandController.text.trim() ==
                                      'I understand'
                                  ? () => _handleClearAll()
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleSwipeDelete(String type) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Record?'),
        content: Text('Remove this $type record? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.showSnackBar('$type record deleted');
    }
  }

  Future<void> _handleDeleteDataType(String type) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete All $type?'),
        content: Text(
          'This will permanently delete all $type records. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.showSnackBar('All $type records deleted');
    }
  }

  Future<void> _handleExport(String format) async {
    try {
      final exportService = ref.read(dataExportServiceProvider);
      final file = await exportService.exportAllDataAsJson();
      if (mounted) {
        context.showSnackBar(
          'Data exported as $format: ${file.path.split('/').last}',
        );
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Export failed: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _handleExportDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
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
    if (range == null || !mounted) return;

    try {
      final exportService = ref.read(dataExportServiceProvider);
      final file = await exportService.exportDateRange(range.start, range.end);
      if (mounted) {
        context.showSnackBar('Data exported: ${file.path.split('/').last}');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Export failed: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _handleClearAll() async {
    try {
      final exportService = ref.read(dataExportServiceProvider);
      await exportService.deleteAllData();

      if (mounted) {
        setState(() {
          _showClearConfirmation = false;
          _understandController.clear();
        });
        context.showSnackBar('All data has been cleared');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          'Failed to clear data: ${e.toString()}',
          isError: true,
        );
      }
    }
  }

  bool _hasDataForDate(DateTime date) {
    return false;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  int _daysInMonth(int year, int month) {
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) return 29;
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) return 30;
    return 31;
  }

  int _firstWeekdayOffset(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    return firstDay.weekday % 7;
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.light.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.light.bodySmall?.copyWith(
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }
}

class _DataTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color color;
  final VoidCallback onDeleteAll;

  const _DataTypeCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.standard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.light.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    count,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onDeleteAll,
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: AppColors.error,
              ),
              label: Text(
                'Delete All',
                style: TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension DateTimeX on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

extension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : null,
        ),
      );
  }
}
