import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/extensions.dart';

class PregnancySymptomsScreen extends StatefulWidget {
  const PregnancySymptomsScreen({super.key});

  @override
  State<PregnancySymptomsScreen> createState() =>
      _PregnancySymptomsScreenState();
}

class _PregnancySymptomsScreenState extends State<PregnancySymptomsScreen> {
  final Set<String> _selectedSymptoms = {};
  double _severity = 0.5;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _notesController = TextEditingController();
  String? _selectedSymptomForInfo;

  static const _commonSymptoms = [
    _SymptomDef('nausea', 'Nausea/Morning Sickness', Icons.sentiment_very_dissatisfied_rounded, Color(0xFF81C784)),
    _SymptomDef('fatigue', 'Fatigue', Icons.bedtime_rounded, Color(0xFF9575CD)),
    _SymptomDef('back_pain', 'Back Pain', Icons.accessibility_new_rounded, Color(0xFFE57373)),
    _SymptomDef('swelling', 'Swelling', Icons.water_drop_rounded, Color(0xFF64B5F6)),
    _SymptomDef('heartburn', 'Heartburn', Icons.local_fire_department_rounded, Color(0xFFFF8A65)),
    _SymptomDef('shortness_of_breath', 'Shortness of Breath', Icons.air_rounded, Color(0xFF4DD0E1)),
    _SymptomDef('frequent_urination', 'Frequent Urination', Icons.water_rounded, Color(0xFF4FC3F7)),
  ];

  static const _warningSymptoms = [
    _SymptomDef('severe_headache', 'Severe Headache', Icons.face_rounded, Color(0xFFE53935)),
    _SymptomDef('vision_changes', 'Vision Changes', Icons.visibility_rounded, Color(0xFFE53935)),
    _SymptomDef('severe_abdominal_pain', 'Severe Abdominal Pain', Icons.healing_rounded, Color(0xFFD32F2F)),
    _SymptomDef('bleeding', 'Bleeding', Icons.bloodtype_rounded, Color(0xFFB71C1C)),
    _SymptomDef('decreased_fetal_movement', 'Decreased Fetal Movement', Icons.child_care_rounded, Color(0xFFFF5252)),
  ];

  bool get _hasWarningSymptoms =>
      _selectedSymptoms.any((id) => _warningSymptoms.any((w) => w.id == id));

