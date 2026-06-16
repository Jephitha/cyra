import 'package:drift/drift.dart';

class Pregnancies extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get conceptionDate => dateTime().nullable()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get currentWeek => integer()();
  IntColumn get currentTrimester => integer()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
