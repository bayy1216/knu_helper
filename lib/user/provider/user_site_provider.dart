import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

final userSiteProvider = NotifierProvider<UserSiteStateNotifier,List<SiteColorModel>>(() {
  return UserSiteStateNotifier();
});

class UserSiteStateNotifier extends Notifier<List<SiteColorModel>> {

  @override
  List<SiteColorModel> build() {
    getSite();
    return [];
  }

  Future<void> getSite() async {

    final resp = await ref.watch(databaseProvider).getSiteColors();
    state = resp.map((e) => SiteColorModel(
      site: e.site,
      hexCode: e.hexCode,
    )).toList();
    print("GET SITE $resp");
  }

  Future<void> saveSite({required SiteColorModel model}) async {
    print('구독 : ${SiteEnum.getType[model.site]!.englishName}');
    await FirebaseMessaging.instance.subscribeToTopic(SiteEnum.getType[model.site]!.englishName);
    ref.watch(databaseProvider).createSiteColor(
      SiteColorsCompanion(
        site: Value(model.site),
        hexCode: Value(model.hexCode),
      ),
    );
    await getSite();
  }

  Future<void> deleteSite({required SiteColorModel model}) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(SiteEnum.getType[model.site]!.englishName);
    ref.watch(databaseProvider).deleteSiteColor(
      SiteColorsCompanion(
        site: Value(model.site),
        hexCode: Value(model.hexCode),
      ),
    );
    await getSite();
  }


}