  bool get _isWarningSelected => _hasWarningSymptoms;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_selectedSymptoms.isEmpty) {
      context.showSnackBar('Please select at least one symptom', isError: true);
      return;
    }
    context.showSnackBar('Symptoms logged successfully');
    Navigator.of(context).maybePop();
  }

  void _toggleSymptom(String id) {
    setState(() {
      if (_selectedSymptoms.contains(id)) {
        _selectedSymptoms.remove(id);
      } else {
        _selectedSymptoms.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasWarning = _isWarningSelected;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Log Symptoms',
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
            if (hasWarning) ...[
              _buildWarningBanner(isDark),
              const SizedBox(height: AppSpacing.lg),
            ],
            _buildCommonSymptomsSection(isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildWarningSymptomsSection(isDark),
            const SizedBox(height: AppSpacing.lg),
            if (_selectedSymptoms.isNotEmpty)
              _buildSeverityPicker(isDark),
            if (_selectedSymptoms.isNotEmpty)
              const SizedBox(height: AppSpacing.md),
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
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 24,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Your Healthcare Provider',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You\'ve selected symptoms that may require medical attention. Please contact your healthcare provider immediately.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonSymptomsSection(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.healing_outlined,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Common Symptoms',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Select all that apply',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _commonSymptoms.length,
            itemBuilder: (context, index) {
              final symptom = _commonSymptoms[index];
              final isSelected = _selectedSymptoms.contains(symptom.id);
              final hasInfo = _selectedSymptomForInfo == symptom.id;

              return GestureDetector(
                onTap: () => _toggleSymptom(symptom.id),
                onLongPress: () {
                  setState(() {
                    _selectedSymptomForInfo =
                        hasInfo ? null : symptom.id;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? symptom.color.withValues(
                            alpha: isDark ? 0.35 : 0.2)
                        : (isDark
                            ? AppColors.charcoal.withValues(alpha: 0.3)
                            : AppColors.mistWhite),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected
                          ? symptom.color.withValues(alpha: 0.5)
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        symptom.icon,
                        size: 26,
                        color: isSelected
                            ? symptom.color
                            : AppColors.slate,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
                        child: Text(
                          symptom.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight)
                                    : AppColors.slate,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_selectedSymptomForInfo != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildSymptomInfo(
              context,
              _selectedSymptomForInfo!,
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomInfo(
    BuildContext context,
    String symptomId,
    bool isDark,
  ) {
    final info = _symptomEducationalContent(symptomId);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.softGold,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About This Symptom',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                        color: AppColors.softGold,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  info,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.slate,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSymptomsSection(bool isDark) {
    return AppCard.standard(
      backgroundColor: AppColors.error.withValues(alpha: 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: AppColors.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Warning Signs',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'These symptoms may require medical attention',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _warningSymptoms.length,
            itemBuilder: (context, index) {
              final symptom = _warningSymptoms[index];
              final isSelected =
                  _selectedSymptoms.contains(symptom.id);

              return GestureDetector(
                onTap: () => _toggleSymptom(symptom.id),
                onLongPress: () {
                  setState(() {
                    _selectedSymptomForInfo =
                        _selectedSymptomForInfo == symptom.id
                            ? null
                            : symptom.id;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? symptom.color.withValues(
                            alpha: isDark ? 0.3 : 0.15)
                        : (isDark
                            ? AppColors.charcoal
                                .withValues(alpha: 0.3)
                            : AppColors.mistWhite),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected
                          ? symptom.color.withValues(alpha: 0.5)
                          : AppColors.error.withValues(alpha: 0.2),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        symptom.icon,
                        size: 26,
                        color: isSelected
                            ? symptom.color
                            : AppColors.error.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
                        child: Text(
                          symptom.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.charcoal)
                                    : AppColors.slate,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityPicker(bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Severity',
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
              Text(
                'Mild',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _severity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 4,
                  activeColor: AppColors.forestGreen,
                  inactiveColor: isDark
                      ? AppColors.charcoal.withValues(alpha: 0.3)
                      : AppColors.borderLight,
                  onChanged: (val) =>
                      setState(() => _severity = val),
                ),
              ),
              Text(
                'Severe',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              _severityLabel(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _severityLabel() {
    if (_severity < 0.25) return 'Mild';
    if (_severity < 0.5) return 'Moderate';
    if (_severity < 0.75) return 'Noticeable';
    return 'Severe';
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
                        DateFormat('MMM d, yyyy')
                            .format(_selectedDate),
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
      firstDate:
          DateTime.now().subtract(const Duration(days: 7)),
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
              hintText:
                  'Describe your symptoms in more detail...',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppRadius.sm),
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  String _symptomEducationalContent(String symptomId) {
    switch (symptomId) {
      case 'nausea':
        return 'Morning sickness affects up to 80% of pregnancies. '
            'Eat small, frequent meals and stay hydrated. '
            'Ginger and vitamin B6 may help reduce symptoms.';
      case 'fatigue':
        return 'Fatigue is very common, especially in the first and third trimesters. '
            'Your body is working hard to support your baby\'s development. '
            'Prioritize rest and gentle exercise like walking.';
      case 'back_pain':
        return 'Back pain is caused by hormonal changes loosening ligaments and '
            'your shifting center of gravity. Good posture, supportive shoes, '
            'and prenatal yoga can help alleviate discomfort.';
      case 'swelling':
        return 'Swelling (edema) is common due to increased fluid retention. '
            'Elevate your feet, stay hydrated, and avoid standing for long periods. '
            'Contact your provider if swelling is sudden or severe.';
      case 'heartburn':
        return 'Heartburn occurs when pregnancy hormones relax the valve between '
            'your stomach and esophagus. Eat small meals, avoid spicy or fatty foods, '
            'and don\'t lie down right after eating.';
      case 'shortness_of_breath':
        return 'Shortness of breath happens as your growing uterus pushes against '
            'your diaphragm. Practice good posture and slow, deep breathing. '
            'Contact your provider if it\'s severe or sudden.';
      case 'frequent_urination':
        return 'Frequent urination is caused by increased blood flow to your kidneys '
            'and pressure from your growing uterus on your bladder. '
            'Don\'t reduce water intake — it\'s essential for you and your baby.';
      case 'severe_headache':
        return 'Severe or persistent headaches during pregnancy can be a sign of '
            'preeclampsia, especially when accompanied by vision changes. '
            'Please contact your healthcare provider immediately.';
      case 'vision_changes':
        return 'Blurred vision, seeing spots, or sensitivity to light can be signs '
            'of preeclampsia — a serious pregnancy complication. '
            'Seek medical attention right away.';
      case 'severe_abdominal_pain':
        return 'Severe abdominal pain could indicate a number of conditions including '
            'placental abruption, preterm labor, or other complications. '
            'Contact your healthcare provider immediately.';
      case 'bleeding':
        return 'Any bleeding during pregnancy should be evaluated by a healthcare '
            'professional. While spotting can be normal, heavier bleeding may '
            'indicate a complication. Seek immediate medical attention.';
      case 'decreased_fetal_movement':
        return 'A significant decrease in your baby\'s movements may indicate '
            'distress. Try drinking something cold or lying on your side. '
            'If movements don\'t increase, contact your provider immediately.';
      default:
        return 'Contact your healthcare provider for more information about this symptom.';
    }
  }
}

class _SymptomDef {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  const _SymptomDef(this.id, this.name, this.icon, this.color);
}
