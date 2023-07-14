import 'package:flutter/material.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultLayout(
        title: '검색하기',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
        child: Column(
          children: [
            Text('gd'),
          ],
        ),
      ),
    );
  }
}
