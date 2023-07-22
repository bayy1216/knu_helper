import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

class PrivacyScreen extends StatelessWidget {
  static String get routeName => 'privacy';
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child : InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('https://grave-foe-3c7.notion.site/KnuMate-5576f7bd2ced40868adca19ad06b9d5a?pvs=4')),
      ),
    );
  }
}
