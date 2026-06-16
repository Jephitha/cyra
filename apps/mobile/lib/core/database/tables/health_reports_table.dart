import 'package:drift/drift.dart';

class HealthReports extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get reportType => text()();
  DateTimeColumn get dateRangeStart => dateTime()();
  DateTimeColumn get dateRangeEnd => dateTime()();
  TextColumn get filePath => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
