import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';

class LogOPKScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const LogOPKScreen({super.key, this.initialDate});

  @override
  ConsumerState<LogOPKScreen> createState() => _LogOPKScreenState();
}

class _LogOPKScreenState extends ConsumerState<LogOPKScreen> {
  late DateTime _selectedDate;
  OPKResult? _selectedResult;
  String _timeOfDay = 'Afternoon';
  String _brand = 'Clearblue';
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  final List<String> _timeOptions = ['Morning', 'Afternoon', 'Evening'];
  final List<String> _brandOptions = ['Clearblue', 'Easy@Home', 'Wondfo', 'Clinical Guard', 'Pregmate', 'First Response', 'AccuMed', 'Other'];

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

  Future<void> _save() async {
    if (_isSaving || _selectedResult == null) return;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(ovulationRepositoryProvider);
      final now = DateTime.now();

      await repo.saveOPK(OPKTestResult(
        id: 'opk_${_selectedDate.toIso8601String()}_${now.microsecondsSinceEpoch}',
        date: _selectedDate,
        result: _selectedResult!,
        timeOfDay: _timeOfDay,
        brand: _brand,
      ));

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log OPK Result', style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w600,
          )),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).maybePop()),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildDateSelector(isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildResultSelector(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildTimeOfDayPicker(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildBrandSelector(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildNotesField(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildTipsSection(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              _isSaving ? 'Saving...' : 'Save',
              icon: Icons.save_rounded,
              onPressed: (_selectedResult != null && !_isSaving) ? _save : null,
              isLoading: _isSaving,
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(bool isDark) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.forestGreen)),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.mistWhite,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal),
            ),
            if (_selectedDate.isSameDay(DateTime.now())) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                decoration: BoxDecoration(color: AppColors.forestGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.xs)),
                child: Text('Today', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.forestGreen)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultSelector(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Test Result', style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: AppSpacing.md),
        _ResultOption(
          label: 'Positive', description: 'Two lines — test line is as dark or darker than control',
          isSelected: _selectedResult == OPKResult.positive,
          selectedColor: AppColors.forestGreen,
          onTap: () => setState(() => _selectedResult = OPKResult.positive), isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ResultOption(
          label: 'Negative', description: 'One line or test line is lighter than control',
          isSelected: _selectedResult == OPKResult.negative,
          selectedColor: AppColors.slate,
          onTap: () => setState(() => _selectedResult = OPKResult.negative), isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ResultOption(
          label: 'Fading', description: 'Positive yesterday, test line is lighter today',
          isSelected: _selectedResult == OPKResult.fading,
          selectedColor: AppColors.softGold,
          onTap: () => setState(() => _selectedResult = OPKResult.fading), isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildTimeOfDayPicker(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time of Day', style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w500,
        )),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _timeOptions.map((time) {
              final isSelected = _timeOfDay == time;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => setState(() => _timeOfDay = time),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.forestGreen.withValues(alpha: isDark ? 0.3 : 0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: isSelected ? AppColors.forestGreen : (isDark ? AppColors.borderDark : AppColors.borderLight), width: isSelected ? 2 : 1),
                    ),
                    child: Text(time, style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? (isDark ? Colors.white : AppColors.forestGreen) : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    )),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandSelector(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brand', style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal, fontWeight: FontWeight.w500,
        )),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: _brand,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          ),
          items: _brandOptions.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
          onChanged: (v) { if (v != null) setState(() => _brand = v); },
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        ),
      ],
    );
  }

  Widget _buildNotesField(BuildContext context, bool isDark) {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Add notes (optional)',
        prefixIcon: Icon(Icons.edit_note_rounded, size: 20, color: AppColors.slate),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildTipsSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: isDark ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 20, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips for accurate OPK testing', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.forestGreen, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text('Best time to test is between 10am and 2pm. Avoid testing with first morning urine. Reduce fluid intake 2 hours before testing.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.slate)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultOption extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool isDark;

  const _ResultOption({required this.label, required this.description, required this.isSelected, required this.selectedColor, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true, selected: isSelected, label: '$label: $description',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor.withValues(alpha: isDark ? 0.2 : 0.08) : (isDark ? AppColors.charcoal.withValues(alpha: 0.15) : AppColors.mistWhite),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: isSelected ? selectedColor.withValues(alpha: 0.5) : (isDark ? AppColors.borderDark : AppColors.borderLight), width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              _buildTestStripIllustration(context),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? selectedColor : (isDark ? AppColors.textPrimaryDark : AppColors.charcoal), fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.slate)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestStripIllustration(BuildContext context) {
    return Container(
      width: 40, height: 56,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.borderLight)),
      child: CustomPaint(painter: _TestStripPainter(result: label, isSelected: isSelected, selectedColor: selectedColor)),
    );
  }
}

class _TestStripPainter extends CustomPainter {
  final String result;
  final bool isSelected;
  final Color selectedColor;
  _TestStripPainter({required this.result, required this.isSelected, required this.selectedColor});

  @override
  void paint(Canvas canvas, Size size) {
    final controlLineY = size.height * 0.3;
    final testLineY = size.height * 0.55;
    final lineWidth = size.width * 0.6;
    final lineStart = (size.width - lineWidth) / 2;

    canvas.drawLine(Offset(lineStart, controlLineY), Offset(lineStart + lineWidth, controlLineY), Paint()..color = AppColors.charcoal.withValues(alpha: 0.8)..strokeWidth = 3..strokeCap = StrokeCap.round);

    final testPaint = Paint()..strokeWidth = 3..strokeCap = StrokeCap.round;
    switch (result) {
      case 'Positive': testPaint.color = selectedColor.withValues(alpha: 0.9); canvas.drawLine(Offset(lineStart, testLineY), Offset(lineStart + lineWidth, testLineY), testPaint);
      case 'Negative': testPaint.color = AppColors.borderLight; canvas.drawLine(Offset(lineStart, testLineY), Offset(lineStart + lineWidth * 0.5, testLineY), testPaint);
      case 'Fading': testPaint.color = AppColors.softGold.withValues(alpha: 0.5); canvas.drawLine(Offset(lineStart, testLineY), Offset(lineStart + lineWidth * 0.7, testLineY), testPaint);
      default: testPaint.color = AppColors.borderLight; canvas.drawLine(Offset(lineStart, testLineY), Offset(lineStart + lineWidth * 0.5, testLineY), testPaint);
    }
  }

  @override
  bool shouldRepaint(_TestStripPainter old) => old.result != result || old.isSelected != isSelected;
}