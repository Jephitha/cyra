import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  ConsumerState<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  int _selectedMood = 3;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  final List<_MoodFace> _moodFaces = const [
    _MoodFace(1, 'Terrible', Icons.sentiment_very_dissatisfied_rounded),
    _MoodFace(2, 'Poor', Icons.sentiment_dissatisfied_rounded),
    _MoodFace(3, 'Okay', Icons.sentiment_neutral_rounded),
    _MoodFace(4, 'Good', Icons.sentiment_satisfied_rounded),
    _MoodFace(5, 'Great', Icons.sentiment_very_satisfied_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _loadTodayMood();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayMood() async {
    final existing = await ref.read(moodForDateProvider(DateTime.now()).future);
    if (existing != null && mounted) {
      setState(() {
        _selectedMood = existing.moodRating;
        _notesController.text = existing.notes ?? '';
      });
    }
  }

  Color _moodColor(int rating) {
    switch (rating) {
      case 1:
        return AppColors.error;
      case 2:
        return Colors.orange;
      case 3:
        return AppColors.warning;
      case 4:
        return AppColors.forestGreenLight;
      case 5:
        return AppColors.forestGreen;
      default:
        return AppColors.slate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodsAsync = ref.watch(moodsInRangeProvider(
      DateTime.now().subtract(const Duration(days: 30)),
      DateTime.now(),
    ));
    final correlationAsync = ref.watch(moodCycleCorrelationProvider);

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodayMoodSection(isDark),
            const SizedBox(height: AppSpacing.xxl),
            moodsAsync.when(
              data: (moods) => _buildMoodContent(isDark, moods, correlationAsync),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildError(e),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        'Mood Tracker',
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTodayMoodSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How are you feeling today?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_moodFaces.length, (index) {
            final face = _moodFaces[index];
            final isSelected = _selectedMood == face.rating;
            return GestureDetector(
              onTap: () => setState(() => _selectedMood = face.rating),
              child: AnimatedScale(
                scale: isSelected ? 1.2 : 0.9,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      face.icon,
                      size: 40,
                      color: isSelected
                          ? _moodColor(face.rating)
                          : AppColors.slate.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      face.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? _moodColor(face.rating)
                            : AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'How was your day? Add a note...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          'Save Mood',
          icon: Icons.check,
          isLoading: _isSaving,
          onPressed: _saveMood,
          width: double.infinity,
        ),
      ],
    );
  }

  Future<void> _saveMood() async {
    setState(() => _isSaving = true);

    final entry = MoodEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: DateTime.now(),
      moodRating: _selectedMood,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    await ref.read(moodLoggerProvider.notifier).saveMood(entry);

    if (mounted) {
      setState(() => _isSaving = false);
      ref.invalidate(moodsInRangeProvider(
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now(),
      ));
      context.showSnackBar('Mood saved');
    }
  }

  Widget _buildMoodContent(
    bool isDark,
    List<MoodEntry> moods,
    AsyncValue<Map<String, dynamic>> correlationAsync,
  ) {
    if (moods.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMoodCalendar(isDark, moods),
        const SizedBox(height: AppSpacing.xxl),
        _buildMoodTrendChart(isDark, moods),
        const SizedBox(height: AppSpacing.xxl),
        correlationAsync.when(
          data: (correlation) {
            if (correlation['insight'] != null) {
              return _buildInsightCard(isDark, correlation['insight'] as String);
            }
            return const SizedBox.shrink();
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMoodCalendar(bool isDark, List<MoodEntry> moods) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;

    final moodMap = <int, int>{};
    for (final m in moods) {
      if (m.date.month == now.month && m.date.year == now.year) {
        moodMap[m.date.day] = m.moodRating;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(now),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: startWeekday + lastDay.day,
          itemBuilder: (context, index) {
            if (index < startWeekday) {
              return const SizedBox.shrink();
            }
            final day = index - startWeekday + 1;
            final mood = moodMap[day];

            return Container(
              decoration: BoxDecoration(
                color: mood != null
                    ? _moodColor(mood).withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              alignment: Alignment.center,
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      mood != null ? FontWeight.w600 : FontWeight.w400,
                  color: mood != null
                      ? _moodColor(mood)
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.slate),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoodTrendChart(bool isDark, List<MoodEntry> moods) {
    moods.sort((a, b) => a.date.compareTo(b.date));
    if (moods.length < 2) {
      return AppCard.chart(
        title: 'Mood Trend',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Center(
            child: Text(
              'Log more days to see your trend',
              style: TextStyle(color: AppColors.slate, fontSize: 13),
            ),
          ),
        ),
      );
    }

    return AppCard.chart(
      title: 'Mood Trend',
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: (isDark ? AppColors.borderDark : AppColors.borderLight)
                    .withValues(alpha: 0.5),
                strokeWidth: 0.5,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value < 1 || value > 5) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.slate,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: (moods.length / 5).ceilToDouble().clamp(1, double.infinity),
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= moods.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      DateFormat('M/d').format(moods[index].date),
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.slate,
                      ),
                    );
                  },
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (moods.length - 1).toDouble(),
            minY: 0.5,
            maxY: 5.5,
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  moods.length,
                  (i) => FlSpot(i.toDouble(), moods[i].moodRating.toDouble()),
                ),
                isCurved: true,
                color: AppColors.forestGreen,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: _moodColor(spot.y.toInt()),
                      strokeWidth: 0,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.forestGreen.withValues(alpha: 0.08),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => spots.map((spot) {
                  final index = spot.spotIndex;
                  final mood = moods[index];
                  return LineTooltipItem(
                    '${DateFormat('MMM d').format(mood.date)}\nMood: ${mood.moodRating}/5',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(bool isDark, String insight) {
    return AppCard.highlighted(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 24,
            color: AppColors.softGold,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insight',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.softGold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  insight,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mood_outlined,
              size: 56,
              color: AppColors.slate.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Track your mood to discover patterns',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxxl),
        child: Text(
          'Something went wrong',
          style: TextStyle(color: AppColors.error),
        ),
      ),
    );
  }
}

class _MoodFace {
  final int rating;
  final String label;
  final IconData icon;

  const _MoodFace(this.rating, this.label, this.icon);
}
