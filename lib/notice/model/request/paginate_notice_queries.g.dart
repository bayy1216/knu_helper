// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginate_notice_queries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginateNoticeQueries _$PaginateNoticeQueriesFromJson(
        Map<String, dynamic> json) =>
    PaginateNoticeQueries(
      page: json['page'] as int,
      size: json['size'] as int,
      site: json['site'] as String?,
    );

Map<String, dynamic> _$PaginateNoticeQueriesToJson(
    PaginateNoticeQueries instance) {
  final val = <String, dynamic>{
    'page': instance.page,
    'size': instance.size,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('site', instance.site);
  return val;
}
