import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart' as indicator;
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/insights/providers/insight_providers.dart';

enum TipCategory { nutrition, exercise, sleep, stress, symptomManagement }

indicator.CyclePhase _toCyclePhase(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual: return indicator.CyclePhase.menstrual;
    case CyclePhase.follicular: return indicator.CyclePhase.follicular;
    case CyclePhase.ovulation: return indicator.CyclePhase.ovulation;
    case CyclePhase.luteal: return indicator.CyclePhase.luteal;
  }
}

class _TipCardData {
  final String tip;
  final String? whyThisHelps;
  final String? source;
  final CyclePhase? phase;
  final TipCategory category;
  final String id;
  bool isRead;
  bool isExpanded;

  _TipCardData({
    required this.tip,
    this.whyThisHelps,
    this.source,
    this.phase,
    required this.category,
    required this.id,
  }) : isRead = false, isExpanded = false;
}

const _sourceUrls = <String, String>{
  'National Institutes of Health (NIH) - Iron Fact Sheet': 'https://ods.od.nih.gov/factsheets/Iron-HealthProfessional/',
  'American College of Obstetricians and Gynecologists (ACOG) - Exercise During Menstruation': 'https://www.acog.org/womens-health/healthy-living/exercise-during-menstruation',
  'World Health Organization (WHO) - Nutrition Guidelines': 'https://www.who.int/health-topics/nutrition',
  'Journal of Clinical Sleep Medicine': 'https://jcsm.aasm.org/',
  'Harvard Medical School - Hydration': 'https://www.health.harvard.edu/staying-healthy/the-importance-of-staying-hydrated',
  'American Heart Association': 'https://www.heart.org/',
  'Mayo Clinic Proceedings': 'https://www.mayoclinicproceedings.org/',
  'Journal of Affective Disorders': 'https://www.sciencedirect.com/journal/journal-of-affective-disorders',
  'National Institute of Mental Health': 'https://www.nimh.nih.gov/',
  'Cochrane Review on Exercise and Mental Health': 'https://www.cochrane.org/',
};

