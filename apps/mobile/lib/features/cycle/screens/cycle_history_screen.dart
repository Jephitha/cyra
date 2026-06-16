import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/features/cycle/screens/cycle_detail_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';

final _historyProvider = ChangeNotifierProvider<_HistoryState>((ref) {
  return _HistoryState();
});

class _HistoryState extends ChangeNotifier {
  bool isLoading = true;
  bool isRefreshing = false;
  bool hasData = true;

  List<_CycleSummaryItem> cycles = [];

  _HistoryState() {
    _loadData();
  }

  void _loadData() {
    final now = DateTime.now();

    cycles = List.generate(6, (index) {
      final reverseIndex = 5 - index;
      final start = now.subtract(Duration(days: 28 * reverseIndex + 14 * reverseIndex));
      final end = start.add(Duration(days: 28));
      final periodLength = [5, 4, 6, 5, 4, 5][index];
      final cycleLength = [28, 29, 27, 28, 30, 28][index];
      final avgFlow = [2.0, 2.5, 3.0, 2.0, 2.5, 2.0][index];
      final symptomCount = [5, 7, 4, 6, 8, 5][index];

      return _CycleSummaryItem(
        cycleNumber: reverseIndex + 1,
        startDate: start,
        endDate: end,
        cycleLength: cycleLength,
        periodLength: periodLength,
        averageFlow: avgFlow,
        symptomCount: symptomCount,
      );
    });

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    isRefreshing = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    isRefreshing = false;
    notifyListeners();
  }
}

class _CycleSummaryItem {
  final int cycleNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLength;
  final int periodLength;
  final double averageFlow;
  final int symptomCount;

  const _CycleSummaryItem({
    required this.cycleNumber,
    required this.startDate,
    required this.endDate,
    required this.cycleLength,
    required this.periodLength,
    required this.averageFlow,
    required this.symptomCount,
  });

  int get variability {
    return (cycleLength - 28).abs();
  }
}

class CycleHistoryScreen extends ConsumerWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_historyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LogPeriodScreen(),
              ),
            ),
            tooltip: 'Log period',
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !state.hasData
              ? _buildEmptyState(context, ref)
              : RefreshIndicator(
                  onRefresh: () => ref.read(_historyProvider.notifier).refresh(),
                  color: AppColors.forestGreen,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _buildSummaryHeader(context, state, isDark),
                      const SizedBox(height: AppSpacing.lg),
                      ...state.cycles.map((cycle) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildCycleItem(context, cycle, isDark),
                          )),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, _HistoryState state, bool isDark) {
    final totalCycles = state.cycles.length;
    final avgLength = state.cycles.isEmpty
        ? 0.0
        : state.cycles.map((c) => c.cycleLength).reduce((a, b) => a + b) / state.cycles.length;
    final avgPeriod = state.cycles.isEmpty
        ? 0.0
        : state.cycles.map((c) => c.periodLength).reduce((a, b) => a + b) / state.cycles.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$totalCycles tracked cycles',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Avg Length',
                value: '${avgLength.toStringAsFixed(0)} days',
                icon: Icons.repeat_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Avg Period',
                value: '${avgPeriod.toStringAsFixed(0)} days',
                icon: Icons.water_drop_rounded,
                accentColor: const Color(0xFFE86B6B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCycleItem(BuildContext context, _CycleSummaryItem cycle, bool isDark) {
    final regularity = _regularityColor(cycle.variability);
    final format = DateFormat('MMM d');

    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CycleDetailScreen(cycleId: cycle.cycleNumber),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: regularity.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${cycle.cycleNumber}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: regularity.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cycle ${cycle.cycleNumber}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${format.format(cycle.startDate)} – ${format.format(cycle.endDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    _cycleTag('${cycle.cycleLength}d', AppColors.forestGreen),
                    const SizedBox(width: AppSpacing.sm),
                    _cycleTag('Period: ${cycle.periodLength}d', const Color(0xFFE86B6B)),
                    const SizedBox(width: AppSpacing.sm),
                    _cycleTag('Flow: ${cycle.averageFlow.toStringAsFixed(1)}', AppColors.sage),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: regularity.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cycleTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  _Regularity _regularityColor(int variability) {
    if (variability <= 3) return _Regularity(AppColors.success, 'Regular');
    if (variability <= 7) return _Regularity(AppColors.softGold, 'Slightly irregular');
    return _Regularity(AppColors.error, 'Irregular');
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 40,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'No cycles tracked yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Start logging your periods to see your cycle history here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton.primary(
              'Log Your First Period',
              icon: Icons.add_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LogPeriodScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Regularity {
  final Color color;
  final String label;

  const _Regularity(this.color, this.label);
}
