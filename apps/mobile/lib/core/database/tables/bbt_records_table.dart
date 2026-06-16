import 'package:drift/drift.dart';

class BbtRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get temperature => real()();
  TextColumn get measurementMethod => text()();
  TextColumn get timeOfDay => text()();
  BoolColumn get isEstimated => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
