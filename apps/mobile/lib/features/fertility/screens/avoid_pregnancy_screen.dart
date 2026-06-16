import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';

final _avoidPregnancyProvider =
    ChangeNotifierProvider<_AvoidPregnancyState>((ref) {
  return _AvoidPregnancyState();
});

class _TrackingStatus {
  final String name;
  final IconData icon;
  final bool isTracking;

  const _TrackingStatus({
    required this.name,
    required this.icon,
    required this.isTracking,
  });
}

class _AvoidPregnancyState extends ChangeNotifier {
  int currentCycleDay = 14;
  int cycleLength = 28;
  bool isFertileToday = true;
  double fertilityProbability = 0.35;
  int trackedCycles = 2;

  List<_TrackingStatus> trackingStatuses = [
    const _TrackingStatus(name: 'BBT', icon: Icons.device_thermostat_rounded, isTracking: true),
    const _TrackingStatus(name: 'Cervical Mucus', icon: Icons.blur_circular_rounded, isTracking: true),
    const _TrackingStatus(name: 'Cervical Position', icon: Icons.radio_button_checked_rounded, isTracking: false),
    const _TrackingStatus(name: 'OPK', icon: Icons.science_outlined, isTracking: false),
  ];
}

class AvoidPregnancyScreen extends ConsumerWidget {
  const AvoidPregnancyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_avoidPregnancyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xxxxl,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          _buildHeader(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildDisclaimer(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildFertilityStatusCard(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildEducationSection(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildTrackingSection(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _AvoidPregnancyState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fertility Awareness',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Understand your cycle for natural family planning',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.4),
          width: 1.5,
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
                  'Important Disclaimer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This app provides fertility awareness information only. '
                  'It is NOT a birth control method. '
                  'Fertility awareness methods (FAM) require proper training and '
                  'consistent tracking to be effective. '
                  'Consult a healthcare provider for contraception options.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFertilityStatusCard(
    BuildContext context,
    _AvoidPregnancyState state,
    bool isDark,
  ) {
    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                state.isFertileToday
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                size: 20,
                color: state.isFertileToday ? AppColors.warning : AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                state.isFertileToday
                    ? 'Day ${state.currentCycleDay} — Fertile'
                    : 'Day ${state.currentCycleDay} — Not Fertile',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _statusBlock(
                context,
                'Fertility Probability',
                '${(state.fertilityProbability * 100).round()}%',
                state.fertilityProbability >= 0.3
                    ? AppColors.warning
                    : state.fertilityProbability >= 0.1
                        ? AppColors.softGold
                        : AppColors.success,
                isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _statusBlock(
                context,
                'Recommendation',
                state.isFertileToday ? 'Use Protection' : 'Low Risk',
                state.isFertileToday ? AppColors.warning : AppColors.success,
                isDark,
              ),
            ],
          ),
          if (state.isFertileToday) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: isDark ? 0.15 : 0.06),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'You are in your fertile window. Use protection if avoiding pregnancy.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBlock(
    BuildContext context,
    String label,
    String value,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.06),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection(
    BuildContext context,
    _AvoidPregnancyState state,
    bool isDark,
  ) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Fertility Awareness Education',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _educationCard(
            context,
            Icons.device_thermostat_rounded,
            'Basal Body Temperature (BBT)',
            'Track your resting temperature each morning before getting out of bed. '
            'A sustained temperature rise of 0.2-0.5°C indicates ovulation has occurred. '
            'After 3 consecutive days of elevated temps, the fertile window has closed.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _educationCard(
            context,
            Icons.blur_circular_rounded,
            'Cervical Mucus',
            'Observe and record your cervical mucus daily. '
            'The fertile window is characterized by clear, stretchy, egg-white mucus. '
            'After ovulation, mucus becomes thick, sticky, or disappears.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _educationCard(
            context,
            Icons.radio_button_checked_rounded,
            'Cervical Position',
            'During the fertile window, the cervix becomes higher, softer, and more open. '
            'After ovulation, it returns to a lower, firmer, closed position. '
            'This is an advanced sign used in combination with other methods.',
            isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View education articles',
                style: TextStyle(
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _educationCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.forestGreen),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
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
    );
  }

  Widget _buildTrackingSection(
    BuildContext context,
    _AvoidPregnancyState state,
    bool isDark,
  ) {
    final trackingCount = state.trackingStatuses.where((t) => t.isTracking).length;

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes_rounded, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tracking Status',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: HealthStatCard(
                  label: 'Tracked Cycles',
                  value: '${state.trackedCycles}',
                  icon: Icons.repeat_rounded,
                  accentColor: AppColors.sage,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: HealthStatCard(
                  label: 'Methods Tracking',
                  value: '$trackingCount/4',
                  icon: Icons.track_changes_rounded,
                  accentColor: trackingCount >= 2 ? AppColors.success : AppColors.softGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...state.trackingStatuses.map((status) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: (status.isTracking ? AppColors.forestGreen : AppColors.slate)
                          .withValues(alpha: isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      status.icon,
                      size: 16,
                      color: status.isTracking ? AppColors.forestGreen : AppColors.slate,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      status.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                    decoration: BoxDecoration(
                      color: (status.isTracking ? AppColors.forestGreen : AppColors.slate)
                          .withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Text(
                      status.isTracking ? 'Active' : 'Not set',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: status.isTracking ? AppColors.forestGreen : AppColors.slate,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: isDark ? 0.1 : 0.06),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.forestGreen.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.forestGreen,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    state.trackedCycles < 3
                        ? 'You need at least 3 months of data for reliable FAM. Keep tracking!'
                        : 'You have enough data for basic FAM. Consider consulting a FAM instructor.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.forestGreen,
                    ),
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
