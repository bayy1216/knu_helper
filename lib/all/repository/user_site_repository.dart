import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/database/drift_database.dart';
import '../../notice/model/site_color.dart';
import '../../notice/model/site_enum.dart';

final userSiteRepositoryProvider = Provider<UserSiteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return UserSiteRepository(database: db);
});

class UserSiteRepository {
  final LocalDatabase database;

  UserSiteRepository({
    required this.database,
  });


  Future<List<SiteColorModel>> getSite() async {
    final resp = await database.getSiteColors();
    final sites = resp
        .map((e) => SiteColorModel(
      site: e.site,
      hexCode: e.hexCode,
    )).toList();

    return sites;
  }

  Future<void> saveSite({required SiteColorModel model}) async {
    await FirebaseMessaging.instance.subscribeToTopic(SiteEnum.getType[model.site]!.englishName);
    database.createSiteColor(model.toCompanion());
  }

  Future<void> deleteSite({required SiteColorModel model}) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(SiteEnum.getType[model.site]!.englishName);
    database.deleteSiteColor(model.toCompanion());
  }
}
