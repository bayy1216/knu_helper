import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/favorite/repository/favorite_repository.dart';

import 'package:knu_helper/notice/model/notice_model_deprecated.dart';

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
