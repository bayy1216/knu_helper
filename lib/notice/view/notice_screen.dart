import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/component/pagination_list_view.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';
import 'package:knu_helper/notice/view/search_notice_screen.dart';

import '../../common/component/cow_item.dart';
import '../../common/model/offset_pagination_model.dart';
import '../../common/utils/data_utils.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../user/model/response/user_subscribed_site_response.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_provider.dart';
import 'notice_web_view.dart';

final noticeFilterProvider =
NotifierProvider<FilterNoticeSite, String?>(FilterNoticeSite.new);

class NoticeScreen extends ConsumerWidget {
  static String get routeName => 'notice';

  const NoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subScribedSites =
        (ref.watch(userProvider) as UserInfoModel).subscribedSites;
    final List<int> favoriteState = ref.watch(favoriteStreamProvider).when(
          data: (data) => data.map((e) => e.id).toList(),
          error: (error, stackTrace) => [],
          loading: () => [],
        );
    final state = ref.watch(noticeProvider);

    final filterSite = ref.watch(noticeFilterProvider);
    return DefaultLayout(
      title: '공지사항',
      titleWidget: Row(
        children: [
          filterSite == null ? Text(
            '공지사항',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ) : Text(
            filterSite,
            style: TextStyle(
              color: Color(DataUtils.stringToColorCode(
                  subScribedSites.firstWhere((element) => element.site == filterSite).color)),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4.0),
          GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  const vertical = 12.0;
                  final childd = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: vertical),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              ref
                                  .read(noticeFilterProvider.notifier)
                                  .change(null);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: vertical,
                                horizontal: 18.0,
                              ),
                              child: const Text(
                                '전체',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          ...subScribedSites.map((e) {
                            return InkWell(
                              onTap: () {
                                ref
                                    .read(noticeFilterProvider.notifier)
                                    .change(e.site);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: vertical,
                                  horizontal: 18.0,
                                ),
                                child: Text(
                                  e.site,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                        DataUtils.stringToColorCode(e.color)),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                  final DialogTheme dialogTheme = DialogTheme.of(context);
                  final dialogChild = Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 180.0,
                        maxWidth: 180.0,
                      ),
                      child: Material(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(4.0),
                        elevation: 0,
                        type: MaterialType.card,
                        child: childd,
                      ),
                    ),
                  );

                  return AnimatedPadding(
                    padding: MediaQuery.viewInsetsOf(context) +
                        (EdgeInsets.only(left: 12, top: 55)),
                    duration: Duration.zero,
                    curve: Curves.decelerate,
                    child: MediaQuery.removeViewInsets(
                      removeLeft: true,
                      removeTop: true,
                      removeRight: true,
                      removeBottom: true,
                      context: context,
                      child: dialogChild,
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.keyboard_arrow_down_outlined),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: '검색',
          onPressed: () {
            ref.read(keywordProvider.notifier).update((state) => '');
            context.goNamed(SearchNoticeScreen.routeName);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.search),
        )
      ],
      body: (subScribedSites.isEmpty && ref.watch(noticeProvider) is OffsetPagination)
          ? const CowItem(content: '원하는 사이트를 추가해 보세요')
          : PaginationListView(
              provider: noticeProvider,
              itemBuilder: (BuildContext context, int index, model) {
                final colorHexcode = subScribedSites
                    .firstWhere(
                      (element) => element.site == model.site,
                      orElse: () => UserSubscribedSiteModel(
                          site: '', color: 'FFFFFF', isAlarm: false),
                    )
                    .color;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
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
                      isFavorite: favoriteState.contains(model.id),
                      onStarClick: (value) {
                        ref
                            .read(favoriteStreamProvider.notifier)
                            .starClick(model: model, isDelete: value);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
