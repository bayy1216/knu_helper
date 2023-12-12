
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/component/pagination_list_view.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';
import 'package:knu_helper/notice/view/search_notice_screen.dart';


class NoticeScreen extends ConsumerWidget {
  static String get routeName => 'notice';

  const NoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          return NoticeCard.fromModel(
            model: model,
            isFavorite: false,
            onStarClick: (value) {},
          );
        },
      ),
    );
  }
}
