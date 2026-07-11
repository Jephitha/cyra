import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/kick_counter.dart';
import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';
import 'package:cyra/features/pregnancy/providers/pregnancy_providers.dart';

class KickCounterScreen extends ConsumerStatefulWidget {
  const KickCounterScreen({super.key});

  @override
  ConsumerState<KickCounterScreen> createState() => _KickCounterScreenState();
}

class _KickCounterScreenState extends ConsumerState<KickCounterScreen> {
  int _kickCount = 0;
  DateTime? _startTime;
  bool _isRunning = false;
  final List<KickLog> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadKickHistory();
  }

  Future<void> _loadKickHistory() async {
    try {
      final pregnancy = ref.read(currentPregnancyProvider).valueOrNull;
      if (pregnancy != null) {
        final repo = ref.read(pregnancyRepositoryProvider);
        final logs = await repo.getKickLogs(pregnancy.id);
        if (mounted) {
          setState(() {
            _sessions.clear();
            _sessions.addAll(logs);
          });
        }
      }
    } catch (e) {
      // Silently fail on load error
    }
  }

  Future<void> _handleStartStop() async {
    if (_isRunning) {
      if (_kickCount > 0) {
        final endTime = DateTime.now();
        final durationMinutes = endTime.difference(_startTime!).inMinutes;

        try {
          final pregnancy = ref.read(currentPregnancyProvider).valueOrNull;
          if (pregnancy != null) {
            final repo = ref.read(pregnancyRepositoryProvider);
            final kickLog = KickLog(
              id: 'kick_${DateTime.now().microsecondsSinceEpoch}',
              pregnancyId: pregnancy.id,
              date: _startTime!,
              kickCount: _kickCount,
              durationMinutes: durationMinutes,
            );
            await repo.saveKickLog(kickLog);

            if (mounted) {
              setState(() {
                _sessions.insert(0, kickLog);
                _kickCount = 0;
                _startTime = null;
                _isRunning = false;
              });
            }
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _kickCount = 0;
              _startTime = null;
              _isRunning = false;
            });
          }
        }
      } else {
        setState(() {
          _kickCount = 0;
          _startTime = null;
          _isRunning = false;
        });
      }
    } else {
      setState(() {
        _startTime = DateTime.now();
        _kickCount = 0;
        _isRunning = true;
      });
    }
  }

  void _handleKickLogged() {
    setState(() {
      _kickCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kick Counter',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
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
          AppCard.standard(
            padding: EdgeInsets.zero,
            child: KickCounter(
              kickCount: _kickCount,
              startTime: _startTime,
              onKickLogged: _handleKickLogged,
              onStartStop: _handleStartStop,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildNormalRangeInfo(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          if (_sessions.isNotEmpty) _buildSessionHistory(context, isDark),
          if (_sessions.isNotEmpty) const SizedBox(height: AppSpacing.lg),
          _buildTipsCard(context, isDark),
        ],
      ),
    );
  }

  Widget _buildNormalRangeInfo(BuildContext context, bool isDark) {
    return AppCard.standard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Normal Range',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '10 kicks in 2 hours is normal. Baby may be most active after meals.',
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

  Widget _buildSessionHistory(BuildContext context, bool isDark) {
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 20,
                color: AppColors.forestGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Recent Sessions',
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
          ..._sessions.take(5).map((session) {
            final timeStr =
                '${session.date.hour.toString().padLeft(2, '0')}:${session.date.minute.toString().padLeft(2, '0')}';
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
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${session.kickCount}',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.sage,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'kicks in ${session.durationMinutes} min',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.slate,
                        ),
                      ),
                    ),
                    Icon(
                      _isWithinRange(session)
                          ? Icons.check_circle_rounded
                          : Icons.info_outline_rounded,
                      size: 18,
                      color: _isWithinRange(session)
                          ? AppColors.success
                          : AppColors.softGold,
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

  bool _isWithinRange(KickLog session) {
    final durationHours = session.durationMinutes / 60.0;
    if (durationHours <= 0) return false;
    return (session.kickCount / durationHours) >= 5;
  }

  Widget _buildTipsCard(BuildContext context, bool isDark) {
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
                'Tips',
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
          _tipRow(context, 'Count kicks at the same time each day', isDark),
          _tipRow(
            context,
            'Try counting after meals when baby may be active',
            isDark,
          ),
          _tipRow(context, 'Sit in a quiet space or lie on your side', isDark),
          _tipRow(
            context,
            'Contact your provider if you notice decreased movement',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _tipRow(BuildContext context, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: AppColors.slate),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
