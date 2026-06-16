import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';
import 'package:cyra/core/design/widgets/fertility_widget.dart';
import 'package:cyra/core/design/widgets/confidence_badge.dart';
import 'package:cyra/core/design/widgets/cycle_phase_indicator.dart';
import 'package:cyra/features/ovulation/screens/log_bbt_screen.dart';
import 'package:cyra/features/ovulation/screens/log_opk_screen.dart';
import 'package:cyra/features/ovulation/screens/log_mucus_screen.dart';

final _ovulationDashboardProvider =
    ChangeNotifierProvider<_OvulationDashboardState>((ref) {
  return _OvulationDashboardState();
});

class _OvulationDashboardState extends ChangeNotifier {
  bool isLoading = true;

  int currentCycleDay = 14;
  int cycleLength = 28;
  DateTime? lastPeriodStart;
  DateTime? ovulationDate;
  double ovulationProbability = 0.72;
  bool ovulationDetected = false;
  DateTime? confirmedOvulationDate;
  double confidence = 0.68;

  List<BBTDataPoint> bbtData = [];
  double? coverLineTemperature;
  DateTime? lastBBTDate;
  String? lastBBTValue;
  String? lastBBTTime;

  String? latestOPKResult;
  bool? latestOPKPositive;
  List<_OPKTimelineEntry> recentOPKResults = [];

  _MucusEntry? currentMucus;
  List<_MucusEntry> mucusHistory = [];

  _OvulationDashboardState() {
    _loadData();
  }

  void _loadData() {
    lastPeriodStart = DateTime.now().subtract(const Duration(days: 13));
    ovulationDate = DateTime.now().subtract(const Duration(days: 1));

    bbtData = [
      BBTDataPoint(date: DateTime(2026, 3, 1), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 3, 2), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 3, 3), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 3, 4), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 3, 5), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 3, 6), temperature: 36.3),
      BBTDataPoint(date: DateTime(2026, 3, 7), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 3, 8), temperature: 36.4),
      BBTDataPoint(date: DateTime(2026, 3, 9), temperature: 36.6),
      BBTDataPoint(date: DateTime(2026, 3, 10), temperature: 36.5),
      BBTDataPoint(date: DateTime(2026, 3, 11), temperature: 36.7),
      BBTDataPoint(date: DateTime(2026, 3, 12), temperature: 36.8),
      BBTDataPoint(date: DateTime(2026, 3, 13), temperature: 36.9),
      BBTDataPoint(date: DateTime(2026, 3, 14), temperature: 36.8),
    ];
    coverLineTemperature = 36.6;
    lastBBTDate = DateTime.now();
    lastBBTValue = '36.7';
    lastBBTTime = '7:15 AM';

    latestOPKResult = 'Positive';
    latestOPKPositive = true;
    recentOPKResults = [
      _OPKTimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 0)),
        result: 'Positive',
        isPositive: true,
      ),
      _OPKTimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 1)),
        result: 'Fading',
        isPositive: false,
      ),
      _OPKTimelineEntry(
        date: DateTime.now().subtract(const Duration(days: 2)),
        result: 'Positive',
        isPositive: true,
      ),
    ];

    currentMucus = _MucusEntry(
      date: DateTime.now(),
      type: 'Egg White',
      description: 'Clear, stretchy',
      isFertile: true,
    );
    mucusHistory = [
      _MucusEntry(
        date: DateTime.now().subtract(const Duration(days: 0)),
        type: 'Egg White',
        description: 'Clear, stretchy',
        isFertile: true,
      ),
      _MucusEntry(
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'Watery',
        description: 'Clear, wet',
        isFertile: true,
      ),
      _MucusEntry(
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: 'Creamy',
        description: 'White, creamy',
        isFertile: false,
      ),
      _MucusEntry(
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: 'Sticky',
        description: 'Thick, white',
        isFertile: false,
      ),
    ];

    ovulationDetected = true;
    confirmedOvulationDate = DateTime.now().subtract(const Duration(days: 1));
    confidence = 0.72;

    isLoading = false;
    notifyListeners();
  }
}

class _OPKTimelineEntry {
  final DateTime date;
  final String result;
  final bool isPositive;
  const _OPKTimelineEntry({
    required this.date,
    required this.result,
    required this.isPositive,
  });
}

class _MucusEntry {
  final DateTime date;
  final String type;
  final String description;
  final bool isFertile;
  const _MucusEntry({
    required this.date,
    required this.type,
    required this.description,
    required this.isFertile,
  });
}

