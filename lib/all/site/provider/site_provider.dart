import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notice/model/response/site_model.dart';
import '../../../notice/repository/notice_repository.dart';

final asyncSiteNotifier = AsyncNotifierProvider<AsyncSiteNotifier, List<SiteModel>>(AsyncSiteNotifier.new);

class AsyncSiteNotifier extends AsyncNotifier<List<SiteModel>>{
  late final NoticeRepository _noticeRepository = ref.read(noticeRepositoryProvider);

  @override
  Future<List<SiteModel>> build() async{
    final resp = await _noticeRepository.getSiteInfo();
    return resp.siteInfoList;
  }

  refresh() {
    ref.invalidateSelf();
  }

}