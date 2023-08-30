import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/favorite/repository/favorite_repository.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteStateNotifier, List<NoticeModel>>((ref) {
  final repo = ref.watch(favoriteRepositoryProvider);
  return FavoriteStateNotifier(repository: repo);
});

class FavoriteStateNotifier extends StateNotifier<List<NoticeModel>> {
  final FavoriteRepository repository;

  FavoriteStateNotifier({required this.repository}) : super([]);

  getFavorite() async {
    final resp = await repository.getFavorite();
    state = resp;
  }
}
