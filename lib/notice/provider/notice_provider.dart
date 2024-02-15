import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';
import 'package:knu_helper/notice/model/request/paginate_notice_queries.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

import '../../common/provider/paginating_provider.dart';
import '../model/response/notice_model.dart';
import '../view/notice_screen.dart';
import '../view/search_notice_screen.dart';

/// 공지사항 검색을 처리하는 페이징 [StateNotifier] <p>
/// [keywordProvider]를 통해 검색어를 받아 검색을 한다.
final seacrhNoticeProvider =
StateNotifierProvider<NoticeStateNotifier, OffsetPaginationBase>((ref) {
  final repo = ref.watch(noticeRepositoryProvider);
  final title = ref.watch(keywordProvider);
  final baseQuires = PaginateNoticeQueries(
    page: 0,
    size: 20,
    title: title,
  );
  return NoticeStateNotifier(
    repository: repo,
    baseQuires: baseQuires,
  );
});

/// 공지사항을 페이징 처리하기 위한 [StateNotifier] <p>
/// [noticeFilterProvider]를 통해 특정 사이트의 공지사항을 받을지 결정한다.(null이면 전체)
/// 받아오는 공지사항의 사이트는 서버에 저장되어있는 사용자의 구독 사이트를 기준으로 받아온다.
final noticeProvider =
    StateNotifierProvider<NoticeStateNotifier, OffsetPaginationBase>((ref) {
  final repo = ref.watch(noticeRepositoryProvider);
  final noticeSite = ref.watch(noticeFilterProvider);
  final baseQuires = PaginateNoticeQueries(
    page: 0,
    size: 20,
    site : noticeSite,
  );
  return NoticeStateNotifier(
    repository: repo,
    baseQuires: baseQuires,
  );
});

class NoticeStateNotifier
    extends PaginationProvider<NoticeModel, NoticeRepository> {
  NoticeStateNotifier({
    required super.repository,
    required super.baseQuires,
  });


}
