import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/dio/dio_client.dart';
import 'package:knu_helper/common/model/base_paginate_queries.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';
import 'package:knu_helper/common/repository/base_pagination_repository.dart';
import 'package:knu_helper/notice/model/request/paginate_notice_queries.dart';

import '../model/response/notice_model.dart';

final noticeRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NoticeRepository(dioClient: dioClient);
});

class NoticeRepository
    extends IBasePaginationRepository<NoticeModel, PaginateNoticeQueries> {
  final DioClient _dioClient;

  NoticeRepository({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<OffsetPagination<NoticeModel>> paginate({
    required PaginateNoticeQueries queries,
  }) {
    return _dioClient.paginateNotice(queries);
  }
}
