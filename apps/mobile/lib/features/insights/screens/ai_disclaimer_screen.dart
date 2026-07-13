import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/app_card.dart';

class AIDisclaimerScreen extends StatelessWidget {
  final VoidCallback? onAccept;

  const AIDisclaimerScreen({super.key, this.onAccept});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
            ),
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: AppSpacing.xxxl),
              _buildWhatCyraCanDo(context, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildWhatCyraCannotDo(context, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildWhenToSeeDoctor(context, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildFullDisclaimer(context, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildLearnMore(context, isDark),
              const SizedBox(height: AppSpacing.xxxl),
              _buildAcceptButton(context),
              const SizedBox(height: AppSpacing.lg),
              _buildDeclineButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 36,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Smart Local Insights',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Before you begin, review how Cyra creates private insights from the data stored on your device.',
          textAlign: TextAlign.center,
          style: AppTypography.light.bodyMedium?.copyWith(
            color: AppColors.slate,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWhatCyraCanDo(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outlined,
                size: 22,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'What Cyra Can Do',
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
          _BulletPoint(
            icon: Icons.auto_awesome,
            text:
                'Provide educational insights about menstrual cycle phases, symptoms, and patterns based on your logged data.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.pattern_outlined,
            text:
                'Recognize patterns in your tracked symptoms, mood, and cycle length to help you understand your unique cycle.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.calendar_month_outlined,
            text:
                'Generate predictions for your next period, fertile window, and ovulation based on your historical cycle data.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.tips_and_updates_outlined,
            text:
                'Offer general health tips and educational content contextualized to your current cycle phase.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.shield_outlined,
            text:
                'Present information in a clear, accessible way to support your health literacy and awareness.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildWhatCyraCannotDo(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cancel_outlined, size: 22, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'What Cyra Cannot Do',
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
          _BulletPoint(
            icon: Icons.medical_services_outlined,
            text:
                'Diagnose medical conditions, diseases, or disorders of any kind.',
            isDark: isDark,
            isWarning: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.medication_outlined,
            text: 'Prescribe, recommend, or adjust medications or treatments.',
            isDark: isDark,
            isWarning: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.healing_outlined,
            text: 'Prevent, treat, or cure any medical condition or illness.',
            isDark: isDark,
            isWarning: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.person_off_outlined,
            text:
                'Replace professional medical advice, diagnosis, or treatment from a qualified healthcare provider.',
            isDark: isDark,
            isWarning: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.child_care_outlined,
            text:
                'Confirm or rule out pregnancy, fertility issues, or any other medical condition.',
            isDark: isDark,
            isWarning: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletPoint(
            icon: Icons.emergency_outlined,
            text:
                'Provide emergency medical assistance. If you have a medical emergency, call emergency services immediately.',
            isDark: isDark,
            isWarning: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWhenToSeeDoctor(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.warning.withValues(
        alpha: isDark ? 0.12 : 0.06,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                size: 22,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'When to See a Doctor',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'The following signs warrant consultation with a healthcare provider:',
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _WarningSign(
            text:
                'Periods that suddenly stop for 90 days or more (and you are not pregnant)',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _WarningSign(
            text:
                'Periods that last longer than 7 days or are unusually heavy (soaking through a pad or tampon every 1-2 hours)',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _WarningSign(
            text:
                'Severe pain that interferes with daily life or is not relieved by over-the-counter medication',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _WarningSign(
            text: 'Bleeding between periods or after intercourse',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _WarningSign(
            text: 'Cycles shorter than 21 days or longer than 45 days',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _WarningSign(
            text:
                'Sudden changes in your cycle pattern that persist for multiple cycles',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFullDisclaimer(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_outlined, size: 18, color: AppColors.slate),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Medical Disclaimer',
                style: AppTypography.light.labelMedium?.copyWith(
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
            'Smart Local Insights in Cyra are designed for educational and informational purposes only. '
            'They use deterministic rules and statistical pattern analysis on data you voluntarily log. '
            'This feature runs on your device and does not send your health data to a remote AI model. '
            'Insights and predictions are generated from established cycle-tracking methods and your personal data.\n\n'
            'Cyra does not provide medical advice, diagnosis, or treatment. The information provided through '
            'Smart Local Insights should not be used as a substitute for professional medical care. Always consult '
            'a qualified healthcare provider with any questions you may have regarding a medical condition '
            'or health concern.\n\n'
            'Your health data is encrypted and stored securely. Cyra does not share your personal health '
            'information with third parties without your explicit consent. For more information, review '
            'our Privacy Policy.\n\n'
            'By using Smart Local Insights, you acknowledge that:\n'
            '- You understand the limitations of this feature\n'
            '- You will not rely on it for medical decision-making\n'
            '- You will seek professional medical care when needed\n'
            '- Your data will be used to generate insights',
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              height: 1.6,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnMore(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link_rounded, size: 18, color: AppColors.forestGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Learn More',
              style: AppTypography.light.labelMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ExternalLink(
          label: 'American College of Obstetricians and Gynecologists (ACOG)',
          url: 'https://www.acog.org',
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ExternalLink(
          label: 'World Health Organization - Sexual and Reproductive Health',
          url: 'https://www.who.int/health-topics/sexual-health',
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ExternalLink(
          label: 'Office on Women\'s Health - Menstrual Cycle',
          url: 'https://www.womenshealth.gov',
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ExternalLink(label: 'Cyra Privacy Policy', url: null, isDark: isDark),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return AppButton.primary(
      'I Understand',
      icon: Icons.check_rounded,
      onPressed: () {
        if (onAccept != null) {
          onAccept!();
        }
      },
    );
  }

  Widget _buildDeclineButton(BuildContext context) {
    return AppButton.ghost(
      'Go Back',
      icon: Icons.arrow_back_rounded,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  final bool isWarning;

  const _BulletPoint({
    required this.icon,
    required this.text,
    required this.isDark,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isWarning ? AppColors.error : AppColors.forestGreen,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningSign extends StatelessWidget {
  final String text;
  final bool isDark;

  const _WarningSign({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExternalLink extends StatelessWidget {
  final String label;
  final String? url;
  final bool isDark;

  const _ExternalLink({required this.label, this.url, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'External link: $label',
      child: InkWell(
        onTap: url != null
            ? () => launchUrl(
                Uri.parse(url!),
                mode: LaunchMode.externalApplication,
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                url != null ? Icons.open_in_new_outlined : Icons.link_off,
                size: 16,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.forestGreen,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
