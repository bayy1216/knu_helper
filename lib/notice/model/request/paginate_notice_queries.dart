
import 'package:json_annotation/json_annotation.dart';

part 'paginate_notice_queries.g.dart';

@JsonSerializable()
class PaginateNoticeQueries{
  final int page;
  final int size;

  PaginateNoticeQueries({
    required this.page,
    required this.size,
  });

  factory PaginateNoticeQueries.fromJson(Map<String,dynamic> json) => _$PaginateNoticeQueriesFromJson(json);

  Map<String, dynamic> toJson() => _$PaginateNoticeQueriesToJson(this);
}