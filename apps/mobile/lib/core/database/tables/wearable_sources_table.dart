import 'package:drift/drift.dart';

class WearableSources extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sourceType => text()();
  BoolColumn get isConnected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get settingsJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
