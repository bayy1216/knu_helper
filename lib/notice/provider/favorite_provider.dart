import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

final favoriteProvider = NotifierProvider<FavoriteNotifier, List<NoticeModel>>(FavoriteNotifier.new);

class FavoriteNotifier extends Notifier<List<NoticeModel>>{
  late final LocalDatabase localDatabase;
  @override
  List<NoticeModel> build() {
    localDatabase = ref.watch(databaseProvider);
    return [];
  }
  getFavorite()async{
    final resp = await localDatabase.getNotices();
    state = resp.map(
      (e) => NoticeModel(
        id: e.id,
        content: e.content,
        title: e.title,
        site: e.site,
        type: e.type,
        url: e.url,
        views: e.views,
        day: e.day,
      ),
    ).toList();
  }

}