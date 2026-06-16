import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

class SymptomBarData {
  final String label;
  final double value;
  final Color color;

  const SymptomBarData({
    required this.label,
    required this.value,
    this.color = AppColors.sage,
  });
}

class SymptomBarChart extends StatelessWidget {
  final List<SymptomBarData> symptoms;
  final int maxBars;
  final bool showValues;

  const SymptomBarChart({
    super.key,
    required this.symptoms,
    this.maxBars = 10,
    this.showValues = true,
  });

  @override
  Widget build(BuildContext context) {
    if (symptoms.isEmpty) {
      return Semantics(
        label: 'Empty symptom chart',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Log symptoms to see patterns',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final sorted = List<SymptomBarData>.from(symptoms)
      ..sort((a, b) => b.value.compareTo(a.value));
    final displayData = sorted.take(maxBars).toList();
    final maxValue = displayData.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return Semantics(
      label: 'Symptom frequency bar chart',
      child: RotatedBox(
        quarterTurns: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue * 1.2,
              minY: 0,
              barGroups: displayData.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      fromY: 0,
                      width: 18,
                      color: entry.value.color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.sm),
                        topRight: Radius.circular(AppRadius.sm),
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
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= displayData.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          displayData[index].label,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: showValues,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: false,
                getDrawingVerticalLine: (value) => FlLine(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  strokeWidth: 0.5,
                ),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) =>
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.surfaceDark
                          : AppColors.charcoal,
                  tooltipRoundedRadius: AppRadius.sm,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = displayData[group.x];
                    return BarTooltipItem(
                      '${data.label}\n${data.value.toStringAsFixed(0)}',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }
}
