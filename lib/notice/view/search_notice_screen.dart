import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';

import '../../common/component/pagination_list_view.dart';
import '../../common/utils/data_utils.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../../user/model/response/user_subscribed_site_response.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_provider.dart';
import '../components/notice_card.dart';
import 'notice_web_view.dart';

final keywordProvider = StateProvider((ref){
  return '';
});

class SearchNoticeScreen extends ConsumerWidget {
  static String get routeName => 'search_notice';

  SearchNoticeScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(keywordProvider);
    final subScribedSites =
        (ref.watch(userProvider) as UserInfoModel).subscribedSites;
    final List<int> favoriteState = ref.watch(favoriteStreamProvider)
        .requireValue.map((e) => e.id).toList();
    FocusNode searchFocusNode = FocusNode();

    return SafeArea(
      child: DefaultLayout(
        title: '',
        elevation: 1,
        titleWidget: TextField(
          focusNode: searchFocusNode,
          controller: searchController,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade300,
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            hintText: '검색어를 입력하세요',
            hintStyle: const TextStyle(color: Colors.black54),
          ),
          onSubmitted: (text) {
            ref.read(keywordProvider.notifier).update((state) => text);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(keywordProvider.notifier)
                  .update((state) => searchController.text);
              searchFocusNode.unfocus(); // 키보드 숨기기
            },
            icon: const Icon(Icons.search),
          )
        ],
        body: keyword.isEmpty ? Container(
          color: Colors.white,
        ) : PaginationListView(
          provider: seacrhNoticeProvider,
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
                  context.pushNamed(
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
      ),
    );
  }
}
