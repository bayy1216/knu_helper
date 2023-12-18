
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/database/drift_database.dart';



part 'notice_model_deprecated.g.dart';

@JsonSerializable()
@Deprecated('firebase에서 server로 데이터 유형을 변경함')
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

  factory NoticeModel.fromNotice(Notice notice){
    return NoticeModel(
      id: notice.id,
      content: notice.content,
      title: notice.title,
      site: notice.site,
      type: notice.type,
      url: notice.url,
      views: notice.views,
      day: notice.day,
    );
  }
  NoticesCompanion toCompanion(){
    return NoticesCompanion(
      id: Value(id),
      content: Value(content),
      title: Value(title),
      site: Value(site),
      type: Value(type),
      url: Value(url),
      views: Value(views),
      day: Value(day),
    );
  }

}


class Notices extends Table{
  TextColumn get id => text()();
  TextColumn get title =>text()();
  TextColumn get site =>text()();
  TextColumn get type =>text()();
  TextColumn get url =>text()();
  IntColumn get views=>integer()();
  DateTimeColumn get day =>dateTime()();
  TextColumn get content =>text()();


  @override
  Set<Column> get primaryKey => {id}; // id를 기본 키로 지정
}