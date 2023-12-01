import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/favorite/repository/favorite_repository.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/view/notice_web_view.dart';

import '../../common/const/text_style.dart';

class NoticeCard extends StatelessWidget {
  final String content;
  final String title;
  final String site;
  final String type;
  final String url;
  final int views;
  final DateTime day;
  final Function(bool) onStarClick;
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
    this.isFavorite = false,
  }) : super(key: key);

  factory NoticeCard.fromModel({
    required NoticeModel model,
    required Function(bool) onStarClick,
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
      isFavorite: isFavorite,
    );
  }

  void routing(BuildContext context){
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => NoticeWebView(
          title: title,
          url: url,
          isFavorite: isFavorite,
          onStarClick: onStarClick,
        ),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          final tween = Tween(begin: Offset(0.0, 0.2), end: Offset(0.0, 0.0)).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => routing(context),
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
                        future: ref.read(favoriteRepositoryProvider).getColorOfSite(siteName: site),
                        builder: (context, snapshot) {
                          Color color = PRIMARY_COLOR;
                          if (snapshot.hasData) {
                            final hexCode = snapshot.data;
                            color = Color(DataUtils.stringToColorCode(hexCode!));
                          }
                          return chipContainer(text: site, color: color,);
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 6.0),
                  chipContainer(text: type, color: Colors.grey),
                  const Expanded(child: SizedBox()),
                  Text(DataUtils.dateTimeToString(day),style: contentStyle,)
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: titleStyle,
                maxLines: 2,overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 8.0),
                Text('조회수 : $views',style: contentStyle,),
                const Expanded(child: SizedBox()),
                IconBtn(
                  isFavorite: isFavorite,
                  onStarClick: onStarClick,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container chipContainer({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(text, style: chipStyle),
    );
  }
}

class IconBtn extends StatelessWidget {
  final bool isFavorite;
  final Function(bool) onStarClick;
  const IconBtn({super.key, required this.isFavorite, required this.onStarClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onStarClick(isFavorite),
      child: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            crossFadeState: isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Icon(Icons.star_rounded, color: Colors.red, size: 30),
            secondChild: Icon(Icons.star_outline_rounded, color: Colors.grey, size: 30),
          ),
        )
        // child: Icon(isFavorite
        //       ? Icons.star_rounded
        //       : Icons.star_outline_rounded,
        //   color: isFavorite ? Colors.red : Colors.grey,
        //   size: 30,
        // )
      ),
    );
  }
}

