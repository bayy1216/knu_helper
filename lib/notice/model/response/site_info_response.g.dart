// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiteInfoResponse _$SiteInfoResponseFromJson(Map<String, dynamic> json) =>
    SiteInfoResponse(
      siteInfoList: (json['siteInfoList'] as List<dynamic>)
          .map((e) => SiteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
