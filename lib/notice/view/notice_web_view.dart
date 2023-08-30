import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

import '../components/notice_card.dart';

class NoticeWebView extends StatelessWidget {
  final String title;
  final String url;
  final bool isFavorite;
  final Function(bool) onStarClick;
  static String get routeName => 'notice_web_view';

  const NoticeWebView({
    Key? key,
    required this.title,
    required this.url,
    required this.isFavorite,
    required this.onStarClick,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: title,
      actions: [
        IconBtn(
          isSelect: isFavorite,
          onStarClick: onStarClick,
        ),
      ],
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      ),
    );
  }
}
