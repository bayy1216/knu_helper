import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/model/offset_pagination_model.dart';
import 'package:knu_helper/notice/model/request/paginate_notice_queries.dart';
import 'package:knu_helper/notice/repository/notice_repository.dart';

import '../../common/provider/paginating_provider.dart';
import '../model/response/notice_model.dart';
import '../view/notice_screen.dart';

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
