import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../notice/model/notice_entity.dart';
import '../../notice/model/notice_model_deprecated.dart';

part 'drift_database.g.dart';

final databaseProvider = Provider<LocalDatabase>((ref) => LocalDatabase());

@DriftDatabase(tables: [
  NoticeEntities,
  Notices,
],)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // notice entity deprecated
  @Deprecated('firebase에서 server로 데이터 유형을 변경함')
  Future<int> insertNotice(NoticesCompanion data) {
    return into(notices).insert(data);
  }

  @Deprecated('firebase에서 server로 데이터 유형을 변경함')
  Future<int> deleteNotice(NoticesCompanion data) {
    return delete(notices).delete(data);
  }

  @Deprecated('firebase에서 server로 데이터 유형을 변경함')
  Future<bool> isIn({required String id})async{
    final x = await (select(notices)..where((tbl) => tbl.id.equals(id))).get();
    return x.isNotEmpty;
  }

  @Deprecated('firebase에서 server로 데이터 유형을 변경함')
  Future<List<Notice>> getNotices() => select(notices).get();

  @Deprecated('firebase에서 server로 데이터 유형을 변경함')
  Stream<List<Notice>> watchNotices() => select(notices).watch();

  // notice entity 신규
  Future<List<NoticeEntity>> getNoticeEntities() => select(noticeEntities).get();
  Future<int> insertNoticeEntity(NoticeEntitiesCompanion data) {
    return into(noticeEntities).insert(data);
  }
  Future<int> deleteNoticeEntity(NoticeEntitiesCompanion data) {
    return delete(noticeEntities).delete(data);
  }
  Stream<List<NoticeEntity>> watchNoticeEntities() => select(noticeEntities).watch();

  @override
  int get schemaVersion => 2;


  @override
  MigrationStrategy get migration{
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from == 1) {
          final noticeList = await select(notices).get();
          await m.createTable(noticeEntities);
          for (var e in noticeList) {
            final minusId = e.id.hashCode > 0 ? e.id.hashCode : e.id.hashCode * -1;
            final entity = NoticeEntitiesCompanion(
              id: Value(minusId),
              title: Value(e.title),
              site: Value(e.site),
              type: Value(e.type),
              url: Value(e.url),
              views: Value(e.views),
              day: Value(e.day),
            );
            try{
              await insertNoticeEntity(entity);
            }catch(e){}
          }
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
