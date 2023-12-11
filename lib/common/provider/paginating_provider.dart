import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/base_paginate_queries.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';

import '../repository/base_pagination_repository.dart';

class PaginationProvider<T, R extends IBasePaginationRepository>
    extends StateNotifier<OffsetPaginationBase> {
  final R repository;
  final BasePaginationQuires baseQuires;
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
        quires: baseQuires,
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
      state = OffsetPaginationError(message: "데이터를 가져오지 못했습니다.");
      return;
    }
  }
}
