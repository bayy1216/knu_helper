import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';

import '../components/notice_card.dart';

final keywordProvider = StateProvider.autoDispose((ref) => '');
class SearchNoticeScreen extends ConsumerWidget {
  static String get routeName => 'search_notice';
  const SearchNoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final keyword = ref.watch(keywordProvider);
    final searchController = TextEditingController();
    FocusNode searchFocusNode = FocusNode();
    return SafeArea(
      child: DefaultLayout(
        elevation: 3,
        title: '',
        titleWidget: TextField(
          focusNode: searchFocusNode,
          controller: searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            hintText: '검색어를 입력하세요',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onSubmitted: (text){
            ref.read(keywordProvider.notifier).update((state) => text);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(keywordProvider.notifier).update((state) => searchController.text);
              searchFocusNode.unfocus(); // 키보드 숨기기
            },
            icon: const Icon(Icons.search),
          )
        ],
        body: FutureBuilder(
          future: ref.read(noticeProvider.notifier).searchNotice(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Container(color: Colors.transparent);
            }
            else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }


            final searchData = ref.read(noticeProvider) as CursorPagination<NoticeModel>;


              return ListView.separated(
              itemCount: searchData.data.length,
              itemBuilder: (context, index) {
                if(!searchData.data[index].title.contains(keyword) || keyword == ''){
                  return const SizedBox.shrink();
                }
                return NoticeCard.fromModel(
                  model: searchData.data[index],
                  isFavorite: searchData.isFavorite![index],
                  onStarClick: (value) {
                    ref.read(noticeProvider.notifier).toggleStar(model: searchData.data[index], value: value);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8.0);
              },
            );
          }
        ),
      ),
    );
  }
}
