// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      site: json['site'] as String,
      url: json['url'] as String,
      views: json['views'] as String,
      day: DateTime.parse(json['day'] as String),
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'site': instance.site,
      'url': instance.url,
      'views': instance.views,
      'day': instance.day.toIso8601String(),
    };
