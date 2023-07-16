import 'package:drift/drift.dart';

class SiteColorModel {
  final String site;
  final String hexCode;

  SiteColorModel({
    required this.site,
    required this.hexCode,
  });
}

class SiteColors extends Table {
  TextColumn get site => text()();

  TextColumn get hexCode => text()();

  @override
  Set<Column> get primaryKey => {site};
}