class HealthTipsScreen extends ConsumerStatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  ConsumerState<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends ConsumerState<HealthTipsScreen> {
  final List<_TipCardData> _staticTips = [
    _TipCardData(
      id: 'iron',
      category: TipCategory.nutrition,
      phase: CyclePhase.menstrual,
      tip: 'Increase iron-rich foods like spinach, lentils, and lean red meat during your menstrual phase to replenish iron stores lost through bleeding.',
      whyThisHelps: 'Iron is essential for producing hemoglobin, which carries oxygen in your blood. Menstrual blood loss can deplete iron stores, leading to fatigue. Pair iron-rich foods with vitamin C sources like citrus fruits to enhance absorption.',
      source: 'National Institutes of Health (NIH) - Iron Fact Sheet',
    ),
    _TipCardData(
      id: 'gentle_movement',
      category: TipCategory.exercise,
      phase: CyclePhase.menstrual,
      tip: 'Gentle yoga, walking, and stretching can help ease menstrual cramps and improve mood during your period.',
      whyThisHelps: 'Exercise releases endorphins, which are natural pain relievers. Gentle movement also improves blood circulation to the pelvic region, which can reduce cramping.',
      source: 'American College of Obstetricians and Gynecologists (ACOG) - Exercise During Menstruation',
    ),
    _TipCardData(
      id: 'follicular_fuel',
      category: TipCategory.nutrition,
      phase: CyclePhase.follicular,
      tip: 'Focus on complex carbohydrates and lean proteins during the follicular phase to support rising energy levels.',
      whyThisHelps: 'During the follicular phase, estrogen levels rise, increasing energy and metabolism. Complex carbohydrates provide sustained energy, while protein supports tissue repair and growth.',
      source: 'Journal of the International Society of Sports Nutrition - Menstrual Cycle and Nutrition',
    ),
    _TipCardData(
      id: 'luteal_sleep',
      category: TipCategory.sleep,
      phase: CyclePhase.luteal,
      tip: 'Your progesterone rises in the luteal phase, which may affect sleep quality. Try a consistent bedtime routine and avoid caffeine after 2 PM.',
      whyThisHelps: 'Progesterone has a mild sedative effect but can also disrupt sleep architecture. A consistent sleep schedule helps regulate your circadian rhythm.',
      source: 'Sleep Foundation - How Hormones Affect Women\'s Sleep',
    ),
    _TipCardData(
      id: 'luteal_stress',
      category: TipCategory.stress,
      phase: CyclePhase.luteal,
      tip: 'Practice mindfulness or deep breathing exercises during the luteal phase to manage mood changes and irritability.',
      whyThisHelps: 'The luteal phase is associated with higher sensitivity to stress due to hormonal fluctuations. Mindfulness practices have been shown to reduce cortisol levels and improve emotional regulation.',
      source: 'Harvard Health Publishing - Mindfulness for Stress Reduction',
    ),
    _TipCardData(
      id: 'heat_therapy',
      category: TipCategory.symptomManagement,
      phase: CyclePhase.menstrual,
      tip: 'Apply a heating pad or warm compress to your lower abdomen when cramps start. Heat therapy is as effective as ibuprofen for some people.',
      whyThisHelps: 'Heat therapy works by relaxing the uterine muscles and improving blood flow to the pelvic area. Studies show that continuous low-level heat therapy can be as effective as over-the-counter pain medications.',
      source: 'Cochrane Review - Heat Therapy for Dysmenorrhea',
    ),
    _TipCardData(
      id: 'luteal_magnesium',
      category: TipCategory.nutrition,
      phase: CyclePhase.luteal,
      tip: 'Stay hydrated and consider magnesium-rich foods like dark chocolate, nuts, and seeds during the luteal phase to reduce bloating.',
      whyThisHelps: 'Magnesium helps regulate muscle function and may reduce water retention associated with PMS. Adequate hydration supports kidney function and helps flush excess sodium.',
      source: 'Nutrients Journal - Magnesium and Premenstrual Syndrome',
    ),
    _TipCardData(
      id: 'follicular_gains',
      category: TipCategory.exercise,
      phase: CyclePhase.follicular,
      tip: 'Moderate cardio and strength training are most effective during the follicular phase when energy levels naturally peak.',
      whyThisHelps: 'Rising estrogen levels during the follicular phase increase muscle recovery, endurance, and overall energy. This is an ideal time for challenging workouts.',
      source: 'Sports Medicine - Menstrual Cycle and Athletic Performance',
    ),
    _TipCardData(
      id: 'tracking',
      category: TipCategory.symptomManagement,
      phase: CyclePhase.luteal,
      tip: 'Track your symptoms daily to identify patterns. Knowledge of when symptoms typically occur helps you prepare and manage them proactively.',
      whyThisHelps: 'Symptom tracking helps you understand your unique cycle patterns. Recognizing that certain symptoms consistently appear in specific phases allows you to plan self-care strategies in advance.',
      source: 'Journal of Women\'s Health - Benefits of Menstrual Cycle Tracking',
    ),
    _TipCardData(
      id: 'luteal_gentle',
      category: TipCategory.exercise,
      phase: CyclePhase.luteal,
      tip: 'During the luteal phase, focus on lower-intensity activities like walking, swimming, or Pilates to accommodate lower energy levels.',
      whyThisHelps: 'Progesterone dominance in the luteal phase can increase body temperature, heart rate, and perceived exertion. Lower-intensity exercise helps maintain physical activity without overtaxing your body.',
      source: 'ACSM\'s Health & Fitness Journal - Exercise Across the Menstrual Cycle',
    ),
  ];

  TipCategory? _selectedCategory;

