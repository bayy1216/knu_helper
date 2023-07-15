import 'package:drift/drift.dart';

class SiteColors extends Table{
  TextColumn get site => text()();

  TextColumn get hexCode => text()();
  @override
  Set<Column> get primaryKey => {site};
}