class OvulationDashboardScreen extends ConsumerWidget {
  const OvulationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_ovulationDashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          _buildFertileWindowCard(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildBBTSection(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildOPKSection(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildCervicalMucusSection(context, state, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildOvulationStatusCard(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _OvulationDashboardState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ovulation Tracking',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        CyclePhaseIndicator(
          phase: CyclePhase.ovulation,
          size: CyclePhaseIndicatorSize.medium,
        ),
      ],
    );
  }

  Widget _buildFertileWindowCard(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {

    return AppCard.standard(
      padding: EdgeInsets.zero,
      child: FertilityWidget(
        lastPeriodStart: state.lastPeriodStart,
        ovulationDate: state.ovulationDate,
        cycleLength: state.cycleLength,
        currentCycleDay: state.currentCycleDay,
        compact: false,
      ),
    );
  }

  Widget _buildBBTSection(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    return AppCard.chart(
      title: 'Basal Body Temperature',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BBTChart(
            dataPoints: state.bbtData,
            height: 180,
            coverLineTemperature: state.coverLineTemperature,
            ovulationDate: state.ovulationDate,
            showLegend: true,
          ),
          if (state.lastBBTValue != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.device_thermostat_rounded,
                  size: 16,
                  color: AppColors.slate,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Last logged: ${state.lastBBTValue}°C at ${state.lastBBTTime}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.primary(
              'Log Temperature',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LogBBTScreen(),
                  ),
                );
              },
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOPKSection(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'OPK Results',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.latestOPKResult != null)
            _buildLatestOPKResult(context, state, isDark)
          else
            _buildEmptyOPK(context, isDark),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.secondary(
              'Log OPK Result',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LogOPKScreen(),
                  ),
                );
              },
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestOPKResult(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: (state.latestOPKPositive == true
                ? AppColors.forestGreen
                : AppColors.slate)
            .withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: (state.latestOPKPositive == true
                  ? AppColors.forestGreen
                  : AppColors.slate)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            state.latestOPKPositive == true
                ? Icons.celebration_outlined
                : Icons.remove_circle_outline,
            size: 32,
            color: state.latestOPKPositive == true
                ? AppColors.forestGreen
                : AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.latestOPKResult!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                state.latestOPKPositive == true
                    ? 'Test line is as dark or darker than control'
                    : 'Test line is lighter or absent',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOPK(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.science_outlined,
            size: 24,
            color: AppColors.slate.withValues(alpha: 0.5),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'No OPK results logged yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCervicalMucusSection(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.blur_circular_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Cervical Mucus',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (state.currentMucus != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildCurrentMucus(context, state, isDark),
            const SizedBox(height: AppSpacing.md),
            _buildMucusHistory(context, state, isDark),
          ] else ...[
            const SizedBox(height: AppSpacing.lg),
            _buildEmptyMucus(context, isDark),
          ],
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.secondary(
              'Log Mucus',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LogMucusScreen(),
                  ),
                );
              },
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentMucus(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    final mucus = state.currentMucus!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: mucus.isFertile
              ? [AppColors.softGold.withValues(alpha: 0.15), AppColors.softGold.withValues(alpha: 0.05)]
              : [AppColors.forestGreen.withValues(alpha: 0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: mucus.isFertile
              ? AppColors.softGold.withValues(alpha: 0.4)
              : AppColors.forestGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          _mucusIcon(mucus.type, size: 36, color: mucus.isFertile ? AppColors.softGold : AppColors.sage),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mucus.type,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  mucus.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
            decoration: BoxDecoration(
              color: (mucus.isFertile ? AppColors.softGold : AppColors.forestGreen).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Text(
              mucus.isFertile ? 'Fertile' : 'Non-fertile',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: mucus.isFertile ? AppColors.softGold : AppColors.forestGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMucusHistory(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent observations',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.mucusHistory.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final entry = state.mucusHistory[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (entry.isFertile ? AppColors.softGold : AppColors.forestGreen)
                      .withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: (entry.isFertile ? AppColors.softGold : AppColors.slate).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _mucusIcon(entry.type, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      DateFormat('MMM d').format(entry.date),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _mucusIcon(String type, {double size = 24, Color? color}) {
    IconData icon;
    switch (type) {
      case 'Dry':
        icon = Icons.eco_outlined;
      case 'Sticky':
        icon = Icons.circle_rounded;
      case 'Creamy':
        icon = Icons.opacity_rounded;
      case 'Egg White':
        icon = Icons.blur_on_rounded;
      case 'Watery':
        icon = Icons.water_drop_outlined;
      default:
        icon = Icons.circle_outlined;
    }
    return Icon(icon, size: size, color: color ?? AppColors.slate);
  }

  Widget _buildEmptyMucus(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.blur_circular_rounded, size: 24, color: AppColors.slate.withValues(alpha: 0.5)),
          const SizedBox(width: AppSpacing.md),
          Text(
            'No mucus observations logged yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }

  Widget _buildOvulationStatusCard(
    BuildContext context,
    _OvulationDashboardState state,
    bool isDark,
  ) {
    String status;
    Color statusColor;

    if (state.ovulationDetected && state.confirmedOvulationDate != null) {
      status = 'Confirmed';
      statusColor = AppColors.forestGreen;
    } else if (state.ovulationProbability >= 0.5) {
      status = 'Estimated';
      statusColor = AppColors.softGold;
    } else {
      status = 'Not Detected';
      statusColor = AppColors.slate;
    }

    return AppCard.highlighted(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Ovulation Status',
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
              Icon(
                status == 'Confirmed'
                    ? Icons.check_circle_rounded
                    : status == 'Estimated'
                        ? Icons.pending_rounded
                        : Icons.remove_circle_outline_rounded,
                size: 28,
                color: statusColor,
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (state.confirmedOvulationDate != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      DateFormat('MMM d, yyyy').format(state.confirmedOvulationDate!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              ConfidenceBadge(
                confidence: state.confidence,
                size: ConfidenceBadgeSize.medium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Based on your cycle history and symptoms, ovulation likely occurred around this date.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }
}
