import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

final databaseProvider = Provider<LocalDatabase>((ref) => LocalDatabase());

@DriftDatabase(tables: [
  SiteColors,
  Notices,
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createNotice(NoticesCompanion data) => into(notices).insert(data);

  Future<int> createSiteColor(SiteColorsCompanion data) =>
      into(siteColors).insert(data);

  Future<List<SiteColor>> getSiteColors() => select(siteColors).get();

  Future<int> updateSiteColor(String hexCode, String site) =>
      (update(siteColors)..where((tbl) => tbl.site.equals(site)))
          .write(SiteColorsCompanion(site: Value(site),hexCode: Value(hexCode)));

  Stream<List<Notice>> watchNotices() => select(notices).watch();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
