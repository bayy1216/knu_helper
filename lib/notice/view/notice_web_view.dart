import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

import '../components/notice_card.dart';
import '../components/star_icon_button.dart';

class NoticeWebView extends StatefulWidget {
  final String url;
  static String get routeName => 'notice_web_view';

  const NoticeWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<NoticeWebView> createState() => _NoticeWebViewState();
}

class _NoticeWebViewState extends State<NoticeWebView> {
  late bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      actions: [
        StarIconButton(
          isFavorite: isFavorite,
          onStarClick: (value) {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
      ],
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
      ),
    );
  }
}
