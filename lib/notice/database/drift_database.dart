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

  Future<int> insertNotice(NoticeModel model) {
    final data = NoticesCompanion(
      url: Value(model.url),
      site: Value(model.site),
      content: Value(model.content),
      title: Value(model.title),
      day: Value(model.day),
      views: Value(model.views),
      type: Value(model.type),
      id: Value(model.id),
    );
    return into(notices).insert(data);
  }

  Future<int> deleteNotice(NoticeModel model) {
    final data = NoticesCompanion(
      url: Value(model.url),
      site: Value(model.site),
      content: Value(model.content),
      title: Value(model.title),
      day: Value(model.day),
      views: Value(model.views),
      type: Value(model.type),
      id: Value(model.id),
    );
    return delete(notices).delete(data);
  }

  Future<bool> isIn({required String id})async{
    final x = await (select(notices)..where((tbl) => tbl.id.equals(id))).get();
    return x.isNotEmpty;
  }



  Future<int> createSiteColor(SiteColorModel model) async {
    final data = SiteColorsCompanion(
      site: Value(model.site),
      hexCode: Value(model.hexCode),
    );
    try {
      final result = await into(siteColors).insert(data);
      return result;
    } catch (e) {
      updateSiteColor(data);
      print('업데이트');
      return 0; // 또는 다른 값을 반환하거나 예외 상황을 나타내는 값으로 지정
    }
  }

  Future<int> deleteSiteColor(SiteColorModel model) async {
    final data = SiteColorsCompanion(
      site: Value(model.site),
      hexCode: Value(model.hexCode),
    );
    try {
      final result = await delete(siteColors).delete(data);
      return result;
    } catch (e) {
      // 예외 처리
      print('오류 발생: $e');
      return 0; // 또는 다른 값을 반환하거나 예외 상황을 나타내는 값으로 지정
    }
  }

  Future<List<Notice>> getNotices() => select(notices).get();

  Future<List<SiteColor>> getSiteColors() => select(siteColors).get();

  Future<String> getColorOfSite({required String siteName})async{
    final x = await (select(siteColors)..where((tbl) => tbl.site.equals(siteName))).get();
    return x.first.hexCode;
  }

  Future<int> updateSiteColor(SiteColorsCompanion data) =>
      (update(siteColors)..where((tbl) => tbl.site.equals(data.site.value)))
          .write(data);

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
