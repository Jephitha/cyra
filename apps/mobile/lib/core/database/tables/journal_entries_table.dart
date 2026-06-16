import 'package:drift/drift.dart';
import 'cycle_days_table.dart';

class JournalEntries extends Table {
  TextColumn get id => text()();
  TextColumn get cycleDayId => text().references(CycleDays, #id).nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get photoPaths => text().nullable()();
  TextColumn get voiceNotePath => text().nullable()();
  IntColumn get moodRating => integer().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
