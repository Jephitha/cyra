import 'dart:convert';
import 'dart:io';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/journal/models/journal_models.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

class JournalRepository {
  final db.AppDatabase _db;
  final EncryptionService _encryption;

  JournalRepository(this._db, this._encryption);

  // ── CRUD ──────────────────────────────────────────────────────

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    final now = DateTime.now();

    await _db.into(_db.journalEntries).insert(db.JournalEntriesCompanion.insert(
      id: entry.id,
      date: entry.date,
      title: entry.title != null
          ? Value(_encryption.encryptString(entry.title!))
          : Value.absent(),
      content: entry.content != null
          ? Value(_encryption.encryptString(entry.content!))
          : Value.absent(),
      photoPaths: entry.photoPaths.isNotEmpty
          ? Value(json.encode(entry.photoPaths))
          : Value.absent(),
      voiceNotePath: entry.voiceNotePaths.isNotEmpty
          ? Value(json.encode(entry.voiceNotePaths))
          : Value.absent(),
      moodRating: entry.moodRating > 0 ? Value(entry.moodRating) : Value.absent(),
      cycleDayId: entry.cycleDayId != null ? Value(entry.cycleDayId!) : Value.absent(),
      createdAt: now,
      updatedAt: now,
    ));

    return entry.copyWith(createdAt: now, updatedAt: now);
  }

  Future<JournalEntry> updateEntry(JournalEntry entry) async {
    final now = DateTime.now();

    await (_db.update(_db.journalEntries)
          ..where((t) => t.id.equals(entry.id)))
        .write(db.JournalEntriesCompanion(
      date: Value(entry.date),
      title: entry.title != null
          ? Value(_encryption.encryptString(entry.title!))
          : Value.absent(),
      content: entry.content != null
          ? Value(_encryption.encryptString(entry.content!))
          : Value.absent(),
      photoPaths: entry.photoPaths.isNotEmpty
          ? Value(json.encode(entry.photoPaths))
          : Value.absent(),
      voiceNotePath: entry.voiceNotePaths.isNotEmpty
          ? Value(json.encode(entry.voiceNotePaths))
          : Value.absent(),
      moodRating: entry.moodRating > 0 ? Value(entry.moodRating) : Value.absent(),
      cycleDayId: entry.cycleDayId != null ? Value(entry.cycleDayId!) : Value.absent(),
      updatedAt: Value(now),
    ));

    return entry.copyWith(updatedAt: now);
  }

  Future<JournalEntry?> getEntry(String id) async {
    final result = await (_db.select(_db.journalEntries)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomain(result);
  }

  Future<void> deleteEntry(String id) async {
    final entry = await getEntry(id);
    if (entry == null) return;

    await _deleteEntryFiles(entry);

    await (_db.delete(_db.journalEntries)
          ..where((t) => t.id.equals(id))).go();
  }

  // ── Queries ───────────────────────────────────────────────────

  Future<List<JournalEntry>> getEntriesByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _getEntriesInRange(start, end);
  }

  Future<List<JournalEntry>> getEntriesByDateRange(
      DateTime start, DateTime end) async {
    return _getEntriesInRange(start, end);
  }

  Future<List<JournalEntry>> getEntriesForCycle(String cycleDayId) async {
    final results = await (_db.select(_db.journalEntries)
          ..where((t) => t.cycleDayId.equals(cycleDayId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return results.map(_toDomain).toList();
  }

  Future<List<JournalEntry>> getRecentEntries({int limit = 20}) async {
    final results = await (_db.select(_db.journalEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .get();
    return results.map(_toDomain).toList();
  }

  Future<List<JournalEntry>> searchEntries(String query) async {
    final all = await (_db.select(_db.journalEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();

    final results = <JournalEntry>[];
    final lower = query.toLowerCase();

    for (final row in all) {
      final title = row.title != null ? _encryption.decryptString(row.title!) : '';
      final content =
          row.content != null ? _encryption.decryptString(row.content!) : '';

      if (title.toLowerCase().contains(lower) ||
          content.toLowerCase().contains(lower)) {
        results.add(_toDomain(row));
      }
    }

    return results;
  }

  // ── File management ───────────────────────────────────────────

  Future<void> _deleteEntryFiles(JournalEntry entry) async {
    for (final path in entry.photoPaths) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
    for (final path in entry.voiceNotePaths) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }

  Future<String> savePhotoFile(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${dir.path}/journal_photos');
    if (!await photoDir.exists()) await photoDir.create(recursive: true);

    final ext = sourcePath.split('.').last;
    final destPath =
        '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.$ext';
    final destFile = File(destPath);
    await destFile.writeAsBytes(await File(sourcePath).readAsBytes());

    final encryptedPath = '$destPath.encrypted';
    await _encryption.encryptFile(destFile, File(encryptedPath));
    await destFile.delete();

    return encryptedPath;
  }

  Future<File> getDecryptedPhoto(String encryptedPath) async {
    final tempDir = await getApplicationDocumentsDirectory();
    final tempFile = File(
        '${tempDir.path}/temp_photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final parent = tempFile.parent;
    if (!await parent.exists()) await parent.create(recursive: true);

    await _encryption.decryptFile(File(encryptedPath), tempFile);
    return tempFile;
  }

  Future<String> saveVoiceNoteFile(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final voiceDir = Directory('${dir.path}/journal_voice_notes');
    if (!await voiceDir.exists()) await voiceDir.create(recursive: true);

    final destPath =
        '${voiceDir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
    final destFile = File(destPath);
    await destFile.writeAsBytes(await File(sourcePath).readAsBytes());

    final encryptedPath = '$destPath.encrypted';
    await _encryption.encryptFile(destFile, File(encryptedPath));
    await destFile.delete();

    return encryptedPath;
  }

  Future<File> getDecryptedVoiceNote(String encryptedPath) async {
    final tempDir = await getApplicationDocumentsDirectory();
    final tempFile = File(
        '${tempDir.path}/temp_voice/${DateTime.now().millisecondsSinceEpoch}.m4a');
    final parent = tempFile.parent;
    if (!await parent.exists()) await parent.create(recursive: true);

    await _encryption.decryptFile(File(encryptedPath), tempFile);
    return tempFile;
  }

  Future<void> cleanupTempFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final tempPhotoDir = Directory('${dir.path}/temp_photos');
    final tempVoiceDir = Directory('${dir.path}/temp_voice');
    if (await tempPhotoDir.exists()) {
      await tempPhotoDir.delete(recursive: true);
    }
    if (await tempVoiceDir.exists()) {
      await tempVoiceDir.delete(recursive: true);
    }
  }

  // ── Mapping helpers ───────────────────────────────────────────

  JournalEntry _toDomain(db.JournalEntry entity) {
    return JournalEntry(
      id: entity.id,
      date: entity.date,
      title: entity.title != null ? _encryption.decryptString(entity.title!) : null,
      content: entity.content != null
          ? _encryption.decryptString(entity.content!)
          : null,
      photoPaths: entity.photoPaths != null
          ? (json.decode(entity.photoPaths!) as List<dynamic>)
              .cast<String>()
          : [],
      voiceNotePaths: entity.voiceNotePath != null
          ? (json.decode(entity.voiceNotePath!) as List<dynamic>)
              .cast<String>()
          : [],
      moodRating: entity.moodRating ?? 0,
      cycleDayId: entity.cycleDayId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }


  Future<List<JournalEntry>> _getEntriesInRange(
      DateTime start, DateTime end) async {
    final results = await (_db.select(_db.journalEntries)
          ..where((t) => t.date.isBetween(Variable(start), Variable(end)))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return results.map(_toDomain).toList();
  }
}
