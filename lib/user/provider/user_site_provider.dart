import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

final userSiteProvider = StateNotifierProvider<UserSiteStateNotifier,List<SiteColorModel>>((ref) {
  final db = ref.watch(databaseProvider);
  return UserSiteStateNotifier(database: db);
});

class UserSiteStateNotifier extends StateNotifier<List<SiteColorModel>> {
  final LocalDatabase database;

  UserSiteStateNotifier({required this.database}) : super([]) {
    getSite();
  }

  Future<void> getSite() async {
    final resp = await database.getSiteColors();
    state = resp
        .map((e) => SiteColorModel(
              site: e.site,
              hexCode: e.hexCode,
            ))
        .toList();
  }

  Future<void> saveSite({required SiteColorModel model}) async {
    print('구독 : ${SiteEnum.getType[model.site]!.englishName}');
    await FirebaseMessaging.instance.subscribeToTopic(SiteEnum.getType[model.site]!.englishName);
    database.createSiteColor(
      SiteColorsCompanion(
        site: Value(model.site),
        hexCode: Value(model.hexCode),
      ),
    );
    await getSite();
  }

  Future<void> deleteSite({required SiteColorModel model}) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(SiteEnum.getType[model.site]!.englishName);
    database.deleteSiteColor(
      SiteColorsCompanion(
        site: Value(model.site),
        hexCode: Value(model.hexCode),
      ),
    );
    await getSite();
  }

}
