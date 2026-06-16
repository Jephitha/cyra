import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';

class LogOPKScreen extends StatefulWidget {
  const LogOPKScreen({super.key});

  @override
  State<LogOPKScreen> createState() => _LogOPKScreenState();
}

class _LogOPKScreenState extends State<LogOPKScreen> {
  String? _selectedResult;
  String _timeOfDay = 'Afternoon';
  String _brand = 'Clearblue';
  final TextEditingController _notesController = TextEditingController();
  String? _photoPath;

  final List<String> _timeOptions = ['Morning', 'Afternoon', 'Evening'];
  final List<String> _brandOptions = [
    'Clearblue',
    'Easy@Home',
    'Wondfo',
    'Clinical Guard',
    'Pregmate',
    'First Response',
    'AccuMed',
    'Other',
  ];

  int currentCycleDay = 14;
  int cycleLength = 28;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Log OPK Result',
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildCycleDayBanner(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildResultSelector(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildTimeOfDayPicker(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildBrandSelector(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildPhotoAttachment(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildNotesField(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildTipsSection(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              'Save',
              icon: Icons.save_rounded,
              onPressed: _selectedResult != null ? _save : null,
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleDayBanner(BuildContext context, bool isDark) {
    final ovulationDay = cycleLength - 14;
    final isInWindow = currentCycleDay >= ovulationDay - 5 && currentCycleDay <= ovulationDay + 1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isInWindow
              ? [AppColors.forestGreen.withValues(alpha: 0.1), AppColors.forestGreen.withValues(alpha: 0.03)]
              : [AppColors.slate.withValues(alpha: 0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isInWindow
              ? AppColors.forestGreen.withValues(alpha: 0.3)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: isInWindow ? AppColors.forestGreen : AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cycle Day $currentCycleDay',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  isInWindow
                      ? 'You are in your fertile window'
                      : 'You are not in your fertile window',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isInWindow ? AppColors.forestGreen : AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
            decoration: BoxDecoration(
              color: isInWindow
                  ? AppColors.forestGreen.withValues(alpha: 0.15)
                  : AppColors.slate.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Text(
              isInWindow ? 'Fertile' : 'Not Fertile',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isInWindow ? AppColors.forestGreen : AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSelector(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Test Result',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _ResultOption(
          label: 'Positive',
          description: 'Two lines — test line is as dark or darker than control',
          emoji: '🙂',
          isSelected: _selectedResult == 'Positive',
          selectedColor: AppColors.forestGreen,
          onTap: () => setState(() => _selectedResult = 'Positive'),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ResultOption(
          label: 'Negative',
          description: 'One line or test line is lighter than control',
          emoji: '😐',
          isSelected: _selectedResult == 'Negative',
          selectedColor: AppColors.slate,
          onTap: () => setState(() => _selectedResult = 'Negative'),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ResultOption(
          label: 'Fading',
          description: 'Positive yesterday, test line is lighter today',
          emoji: '🤔',
          isSelected: _selectedResult == 'Fading',
          selectedColor: AppColors.softGold,
          onTap: () => setState(() => _selectedResult = 'Fading'),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildTimeOfDayPicker(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time of Day',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.forestGreen.withValues(alpha: isDark ? 0.3 : 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.forestGreen
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      time,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.forestGreen)
                            : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
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
        Text(
          'Brand',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: _brand,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          items: _brandOptions.map((brand) {
            return DropdownMenuItem(value: brand, child: Text(brand));
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _brand = value);
          },
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        ),
      ],
    );
  }

  Widget _buildPhotoAttachment(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        color: _photoPath != null
            ? AppColors.forestGreen.withValues(alpha: 0.06)
            : null,
      ),
      child: InkWell(
        onTap: () {
          // In production, launch image picker
          setState(() => _photoPath = _photoPath == null ? 'placeholder' : null);
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Row(
          children: [
            Icon(
              _photoPath != null ? Icons.check_circle_rounded : Icons.photo_camera_outlined,
              size: 24,
              color: _photoPath != null ? AppColors.forestGreen : AppColors.slate,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                _photoPath != null ? 'Photo attached' : 'Attach photo of test strip',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _photoPath != null
                      ? AppColors.forestGreen
                      : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                ),
              ),
            ),
            Icon(
              _photoPath != null ? Icons.close : Icons.add_rounded,
              size: 20,
              color: _photoPath != null ? AppColors.error : AppColors.slate,
            ),
          ],
        ),
      ),
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
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.2),
        ),
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
                Text(
                  'Tips for accurate OPK testing',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Best time to test is between 10am and 2pm. '
                  'Avoid testing with first morning urine. '
                  'Reduce fluid intake 2 hours before testing for accurate results.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
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
  final String emoji;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool isDark;

  const _ResultOption({
    required this.label,
    required this.description,
    required this.emoji,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label: $description',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withValues(alpha: isDark ? 0.2 : 0.08)
                : (isDark ? AppColors.charcoal.withValues(alpha: 0.15) : AppColors.mistWhite),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.5)
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _buildTestStripIllustration(context),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? selectedColor : (isDark ? AppColors.textPrimaryDark : AppColors.charcoal),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
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
      width: 40,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: CustomPaint(
        painter: _TestStripPainter(
          result: label,
          isSelected: isSelected,
          selectedColor: selectedColor,
        ),
      ),
    );
  }
}

class _TestStripPainter extends CustomPainter {
  final String result;
  final bool isSelected;
  final Color selectedColor;

  _TestStripPainter({
    required this.result,
    required this.isSelected,
    required this.selectedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final controlLineY = size.height * 0.3;
    final testLineY = size.height * 0.55;
    final lineWidth = size.width * 0.6;
    final lineStart = (size.width - lineWidth) / 2;

    final controlPaint = Paint()
      ..color = AppColors.charcoal.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(lineStart, controlLineY),
      Offset(lineStart + lineWidth, controlLineY),
      controlPaint,
    );

    final testPaint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    switch (result) {
      case 'Positive':
        testPaint.color = selectedColor.withValues(alpha: 0.9);
        canvas.drawLine(
          Offset(lineStart, testLineY),
          Offset(lineStart + lineWidth, testLineY),
          testPaint,
        );
      case 'Negative':
        testPaint.color = AppColors.borderLight;
        canvas.drawLine(
          Offset(lineStart, testLineY),
          Offset(lineStart + lineWidth * 0.5, testLineY),
          testPaint,
        );
      case 'Fading':
        testPaint.color = AppColors.softGold.withValues(alpha: 0.5);
        canvas.drawLine(
          Offset(lineStart, testLineY),
          Offset(lineStart + lineWidth * 0.7, testLineY),
          testPaint,
        );
      default:
        testPaint.color = AppColors.borderLight;
        canvas.drawLine(
          Offset(lineStart, testLineY),
          Offset(lineStart + lineWidth * 0.5, testLineY),
          testPaint,
        );
    }
  }

  @override
  bool shouldRepaint(_TestStripPainter oldDelegate) =>
      oldDelegate.result != result || oldDelegate.isSelected != isSelected;
}
