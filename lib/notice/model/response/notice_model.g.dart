// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      site: json['site'] as String,
      date: DateTime.parse(json['date'] as String),
      url: json['url'] as String,
      views: json['views'] as int,
      type: json['type'] as String,
    );
