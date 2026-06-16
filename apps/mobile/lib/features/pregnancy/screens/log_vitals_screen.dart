import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/extensions.dart';

class LogVitalsScreen extends StatefulWidget {
  final String? initialSection;

  const LogVitalsScreen({super.key, this.initialSection});

  @override
  State<LogVitalsScreen> createState() => _LogVitalsScreenState();
}

class _LogVitalsScreenState extends State<LogVitalsScreen> {
  late String _activeSection;

  final _weightController = TextEditingController();
  bool _useLbs = false;

  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  final _glucoseController = TextEditingController();
  bool _glucoseFasting = true;
  bool _useMgDl = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeSection = widget.initialSection ?? 'weight';
  }

  @override
  void dispose() {
    _weightController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _glucoseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    context.showSnackBar('Vitals saved successfully');
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Log Vitals',
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          children: [
            _buildSectionTabs(isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildActiveSection(isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildDateTimePicker(context, isDark),
            const SizedBox(height: AppSpacing.md),
            _buildNotesField(isDark),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              'Save',
              icon: Icons.save_rounded,
              onPressed: _save,
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTabs(bool isDark) {
    final sections = [
      ('weight', Icons.monitor_weight_rounded, 'Weight'),
      ('blood_pressure', Icons.favorite_rounded, 'BP'),
      ('glucose', Icons.bloodtype_rounded, 'Glucose'),
    ];

    return Row(
      children: sections.map((section) {
        final isActive = _activeSection == section.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _activeSection = section.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? AppColors.forestGreen
                        : (isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight),
                    width: isActive ? 2.5 : 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    section.$2,
                    size: 22,
                    color: isActive
                        ? AppColors.forestGreen
                        : AppColors.slate,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    section.$3,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? AppColors.forestGreen
                          : AppColors.slate,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActiveSection(bool isDark) {
    switch (_activeSection) {
      case 'weight':
        return _buildWeightSection(isDark);
      case 'blood_pressure':
        return _buildBloodPressureSection(isDark);
      case 'glucose':
        return _buildGlucoseSection(isDark);
      default:
        return _buildWeightSection(isDark);
    }
  }

  Widget _buildWeightSection(bool isDark) {
    final unit = _useLbs ? 'lbs' : 'kg';
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monitor_weight_rounded,
                size: 20,
                color: AppColors.sage,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Weight',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Weight ($unit)',
                    hintText: 'Enter your weight',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                children: [
                  Text(
                    'Unit',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('kg')),
                      ButtonSegment(value: true, label: Text('lbs')),
                    ],
                    selected: {_useLbs},
                    onSelectionChanged: (set) =>
                        setState(() => _useLbs = set.first),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildWeightGuidance(context, isDark),
        ],
      ),
    );
  }

  Widget _buildWeightGuidance(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.sage,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expected Weight Gain',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.sage,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'For a healthy BMI: 11.5-16 kg (25-35 lbs) total gain recommended.',
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

  Widget _buildBloodPressureSection(bool isDark) {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);
    final bpStatus = _bloodPressureStatus(systolic, diastolic);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 20,
                color: bpStatus.color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Blood Pressure',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: bpStatus.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Text(
                  bpStatus.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bpStatus.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _systolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Systolic',
                    hintText: '120',
                    helperText: 'Top number',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text('/', style: TextStyle(fontSize: 24)),
              ),
              Expanded(
                child: TextField(
                  controller: _diastolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Diastolic',
                    hintText: '80',
                    helperText: 'Bottom number',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _bpIndicator(context, bpStatus, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildBPInfo(context, isDark),
        ],
      ),
    );
  }

  _BpStatus _bloodPressureStatus(int? systolic, int? diastolic) {
    if (systolic == null || diastolic == null) {
      return _BpStatus('--', AppColors.slate);
    }
    if (systolic < 120 && diastolic < 80) {
      return _BpStatus('Normal', AppColors.success);
    }
    if (systolic < 130 && diastolic < 85) {
      return _BpStatus('Elevated', AppColors.softGold);
    }
    if (systolic < 140 || diastolic < 90) {
      return _BpStatus('Stage 1 High', AppColors.warning);
    }
    return _BpStatus('Stage 2 High', AppColors.error);
  }

  Widget _bpIndicator(BuildContext context, _BpStatus status, bool isDark) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        gradient: LinearGradient(
          colors: [
            AppColors.success,
            AppColors.softGold,
            AppColors.warning,
            AppColors.error,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xs),
                gradient: LinearGradient(
                  colors: [
                    AppColors.success,
                    AppColors.success.withValues(alpha: 0.3),
                  ],
                  stops: const [0.0, 0.25],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.softGold.withValues(alpha: 0.3),
                    AppColors.softGold.withValues(alpha: 0.1),
                  ],
                  stops: const [0.0, 0.25],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.1),
                    AppColors.warning.withValues(alpha: 0.3),
                  ],
                  stops: const [0.0, 0.25],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppRadius.xs),
                  bottomRight: Radius.circular(AppRadius.xs),
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColors.error.withValues(alpha: 0.3),
                    AppColors.error,
                  ],
                  stops: const [0.0, 0.25],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBPInfo(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.forestGreen,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blood Pressure in Pregnancy',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Normal BP is <120/80. Elevated BP should be monitored. Contact your provider if BP exceeds 140/90.',
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

  Widget _buildGlucoseSection(bool isDark) {
    final glucose = double.tryParse(_glucoseController.text);
    final glucoseStatus = _glucoseStatus(glucose);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bloodtype_rounded,
                size: 20,
                color: glucoseStatus.color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Glucose',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: glucoseStatus.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Text(
                  glucoseStatus.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: glucoseStatus.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _glucoseController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _useMgDl
                        ? 'Blood Sugar (mg/dL)'
                        : 'Blood Sugar (mmol/L)',
                    hintText: _useMgDl ? '100' : '5.5',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                children: [
                  Text(
                    'Unit',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('mmol/L')),
                      ButtonSegment(value: true, label: Text('mg/dL')),
                    ],
                    selected: {_useMgDl},
                    onSelectionChanged: (set) =>
                        setState(() => _useMgDl = set.first),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text(
                'Fasting',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Switch(
                value: _glucoseFasting,
                onChanged: (val) =>
                    setState(() => _glucoseFasting = val),
                activeColor: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Post-meal',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGlucoseInfo(context, _glucoseFasting, isDark),
        ],
      ),
    );
  }

  _BpStatus _glucoseStatus(double? glucose) {
    if (glucose == null) {
      return _BpStatus('--', AppColors.slate);
    }
    final mmolL = _useMgDl ? glucose / 18.0 : glucose;
    if (_glucoseFasting) {
      if (mmolL < 5.3) return _BpStatus('Normal', AppColors.success);
      if (mmolL < 5.6) return _BpStatus('Elevated', AppColors.softGold);
      return _BpStatus('High', AppColors.warning);
    } else {
      if (mmolL < 7.8) return _BpStatus('Normal', AppColors.success);
      if (mmolL < 11.0) return _BpStatus('Elevated', AppColors.softGold);
      return _BpStatus('High', AppColors.warning);
    }
  }

  Widget _buildGlucoseInfo(BuildContext context, bool fasting, bool isDark) {
    final target = fasting ? '<5.3 mmol/L fasting' : '<7.8 mmol/L post-meal';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.forestGreen,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Range',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Target: $target. Elevated levels may indicate gestational diabetes. Discuss results with your provider.',
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

  Widget _buildDateTimePicker(BuildContext context, bool isDark) {
    return AppCard.standard(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _pickDate,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: AppColors.slate,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.slate),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        DateFormat('MMM d, yyyy').format(_selectedDate),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.charcoal,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _pickTime,
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.slate,
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.slate),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      _selectedTime.format(context),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.charcoal,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.forestGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.forestGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Widget _buildNotesField(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes_rounded,
                size: 18,
                color: AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any notes about your vitals...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}

class _BpStatus {
  final String label;
  final Color color;
  const _BpStatus(this.label, this.color);
}
