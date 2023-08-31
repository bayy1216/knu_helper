import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

class PrivacyScreen extends StatelessWidget {
  static String get routeName => 'privacy';
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '개인정보처리방침',
      elevation: 2,
      body : InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('https://bayy1216.github.io/knu_mate_info.html')),
      ),
    );
  }
}
