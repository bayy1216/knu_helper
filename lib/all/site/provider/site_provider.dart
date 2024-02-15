import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notice/model/response/site_model.dart';
import '../../../notice/repository/notice_repository.dart';

final asyncSiteNotifier = AsyncNotifierProvider<AsyncSiteNotifier, List<SiteModel>>(AsyncSiteNotifier.new);

class AsyncSiteNotifier extends AsyncNotifier<List<SiteModel>>{
  late final NoticeRepository _noticeRepository = ref.read(noticeRepositoryProvider);

  /// 서버에서 공지사항 사이트 목록을 받아온다.
  ///
  /// 기본은 로컬에 저장된 사이트를 보여주었지만,
  /// 서버에서 공지사항 사이트 목록이 추가될 수 있으므로
  /// 먼저 로컬데이터를 보여주고 서버에서 받아온 데이터를 보여준다.
  @override
  Future<List<SiteModel>> build() async{
    final local = await _noticeRepository.getLocalSiteInfo();
    state = AsyncData(local.siteInfoList);
    final resp = await _noticeRepository.getSiteInfo();
    return resp.siteInfoList;
  }

  refresh() {
    ref.invalidateSelf();
  }

}