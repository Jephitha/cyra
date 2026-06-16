import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

class BBTDataPoint {
  final DateTime date;
  final double temperature;
  final bool isEstimated;

  const BBTDataPoint({
    required this.date,
    required this.temperature,
    this.isEstimated = false,
  });
}

class BBTChart extends StatefulWidget {
  final List<BBTDataPoint> dataPoints;
  final bool showLegend;
  final double height;
  final Color lineColor;
  final double? coverLineTemperature;
  final DateTime? ovulationDate;

  const BBTChart({
    super.key,
    required this.dataPoints,
    this.showLegend = false,
    this.height = 200,
    this.lineColor = AppColors.forestGreen,
    this.coverLineTemperature,
    this.ovulationDate,
  });

  @override
  State<BBTChart> createState() => _BBTChartState();
}

class _BBTChartState extends State<BBTChart> {
  double _minTemp = 36.0;
  double _maxTemp = 37.5;

  @override
  void initState() {
    super.initState();
    _computeTempRange();
  }

  @override
  void didUpdateWidget(BBTChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataPoints != widget.dataPoints) {
      _computeTempRange();
    }
  }

  void _computeTempRange() {
    if (widget.dataPoints.isEmpty) {
      _minTemp = 36.0;
      _maxTemp = 37.5;
      return;
    }
    final temps = widget.dataPoints.map((d) => d.temperature);
    final min = temps.reduce((a, b) => a < b ? a : b);
    final max = temps.reduce((a, b) => a > b ? a : b);
    final padding = ((max - min) * 0.2).clamp(0.3, 1.0);
    _minTemp = (min - padding).clamp(35.5, 37.0);
    _maxTemp = (max + padding).clamp(36.5, 38.0);
  }

  double get _coverLineTemperature {
    if (widget.coverLineTemperature != null) return widget.coverLineTemperature!;
    if (widget.dataPoints.isEmpty) return 36.5;
    final count = (widget.dataPoints.length ~/ 2).clamp(1, widget.dataPoints.length);
    final preOvPoints = widget.dataPoints.take(count);
    final avg = preOvPoints.map((d) => d.temperature).reduce((a, b) => a + b) / count;
    return (avg * 10).roundToDouble() / 10 + 0.1;
  }

  int? get _ovulationIndex {
    if (widget.ovulationDate == null) return null;
    for (int i = 0; i < widget.dataPoints.length; i++) {
      if (widget.dataPoints[i].date.year == widget.ovulationDate!.year &&
          widget.dataPoints[i].date.month == widget.ovulationDate!.month &&
          widget.dataPoints[i].date.day == widget.ovulationDate!.day) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataPoints.isEmpty) {
      return Semantics(
        label: 'Empty BBT chart',
        child: SizedBox(
          height: widget.height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.device_thermostat_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Start tracking your temperature to see your BBT chart',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: 'Basal body temperature chart',
          child: SizedBox(
            height: widget.height,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm, top: AppSpacing.sm),
              child: LineChart(
                _buildChartData(),
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
        if (widget.showLegend) _buildLegend(),
      ],
    );
  }

  LineChartData _buildChartData() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final gridColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final coverTemp = _coverLineTemperature;

    return LineChartData(
      lineBarsData: [_buildLineBarData()],
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: coverTemp,
            color: AppColors.charcoal,
            strokeWidth: 1.5,
            dashArray: [6, 4],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.bottomRight,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.charcoal.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
        verticalLines: [
          if (_ovulationIndex != null)
            VerticalLine(
              x: _ovulationIndex!.toDouble(),
              color: AppColors.softGold,
              strokeWidth: 2,
              dashArray: [4, 3],
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topCenter,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.softGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: _bottomInterval,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= widget.dataPoints.length) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  'Day ${index + 1}',
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            getTitlesWidget: (value, meta) {
              if (value == meta.max || value == meta.min) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  '${value.toStringAsFixed(1)}°C',
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              );
            },
            interval: 0.5,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 0.5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: gridColor.withValues(alpha: 0.4),
          strokeWidth: 0.5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: gridColor.withValues(alpha: 0.2),
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
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) =>
              isDark ? AppColors.surfaceDark : AppColors.charcoal,
          tooltipRoundedRadius: AppRadius.sm,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.spotIndex;
              if (index < 0 || index >= widget.dataPoints.length) return null;
              final point = widget.dataPoints[index];
              return LineTooltipItem(
                '${DateFormat('MMM d').format(point.date)}\n${point.temperature.toStringAsFixed(1)}°C',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      minX: 0,
      maxX: (widget.dataPoints.length - 1).toDouble().clamp(0, double.infinity),
      minY: _minTemp,
      maxY: _maxTemp,
    );
  }

  LineChartBarData _buildLineBarData() {
    return LineChartBarData(
      spots: widget.dataPoints.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.temperature);
      }).toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: widget.lineColor,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          if (index < 0 || index >= widget.dataPoints.length) {
            return FlDotCirclePainter(radius: 3, color: widget.lineColor, strokeWidth: 0);
          }
          final point = widget.dataPoints[index];
          if (point.isEstimated) {
            return FlDotCirclePainter(
              radius: 3,
              color: Colors.transparent,
              strokeWidth: 1.5,
              strokeColor: widget.lineColor.withValues(alpha: 0.5),
            );
          }
          return FlDotCirclePainter(radius: 3, color: widget.lineColor, strokeWidth: 0);
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: widget.lineColor.withValues(alpha: 0.12),
      ),
    );
  }

  double get _bottomInterval {
    if (widget.dataPoints.length <= 7) return 1;
    if (widget.dataPoints.length <= 14) return 2;
    return (widget.dataPoints.length / 7).ceilToDouble();
  }

  Widget _buildLegend() {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Semantics(
        label: 'Chart legend',
        child: Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.center,
          children: [
            _legendDot(AppColors.softGold, 'Ovulation', muted),
            _legendDash(AppColors.charcoal, 'Cover line', muted),
            _legendDot(AppColors.charcoal.withValues(alpha: 0.5), 'Estimated', muted),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: TextStyle(fontSize: 11, color: textColor)),
      ],
    );
  }

  Widget _legendDash(Color color, String label, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 3,
          child: CustomPaint(
            painter: _DashPainter(color: color),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: TextStyle(fontSize: 11, color: textColor)),
      ],
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;

  _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const dashWidth = 4.0;
    const gapWidth = 3.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset((startX + dashWidth).clamp(0, size.width), size.height / 2),
        paint,
      );
      startX += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => oldDelegate.color != color;
}
