
import 'package:json_annotation/json_annotation.dart';

import '../../../common/model/base_paginate_queries.dart';

part 'paginate_notice_queries.g.dart';

@JsonSerializable(
  includeIfNull: false,
)
class PaginateNoticeQueries extends BasePaginationQueries{
  final String? site;
  PaginateNoticeQueries({
    required super.page,
    required super.size,
    this.site,
  });

  factory PaginateNoticeQueries.fromJson(Map<String,dynamic> json) => _$PaginateNoticeQueriesFromJson(json);

  Map<String, dynamic> toJson() => _$PaginateNoticeQueriesToJson(this);
}