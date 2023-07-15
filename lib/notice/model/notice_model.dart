
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final String id;
  final String content;

  final String title;
  final String site;
  final String type;
  final String url;
  final int views;
  final DateTime day;

  NoticeModel({
    required this.id,
    required this.content,
    required this.title,
    required this.site,
    required this.type,
    required this.url,
    required this.views,
    required this.day,
  });

  factory NoticeModel.fromJson(Map<String,dynamic> json)
  => _$NoticeModelFromJson(json);

  Map<String, dynamic> toJson() =>_$NoticeModelToJson(this);

}


class Notices extends Table{
  TextColumn get id => text()();
  TextColumn get title =>text()();
  TextColumn get site =>text()();
  TextColumn get type =>text()();
  TextColumn get url =>text()();
  TextColumn get views=>text()();
  DateTimeColumn get day =>dateTime()();
  TextColumn get content =>text()();
}