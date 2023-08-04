import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';
import 'package:knu_helper/user/provider/user_site_provider.dart';

final noticeProvider = NotifierProvider<NoticeNotifier, CursorPaginationBase>(NoticeNotifier.new);

class NoticeNotifier extends Notifier<CursorPaginationBase> {
  late NoticeRepository repository;
  late LocalDatabase database;
  late List<SiteColorModel> siteList;


  @override
  CursorPaginationBase build() {
    state = CursorPaginationLoading();
    repository = ref.watch(noticeRepositoryProvider);
    database = ref.watch(databaseProvider);
    siteList = ref.watch(userSiteProvider);
    paginate();
    return CursorPaginationLoading();
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

  searchNotice()async{
    if (state is CursorPaginationEnd) {
      return;
    }
    final resp = await repository.searchNotice(
      siteList: siteList.map((e) => e.site).toList(),
    );
    final List<bool> isFavorite = [];
    for (var e in resp) {
      final isIn = await database.isIn(id: e.id);
      isFavorite.add(isIn);
    }
    state = CursorPaginationEnd(data: [...resp], isFavorite: [...isFavorite]);
  }


  Future<int> paginate({
    //-1 진행중,에러 /  0 이상 응답받은 데이터갯수
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      print('PAGINATE');
      if (state is CursorPaginationEnd) {
        return -1;
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationRefetchingMore;
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return -1;
      }



      final limit = (state is CursorPagination) ? (state as CursorPagination).data.length + 10: 10;
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

      print("repository before ${siteList.map((e) => e.site).toList()}}");
      final resp = await repository.paginate(
        siteList: siteList.map((e) => e.site).toList(),
        limit: limit,
      );
      final List<bool> isFavorite = [];
      for (var e in resp) {
        final isIn = await database.isIn(id: e.id);
        isFavorite.add(isIn);
      }


      state = CursorPagination(data: [...resp], isFavorite: [...isFavorite]);

      return resp.length;
    } catch (e) {
      print('[!!paginate ERROR] : $e');
      state = CursorPaginationError(message: '$e : 데이터를 가져오지 못했습니다.');
      return -1;
    }
  }

}
