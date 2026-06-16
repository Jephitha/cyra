import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/journal/models/journal_models.dart';
import 'package:cyra/features/journal/repositories/journal_repository.dart';

part 'journal_providers.g.dart';

@Riverpod(keepAlive: true)
JournalRepository journalRepository(JournalRepositoryRef ref) {
  return JournalRepository(
    ref.watch(db.appDatabaseProvider),
    ref.watch(encryptionServiceProvider),
  );
}

@riverpod
Future<List<JournalEntry>> recentJournalEntries(RecentJournalEntriesRef ref,
    {int limit = 20}) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getRecentEntries(limit: limit);
}

@riverpod
Future<List<JournalEntry>> journalEntriesByDateRange(
    JournalEntriesByDateRangeRef ref,
    DateTime start,
    DateTime end) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getEntriesByDateRange(start, end);
}

@riverpod
Future<JournalEntry?> journalEntry(JournalEntryRef ref, String id) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getEntry(id);
}

@riverpod
Future<List<JournalEntry>> journalEntriesForCycle(
    JournalEntriesForCycleRef ref, String cycleDayId) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getEntriesForCycle(cycleDayId);
}

@riverpod
Future<List<JournalEntry>> journalSearchResults(
    JournalSearchResultsRef ref, String query) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.searchEntries(query);
}

@riverpod
class JournalWriter extends _$JournalWriter {
  @override
  Future<void> build() => Future.value();

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    final repo = ref.read(journalRepositoryProvider);
    final created = await repo.createEntry(entry);
    ref.invalidate(recentJournalEntriesProvider);
    return created;
  }

  Future<JournalEntry> updateEntry(JournalEntry entry) async {
    final repo = ref.read(journalRepositoryProvider);
    final updated = await repo.updateEntry(entry);
    ref.invalidate(recentJournalEntriesProvider);
    ref.invalidate(journalEntryProvider(entry.id));
    return updated;
  }

  Future<void> deleteEntry(String id) async {
    final repo = ref.read(journalRepositoryProvider);
    await repo.deleteEntry(id);
    ref.invalidate(recentJournalEntriesProvider);
  }
}
