import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';

class NoticeScreen extends ConsumerWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final state = ref.watch(noticeProvider);
    Future((){
      ref.read(noticeProvider.notifier).getNotice();
    });

    return SafeArea(
      child: DefaultLayout(
        title: '검색하기',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
        child: ListView(
          children: state.map((e) => NoticeCard.fromModel(model: e)).toList(),
        ),
      ),
    );
  }
}
