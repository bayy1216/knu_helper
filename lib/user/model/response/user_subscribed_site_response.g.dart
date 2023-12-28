// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscribed_site_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSubscribedSiteResponse _$UserSubscribedSiteResponseFromJson(
        Map<String, dynamic> json) =>
    UserSubscribedSiteResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              UserSubscribedSiteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

UserSubscribedSiteModel _$UserSubscribedSiteModelFromJson(
        Map<String, dynamic> json) =>
    UserSubscribedSiteModel(
      site: json['site'] as String,
      color: json['color'] as String,
      isAlarm: json['isAlarm'] as bool,
    );
