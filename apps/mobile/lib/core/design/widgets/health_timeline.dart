import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';

enum TimelineEntryType { period, ovulation, symptom, pregnancy, journal, fertility }

class TimelineEntry {
  final DateTime date;
  final String title;
  final String? description;
  final IconData? icon;
  final Color? color;
  final TimelineEntryType type;
  final VoidCallback? onTap;

  const TimelineEntry({
    required this.date,
    required this.title,
    this.description,
    this.icon,
    this.color,
    required this.type,
    this.onTap,
  });
}

class HealthTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  final bool horizontal;
  final double dotRadius;

  const HealthTimeline({
    super.key,
    required this.entries,
    this.horizontal = false,
    this.dotRadius = 8,
  });

  Color _defaultColorForType(TimelineEntryType type) {
    switch (type) {
      case TimelineEntryType.period:
        return AppColors.error;
      case TimelineEntryType.ovulation:
        return AppColors.softGold;
      case TimelineEntryType.symptom:
        return AppColors.sage;
      case TimelineEntryType.pregnancy:
        return AppColors.timelineJournal;
      case TimelineEntryType.journal:
        return AppColors.slate;
      case TimelineEntryType.fertility:
        return AppColors.forestGreen;
    }
  }

  IconData _defaultIconForType(TimelineEntryType type) {
    switch (type) {
      case TimelineEntryType.period:
        return Icons.water_drop;
      case TimelineEntryType.ovulation:
        return Icons.circle_outlined;
      case TimelineEntryType.symptom:
        return Icons.healing_outlined;
      case TimelineEntryType.pregnancy:
        return Icons.favorite_outlined;
      case TimelineEntryType.journal:
        return Icons.article_outlined;
      case TimelineEntryType.fertility:
        return Icons.schedule_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Semantics(
        label: 'Empty timeline',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timeline_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No entries yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return horizontal ? _buildHorizontal(context) : _buildVertical(context);
  }

  Widget _buildVertical(BuildContext context) {
    final sorted = List<TimelineEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Semantics(
      label: 'Health timeline',
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final entry = sorted[index];
          final isLast = index == sorted.length - 1;
          return _VerticalTimelineItem(
            entry: entry,
            isLast: isLast,
            dotRadius: dotRadius,
            defaultColor: entry.color ?? _defaultColorForType(entry.type),
            defaultIcon: entry.icon ?? _defaultIconForType(entry.type),
          );
        },
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    final sorted = List<TimelineEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Semantics(
      label: 'Health timeline',
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sorted.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
          itemBuilder: (context, index) {
            final entry = sorted[index];
            return _HorizontalTimelineItem(
              entry: entry,
              dotRadius: dotRadius,
              defaultColor: entry.color ?? _defaultColorForType(entry.type),
              defaultIcon: entry.icon ?? _defaultIconForType(entry.type),
            );
          },
        ),
      ),
    );
  }
}

class _VerticalTimelineItem extends StatelessWidget {
  final TimelineEntry entry;
  final bool isLast;
  final double dotRadius;
  final Color defaultColor;
  final IconData defaultIcon;

  const _VerticalTimelineItem({
    required this.entry,
    required this.isLast,
    required this.dotRadius,
    required this.defaultColor,
    required this.defaultIcon,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(entry.date);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: dotRadius * 4,
            child: Column(
              children: [
                SizedBox(height: dotRadius),
                _TimelineDot(
                  radius: dotRadius,
                  color: defaultColor,
                  icon: defaultIcon,
                  onTap: entry.onTap,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: defaultColor.withValues(alpha: 0.25),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Semantics(
                label: '${entry.type.name} entry: ${entry.title}',
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: entry.onTap,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateStr,
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            entry.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: textColor,
                            ),
                          ),
                          if (entry.description != null) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              entry.description!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalTimelineItem extends StatelessWidget {
  final TimelineEntry entry;
  final double dotRadius;
  final Color defaultColor;
  final IconData defaultIcon;

  const _HorizontalTimelineItem({
    required this.entry,
    required this.dotRadius,
    required this.defaultColor,
    required this.defaultIcon,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d').format(entry.date);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Semantics(
      label: '${entry.type.name} entry: ${entry.title}',
      child: GestureDetector(
        onTap: entry.onTap,
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _TimelineDot(
                radius: dotRadius,
                color: defaultColor,
                icon: defaultIcon,
                onTap: entry.onTap,
              ),
              const SizedBox(height: AppSpacing.xs),
              Flexible(
                child: Text(
                  entry.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (entry.description != null)
                Flexible(
                  child: Text(
                    entry.description!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final double radius;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _TimelineDot({
    required this.radius,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Timeline dot',
      child: Container(
        width: radius * 2 + 4,
        height: radius * 2 + 4,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: radius * 1.2,
                color: AppColors.onBrand,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
