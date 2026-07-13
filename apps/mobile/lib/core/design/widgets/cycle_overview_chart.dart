import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

class CycleLengthData {
  final int cycleNumber;
  final int lengthDays;
  final bool isAverage;

  const CycleLengthData({
    required this.cycleNumber,
    required this.lengthDays,
    this.isAverage = false,
  });
}

class CycleOverviewChart extends StatefulWidget {
  final List<CycleLengthData> cycleHistory;
  final bool showAverageLine;
  final double height;

  const CycleOverviewChart({
    super.key,
    required this.cycleHistory,
    this.showAverageLine = true,
    this.height = 200,
  });

  @override
  State<CycleOverviewChart> createState() => _CycleOverviewChartState();
}

class _CycleOverviewChartState extends State<CycleOverviewChart> {
  double _averageLength = 28;

  @override
  void initState() {
    super.initState();
    _computeAverage();
  }

  @override
  void didUpdateWidget(CycleOverviewChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cycleHistory != widget.cycleHistory) {
      _computeAverage();
    }
  }

  void _computeAverage() {
    final avgEntries = widget.cycleHistory.where((c) => c.isAverage).toList();
    if (avgEntries.isNotEmpty) {
      _averageLength = avgEntries.first.lengthDays.toDouble();
      return;
    }
    final realCycles = widget.cycleHistory.where((c) => c.lengthDays > 0).toList();
    if (realCycles.isEmpty) {
      _averageLength = 28;
      return;
    }
    _averageLength = realCycles.map((c) => c.lengthDays).reduce((a, b) => a + b) / realCycles.length;
  }

  Color _barColor(int lengthDays) {
    final diff = (lengthDays - _averageLength).abs();
    if (diff <= 3) return AppColors.forestGreen;
    if (diff <= 7) return AppColors.softGold;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cycleHistory.isEmpty) {
      return Semantics(
        label: 'Empty cycle overview chart',
        child: SizedBox(
          height: widget.height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Complete your first cycle to see your overview',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final displayData = widget.cycleHistory.where((c) => c.lengthDays > 0).toList();
    if (displayData.isEmpty) {
      return Semantics(
        label: 'No cycle data',
        child: SizedBox(
          height: widget.height,
          child: Center(
            child: Text(
              'No complete cycle data yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      );
    }

    final maxLength = displayData.map((c) => c.lengthDays).reduce((a, b) => a > b ? a : b);

    return Semantics(
      label: 'Cycle length overview chart',
      child: SizedBox(
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: BarChart(
            _buildChartData(displayData, maxLength),
            duration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }

  BarChartData _buildChartData(List<CycleLengthData> displayData, int maxLength) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final gridColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (maxLength * 1.2).ceilToDouble().clamp(30, double.infinity),
      minY: 0,
      extraLinesData: widget.showAverageLine
          ? ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: _averageLength,
                  color: AppColors.charcoal,
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.charcoal.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          : null,
      barGroups: displayData.asMap().entries.map((entry) {
        final cycle = entry.value;
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: cycle.lengthDays.toDouble(),
              fromY: 0,
              width: 20,
              color: _barColor(cycle.lengthDays),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.xs),
                topRight: Radius.circular(AppRadius.xs),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
          ],
        );
      }).toList(),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= displayData.length) {
                return const SizedBox.shrink();
              }
              final shouldShow = displayData.length <= 15 || index % 2 == 0;
              if (!shouldShow) return const SizedBox.shrink();
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  'Cycle ${displayData[index].cycleNumber}',
                  style: TextStyle(fontSize: 9, color: textColor),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value == 0) return const SizedBox.shrink();
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  '${value.toInt()}d',
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              );
            },
            interval: _leftAxisInterval(maxLength),
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: gridColor.withValues(alpha: 0.3),
          strokeWidth: 0.5,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: gridColor, width: 0.5),
          left: BorderSide(color: gridColor, width: 0.5),
        ),
      ),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) =>
              isDark ? AppColors.surfaceDark : AppColors.charcoal,
          tooltipRoundedRadius: AppRadius.sm,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final cycle = displayData[group.x];
            return BarTooltipItem(
              'Cycle ${cycle.cycleNumber}\n${cycle.lengthDays} days',
              TextStyle(
                color: AppColors.onBrand,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
    );
  }

  double _leftAxisInterval(int maxLength) {
    if (maxLength <= 30) return 5;
    if (maxLength <= 60) return 10;
    return 20;
  }
}
