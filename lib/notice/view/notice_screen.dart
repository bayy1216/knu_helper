
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/component/pagination_list_view.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';
import 'package:knu_helper/notice/view/search_notice_screen.dart';

import '../../common/utils/data_utils.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_provider.dart';
import 'notice_web_view.dart';


class NoticeScreen extends ConsumerWidget {
  static String get routeName => 'notice';

  const NoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subScribedSites = (ref.watch(userProvider) as UserInfoModel).subscribedSites;
    return DefaultLayout(
      title: '공지사항',
      actions: [
        IconButton(
          tooltip: '검색',
          onPressed: () {
            context.goNamed(SearchNoticeScreen.routeName);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.search),
        )
      ],
      body: PaginationListView(
        provider: noticeProvider,
        itemBuilder: (BuildContext context, int index, model) {
          final colorHexcode = subScribedSites.firstWhere((element) => element.site == model.site).color;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                context.goNamed(
                  NoticeWebView.routeName,
                  pathParameters: {'url': model.url},
                );
              },
              child: NoticeCard.fromModel(
                color: Color(DataUtils.stringToColorCode(colorHexcode)),
                model: model,
                isFavorite: false,
                onStarClick: (value) {
                  ref.read(favoriteStreamProvider.notifier).starClick(model: model, isDelete: value);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
