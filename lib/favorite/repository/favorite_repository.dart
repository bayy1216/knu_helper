import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/database/drift_database.dart';
import '../../notice/model/response/notice_model.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FavoriteRepository(localDatabase: db);
});

class FavoriteRepository{
  final LocalDatabase localDatabase;

  FavoriteRepository({required this.localDatabase});
  Future<List<NoticeModel>> getFavorite() async {
    final resp = await localDatabase.getNoticeEntities();
    return resp.map((e) => NoticeModel.fromEntity(e)).toList();
  }
  Future<int> saveFavorite({required NoticeModel model}) async {
    final data = model.toCompanion();
    return localDatabase.insertNoticeEntity(data);
  }
  Future<int> deleteFavorite({required NoticeModel model}) async {
    final data = model.toCompanion();
    return localDatabase.deleteNoticeEntity(data);
  }

  Stream <List<NoticeModel>> watchFavorite() {
    return localDatabase.watchNoticeEntities().map((event) => event.map((e) => NoticeModel.fromEntity(e)).toList());
  }

}