// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offset_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OffsetPagination<T> _$OffsetPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    OffsetPagination<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$OffsetPaginationToJson<T>(
  OffsetPagination<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'hasNext': instance.hasNext,
      'data': instance.data.map(toJsonT).toList(),
    };
