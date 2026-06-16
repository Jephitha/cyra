import 'package:drift/drift.dart';

class CommunityPosts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get topicId => text()();
  TextColumn get content => text()();
  BoolColumn get isAnonymous => boolean().withDefault(const Constant(true))();
  BoolColumn get isModerated => boolean().withDefault(const Constant(false))();
  TextColumn get moderationAction => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
