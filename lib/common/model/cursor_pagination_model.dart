import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final List<T> data;

  CursorPagination({
    required this.data,
  });

  CursorPagination copywith({
    List<T>? data,
  }) {
    return CursorPagination<T>(
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.data,
  });
} //새로고침하여 데이터 요청 중

class CursorPaginationRefetchingMore<T> extends CursorPagination<T> {
  CursorPaginationRefetchingMore({
    required super.data,
  });
} //리스트 맨 아래에서 다음 추가데이터 요청하는 중

class CursorPaginationEnd<T> extends CursorPagination<T> {
  CursorPaginationEnd({
    required super.data,
  });
} //더이상 데이터 없음