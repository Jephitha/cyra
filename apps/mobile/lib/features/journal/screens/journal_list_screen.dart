import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/journal/models/journal_models.dart';
import 'package:cyra/features/journal/providers/journal_providers.dart';
import 'package:cyra/features/journal/screens/journal_entry_screen.dart';
import 'package:cyra/features/journal/screens/new_journal_entry_screen.dart';

final _listViewModeProvider = StateProvider<bool>((ref) => true);

final _searchQueryProvider = StateProvider<String>((ref) => '');

final _dateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isListView = ref.watch(_listViewModeProvider);
    final query = ref.watch(_searchQueryProvider);
    final dateRange = ref.watch(_dateRangeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final entriesAsync = query.isNotEmpty
        ? ref.watch(journalSearchResultsProvider(query))
        : dateRange != null
            ? ref.watch(
                journalEntriesByDateRangeProvider(dateRange.start, dateRange.end))
            : ref.watch(recentJournalEntriesProvider());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: Icon(
                isListView ? Icons.calendar_view_week_rounded : Icons.list_rounded),
            onPressed: () =>
                ref.read(_listViewModeProvider.notifier).state = !isListView,
            tooltip: isListView ? 'Calendar view' : 'List view',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context, ref, isDark),
          _buildFilterChips(context, ref, isDark, dateRange),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildErrorState(context, e.toString()),
              data: (entries) => entries.isEmpty
                  ? _buildEmptyState(context, ref, isDark)
                  : isListView
                      ? _buildListView(context, ref, entries, isDark)
                      : _buildCalendarView(context, ref, entries, isDark),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNewEntry(context, ref),
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, WidgetRef ref, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
      child: TextField(
        onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
        decoration: InputDecoration(
          hintText: 'Search journal entries...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: ref.watch(_searchQueryProvider).isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () =>
                      ref.read(_searchQueryProvider.notifier).state = '',
                )
              : null,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref, bool isDark,
      DateTimeRange? dateRange) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          ActionChip(
            avatar: const Icon(Icons.date_range_rounded, size: 16),
            label: Text(
              dateRange != null
                  ? '${DateFormat.MMMd().format(dateRange.start)} - ${DateFormat.MMMd().format(dateRange.end)}'
                  : 'Date range',
              style: const TextStyle(fontSize: 12),
            ),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
                lastDate: DateTime.now(),
                initialDateRange: dateRange,
              );
              if (picked != null) {
                ref.read(_dateRangeProvider.notifier).state = picked;
              }
            },
          ),
          if (dateRange != null) ...[
            const SizedBox(width: AppSpacing.sm),
            ActionChip(
              avatar: const Icon(Icons.clear_rounded, size: 16),
              label: const Text('Clear', style: TextStyle(fontSize: 12)),
              onPressed: () =>
                  ref.read(_dateRangeProvider.notifier).state = null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, WidgetRef ref,
      List<JournalEntry> entries, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final dateFormat = DateFormat('MMM d, yyyy');
        final displayTitle = entry.title ??
            (entry.content != null && entry.content!.isNotEmpty
                ? entry.content!.split('\n').first
                : null);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: AppCard.interactive(
            onTap: () => _navigateToEntry(context, ref, entry.id),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMoodIndicator(entry.moodRating),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(entry.date),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.slate,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      if (displayTitle != null)
                        Text(
                          displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.charcoal,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      if (entry.content != null && entry.content!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xxs),
                          child: Text(
                            entry.content!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.slate),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xs),
                      _buildMediaIndicators(entry),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20, color: AppColors.slate),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView(BuildContext context, WidgetRef ref,
      List<JournalEntry> entries, bool isDark) {
    final entryDates = entries.map((e) => e.date.startOfDay).toSet();
    final now = DateTime.now();
    final firstDay = now.subtract(const Duration(days: 90));
    final lastDay = now;

    return _JournalCalendar(
      entries: entries,
      entryDates: entryDates,
      firstDay: firstDay,
      lastDay: lastDay,
      onDaySelected: (date) {
        final dayEntries =
            entries.where((e) => e.date.isSameDay(date)).toList();
        if (dayEntries.length == 1) {
          _navigateToEntry(context, ref, dayEntries.first.id);
        } else if (dayEntries.isNotEmpty) {
          _showDayEntries(context, ref, date, dayEntries, isDark);
        }
      },
    );
  }

  void _showDayEntries(BuildContext context, WidgetRef ref, DateTime date,
      List<JournalEntry> entries, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            DateFormat('MMMM d, yyyy').format(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...entries.map((e) => ListTile(
                leading: _buildMoodIndicator(e.moodRating),
                title: Text(e.title ?? 'Journal Entry'),
                subtitle: Text(DateFormat('h:mm a').format(e.date)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  _navigateToEntry(context, ref, e.id);
                },
              )),
        ],
      ),
    );
  }

  void _navigateToEntry(BuildContext context, WidgetRef ref, String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => JournalEntryScreen(entryId: id)),
    );
  }

  void _navigateToNewEntry(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NewJournalEntryScreen()),
    );
  }

  Widget _buildMoodIndicator(int rating) {
    if (rating <= 0) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(Icons.tag_faces_outlined, size: 18, color: AppColors.slate),
      );
    }

    final emoji = _moodEmoji(rating);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _moodColor(rating).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildMediaIndicators(JournalEntry entry) {
    final children = <Widget>[];
    if (entry.photoPaths.isNotEmpty) {
      children.add(_mediaChip(
          Icons.photo_rounded, '${entry.photoPaths.length}', AppColors.sage));
    }
    if (entry.voiceNotePaths.isNotEmpty) {
      children.add(_mediaChip(
          Icons.mic_rounded, '${entry.voiceNotePaths.length}', AppColors.softGold));
    }
    if (children.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          children[i],
        ],
      ],
    );
  }

  Widget _mediaChip(IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(count,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, WidgetRef ref, bool isDark) {
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
              child: const Icon(Icons.article_outlined,
                  size: 40, color: AppColors.forestGreen),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Your journal is empty',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start writing about your health journey.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme.bodyMedium
                  ?.copyWith(color: AppColors.slate),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            AppButton.primary(
              'Write Your First Entry',
              icon: Icons.edit_rounded,
              onPressed: () => _navigateToNewEntry(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(error, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String _moodEmoji(int rating) {
    switch (rating) {
      case 1:
        return '\u{1F622}';
      case 2:
        return '\u{1F641}';
      case 3:
        return '\u{1F610}';
      case 4:
        return '\u{1F642}';
      case 5:
        return '\u{1F601}';
      default:
        return '';
    }
  }

  Color _moodColor(int rating) {
    switch (rating) {
      case 1:
        return AppColors.error;
      case 2:
        return const Color(0xFFE86B6B);
      case 3:
        return AppColors.softGold;
      case 4:
        return AppColors.sage;
      case 5:
        return AppColors.forestGreen;
      default:
        return AppColors.slate;
    }
  }
}

class _JournalCalendar extends StatefulWidget {
  final List<JournalEntry> entries;
  final Set<DateTime> entryDates;
  final DateTime firstDay;
  final DateTime lastDay;
  final void Function(DateTime date) onDaySelected;

  const _JournalCalendar({
    required this.entries,
    required this.entryDates,
    required this.firstDay,
    required this.lastDay,
    required this.onDaySelected,
  });

  @override
  State<_JournalCalendar> createState() => _JournalCalendarState();
}

class _JournalCalendarState extends State<_JournalCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysInMonth = _daysInMonth(_currentMonth.year, _currentMonth.month);
    final offset = _firstWeekdayOffset(_currentMonth.year, _currentMonth.month);

    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: AppSpacing.sm),
        _buildWeekdayHeaders(context),
        const SizedBox(height: AppSpacing.xs),
        _buildDaysGrid(context, daysInMonth, offset, isDark),
        const SizedBox(height: AppSpacing.md),
        if (widget.entries.isNotEmpty) _buildEntrySummary(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
            }),
          ),
          Text(monthName,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    const headers = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: headers.map((d) {
          return Expanded(
            child: Center(
              child: Text(d,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate,
                      )),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDaysGrid(
      BuildContext context, int daysInMonth, int offset, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: List.generate(((offset + daysInMonth) / 7).ceil(), (row) {
          return Row(
            children: List.generate(7, (col) {
              final cell = row * 7 + col;
              final day = cell - offset + 1;
              if (day < 1 || day > daysInMonth) {
                return const Expanded(child: SizedBox.shrink());
              }
              final date = DateTime(_currentMonth.year, _currentMonth.month, day);
              final hasEntry = widget.entryDates.any((d) =>
                  d.year == date.year &&
                  d.month == date.month &&
                  d.day == date.day);
              final isToday = _isToday(date);

              return Expanded(
                child: GestureDetector(
                  onTap: hasEntry ? () => widget.onDaySelected(date) : null,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hasEntry
                          ? AppColors.forestGreen.withValues(alpha: 0.12)
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isToday ? FontWeight.w700 : FontWeight.w400,
                        color: isToday
                            ? AppColors.forestGreen
                            : hasEntry
                                ? (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.charcoal)
                                : AppColors.slate,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildEntrySummary(BuildContext context, bool isDark) {
    final dateFormat = DateFormat('MMM d');
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: widget.entries.length,
        itemBuilder: (context, index) {
          final entry = widget.entries[index];
          return ListTile(
            dense: true,
            leading: Text(
              _moodEmoji(entry.moodRating),
              style: const TextStyle(fontSize: 20),
            ),
            title: Text(
              entry.title ?? 'Journal Entry',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            subtitle: Text(dateFormat.format(entry.date)),
            trailing: const Icon(Icons.chevron_right, size: 18),
            onTap: () => widget.onDaySelected(entry.date),
          );
        },
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) return 29;
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) return 30;
    return 31;
  }

  int _firstWeekdayOffset(int year, int month) {
    return DateTime(year, month, 1).weekday % 7;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _moodEmoji(int rating) {
    switch (rating) {
      case 1:
        return '\u{1F622}';
      case 2:
        return '\u{1F641}';
      case 3:
        return '\u{1F610}';
      case 4:
        return '\u{1F642}';
      case 5:
        return '\u{1F601}';
      default:
        return '\u{1F610}';
    }
  }
}

extension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
