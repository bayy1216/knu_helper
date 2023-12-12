import 'package:knu_helper/common/model/base_paginate_queries.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';

abstract class IBasePaginationRepository<T, Q extends BasePaginationQueries> {
  Future<OffsetPagination<T>> paginate({
    required Q queries,
  });
}
