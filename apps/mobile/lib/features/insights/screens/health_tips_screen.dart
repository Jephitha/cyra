import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';

enum TipCategory { nutrition, exercise, sleep, stress, symptomManagement }

class HealthTip {
  final TipCategory category;
  final String tip;
  final CyclePhase phase;
  final String whyThisHelps;
  final String source;
  final String? sourceUrl;

  const HealthTip({
    required this.category,
    required this.tip,
    required this.phase,
    required this.whyThisHelps,
    required this.source,
    this.sourceUrl,
  });
}

class _TipCardData {
  final HealthTip tip;
  bool isRead;
  bool isExpanded;

  _TipCardData({required this.tip}) : isRead = false, isExpanded = false;
}

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final List<_TipCardData> _tips = [
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.nutrition,
        tip: 'Increase iron-rich foods like spinach, lentils, and lean red meat during your menstrual phase to replenish iron stores lost through bleeding.',
        phase: CyclePhase.menstrual,
        whyThisHelps: 'Iron is essential for producing hemoglobin, which carries oxygen in your blood. '
            'Menstrual blood loss can deplete iron stores, leading to fatigue. Pair iron-rich foods with '
            'vitamin C sources like citrus fruits to enhance absorption.',
        source: 'National Institutes of Health (NIH) - Iron Fact Sheet',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.exercise,
        tip: 'Gentle yoga, walking, and stretching can help ease menstrual cramps and improve mood during your period.',
        phase: CyclePhase.menstrual,
        whyThisHelps: 'Exercise releases endorphins, which are natural pain relievers. Gentle movement also '
            'improves blood circulation to the pelvic region, which can reduce cramping. Avoid high-intensity '
            'workouts if you feel fatigued.',
        source: 'American College of Obstetricians and Gynecologists (ACOG) - Exercise During Menstruation',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.nutrition,
        tip: 'Focus on complex carbohydrates and lean proteins during the follicular phase to support rising energy levels.',
        phase: CyclePhase.follicular,
        whyThisHelps: 'During the follicular phase, estrogen levels rise, increasing energy and metabolism. '
            'Complex carbohydrates provide sustained energy, while protein supports tissue repair and growth. '
            'This is a good time for higher-intensity workouts.',
        source: 'Journal of the International Society of Sports Nutrition - Menstrual Cycle and Nutrition',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.sleep,
        tip: 'Your progesterone rises in the luteal phase, which may affect sleep quality. Try a consistent bedtime routine and avoid caffeine after 2 PM.',
        phase: CyclePhase.luteal,
        whyThisHelps: 'Progesterone has a mild sedative effect but can also disrupt sleep architecture. '
            'A consistent sleep schedule helps regulate your circadian rhythm. Reducing caffeine intake '
            'in the afternoon can improve sleep onset and quality.',
        source: 'Sleep Foundation - How Hormones Affect Women\'s Sleep',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.stress,
        tip: 'Practice mindfulness or deep breathing exercises during the luteal phase to manage mood changes and irritability.',
        phase: CyclePhase.luteal,
        whyThisHelps: 'The luteal phase is associated with higher sensitivity to stress due to hormonal '
            'fluctuations. Mindfulness practices have been shown to reduce cortisol levels and improve '
            'emotional regulation. Even 5-10 minutes daily can make a difference.',
        source: 'Harvard Health Publishing - Mindfulness for Stress Reduction',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.symptomManagement,
        tip: 'Apply a heating pad or warm compress to your lower abdomen when cramps start. Heat therapy is as effective as ibuprofen for some people.',
        phase: CyclePhase.menstrual,
        whyThisHelps: 'Heat therapy works by relaxing the uterine muscles and improving blood flow to the '
            'pelvic area. Studies show that continuous low-level heat therapy can be as effective as '
            'over-the-counter pain medications for menstrual cramp relief.',
        source: 'Cochrane Review - Heat Therapy for Dysmenorrhea',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.nutrition,
        tip: 'Stay hydrated and consider magnesium-rich foods like dark chocolate, nuts, and seeds during the luteal phase to reduce bloating.',
        phase: CyclePhase.luteal,
        whyThisHelps: 'Magnesium helps regulate muscle function and may reduce water retention associated '
            'with PMS. Adequate hydration supports kidney function and helps flush excess sodium, '
            'which can contribute to bloating.',
        source: 'Nutrients Journal - Magnesium and Premenstrual Syndrome',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.exercise,
        tip: 'Moderate cardio and strength training are most effective during the follicular phase when energy levels naturally peak.',
        phase: CyclePhase.follicular,
        whyThisHelps: 'Rising estrogen levels during the follicular phase increase muscle recovery, '
            'endurance, and overall energy. This is an ideal time for challenging workouts. '
            'Listening to your body remains important regardless of cycle phase.',
        source: 'Sports Medicine - Menstrual Cycle and Athletic Performance',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.symptomManagement,
        tip: 'Track your symptoms daily to identify patterns. Knowledge of when symptoms typically occur helps you prepare and manage them proactively.',
        phase: CyclePhase.luteal,
        whyThisHelps: 'Symptom tracking helps you understand your unique cycle patterns. Recognizing that '
            'certain symptoms consistently appear in specific phases allows you to plan self-care strategies '
            'in advance and have more informed conversations with your healthcare provider.',
        source: 'Journal of Women\'s Health - Benefits of Menstrual Cycle Tracking',
      ),
    ),
    _TipCardData(
      tip: const HealthTip(
        category: TipCategory.exercise,
        tip: 'During the luteal phase, focus on lower-intensity activities like walking, swimming, or Pilates to accommodate lower energy levels.',
        phase: CyclePhase.luteal,
        whyThisHelps: 'Progesterone dominance in the luteal phase can increase body temperature, heart rate, '
            'and perceived exertion. Lower-intensity exercise helps maintain physical activity without '
            'overtaxing your body, supporting both physical and mental well-being.',
        source: 'ACSM\'s Health & Fitness Journal - Exercise Across the Menstrual Cycle',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          _buildFilterBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl),
              children: [
                _buildHeader(context),
                const SizedBox(height: AppSpacing.lg),
                ...List.generate(_tips.length, (i) => _buildTipCard(context, i)),
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
          'Tips are contextual to your current cycle phase and based on medical guidelines. '
          '$_unreadCount unread',
          style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
        ),
      ],
    );
  }

  String get _unreadCount => '${_tips.where((t) => !t.isRead).length}';

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Nutrition',
              isSelected: false,
              icon: Icons.restaurant_outlined,
              onTap: () {},
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Exercise',
              isSelected: false,
              icon: Icons.fitness_center_outlined,
              onTap: () {},
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Sleep',
              isSelected: false,
              icon: Icons.bedtime_outlined,
              onTap: () {},
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Stress',
              isSelected: false,
              icon: Icons.self_improvement_outlined,
              onTap: () {},
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Symptoms',
              isSelected: false,
              icon: Icons.healing_outlined,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, int index) {
    final tipData = _tips[index];
    final tip = tipData.tip;
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
                _CategoryIcon(category: tip.category, isDark: isDark),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CategoryLabel(category: tip.category),
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
                        tip.tip,
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          CyclePhaseIndicator(
                            phase: tip.phase,
                            size: CyclePhaseIndicatorSize.small,
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
            const SizedBox(height: AppSpacing.md),
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
                    tipData.tip.whyThisHelps,
                    style: AppTypography.light.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(Icons.source_outlined, size: 14, color: AppColors.slate),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Source: ${tipData.tip.source}',
                          style: AppTypography.light.labelSmall?.copyWith(
                            color: AppColors.slate,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    ? (isDark ? Colors.white : AppColors.forestGreen)
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
        return const Color(0xFF5B6ABF);
      case TipCategory.stress:
        return AppColors.softGold;
      case TipCategory.symptomManagement:
        return const Color(0xFFE86B6B);
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
