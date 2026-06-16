import 'package:drift/drift.dart';
import 'cycle_days_table.dart';
import 'symptoms_table.dart';

class SymptomLogs extends Table {
  TextColumn get id => text()();
  TextColumn get cycleDayId => text().references(CycleDays, #id).nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get symptomId => text().references(Symptoms, #id)();
  IntColumn get severity => integer()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
