import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/database/drift_database.dart';
import '../../notice/model/notice_model.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FavoriteRepository(localDatabase: db);
});

class FavoriteRepository{
  final LocalDatabase localDatabase;

  FavoriteRepository({required this.localDatabase});
  Future<List<NoticeModel>> getFavorite() async {
    final resp = await localDatabase.getNotices();
    return resp.map((e) => NoticeModel.fromNotice(e)).toList();
  }
  Future<void> saveFavorite({required NoticeModel model}) async {
    final data = model.toCompanion();
    await localDatabase.insertNotice(data);
  }
  Future<void> deleteFavorite({required NoticeModel model}) async {
    final data = model.toCompanion();
    await localDatabase.deleteNotice(data);
  }
}