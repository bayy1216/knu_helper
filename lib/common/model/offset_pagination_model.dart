import 'package:json_annotation/json_annotation.dart';

part 'offset_pagination_model.g.dart';

sealed class OffsetPaginationBase{}

class OffsetPaginationError extends OffsetPaginationBase{
  final String message;
  OffsetPaginationError(this.message);
}

class OffsetPaginationLoading extends OffsetPaginationBase{}

@JsonSerializable(
  genericArgumentFactories: true,
)
class OffsetPagination<T> extends OffsetPaginationBase {
  final bool hasNext;
  final List<T> data;

  OffsetPagination({
    required this.data,
    required this.hasNext,
  });

  OffsetPagination copyWith({
    List<T>? data,
    bool? hasNext,
  }) {
    return OffsetPagination<T>(
      data: data ?? this.data,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  factory OffsetPagination.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$OffsetPaginationFromJson(json, fromJsonT);
}

class OffsetPaginationRefetching<T> extends OffsetPagination<T> {
  OffsetPaginationRefetching({
    required super.data,
    required super.hasNext,
  });
} //새로고침하여 데이터 요청 중

class OffsetPaginationRefetchingMore<T> extends OffsetPagination<T> {
  OffsetPaginationRefetchingMore({
    required super.data,
    required super.hasNext,
  });
} //리스트 맨 아래에서 다음 추가데이터 요청하는 중

class OffsetPaginationEnd<T> extends OffsetPagination<T> {
  OffsetPaginationEnd({
    required super.data,
    required super.hasNext,
  });
} //더이상 데이터 없음