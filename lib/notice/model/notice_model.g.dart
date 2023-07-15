// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      id: json['id'] as String,
      content: json['content'] as String,
      title: json['title'] as String,
      site: json['site'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      views: json['views'] as int,
      day: DateTime.parse(json['day'] as String),
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'title': instance.title,
      'site': instance.site,
      'type': instance.type,
      'url': instance.url,
      'views': instance.views,
      'day': instance.day.toIso8601String(),
    };
