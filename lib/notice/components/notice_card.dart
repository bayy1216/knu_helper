import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/favorite/repository/favorite_repository.dart';
import 'package:knu_helper/notice/components/chip_item.dart';
import 'package:knu_helper/notice/components/star_icon_button.dart';

import '../../common/const/text_style.dart';
import '../model/response/notice_model.dart';

class NoticeCard extends StatelessWidget {
  final Color color;
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
    required this.color,
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
    required Color color,
    required NoticeModel model,
    required Function(bool) onStarClick,
    bool isFavorite = false,
  }) {
    return NoticeCard(
      color: color,
      title: model.title,
      site: model.site,
      type: model.type,
      url: model.url,
      views: model.views,
      day: model.date,
      onStarClick: onStarClick,
      isFavorite: isFavorite,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
                ChipItem(text: site, color: color,),
                const SizedBox(width: 6.0),
                ChipItem(text: type, color: Colors.grey),
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
          const Text(''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8.0),
              Text('조회수 : $views',style: contentStyle,),
              const Expanded(child: SizedBox()),
              StarIconButton(
                isFavorite: isFavorite,
                onStarClick: onStarClick,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

