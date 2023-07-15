import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

final noticeProvider =
    StateNotifierProvider<NoticeStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(noticeRepositoryProvider);
  return NoticeStateNotifier(repository: repo);
});

class NoticeStateNotifier extends StateNotifier<CursorPaginationBase> {
  final NoticeRepository repository;

  NoticeStateNotifier({required this.repository})
      : super(CursorPaginationLoading()){
    paginate();
  }

  customSetState(){
    final temp = state as CursorPagination<NoticeModel>;
    state = CursorPaginationRefetchingMore<NoticeModel>(
      data: temp.data
    );
    state = temp;
  }

  updateToEnd(){
    final pState = state as CursorPagination<NoticeModel>;
    state = CursorPaginationEnd(data: pState.data);
  }


  Future<int> paginate({//-1 진행중,에러 /  0 이상 응답받은 데이터갯수
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
        );
        afterDay = pState.data.last.day.subtract(const Duration(days: 1));

      } else {
        //데이터처음부터 가져오는 상황
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<NoticeModel>;
          state = CursorPaginationRefetching<NoticeModel>(
            data: pState.data,
          );
        } else {
          //나머지 로딩 상황
          state = CursorPaginationLoading();
        }
      }


      final resp = await repository.paginate(
        afterDay: afterDay,
        periodDay: periodDay,
      );

      if (state is CursorPaginationRefetchingMore) {

        final pState = state as CursorPagination<NoticeModel>;
        state = pState.copywith(
          data: [
            ...pState.data,
            ...resp
          ]
        );
      } else {
        state = CursorPagination(data: [...resp]);
      }
      return resp.length;
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
      return -1;
    }
  }
}
