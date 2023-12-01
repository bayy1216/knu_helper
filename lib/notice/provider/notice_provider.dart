import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/favorite/repository/favorite_repository.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

import '../../all/provider/user_site_provider.dart';
import '../../common/database/drift_database.dart';

final noticeProvider =
    StateNotifierProvider<NoticeStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(noticeRepositoryProvider);
  final favoriteRepo = ref.watch(favoriteRepositoryProvider);
  final siteList = ref.watch(userSiteProvider);
  return NoticeStateNotifier(
    repository: repo,
    favoriteRepository: favoriteRepo,
    siteList: siteList,
  );
});

class NoticeStateNotifier extends StateNotifier<CursorPaginationBase> {
  final NoticeRepository repository;
  final FavoriteRepository favoriteRepository;
  final List<SiteColorModel> siteList;

  NoticeStateNotifier({
    required this.repository,
    required this.favoriteRepository,
    required this.siteList,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  toggleStar({required NoticeModel model, required bool value}) {
    final pState = state as CursorPagination<NoticeModel>;
    int idx = pState.data.indexWhere((element) => element.id == model.id);
    if (idx == -1) return;

    pState.isFavorite![idx] = !value;
    final s = pState.copyWith(isFavorite: [...pState.isFavorite!]);
    if (value) {//즐겨찾기에 삭제
      favoriteRepository.deleteFavorite(model: model);
    } else {//즐겨찾기에서 추가
      favoriteRepository.saveFavorite(model: model);
    }
    print('누름 $idx, $value');
    state = s;
  }

  updateToEnd() {
    final pState = state as CursorPagination<NoticeModel>;
    state =
        CursorPaginationEnd(data: pState.data, isFavorite: pState.isFavorite);
  }

  Future<bool> searchNotice() async {
    if (state is CursorPaginationEnd) {
      return true;
    }
    final resp = await repository.searchNotice(
      siteList: siteList.map((e) => e.site).toList(),
    );
    print(resp.length);
    final List<bool> isFavorite = [];
    for (var e in resp) {
      final isIn = await favoriteRepository.isIn(id: e.id);
      isFavorite.add(isIn);
    }
    state = CursorPaginationEnd(data: [...resp], isFavorite: [...isFavorite]);
    return true;
  }

  Future<int> paginate({
    //-1 진행중,에러 /  0 이상 응답받은 데이터갯수
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is CursorPaginationEnd) {
        return -1;
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationRefetchingMore;
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return -1;
      }

      final limit = (state is CursorPagination)
          ? (state as CursorPagination).data.length + 10
          : 10;
      if (fetchMore) {
        //기존에 있는 상황
        final pState = state as CursorPagination<NoticeModel>;
        state = CursorPaginationRefetchingMore<NoticeModel>(
          data: pState.data,
          isFavorite: pState.isFavorite,
        );
      } else {
        //데이터처음부터 가져오는 상황
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<NoticeModel>;
          state = CursorPaginationRefetching<NoticeModel>(
            data: pState.data,
            isFavorite: pState.isFavorite,
          );
        } else {
          //나머지 로딩 상황
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        siteList: siteList.map((e) => e.site).toList(),
        limit: limit,
      );
      final List<bool> isFavorite = [];
      for (var e in resp) {
        final isIn = await favoriteRepository.isIn(id: e.id);
        isFavorite.add(isIn);
      }

      state = CursorPagination(data: [...resp], isFavorite: [...isFavorite]);

      return resp.length;
    } catch (e) {
      print(e);
      state = CursorPaginationError(message: '$e : 데이터를 가져오지 못했습니다.');
      return -1;
    }
  }
}
