import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/database/drift_database.dart';

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
  factory NoticeModel.fromEntity(NoticeEntity entity) => NoticeModel(
    id: entity.id,
    title: entity.title,
    site: entity.site,
    date: entity.day,
    url: entity.url,
    views: entity.views,
    type: entity.type,
  );
  NoticeEntitiesCompanion toCompanion(){
    return NoticeEntitiesCompanion(
      id: Value(id),
      title: Value(title),
      site: Value(site),
      day: Value(date),
      url: Value(url),
      views: Value(views),
      type: Value(type),
    );
  }
}