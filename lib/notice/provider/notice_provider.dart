import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';
import 'package:knu_helper/user/provider/user_site_provider.dart';

final noticeProvider =
    StateNotifierProvider<NoticeStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(noticeRepositoryProvider);
  final db = ref.watch(databaseProvider);
  final siteList = ref.watch(userSiteProvider);
  return NoticeStateNotifier(
      repository: repo, database: db, siteList: siteList);
});

class NoticeStateNotifier extends StateNotifier<CursorPaginationBase> {
  final NoticeRepository repository;
  final LocalDatabase database;
  final List<SiteColorModel> siteList;

  NoticeStateNotifier({
    required this.repository,
    required this.database,
    required this.siteList,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  toggleStar({required NoticeModel model, required bool value}) {
    final pState = state as CursorPagination<NoticeModel>;
    int idx = pState.data.indexWhere((element) => element.id == model.id);
    print(pState.data);
    if (idx == -1) {
      print("없음");
      return;
    }
    pState.isFavorite![idx] = value;
    print('누름 $idx, $value');
    state = pState;
  }

  updateToEnd() {
    final pState = state as CursorPagination<NoticeModel>;
    state =
        CursorPaginationEnd(data: pState.data, isFavorite: pState.isFavorite);
  }

  Future<int> paginate({
    //-1 진행중,에러 /  0 이상 응답받은 데이터갯수
    bool fetchMore = false,
    bool forceRefetch = false,
    int periodDay = 14,
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

      DateTime afterDay = DateTime.now();

      if (fetchMore) {
        //기존에 있는 상황
        final pState = state as CursorPagination<NoticeModel>;
        state = CursorPaginationRefetchingMore<NoticeModel>(
          data: pState.data,
          isFavorite: pState.isFavorite,
        );
        afterDay = pState.data.last.day.subtract(const Duration(days: 1));
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
        afterDay: afterDay,
        periodDay: periodDay,
        siteList: siteList.map((e) => e.site).toList(),
      );
      final List<bool> isFavorite = [];
      for (var e in resp) {
        final isIn = await database.isIn(id: e.id);
        isFavorite.add(isIn);
      }

      if (state is CursorPaginationRefetchingMore) {
        final pState = state as CursorPagination<NoticeModel>;
        state = pState.copywith(
          data: [...pState.data, ...resp],
          isFavorite: [
            ...pState.isFavorite!,
            ...isFavorite,
          ],
        );
      } else {
        state = CursorPagination(data: [...resp], isFavorite: [...isFavorite]);
      }
      return resp.length;
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
      return -1;
    }
  }
}
