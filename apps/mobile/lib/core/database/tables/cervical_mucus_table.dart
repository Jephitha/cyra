import 'package:drift/drift.dart';
import 'cycle_days_table.dart';

class CervicalMucusObservations extends Table {
  TextColumn get id => text()();
  TextColumn get cycleDayId => text().references(CycleDays, #id)();
  TextColumn get type => text()();
  TextColumn get consistency => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get amount => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
