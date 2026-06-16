import 'package:drift/drift.dart';
import 'pregnancies_table.dart';

class FetalMeasurements extends Table {
  TextColumn get id => text()();
  TextColumn get pregnancyId => text().references(Pregnancies, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get weight => real().nullable()();
  IntColumn get bloodPressureSystolic => integer().nullable()();
  IntColumn get bloodPressureDiastolic => integer().nullable()();
  RealColumn get glucoseLevel => real().nullable()();
  IntColumn get kicksCount => integer().nullable()();
  TextColumn get contractionsJson => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
