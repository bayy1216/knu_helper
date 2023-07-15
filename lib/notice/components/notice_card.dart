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
      child: Column(
        children: [Text(title), Text(content)],
      ),
    );
  }
}
