// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscribed_site_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSubscribedSiteRequest _$UserSubscribedSiteRequestFromJson(
        Map<String, dynamic> json) =>
    UserSubscribedSiteRequest(
      site: json['site'] as String,
      color: json['color'] as String,
      alarm: json['alarm'] as bool,
    );

Map<String, dynamic> _$UserSubscribedSiteRequestToJson(
        UserSubscribedSiteRequest instance) =>
    <String, dynamic>{
      'site': instance.site,
      'color': instance.color,
      'alarm': instance.alarm,
    };
