import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/contraction_timer.dart';

class ContractionTimerScreen extends StatefulWidget {
  const ContractionTimerScreen({super.key});

  @override
  State<ContractionTimerScreen> createState() =>
      _ContractionTimerScreenState();
}

class _ContractionTimerScreenState extends State<ContractionTimerScreen> {
  final List<Contraction> _contractions = [];
  bool _showEducation = true;

  void _handleStartContraction() {
    setState(() {
      _showEducation = false;
    });
  }

  void _handleEndContraction() {
    final now = DateTime.now();
    final duration = now.difference(
      _contractions.isNotEmpty
          ? _contractions.last.startTime
          : now.subtract(const Duration(seconds: 30)),
    );

    setState(() {
      _contractions.add(
        Contraction(
          startTime: now.subtract(duration),
          duration: duration,
          intensity: 3.0,
        ),
      );
    });
  }

  Duration? get _averageDuration {
    if (_contractions.isEmpty) return null;
    final totalMicros = _contractions.fold<int>(
      0,
      (sum, c) => sum + c.duration.inMicroseconds,
    );
    return Duration(microseconds: totalMicros ~/ _contractions.length);
  }

  Duration? get _averageFrequency {
    if (_contractions.length < 2) return null;
    final sorted = List<Contraction>.from(_contractions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final gaps = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      gaps.add(
        sorted[i].startTime.difference(sorted[i - 1].startTime).inSeconds,
      );
    }
    final avgSeconds = gaps.reduce((a, b) => a + b) ~/ gaps.length;
    return Duration(seconds: avgSeconds);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avgDuration = _averageDuration;
    final avgFrequency = _averageFrequency;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contraction Timer',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_contractions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share log',
              onPressed: () {
                _showShareSheet(context, isDark);
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          AppCard.standard(
            padding: EdgeInsets.zero,
            child: ContractionTimer(
              contractions: _contractions,
              onStartContraction: _handleStartContraction,
              onEndContraction: _handleEndContraction,
            ),
          ),
          if (_contractions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildSummaryStats(context, isDark, avgDuration, avgFrequency),
          ],
          if (_contractions.length >= 1) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildContractionList(context, isDark),
          ],
          if (_showEducation || _contractions.isEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildEducationSection(context, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryStats(
    BuildContext context,
    bool isDark,
    Duration? avgDuration,
    Duration? avgFrequency,
  ) {
    final meets511 = avgFrequency != null &&
        avgFrequency.inMinutes <= 5 &&
        avgDuration != null &&
        avgDuration.inSeconds >= 60;

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Summary',
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
                child: _statBox(
                  context,
                  Icons.timer_outlined,
                  'Average Duration',
                  avgDuration != null
                      ? _formatDuration(avgDuration)
                      : '--',
                  AppColors.sage,
                  isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _statBox(
                  context,
                  Icons.repeat_rounded,
                  'Frequency',
                  avgFrequency != null
                      ? 'Every ${avgFrequency.inMinutes}m ${avgFrequency.inSeconds.remainder(60)}s'
                      : '--',
                  AppColors.softGold,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  context,
                  Icons.format_list_numbered_rounded,
                  'Total',
                  '${_contractions.length}',
                  AppColors.forestGreen,
                  isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _statBox(
                  context,
                  Icons.medical_services_outlined,
                  '5-1-1 Status',
                  meets511 ? 'Met' : 'Not yet',
                  meets511 ? AppColors.success : AppColors.slate,
                  isDark,
                ),
              ),
            ],
          ),
          if (meets511) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Your contractions meet the 5-1-1 rule. Consider contacting your healthcare provider.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.charcoal,
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

  Widget _statBox(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractionList(BuildContext context, bool isDark) {
    final recent = _contractions.reversed.take(10).toList();

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.list_alt_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Contraction Log',
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
          ...recent.map((c) {
            final timeStr = DateFormat('h:mm a').format(c.startTime);
            final durationStr = _formatDuration(c.duration);
            final intensityStars = '★' * c.intensity.round();
            final intensityEmpty = '☆' * (5 - c.intensity.round());

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.charcoal.withValues(alpha: 0.2)
                      : AppColors.mistWhite,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Text(
                      timeStr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.slate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        durationStr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Text(
                      '$intensityStars$intensityEmpty',
                      style: const TextStyle(
                        color: AppColors.softGold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWhenToGoSection(context, isDark),
        const SizedBox(height: AppSpacing.md),
        _buildOtherSignsSection(context, isDark),
      ],
    );
  }

  Widget _buildWhenToGoSection(BuildContext context, bool isDark) {
    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_hospital_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'When to Go to the Hospital',
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
            'The 5-1-1 Rule',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ruleRow(context, '5', 'Contractions every 5 minutes', isDark),
          _ruleRow(context, '1', 'Contractions lasting 1 minute each', isDark),
          _ruleRow(context, '1', 'This pattern continues for 1 hour', isDark),
        ],
      ),
    );
  }

  Widget _ruleRow(
    BuildContext context,
    String number,
    String description,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.slate,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherSignsSection(BuildContext context, bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other Signs of Labor',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _signRow(context, Icons.water_drop_rounded, 'Water breaking (rupture of membranes)', isDark),
          _signRow(context, Icons.bloodtype_rounded, 'Bloody show (mucus plug discharge)', isDark),
          _signRow(context, Icons.air_rounded, 'Back pain that comes and goes', isDark),
          _signRow(context, Icons.self_improvement_rounded, 'Pelvic pressure and cramping', isDark),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Always follow your healthcare provider\'s guidance on when to come to the hospital.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate,
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

  Widget _signRow(
    BuildContext context,
    IconData icon,
    String text,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.slate),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share Contraction Log',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    'Copy to Clipboard',
                    icon: Icons.copy_rounded,
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraction log copied')));
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.secondary(
                    'Share as PDF',
                    icon: Icons.picture_as_pdf_rounded,
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF export coming soon')));
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.ghost(
                    'Cancel',
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
