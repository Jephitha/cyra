import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables/cycles_table.dart';
import 'tables/cycle_days_table.dart';
import 'tables/symptoms_table.dart';
import 'tables/symptom_logs_table.dart';
import 'tables/bbt_records_table.dart';
import 'tables/ovulation_tests_table.dart';
import 'tables/cervical_mucus_table.dart';
import 'tables/pregnancies_table.dart';
import 'tables/fetal_measurements_table.dart';
import 'tables/journal_entries_table.dart';
import 'tables/user_conditions_table.dart';
import 'tables/wearable_sources_table.dart';
import 'tables/education_articles_table.dart';
import 'tables/community_posts_table.dart';
import 'tables/health_reports_table.dart';
import 'tables/app_settings_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Cycles,
  CycleDays,
  Symptoms,
  SymptomLogs,
  BbtRecords,
  OvulationTests,
  CervicalMucusObservations,
  Pregnancies,
  FetalMeasurements,
  JournalEntries,
  UserConditions,
  WearableSources,
  EducationArticles,
  CommunityPosts,
  HealthReports,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
      : super(executor ?? _openConnection());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'cyra.db'));
      return NativeDatabase(file);
    });
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}
