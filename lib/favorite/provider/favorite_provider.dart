import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/favorite/repository/favorite_repository.dart';

import '../../notice/model/response/notice_model.dart';

final favoriteStreamProvider = StreamNotifierProvider<FavoriteNotifier, List<NoticeModel>>(FavoriteNotifier.new);

/// 즐겨찾기를 위한 [StreamNotifier] <p>
/// 즐겨찾기 공지사항을 Stream을 통해 받아온다.
/// CRUD를 지원한다.
class FavoriteNotifier extends StreamNotifier<List<NoticeModel>> {
  late final FavoriteRepository _repository = ref.read(favoriteRepositoryProvider);
  @override
  Stream<List<NoticeModel>> build() {
    return _repository.watchFavorite();
  }

  Future<void> starClick({required NoticeModel model, required bool isDelete}) async {
    if (isDelete) {
      await deleteFavorite(model: model);
    } else {
      await saveFavorite(model: model);
    }
  }

  Future<void> saveFavorite({required NoticeModel model}) async {
    final resp = await _repository.saveFavorite(model: model);
  }

  Future<void> deleteFavorite({required NoticeModel model}) async {
    final resp = await _repository.deleteFavorite(model: model);
  }

  Future<bool> isFavorite({required int id})async{
    final f = await future;
    return f.any((element) => element.id == id);
  }
}