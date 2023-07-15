import 'package:flutter/material.dart';
import 'package:knu_helper/notice/model/notice_model.dart';

class NoticeCard extends StatelessWidget {
  final String content;
  final String title;
  final String site;
  final String type;
  final String url;
  final int views;
  final DateTime day;

  const NoticeCard({
    Key? key,
    required this.content,
    required this.title,
    required this.site,
    required this.type,
    required this.url,
    required this.views,
    required this.day,
  }) : super(key: key);

  factory NoticeCard.fromModel({required NoticeModel model}) {
    return NoticeCard(
      content: model.content,
      title: model.title,
      site: model.site,
      type: model.type,
      url: model.url,
      views: model.views,
      day: model.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
        children: [
          Text(title),
          Text(content),
          Text(day.toString())
        ],
      ),
    );
  }
}
