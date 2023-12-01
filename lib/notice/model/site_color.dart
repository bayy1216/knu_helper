import 'package:drift/drift.dart';

import '../../common/database/drift_database.dart';

class SiteColorModel {
  final String site;
  final String hexCode;

  SiteColorModel({
    required this.site,
    required this.hexCode,
  });

  SiteColorsCompanion toCompanion(){
    return SiteColorsCompanion(
      site: Value(site),
      hexCode: Value(hexCode),
    );
  }
}

class SiteColors extends Table {
  TextColumn get site => text()();

  TextColumn get hexCode => text()();

  @override
  Set<Column> get primaryKey => {site};
}
