import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/bbt_chart.dart';

class _FertilityChartMarker {
  final DateTime date;
  final _MarkerType type;
  final String? label;
  const _FertilityChartMarker({
    required this.date,
    required this.type,
    this.label,
  });
}

enum _MarkerType { opkPositive, opkNegative, intercourse, mucus }

enum _TimeRange { thisCycle, last3Months, custom }

class FertilityChartScreen extends StatefulWidget {
  const FertilityChartScreen({super.key});

  @override
  State<FertilityChartScreen> createState() => _FertilityChartScreenState();
}

class _FertilityChartScreenState extends State<FertilityChartScreen> {
  _TimeRange _selectedRange = _TimeRange.thisCycle;

  final List<BBTDataPoint> _bbtData = [
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
    BBTDataPoint(date: DateTime(2026, 3, 15), temperature: 36.9),
    BBTDataPoint(date: DateTime(2026, 3, 16), temperature: 36.8),
    BBTDataPoint(date: DateTime(2026, 3, 17), temperature: 36.7),
  ];

  final DateTime _ovulationDate = DateTime(2026, 3, 12);
  final double _coverLine = 36.6;

  final List<_FertilityChartMarker> _markers = [
    _FertilityChartMarker(
      date: DateTime(2026, 3, 8),
      type: _MarkerType.opkPositive,
      label: 'OPK+',
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 9),
      type: _MarkerType.opkPositive,
      label: 'OPK+',
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 10),
      type: _MarkerType.opkNegative,
      label: 'OPK-',
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 7),
      type: _MarkerType.intercourse,
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 9),
      type: _MarkerType.intercourse,
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 12),
      type: _MarkerType.intercourse,
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 5),
      type: _MarkerType.mucus,
      label: 'Sticky',
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 7),
      type: _MarkerType.mucus,
      label: 'Creamy',
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 9),
      type: _MarkerType.mucus,
      label: 'Egg White',
    ),
    _FertilityChartMarker(
      date: DateTime(2026, 3, 11),
      type: _MarkerType.mucus,
      label: 'Watery',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fertility Chart',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildTimeRangeSelector(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          AppCard.chart(
            title: 'Basal Body Temperature',
            child: Column(
              children: [
                BBTChart(
                  dataPoints: _bbtData,
                  height: 220,
                  coverLineTemperature: _coverLine,
                  ovulationDate: _ovulationDate,
                  showLegend: false,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildChartOverlay(context, isDark),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildMarkersSection(context, isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildLegend(context, isDark),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _TimeRange.values.map((range) {
          final isSelected = _selectedRange == range;
          String label;
          switch (range) {
            case _TimeRange.thisCycle:
              label = 'This Cycle';
            case _TimeRange.last3Months:
              label = 'Last 3 Months';
            case _TimeRange.custom:
              label = 'Custom';
          }
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.forestGreen.withValues(alpha: isDark ? 0.3 : 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.forestGreen
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.forestGreen)
                        : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartOverlay(BuildContext context, bool isDark) {
    return SizedBox(
      height: 30,
      child: CustomPaint(
        painter: _FertileWindowOverlayPainter(
          dataLength: _bbtData.length,
          fertileStart: 7,
          fertileEnd: 13,
          ovulationDay: 11,
          isDark: isDark,
        ),
        size: Size(MediaQuery.of(context).size.width - 64, 30),
      ),
    );
  }

  Widget _buildMarkersSection(BuildContext context, bool isDark) {
    final opkMarkers = _markers.where((m) =>
        m.type == _MarkerType.opkPositive || m.type == _MarkerType.opkNegative);
    final intercourseMarkers = _markers.where((m) => m.type == _MarkerType.intercourse);
    final mucusMarkers = _markers.where((m) => m.type == _MarkerType.mucus);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.push_pin_outlined, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Markers',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildMarkerGroup(
            context,
            'OPK Results',
            Icons.science_outlined,
            AppColors.forestGreen,
            opkMarkers,
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMarkerGroup(
            context,
            'Intercourse',
            Icons.favorite_outlined,
            const Color(0xFFE86B6B),
            intercourseMarkers,
            isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMarkerGroup(
            context,
            'Cervical Mucus',
            Icons.blur_circular_rounded,
            AppColors.softGold,
            mucusMarkers,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerGroup(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Iterable<_FertilityChartMarker> markers,
    bool isDark,
  ) {
    if (markers.isEmpty) {
      return Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'No $label logged',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: markers.map((marker) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (marker.type == _MarkerType.opkPositive)
                    Icon(Icons.check_circle, size: 14, color: AppColors.forestGreen)
                  else if (marker.type == _MarkerType.opkNegative)
                    Icon(Icons.remove_circle, size: 14, color: AppColors.slate)
                  else if (marker.type == _MarkerType.intercourse)
                    Icon(Icons.favorite, size: 14, color: const Color(0xFFE86B6B))
                  else
                    Icon(Icons.blur_on_rounded, size: 14, color: AppColors.softGold),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    DateFormat('MMM d').format(marker.date),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (marker.label != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '· ${marker.label}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.2) : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _legendItem(context, Container(
                width: 12, height: 12,
                decoration: const BoxDecoration(color: AppColors.forestGreen, shape: BoxShape.circle),
              ), 'BBT Reading'),
              _legendItem(context, Container(
                width: 24, height: 3,
                decoration: BoxDecoration(color: AppColors.charcoal, borderRadius: BorderRadius.circular(2)),
              ), 'Cover Line'),
              _legendItem(context, Container(
                width: 12, height: 12,
                decoration: BoxDecoration(color: AppColors.softGold, shape: BoxShape.circle),
              ), 'Ovulation'),
              _legendItem(context, Container(
                width: 12, height: 12,
                decoration: BoxDecoration(color: AppColors.forestGreenLight, shape: BoxShape.circle),
              ), 'Fertile Window'),
              _legendItem(context, Icon(Icons.check_circle, size: 14, color: AppColors.forestGreen), 'OPK+'),
              _legendItem(context, Icon(Icons.remove_circle, size: 14, color: AppColors.slate), 'OPK-'),
              _legendItem(context, Icon(Icons.favorite, size: 14, color: const Color(0xFFE86B6B)), 'Intercourse'),
              _legendItem(context, Icon(Icons.blur_on_rounded, size: 14, color: AppColors.softGold), 'Mucus'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, Widget icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }
}

class _FertileWindowOverlayPainter extends CustomPainter {
  final int dataLength;
  final int fertileStart;
  final int fertileEnd;
  final int ovulationDay;
  final bool isDark;

  _FertileWindowOverlayPainter({
    required this.dataLength,
    required this.fertileStart,
    required this.fertileEnd,
    required this.ovulationDay,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataLength == 0) return;

    final cellWidth = size.width / dataLength;

    for (int day = 1; day <= dataLength; day++) {
      final x = (day - 1) * cellWidth;

      if (day >= fertileStart && day <= fertileEnd) {
        final paint = Paint()
          ..color = AppColors.forestGreenLight.withValues(alpha: isDark ? 0.2 : 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawRect(
          Rect.fromLTWH(x, 0, cellWidth, size.height),
          paint,
        );
      }

      if (day == ovulationDay) {
        final paint = Paint()
          ..color = AppColors.softGold.withValues(alpha: isDark ? 0.4 : 0.5)
          ..style = PaintingStyle.fill;
        canvas.drawRect(
          Rect.fromLTWH(x, 0, cellWidth, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FertileWindowOverlayPainter oldDelegate) =>
      oldDelegate.dataLength != dataLength ||
      oldDelegate.fertileStart != fertileStart ||
      oldDelegate.fertileEnd != fertileEnd ||
      oldDelegate.ovulationDay != ovulationDay;
}
