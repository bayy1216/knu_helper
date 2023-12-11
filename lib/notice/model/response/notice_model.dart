import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';
@JsonSerializable(createToJson: false)
class NoticeModel{
  final int id;
  final String title;
  final String site;
  final DateTime date;
  final String url;
  final int views;
  final String type;

  NoticeModel({
    required this.id,
    required this.title,
    required this.site,
    required this.date,
    required this.url,
    required this.views,
    required this.type,
  });

  factory NoticeModel.fromJson(Map<String,dynamic> json) => _$NoticeModelFromJson(json);
}