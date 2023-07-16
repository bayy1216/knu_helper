import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/view/notice_web_view.dart';

class NoticeCard extends StatelessWidget {
  final String content;
  final String title;
  final String site;
  final String type;
  final String url;
  final int views;
  final DateTime day;
  final Function() onStarClick;
  final Function() offStarClick;
  final bool isFavorite;

  const NoticeCard({
    Key? key,
    required this.content,
    required this.title,
    required this.site,
    required this.type,
    required this.url,
    required this.views,
    required this.day,
    required this.onStarClick,
    required this.offStarClick,
    this.isFavorite = false,
  }) : super(key: key);

  factory NoticeCard.fromModel({
    required NoticeModel model,
    required Function() onStarClick,
    required Function() offStarClick,
    bool isFavorite = false,
  }) {
    return NoticeCard(
      content: model.content,
      title: model.title,
      site: model.site,
      type: model.type,
      url: model.url,
      views: model.views,
      day: model.day,
      onStarClick: onStarClick,
      offStarClick: offStarClick,
      isFavorite: isFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSelect = isFavorite;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeWebView(
              title: title,
              url: url,
              isFavorite: isSelect,
              onStarClick: onStarClick,
              offStarClick: offStarClick,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0), // 그림자의 위치 조정 (수평, 수직)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return FutureBuilder<String>(
                        future: ref.read(databaseProvider).getColorOfSite(siteName: site),
                        builder: (context, snapshot) {
                          Color color = PRIMARY_COLOR;
                          if (snapshot.hasData) {
                            final hexCode = snapshot.data;
                            color = Color(DataUtils.stringToColorCode(hexCode!));
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(site, style: TextStyle(color: Colors.white, fontSize: 12)),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(width: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(type, style: TextStyle(color: Colors.white,fontSize: 12)),
                  ),
                  Expanded(child: SizedBox()),
                  Text(DataUtils.dateTimeToString(day))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,),
            ),
            Text(content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 4.0),
                Text('조회수 : $views'),
                Expanded(child: SizedBox()),
                _IconBtn(
                  isSelect: isSelect,
                  onStarClick: (){
                    onStarClick();
                    isSelect = true;
                    print(isSelect);
                  },
                  offStarClick: (){
                    isSelect = false;
                    offStarClick();
                    print(isSelect);
                  },
                ),
              ],
            ),
          ],
        ),
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
        setState(() {});
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
