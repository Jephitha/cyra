import 'package:drift/drift.dart';

class AppSettings extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
