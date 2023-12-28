import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/dio/dio_client.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';
import 'package:knu_helper/common/repository/base_pagination_repository.dart';
import 'package:knu_helper/notice/model/request/paginate_notice_queries.dart';

import '../model/response/notice_model.dart';
import '../model/response/site_info_response.dart';

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

  Future<SiteInfoResponse> getSiteInfo() {
    return _dioClient.getSiteInfo();
  }

  Future<SiteInfoResponse> getLocalSiteInfo() async{
    final string = await rootBundle.loadString('asset/json/site-info.json');
    final json = jsonDecode(string);
    if (json is Map<String, dynamic>) {
      return SiteInfoResponse.fromJson(json);
    }
    return SiteInfoResponse(siteInfoList: []);
  }

}
