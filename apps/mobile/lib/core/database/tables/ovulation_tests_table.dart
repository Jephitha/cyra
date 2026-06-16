import 'package:drift/drift.dart';

class OvulationTests extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get result => text()();
  TextColumn get timeOfDay => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
