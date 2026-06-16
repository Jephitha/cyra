import 'package:drift/drift.dart';
import 'cycles_table.dart';

class CycleDays extends Table {
  TextColumn get id => text()();
  TextColumn get cycleId => text().references(Cycles, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get flowIntensity => integer().nullable()();
  BoolColumn get spotting => boolean().withDefault(const Constant(false))();
  BoolColumn get clotting => boolean().withDefault(const Constant(false))();
  TextColumn get symptomsJson => text().nullable()();
  RealColumn get temperature => real().nullable()();
  TextColumn get cervicalMucus => text().nullable()();
  TextColumn get cervicalPosition => text().nullable()();
  TextColumn get opkResult => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
