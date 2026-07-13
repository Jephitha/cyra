import 'package:flutter/material.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community Guidelines',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildHeader(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildGuideline(
            context,
            icon: Icons.favorite_outline_rounded,
            title: 'Be Respectful and Supportive',
            description:
                'Treat everyone with kindness and empathy. This is a safe space '
                'for all women and gender-diverse people on their health journeys. '
                'Support each other with compassion.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGuideline(
            context,
            icon: Icons.medical_services_outlined,
            title: 'No Medical Advice',
            description:
                'Share your personal experiences, but do not provide medical '
                'diagnoses, prescriptions, or treatment recommendations. '
                'Always encourage others to consult a healthcare provider '
                'for medical concerns.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGuideline(
            context,
            icon: Icons.shield_outlined,
            title: 'No Harassment or Hate Speech',
            description:
                'Harassment, hate speech, bullying, discrimination, or '
                'targeting of any individual or group will not be tolerated. '
                'This includes sexist, racist, homophobic, transphobic, or '
                'ableist language.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGuideline(
            context,
            icon: Icons.lock_outline_rounded,
            title: 'Protect Your Privacy',
            description:
                'Do not share personal identifying information \u2014 yours or '
                'anyone else\u2019s. This includes full names, addresses, phone '
                'numbers, emails, social media handles, or any other '
                'identifying details.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGuideline(
            context,
            icon: Icons.campaign_outlined,
            title: 'No Spam or Promotions',
            description:
                'Do not post spam, advertisements, promotional content, or '
                'solicitations. This includes links to products, services, '
                'surveys, or fundraising campaigns.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGuideline(
            context,
            icon: Icons.flag_outlined,
            title: 'Report Concerning Content',
            description:
                'If you see something that violates these guidelines, report it. '
                'Our moderation team reviews all reports confidentially. '
                'You can report posts and replies anonymously.',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildConsequences(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildFooter(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.forestGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.article_outlined,
            size: 32,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Our Commitment to a Safe Community',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'These guidelines help us maintain a supportive, safe, '
          'and anonymous space for everyone.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.slate,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGuideline(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 20, color: AppColors.forestGreen),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
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

  Widget _buildConsequences(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel_rounded,
                size: 20,
                color: AppColors.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Consequences of Violations',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildConsequenceItem(
            'First violation: Warning and content removal',
            isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildConsequenceItem(
            'Repeated violations: Temporary suspension',
            isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildConsequenceItem(
            'Severe violations (hate speech, harassment): '
            'Permanent ban from the community',
            isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildConsequenceItem(
            'Illegal content: Reported to appropriate authorities',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildConsequenceItem(String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 5,
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.slate,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.forestGreen,
            AppColors.forestGreenLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite_rounded,
            color: AppColors.onBrand,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Thank you for being part of the Cyra Community.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onBrand.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Together we create a safe, supportive space for all.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onBrand.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
