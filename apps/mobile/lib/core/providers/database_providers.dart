import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cyra/core/database/app_database.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}
