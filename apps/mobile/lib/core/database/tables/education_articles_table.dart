import 'package:drift/drift.dart';

class EducationArticles extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get category => text()();
  TextColumn get summary => text().nullable()();
  BoolColumn get isOfflineAvailable =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get medicalReviewDate => dateTime().nullable()();
  TextColumn get reviewAuthor => text().nullable()();
  IntColumn get readTimeMinutes => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
