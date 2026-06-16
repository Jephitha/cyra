import 'package:drift/drift.dart';

class Symptoms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get iconName => text()();
  TextColumn get colorHex => text()();
  TextColumn get predefinedOptions => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
