import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/cycle/screens/cycle_detail_screen.dart';
import 'package:cyra/features/cycle/screens/log_period_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CycleHistoryScreen extends ConsumerWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cyclesAsync = ref.watch(allCyclesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Log period',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const LogPeriodScreen()),
            ),
          ),
        ],
      ),
      body: cyclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            _ErrorState(onRetry: () => ref.invalidate(allCyclesProvider)),
        data: (cycles) => cycles.isEmpty
            ? const _EmptyState()
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(allCyclesProvider);
                  await ref.read(allCyclesProvider.future);
                },
                child: _HistoryList(cycles: cycles),
              ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.cycles});
  final List<Cycle> cycles;

  @override
  Widget build(BuildContext context) {
    final avgLength =
        cycles.map((cycle) => cycle.cycleLength).reduce((a, b) => a + b) /
        cycles.length;
    final avgPeriod =
        cycles.map((cycle) => cycle.periodLength).reduce((a, b) => a + b) /
        cycles.length;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          '${cycles.length} tracked cycles',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: HealthStatCard(
                label: 'Avg Length',
                value: '${avgLength.round()} days',
                icon: Icons.repeat_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HealthStatCard(
                label: 'Avg Period',
                value: '${avgPeriod.round()} days',
                icon: Icons.sync_rounded,
                accentColor: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        for (var index = 0; index < cycles.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _CycleCard(
              cycle: cycles[index],
              number: cycles.length - index,
            ),
          ),
      ],
    );
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({required this.cycle, required this.number});
  final Cycle cycle;
  final int number;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMM d');
    final end =
        cycle.endDate ??
        cycle.startDate.add(Duration(days: cycle.cycleLength - 1));
    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CycleDetailScreen(cycleId: cycle.id),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.forestGreen.withValues(alpha: 0.12),
            child: Text(
              '$number',
              style: TextStyle(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cycle $number',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${format.format(cycle.startDate)} – ${format.format(end)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${cycle.cycleLength} days • Period ${cycle.periodLength} days',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.forestGreen,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, size: 64, color: AppColors.forestGreen),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'No cycles tracked yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Start logging your periods to see your cycle history here.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(
            'Log Your First Period',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const LogPeriodScreen()),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) =>
      Center(child: AppButton.secondary('Try Again', onPressed: onRetry));
}
