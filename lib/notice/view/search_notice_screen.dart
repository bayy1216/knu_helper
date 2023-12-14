import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';

import '../components/notice_card.dart';
import '../model/response/notice_model.dart';

final keywordProvider = StateProvider.autoDispose((ref) => '');

class SearchNoticeScreen extends ConsumerWidget {
  static String get routeName => 'search_notice';

  SearchNoticeScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(keywordProvider);
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
        body: FutureBuilder(
          //future: ref.read(noticeProvider.notifier).searchNotice(),\
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(color: Colors.transparent);
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            final searchData =
                ref.read(noticeProvider) as CursorPagination<NoticeModel>;

            return ListView.builder(
              itemCount: searchData.data.length,
              itemBuilder: (context, index) {
                if (!searchData.data[index].title.contains(keyword) ||
                    keyword == '') {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: NoticeCard.fromModel(
                    color: Colors.grey.shade300,
                    model: searchData.data[index],
                    isFavorite: searchData.isFavorite![index],
                    onStarClick: (value) {
                      // ref.read(noticeProvider.notifier).toggleStar(
                      //       model: searchData.data[index],
                      //       value: value,
                      //     );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
