import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/base_paginate_queries.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';

import '../repository/base_pagination_repository.dart';

/// 페이징 처리를 위한 [StateNotifier] <p>
/// [T] : 데이터 타입 <p>
/// [R] : Repository 타입 <p>
/// [baseQuires] : 페이징을 위한 쿼리, [BasePaginationQueries]를 상속하면 이에 맞는 쿼리를 사용할 수 있다. <p>
/// [baseQuires]는 final로 선언되어있어 해당 쿼리를 외부에서 변경시 [StateNotifier]가 재생성되어 [page]는 0으로 된다.
///
/// [page], [OffsetPaginationBase]의 값을 내부에 상태로 가지고 있는다.
class PaginationProvider<T, R extends IBasePaginationRepository<T, BasePaginationQueries>>
    extends StateNotifier<OffsetPaginationBase> {
  final R repository;
  final BasePaginationQueries baseQuires;
  int page = 0;

  PaginationProvider({
    required this.repository,
    required this.baseQuires,
  }) : super(OffsetPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int pageSize = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      //데이터가 있을때, 다음 데이터가 없음
      if (state is OffsetPagination && !forceRefetch) {
        final pState = state as OffsetPagination;
        if (!pState.hasNext) {
          return;
        }
      }

      final isLoading = state is OffsetPaginationLoading;
      final isRefetching = state is OffsetPaginationRefetchingMore;

      if (fetchMore && isRefetching) {
        return;
      }

      if (fetchMore) {
        final pState = state as OffsetPagination<T>;
        state = OffsetPaginationRefetchingMore<T>(
          hasNext: pState.hasNext,
          data: pState.data,
        );
      } else if (forceRefetch) {
        page = 0;
        //state = CursorPaginationLoading();
      }


      baseQuires.updateQuires(
        page: page,
        size: pageSize,
      );

      final resp = await repository.paginate(
        queries: baseQuires,
      );

      if (isLoading || forceRefetch) {
        //맨처음 로딩상황 & 처음꺼 다시시도
        state = resp;
      } else {
        //이후 데이터 계속 요청하는 상황(isRefetching)

        final pState = state as OffsetPagination<T>;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      }
      page++;
      return;
    } catch (e) {
      print(e);
      state = OffsetPaginationError(message: "데이터를 가져오지 못했습니다.");
      return;
    }
  }
}
