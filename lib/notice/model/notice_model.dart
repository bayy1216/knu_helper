
import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final int id;
  final String title;
  final String site;
  final String url;
  final String views;
  final DateTime day;

  NoticeModel({
    required this.id,
    required this.title,
    required this.site,
    required this.url,
    required this.views,
    required this.day,
  });

  factory NoticeModel.fromJson(Map<String,dynamic> json)
  => _$NoticeModelFromJson(json);

  Map<String, dynamic> toJson() =>_$NoticeModelToJson(this);

}
