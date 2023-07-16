import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/all/view/select_site_screen.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';
import 'package:knu_helper/user/provider/user_site_provider.dart';

class AllScreen extends ConsumerWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '전체',
      elevation: 2.5,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            _IconButton(
              onTap: () {
                context.goNamed(SelectSiteScreen.routeName);
              },
              content: '공지 선택하기',
              icon: const Icon(Icons.edit_notifications_outlined, color: BODY_TEXT_COLOR),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final String content;
  final Icon icon;
  final Function() onTap;

  const _IconButton({
    Key? key,
    required this.onTap,
    required this.content,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            const SizedBox(width: 8.0),
            Text(content),
            const Expanded(child: SizedBox()),
            const Icon(Icons.keyboard_arrow_right,color: BODY_TEXT_COLOR),
          ],
        ),
      ),
    );
  }
}
