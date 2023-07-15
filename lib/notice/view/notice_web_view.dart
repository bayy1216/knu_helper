import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/model/notice_model.dart';

class NoticeWebView extends StatelessWidget {
  final String title;
  final String url;
  final bool isFavorite;
  final Function() onStarClick;
  final Function() offStarClick;
  static String get routeName => 'notice_web_view';

  const NoticeWebView({
    Key? key,
    required this.title,
    required this.url,
    required this.isFavorite,
    required this.onStarClick,
    required this.offStarClick,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: title,
      actions: [
        _IconBtn(
          isSelect: isFavorite,
          onStarClick: onStarClick,
          offStarClick: offStarClick,
        ),
      ],
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      ),
    );
  }
}
class _IconBtn extends StatefulWidget {
  final bool isSelect;
  final Function() onStarClick;
  final Function() offStarClick;

  const _IconBtn({
    Key? key,
    required this.isSelect,
    required this.onStarClick,
    required this.offStarClick,
  }) : super(key: key);

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  late bool isSelect;

  @override
  void initState() {
    super.initState();
    isSelect = widget.isSelect;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSelect) {
          widget.offStarClick();
        } else {
          widget.onStarClick();
        }
        isSelect = !isSelect;
        setState(() {
          print('click');
        });
      },
      child: SizedBox(
        height: 45,
        width: 45,
        child: isSelect
            ? Icon(
          Icons.star_rounded,
          color: Colors.red,
          size: 30,
        )
            : Icon(
          Icons.star_outline_rounded,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}
