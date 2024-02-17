import 'package:flutter/material.dart';

import '../model/base_paginate_queries.dart';
import '../model/offset_pagination_model.dart';
import '../provider/paginating_provider.dart';
import '../repository/base_pagination_repository.dart';

class PaginationUtils {
  static void paginate<T>({
    required ScrollController controller,
    required PaginationProvider<T, IBasePaginationRepository>
        paginationProvider,
  }) async {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      await paginationProvider.paginate(
        fetchMore: true,
      );
    }
  }

  static Stream<OffsetPaginationBase>
      paginateStream<T, Q extends BasePaginationQueries>({
    required int page,
    required int pageSize,
    required bool fetchMore,
    required bool forceRefetch,
    required IBasePaginationRepository<T, Q> repository,
    required OffsetPaginationBase state,
    required Q baseQuires,
  }) async* {
    ///데이터가 있을때, hasNext가 false인경우 early return
    if (state is OffsetPagination && !forceRefetch) {
      if (!state.hasNext) {
        return;
      }
    }
    final isLoading = state is OffsetPaginationLoading;
    final isRefetching = state is OffsetPaginationRefetchingMore;

    ///요청중일때, paginate함수 호출시 early return
    if (fetchMore && isRefetching) {
      return;
    }

    ///다음 데이터 요청시, state를 OffsetPaginationRefetchingMore로 변경
    if (fetchMore) {
      final pState = state as OffsetPagination;
      yield OffsetPaginationRefetchingMore(
        hasNext: pState.hasNext,
        data: pState.data,
      );
    }

    ///새로고침일때, state를 OffsetPaginationLoading으로 변경
    else if (forceRefetch) {
      yield OffsetPaginationLoading();
    }
    final pState = state as OffsetPagination;
    baseQuires.updateQuires(page: page);

    final data = await repository.paginate(queries: baseQuires);

    ///로딩중이거나, 강제로 새로고침할때, 데이터를 그대로 반환
    if (isLoading || forceRefetch) {
      yield data;
    }

    /// 기존 데이터에 추가
    else {
      yield OffsetPagination(
        hasNext: data.hasNext,
        data: pState.data + data.data,
      );
    }

    ///page를 증가
    page++;
    return;
  }
}
