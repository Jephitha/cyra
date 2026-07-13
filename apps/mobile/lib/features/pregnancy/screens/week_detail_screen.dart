import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/date_utils.dart';
import 'package:cyra/features/pregnancy/screens/pregnancy_symptoms_screen.dart';

class WeekDetailScreen extends StatelessWidget {
  final int week;

  const WeekDetailScreen({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final comparison = CycleDateUtils.weekToSizeComparison(week);
    final trimester = CycleDateUtils.getTrimester(week);
    final trimesterColor = _trimesterColor(trimester);
    final babyLength = _babyLength(week);
    final babyWeight = _babyWeight(week);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Week $week',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
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
          _buildWeekHeader(context, isDark, comparison, trimesterColor),
          const SizedBox(height: AppSpacing.lg),
          _buildBabySizeCard(context, isDark, babyLength, babyWeight),
          const SizedBox(height: AppSpacing.lg),
          _buildDevelopmentSection(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildMaternalChangesSection(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildTipsSection(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildNavigation(context, isDark),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, isDark),
    );
  }

  Widget _buildWeekHeader(
    BuildContext context,
    bool isDark,
    String comparison,
    Color trimesterColor,
  ) {
    final emoji = _weekEmoji(week);

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: trimesterColor.withValues(alpha: isDark ? 0.25 : 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 36)),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Week $week — Baby is the size of a $comparison',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBabySizeCard(
    BuildContext context,
    bool isDark,
    double length,
    double weight,
  ) {
    return AppCard.standard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(Icons.straighten_rounded, size: 24, color: AppColors.sage),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${length.toStringAsFixed(1)} cm',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Length',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.monitor_weight_rounded,
                  size: 24,
                  color: AppColors.softGold,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${weight.toStringAsFixed(1)} g',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Weight',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentSection(BuildContext context, bool isDark) {
    final milestones = _weekMilestones(week);
    final description = _weekDevelopmentDescription(week);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 20,
                color: AppColors.softGold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "What's happening with baby?",
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
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
            ),
          ),
          if (milestones.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            ...milestones.map(
              (m) => _milestoneRow(context, m.icon, m.text, isDark),
            ),
          ],
        ],
      ),
    );
  }

  Widget _milestoneRow(
    BuildContext context,
    String emoji,
    String text,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaternalChangesSection(BuildContext context, bool isDark) {
    final changes = _weekMaternalChanges(week);
    final symptoms = _weekCommonSymptoms(week);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 20,
                color: AppColors.period,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "What's happening with you?",
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
          Text(
            changes,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
            ),
          ),
          if (symptoms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Common Symptoms',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: symptoms.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warmIvory.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    s,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.slate,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context, bool isDark) {
    final tips = _weekTips(week);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: AppColors.softGold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tips for This Week',
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
          ...tips.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, bool isDark) {
    return Row(
      children: [
        if (week > 1)
          Expanded(
            child: AppButton.secondary(
              '← Week ${week - 1}',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => WeekDetailScreen(week: week - 1),
                  ),
                );
              },
            ),
          ),
        if (week > 1 && week < 40) const SizedBox(width: AppSpacing.md),
        if (week < 40)
          Expanded(
            child: AppButton.primary(
              'Week ${week + 1} →',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => WeekDetailScreen(week: week + 1),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        child: AppButton.primary(
          'Log Symptom',
          icon: Icons.add_rounded,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PregnancySymptomsScreen(),
              ),
            );
          },
          width: double.infinity,
        ),
      ),
    );
  }

  Color _trimesterColor(int trimester) {
    switch (trimester) {
      case 1:
        return AppColors.sage;
      case 2:
        return AppColors.softGold;
      case 3:
        return AppColors.symptomRed;
      default:
        return AppColors.sage;
    }
  }

  String _weekEmoji(int week) {
    if (week <= 8) return '🌱';
    if (week <= 13) return '🍇';
    if (week <= 18) return '🍎';
    if (week <= 24) return '🍌';
    if (week <= 30) return '🍈';
    if (week <= 36) return '🥬';
    return '🍉';
  }

  double _babyLength(int week) {
    if (week <= 4) return 0.1;
    if (week <= 8) return 1.6;
    if (week <= 12) return 5.4;
    if (week <= 16) return 11.6;
    if (week <= 20) return 16.4;
    if (week <= 24) return 30.0;
    if (week <= 28) return 37.6;
    if (week <= 32) return 42.4;
    if (week <= 36) return 47.4;
    return 50.7;
  }

  double _babyWeight(int week) {
    if (week <= 8) return 1;
    if (week <= 12) return 14;
    if (week <= 16) return 100;
    if (week <= 20) return 300;
    if (week <= 24) return 600;
    if (week <= 28) return 1000;
    if (week <= 32) return 1800;
    if (week <= 36) return 2600;
    return 3400;
  }

  String _weekDevelopmentDescription(int week) {
    if (week <= 4) {
      return 'The fertilized egg implants in your uterus. The cells begin dividing into the embryo and placenta. Your baby is just a tiny cluster of cells right now.';
    }
    if (week <= 8) {
      return 'Your baby\'s heart is beating about 150 times per minute — twice as fast as yours! All major organs are beginning to form. Tiny arms and legs are sprouting.';
    }
    if (week <= 12) {
      return 'Your baby is now fully formed with all organs in place. Fingers and toes are separated. The kidneys are producing urine, and the baby can make a fist.';
    }
    if (week <= 16) {
      return 'Your baby\'s skeleton is hardening and muscles are developing. The baby can suck their thumb and make facial expressions. Hair and nails are growing.';
    }
    if (week <= 20) {
      return 'Your baby is covered in fine hair called lanugo. The skin is developing layers and vernix caseosa is forming to protect it. You may feel gentle flutters.';
    }
    if (week <= 24) {
      return 'Your baby\'s senses are rapidly developing. They can hear your voice, sense light, and has developed a regular sleep-wake cycle. The lungs are forming air sacs.';
    }
    if (week <= 28) {
      return 'Your baby\'s brain is developing rapidly with billions of neurons forming connections. The eyes can open and close. The baby can recognize your voice.';
    }
    if (week <= 32) {
      return 'Your baby is putting on weight rapidly and the bones are fully developed. The baby is practicing breathing movements. Most babies are in head-down position now.';
    }
    if (week <= 36) {
      return 'Your baby continues to gain about 200g per week. The lungs are nearly fully mature. The baby\'s fingernails reach the tips of their fingers.';
    }
    return 'Your baby is considered full-term and is ready for birth. The lungs are mature and the baby continues to gain weight. All systems are fully developed.';
  }

  List<_Milestone> _weekMilestones(int week) {
    if (week <= 4) {
      return [
        _Milestone('💓', 'Heart and circulatory system begin to form'),
        _Milestone('🧬', 'Neural tube begins to close'),
      ];
    }
    if (week <= 8) {
      return [
        _Milestone('💓', 'Heartbeat is detectable via ultrasound'),
        _Milestone('🦾', 'Arm and leg buds appear'),
        _Milestone('👁️', 'Eyes and ears begin to form'),
      ];
    }
    if (week <= 12) {
      return [
        _Milestone('🦴', 'Bones begin to harden'),
        _Milestone('👆', 'Fingers and toes are fully separated'),
        _Milestone('🫧', 'Kidneys begin producing urine'),
      ];
    }
    if (week <= 16) {
      return [
        _Milestone('👂', 'Baby can hear sounds'),
        _Milestone('🫦', 'Sucking reflex develops'),
        _Milestone('💇', 'Hair and eyebrows are growing'),
      ];
    }
    if (week <= 20) {
      return [
        _Milestone('🦵', 'Muscles are developing'),
        _Milestone('👶', 'Vernix caseosa protects the skin'),
        _Milestone('🫁', 'Lungs are forming air passages'),
      ];
    }
    if (week <= 24) {
      return [
        _Milestone('👂', 'Baby recognizes your voice'),
        _Milestone('🌞', 'Senses light through the womb'),
        _Milestone('💤', 'Sleep-wake cycle is established'),
      ];
    }
    if (week <= 28) {
      return [
        _Milestone('🧠', 'Brain developing billions of neurons'),
        _Milestone('👁️', 'Eyes can open and blink'),
        _Milestone('🎵', 'Responds to music and sounds'),
      ];
    }
    if (week <= 32) {
      return [
        _Milestone('🫁', 'Practicing breathing movements'),
        _Milestone('🦴', 'Bones are fully developed'),
        _Milestone('🔄', 'Usually moves into head-down position'),
      ];
    }
    if (week <= 36) {
      return [
        _Milestone('💪', 'Gaining about 200g per week'),
        _Milestone('💅', 'Fingernails reach fingertips'),
        _Milestone('🫁', 'Lungs are nearly mature'),
      ];
    }
    return [
      _Milestone('✅', 'Full-term and ready for birth'),
      _Milestone('💪', 'Continues to gain weight'),
      _Milestone('🫁', 'All systems are fully mature'),
    ];
  }

  String _weekMaternalChanges(int week) {
    if (week <= 4) {
      return 'You may experience light spotting and mild cramping as the embryo implants. Hormone levels begin to rise, which may cause breast tenderness and fatigue.';
    }
    if (week <= 8) {
      return 'Morning sickness may begin as hCG levels peak. You may feel extremely tired as your body works to support the pregnancy. Frequent urination starts.';
    }
    if (week <= 12) {
      return 'Your energy levels may improve as the first trimester ends. Your uterus is expanding, which may cause mild round ligament pain. Your appetite may return.';
    }
    if (week <= 16) {
      return 'Your energy is likely returning and nausea is subsiding. Your belly is starting to show. You may notice changes in your skin and hair.';
    }
    if (week <= 20) {
      return 'Your belly is more noticeably pregnant. You may feel the baby moving. Skin changes like the linea nigra may appear. Bra size may increase.';
    }
    if (week <= 24) {
      return 'Round ligament pain may occur as your uterus expands. You may experience heartburn and indigestion. Your center of gravity is shifting.';
    }
    if (week <= 28) {
      return 'Shortness of breath may begin as your uterus pushes upward. Braxton Hicks contractions may start. You may have trouble sleeping comfortably.';
    }
    if (week <= 32) {
      return 'Frequent urination increases as the baby presses on your bladder. Back pain and swelling in feet/ankles are common. Fatigue may return.';
    }
    if (week <= 36) {
      return 'Your baby dropping into the pelvis may relieve breathing but increase pelvic pressure. Contractions may become more frequent. Nesting instinct often kicks in.';
    }
    return 'You may feel a mix of excitement and nervousness. Cervical dilation may begin. Rest as much as possible and stay hydrated. Watch for signs of labor.';
  }

  List<String> _weekCommonSymptoms(int week) {
    if (week <= 4) {
      return ['Implantation spotting', 'Mild cramping', 'Breast tenderness'];
    }
    if (week <= 8) {
      return [
        'Morning sickness',
        'Fatigue',
        'Frequent urination',
        'Breast tenderness',
      ];
    }
    if (week <= 12) {
      return ['Nausea', 'food aversions', 'Mood swings', 'Bloating'];
    }
    if (week <= 16) {
      return ['Round ligament pain', 'Skin changes', 'Increased appetite'];
    }
    if (week <= 20) return ['Back pain', 'Leg cramps', 'Skin changes'];
    if (week <= 24) return ['Heartburn', 'Round ligament pain', 'Swollen feet'];
    if (week <= 28) {
      return ['Shortness of breath', 'Braxton Hicks', 'Back pain'];
    }
    if (week <= 32) {
      return ['Frequent urination', 'Swelling', 'Back pain', 'Fatigue'];
    }
    if (week <= 36) {
      return ['Pelvic pressure', 'Braxton Hicks', 'Swelling', 'Fatigue'];
    }
    return [
      'Pelvic pressure',
      'Frequent urination',
      'Contractions',
      'Nesting instinct',
    ];
  }

  List<String> _weekTips(int week) {
    if (week <= 4) {
      return [
        'Start taking a prenatal vitamin with folic acid (400-800 mcg daily)',
        'Schedule your first prenatal appointment',
        'Avoid alcohol, smoking, and limit caffeine to 200mg per day',
        'Drink plenty of water and eat a balanced diet',
      ];
    }
    if (week <= 8) {
      return [
        'Eat small, frequent meals to manage morning sickness',
        'Get plenty of rest — your body is working hard',
        'Gentle exercise like walking can help maintain energy',
        'Avoid raw fish, unpasteurized dairy, and deli meats',
      ];
    }
    if (week <= 12) {
      return [
        'Schedule your first trimester screening and ultrasound',
        'Start researching childbirth classes',
        'Discuss genetic screening options with your provider',
        'Begin Kegel exercises to strengthen pelvic floor',
      ];
    }
    if (week <= 16) {
      return [
        'Apply belly oil or lotion to support skin elasticity',
        'Wear comfortable, supportive bras',
        'Stay active with pregnancy-safe exercise',
        'Discuss your birth plan preferences with your provider',
      ];
    }
    if (week <= 20) {
      return [
        'Schedule your anatomy scan ultrasound',
        'Start sleeping on your side with pillows for support',
        'Monitor your blood pressure at prenatal visits',
        'Begin tracking fetal movements once you feel them regularly',
      ];
    }
    if (week <= 24) {
      return [
        'Take a glucose screening test if recommended',
        'Elevate your feet when resting to reduce swelling',
        'Avoid lying flat on your back — sleep on your left side',
        'Wear comfortable shoes with good arch support',
      ];
    }
    if (week <= 28) {
      return [
        'Schedule your glucose tolerance test (24-28 weeks)',
        'Practice pelvic tilts for back pain relief',
        'Pack a hospital bag — it\'s never too early',
        'Take a childbirth education class',
      ];
    }
    if (week <= 32) {
      return [
        'Continue monitoring fetal movements daily',
        'Use a pregnancy pillow for comfortable sleep',
        'Eat iron-rich foods to prevent anemia',
        'Prepare your maternity leave plan',
      ];
    }
    if (week <= 36) {
      return [
        'Attend weekly prenatal appointments from week 36',
        'Discuss labor signs and when to go to the hospital',
        'Finish preparing the nursery and washing baby clothes',
        'Practice relaxation and breathing techniques',
      ];
    }
    return [
      'Rest as much as possible — labor is physically demanding',
      'Watch for signs of labor: contractions, water breaking, bloody show',
      'Stay hydrated and eat light, energy-rich meals',
      'Reach out to your support person when contractions begin',
    ];
  }
}

class _Milestone {
  final String icon;
  final String text;
  const _Milestone(this.icon, this.text);
}
