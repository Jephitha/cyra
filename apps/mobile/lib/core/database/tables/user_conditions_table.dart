import 'package:drift/drift.dart';

class UserConditions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get conditionType => text()();
  DateTimeColumn get diagnosisDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