  List<_TipCardData> get _filteredTips {
    if (_selectedCategory == null) return _staticTips;
    return _staticTips.where((t) => t.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final personalizedTip = ref.watch(healthTipProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Tips',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textPrimaryDark
                : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
              children: [
                _buildHeader(context),
                if (personalizedTip.valueOrNull != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _buildPersonalizedTip(context, personalizedTip.valueOrNull!),
                ],
                const SizedBox(height: AppSpacing.lg),
                ...List.generate(_filteredTips.length, (i) => _buildTipCard(context, _filteredTips[i])),
                const SizedBox(height: AppSpacing.xxl),
                _buildDisclaimers(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalized Health Tips',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Tips are contextual to your current cycle phase and based on medical guidelines.',
          style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
        ),
      ],
    );
  }

  Widget _buildPersonalizedTip(BuildContext context, String tip) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.softGold),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Personalized For You',
                style: AppTypography.light.labelMedium?.copyWith(
                  color: AppColors.softGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            tip,
            style: AppTypography.light.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textPrimaryDark
                  : AppColors.charcoal,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final filters = [
      (null as TipCategory?, 'All', null as IconData?),
      (TipCategory.nutrition, 'Nutrition', Icons.restaurant_outlined),
      (TipCategory.exercise, 'Exercise', Icons.fitness_center_outlined),
      (TipCategory.sleep, 'Sleep', Icons.bedtime_outlined),
      (TipCategory.stress, 'Stress', Icons.self_improvement_outlined),
      (TipCategory.symptomManagement, 'Symptoms', Icons.healing_outlined),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final (category, label, icon) = f;
            final selected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(
                label: label,
                isSelected: selected,
                icon: icon,
                onTap: () => setState(() => _selectedCategory = category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, _TipCardData tipData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard.standard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryIcon(category: tipData.category, isDark: isDark),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CategoryLabel(category: tipData.category),
                          const Spacer(),
                          if (!tipData.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.forestGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        tipData.tip,
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          if (tipData.phase != null)
                            indicator.CyclePhaseIndicator(
                              phase: _toCyclePhase(tipData.phase!),
                              size: indicator.CyclePhaseIndicatorSize.small,
                            ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => setState(() {
                              tipData.isRead = !tipData.isRead;
                            }),
                            icon: Icon(
                              tipData.isRead ? Icons.check_circle : Icons.check_circle_outlined,
                              size: 16,
                              color: tipData.isRead ? AppColors.forestGreen : AppColors.slate,
                            ),
                            label: Text(
                              tipData.isRead ? 'Read' : 'Mark as read',
                              style: TextStyle(
                                fontSize: 12,
                                color: tipData.isRead ? AppColors.forestGreen : AppColors.slate,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (tipData.whyThisHelps != null)
              _buildExpandableSection(context, tipData, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(BuildContext context, _TipCardData tipData, bool isDark) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => tipData.isExpanded = !tipData.isExpanded),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Icon(
                  tipData.isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AppColors.slate,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Why this helps',
                  style: AppTypography.light.labelMedium?.copyWith(
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: isDark ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tipData.whyThisHelps!,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                      height: 1.6,
                    ),
                  ),
                  if (tipData.source != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(Icons.source_outlined, size: 14, color: AppColors.slate),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: InkWell(
                            onTap: tipData.source != null && _sourceUrls.containsKey(tipData.source)
                                ? () => launchUrl(Uri.parse(_sourceUrls[tipData.source]!), mode: LaunchMode.externalApplication)
                                : null,
                            child: Text(
                              'Source: ${tipData.source}',
                              style: AppTypography.light.labelSmall?.copyWith(
                                color: _sourceUrls.containsKey(tipData.source) ? AppColors.forestGreen : AppColors.slate,
                                decoration: _sourceUrls.containsKey(tipData.source) ? TextDecoration.underline : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          crossFadeState: tipData.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildDisclaimers(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outlined, size: 16, color: AppColors.warning),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Important',
                style: AppTypography.light.labelMedium?.copyWith(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'These tips are for educational purposes only and are not medical recommendations. '
            'Always consult your healthcare provider before making significant changes to your diet, '
            'exercise routine, or health management strategies. Individual health needs vary.',
            style: AppTypography.light.bodySmall?.copyWith(
              color: AppColors.charcoal,
              height: 1.5,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.forestGreen : AppColors.slate),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? (isDark ? AppColors.onBrand : AppColors.forestGreen)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final TipCategory category;
  final bool isDark;

  const _CategoryIcon({required this.category, required this.isDark});

  IconData get _icon {
    switch (category) {
      case TipCategory.nutrition:
        return Icons.restaurant_outlined;
      case TipCategory.exercise:
        return Icons.fitness_center_outlined;
      case TipCategory.sleep:
        return Icons.bedtime_outlined;
      case TipCategory.stress:
        return Icons.self_improvement_outlined;
      case TipCategory.symptomManagement:
        return Icons.healing_outlined;
    }
  }

  Color get _color {
    switch (category) {
      case TipCategory.nutrition:
        return AppColors.forestGreen;
      case TipCategory.exercise:
        return AppColors.sage;
      case TipCategory.sleep:
        return AppColors.hormoneBlue;
      case TipCategory.stress:
        return AppColors.softGold;
      case TipCategory.symptomManagement:
        return AppColors.period;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(_icon, size: 22, color: _color),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final TipCategory category;

  const _CategoryLabel({required this.category});

  String get _label {
    switch (category) {
      case TipCategory.nutrition:
        return 'Nutrition';
      case TipCategory.exercise:
        return 'Exercise';
      case TipCategory.sleep:
        return 'Sleep';
      case TipCategory.stress:
        return 'Stress';
      case TipCategory.symptomManagement:
        return 'Symptom Management';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.slate.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.slate,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
