import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/core/constants/cycle_constants.dart';

Color _phaseColor(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return const Color(0xFFE86B6B);
    case CyclePhase.follicular:
      return AppColors.sage;
    case CyclePhase.ovulation:
      return AppColors.softGold;
    case CyclePhase.luteal:
      return AppColors.forestGreen;
  }
}

String _phaseLabel(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return 'Menstrual';
    case CyclePhase.follicular:
      return 'Follicular';
    case CyclePhase.ovulation:
      return 'Ovulation';
    case CyclePhase.luteal:
      return 'Luteal';
  }
}

class CycleEducationScreen extends StatefulWidget {
  final int? userCycleLength;

  const CycleEducationScreen({super.key, this.userCycleLength});

  @override
  State<CycleEducationScreen> createState() => _CycleEducationScreenState();
}

class _CycleEducationScreenState extends State<CycleEducationScreen> {
  CyclePhase? _expandedPhase;

  final int _currentCycleDay = 22;

  CyclePhase get _currentPhase {
    if (_currentCycleDay <= 5) return CyclePhase.menstrual;
    if (_currentCycleDay <= 13) return CyclePhase.follicular;
    if (_currentCycleDay == 14) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cycle Education',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          _buildCurrentPhaseHighlight(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildPhaseCard(context, CyclePhase.menstrual, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildPhaseCard(context, CyclePhase.follicular, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildPhaseCard(context, CyclePhase.ovulation, isDark),
          const SizedBox(height: AppSpacing.md),
          _buildPhaseCard(context, CyclePhase.luteal, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildHormoneVisualization(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildPersonalizedSection(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildReferences(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCurrentPhaseHighlight(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _phaseColor(_currentPhase).withValues(alpha: isDark ? 0.25 : 0.12),
            _phaseColor(_currentPhase).withValues(alpha: isDark ? 0.1 : 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _phaseColor(_currentPhase).withValues(alpha: isDark ? 0.4 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _phaseColor(_currentPhase),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'You are here',
                style: AppTypography.light.labelMedium?.copyWith(
                  color: _phaseColor(_currentPhase),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Current Phase: ${_phaseLabel(_currentPhase)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Day $_currentCycleDay of ~${widget.userCycleLength ?? CycleConstants.averageCycleLength}',
            style: AppTypography.light.bodyMedium?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _phaseDescription(_currentPhase),
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(BuildContext context, CyclePhase phase, bool isDark) {
    final isExpanded = _expandedPhase == phase;
    final phaseDays = _phaseDays(phase);

    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              _expandedPhase = isExpanded ? null : phase;
            }),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _phaseColor(phase),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _phaseLabel(phase),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          phaseDays,
                          style: AppTypography.light.bodySmall?.copyWith(color: AppColors.slate),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more, color: AppColors.slate),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(context, phase, isDark),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, CyclePhase phase, bool isDark) {
    return Column(
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHormoneLevelsMini(phase, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildSectionTitle(context, 'What\'s Happening in Your Body', Icons.biotech_outlined, isDark),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _bodyProcess(phase),
                style: AppTypography.light.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSectionTitle(context, 'Common Symptoms', Icons.healing_outlined, isDark),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _commonSymptoms(phase).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: _phaseColor(phase).withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: _phaseColor(phase).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    s,
                      style: TextStyle(
                        fontSize: 12,
                        color: _phaseColor(phase),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSectionTitle(context, 'Self-Care Tips', Icons.self_improvement_outlined, isDark),
              const SizedBox(height: AppSpacing.sm),
              ..._selfCareTips(phase).map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outlined, size: 16, color: _phaseColor(phase)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTypography.light.bodySmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHormoneLevelsMini(CyclePhase phase, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Hormone Levels', Icons.show_chart_outlined, isDark),
        const SizedBox(height: AppSpacing.md),
        _HormoneBar(label: 'Estrogen', level: _estrogenLevel(phase), color: const Color(0xFFE86B6B), isDark: isDark),
        const SizedBox(height: AppSpacing.sm),
        _HormoneBar(label: 'Progesterone', level: _progesteroneLevel(phase), color: AppColors.forestGreen, isDark: isDark),
        const SizedBox(height: AppSpacing.sm),
        _HormoneBar(label: 'LH', level: _lhLevel(phase), color: AppColors.softGold, isDark: isDark),
        const SizedBox(height: AppSpacing.sm),
        _HormoneBar(label: 'FSH', level: _fshLevel(phase), color: AppColors.sage, isDark: isDark),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.charcoal.withValues(alpha: 0.6)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: AppTypography.light.labelMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHormoneVisualization(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.show_chart_rounded, size: 20, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Hormone Levels Across Your Cycle',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard.standard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _HormoneChartPainter(isDark: isDark),
              size: Size.infinite,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _HormoneLegend(label: 'Estrogen', color: const Color(0xFFE86B6B)),
            _HormoneLegend(label: 'Progesterone', color: AppColors.forestGreen),
            _HormoneLegend(label: 'LH', color: AppColors.softGold),
            _HormoneLegend(label: 'FSH', color: AppColors.sage),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalizedSection(BuildContext context, bool isDark) {
    final cycleLength = widget.userCycleLength ?? CycleConstants.averageCycleLength;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outlined, size: 20, color: AppColors.softGold),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'How This Applies to You',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.softGold.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            'With your ~$cycleLength-day cycle, your phases are approximately: '
            'Menstrual (days 1-5), Follicular (days 6-${cycleLength ~/ 2 - 1}), '
            'Ovulation (day ${cycleLength ~/ 2}), '
            'Luteal (days ${cycleLength ~/ 2 + 1}-$cycleLength). '
            'You are currently in the ${_phaseLabel(_currentPhase).toLowerCase()} phase, '
            'which means ${_personalizedAdvice(_currentPhase)}',
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferences(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.source_outlined, size: 16, color: AppColors.slate),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.light.labelSmall?.copyWith(color: AppColors.slate, height: 1.4),
                children: [
                  const TextSpan(text: 'Based on evidence-based guidelines from the '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://www.acog.org'), mode: LaunchMode.externalApplication),
                      child: Text(
                        'American College of Obstetricians and Gynecologists (ACOG)',
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          decoration: TextDecoration.underline,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ', the '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://www.who.int'), mode: LaunchMode.externalApplication),
                      child: Text(
                        'World Health Organization (WHO)',
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          decoration: TextDecoration.underline,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ', and peer-reviewed research on menstrual health and endocrinology.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _estrogenLevel(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 0.2;
      case CyclePhase.follicular:
        return 0.7;
      case CyclePhase.ovulation:
        return 1.0;
      case CyclePhase.luteal:
        return 0.5;
    }
  }

  double _progesteroneLevel(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 0.1;
      case CyclePhase.follicular:
        return 0.15;
      case CyclePhase.ovulation:
        return 0.2;
      case CyclePhase.luteal:
        return 1.0;
    }
  }

  double _lhLevel(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 0.15;
      case CyclePhase.follicular:
        return 0.4;
      case CyclePhase.ovulation:
        return 1.0;
      case CyclePhase.luteal:
        return 0.2;
    }
  }

  double _fshLevel(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 0.6;
      case CyclePhase.follicular:
        return 0.8;
      case CyclePhase.ovulation:
        return 0.3;
      case CyclePhase.luteal:
        return 0.1;
    }
  }

  String _phaseDays(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Days 1-5 (approximately)';
      case CyclePhase.follicular:
        return 'Days 6-13 (approximately)';
      case CyclePhase.ovulation:
        return 'Day 14 (approximately)';
      case CyclePhase.luteal:
        return 'Days 15-28 (approximately)';
    }
  }

  String _phaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'The menstrual phase begins on the first day of bleeding. The uterine lining sheds as '
            'hormone levels drop. This phase typically lasts 3-7 days.';
      case CyclePhase.follicular:
        return 'The follicular phase overlaps with menstruation and continues until ovulation. The '
            'pituitary gland releases FSH, stimulating follicles in the ovaries to mature. Estrogen rises steadily.';
      case CyclePhase.ovulation:
        return 'Ovulation occurs when a mature egg is released from the ovary. This is triggered by a '
            'surge in LH. The egg travels through the fallopian tube and can be fertilized for about 12-24 hours.';
      case CyclePhase.luteal:
        return 'After ovulation, the follicle transforms into the corpus luteum, which produces progesterone '
            'to prepare the uterine lining for a potential pregnancy. If fertilization does not occur, hormone '
            'levels drop and menstruation begins.';
    }
  }

  String _bodyProcess(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'The uterine lining (endometrium) that built up during the previous cycle is shed through '
            'the vagina. This occurs because estrogen and progesterone levels drop sharply at the end of '
            'the luteal phase, triggering the breakdown of the endometrial lining.';
      case CyclePhase.follicular:
        return 'FSH stimulates several ovarian follicles to grow, each containing an egg. As follicles '
            'mature, they produce increasing amounts of estrogen. Eventually, one dominant follicle emerges, '
            'and rising estrogen triggers a surge in LH, which initiates ovulation.';
      case CyclePhase.ovulation:
        return 'The LH surge causes the mature follicle to rupture and release the egg. The egg is then '
            'captured by the fallopian tube. This is the only time during the cycle when pregnancy can '
            'occur, as the egg is viable for approximately 12-24 hours.';
      case CyclePhase.luteal:
        return 'After ovulation, the empty follicle becomes the corpus luteum, which secretes progesterone. '
            'Progesterone thickens the uterine lining and maintains it for potential implantation. If '
            'pregnancy does not occur, the corpus luteum degenerates, hormone levels fall, and a new '
            'menstrual cycle begins.';
    }
  }

  List<String> _commonSymptoms(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return ['Cramps', 'Fatigue', 'Lower back pain', 'Bloating', 'Headaches'];
      case CyclePhase.follicular:
        return ['Increased energy', 'Clearer skin', 'Improved mood', 'Higher libido'];
      case CyclePhase.ovulation:
        return ['Mittelschmerz (mild pain)', 'Increased cervical mucus', 'Heightened sense of smell', 'Spotting (rare)'];
      case CyclePhase.luteal:
        return ['Bloating', 'Breast tenderness', 'Mood swings', 'Fatigue', 'Food cravings', 'Acne', 'Irritability'];
    }
  }

  List<String> _selfCareTips(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return [
          'Rest when needed and prioritize sleep',
          'Use heat therapy for cramps',
          'Stay hydrated and eat iron-rich foods',
          'Gentle movement like walking or yoga',
        ];
      case CyclePhase.follicular:
        return [
          'Take advantage of higher energy levels',
          'Try new or more intense workouts',
          'Focus on complex carbohydrates and protein',
          'Schedule important meetings or tasks',
        ];
      case CyclePhase.ovulation:
        return [
          'Listen to your body\'s signals',
          'Stay hydrated',
          'Practice safe intercourse if sexually active',
          'Track your fertility signs if relevant',
        ];
      case CyclePhase.luteal:
        return [
          'Prioritize rest and stress management',
          'Eat magnesium-rich foods for bloating',
          'Maintain a consistent sleep schedule',
          'Practice self-compassion with mood changes',
        ];
    }
  }

  String _personalizedAdvice(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'your body is in its resting phase. Focus on gentle care and recovery.';
      case CyclePhase.follicular:
        return 'your energy and mood are naturally rising. This is a great time for activity and social engagement.';
      case CyclePhase.ovulation:
        return 'you are at your most fertile point. Continue tracking to confirm your pattern.';
      case CyclePhase.luteal:
        return 'your body is preparing for the next cycle. Be mindful of increased sensitivity and prioritize self-care.';
    }
  }
}

class _HormoneBar extends StatelessWidget {
  final String label;
  final double level;
  final Color color;
  final bool isDark;

  const _HormoneBar({
    required this.label,
    required this.level,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTypography.light.labelSmall?.copyWith(color: AppColors.slate),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: LinearProgressIndicator(
              value: level,
              backgroundColor: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.borderLight,
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 32,
          child: Text(
            '${(level * 100).round()}%',
            textAlign: TextAlign.right,
            style: AppTypography.light.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _HormoneLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _HormoneLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.slate),
        ),
      ],
    );
  }
}

class _HormoneChartPainter extends CustomPainter {
  final bool isDark;

  _HormoneChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final phases = ['Menstrual', 'Follicular', 'Ovulation', 'Luteal'];
    final phaseWidth = width / 4;

    final hormoneData = {
      'Estrogen': [0.2, 0.7, 1.0, 0.5],
      'Progesterone': [0.1, 0.15, 0.2, 1.0],
      'LH': [0.15, 0.4, 1.0, 0.2],
      'FSH': [0.6, 0.8, 0.3, 0.1],
    };

    final hormoneColors = {
      'Estrogen': const Color(0xFFE86B6B),
      'Progesterone': AppColors.forestGreen,
      'LH': AppColors.softGold,
      'FSH': AppColors.sage,
    };

    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final gridColor = (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.3);
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = bgColor);

    for (int i = 0; i <= 4; i++) {
      final x = i * phaseWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, height),
        Paint()..color = gridColor..strokeWidth = 0.5,
      );
    }

    final margin = 20.0;
    final chartHeight = height - margin - 20;
    final chartTop = margin;

    for (final entry in hormoneData.entries) {
      final data = entry.value;
      final color = hormoneColors[entry.key]!;

      final path = Path();
      for (int phase = 0; phase < 4; phase++) {
        final x = phase * phaseWidth + phaseWidth / 2;
        final y = chartTop + chartHeight * (1.0 - data[phase] * 0.85);

        if (phase == 0) {
          path.moveTo(x, y);
        } else {
          final prevX = (phase - 1) * phaseWidth + phaseWidth / 2;
          final prevY = chartTop + chartHeight * (1.0 - data[phase - 1] * 0.85);
          path.cubicTo(
            prevX + phaseWidth / 3, prevY,
            x - phaseWidth / 3, y,
            x, y,
          );
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    for (int i = 0; i < 4; i++) {
      final x = i * phaseWidth + phaseWidth / 2;
      final label = phases[i];
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(fontSize: 8, color: textColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: phaseWidth);
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant _HormoneChartPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
