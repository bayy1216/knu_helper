import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/model/notice_model.dart';

class NoticeWebView extends StatelessWidget {
  final NoticeModel model;
  final Function()? onTap;
  static String get routeName => 'notice_web_view';

  const NoticeWebView({
    Key? key,
    required this.model,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: model.title,
      actions: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.star_outline_rounded,
            color: Colors.grey,
            size: 30,
          ),
        )
      ],
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(model.url)),
      ),
    );
  }
}
