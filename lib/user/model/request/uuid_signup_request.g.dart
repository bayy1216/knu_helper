// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uuid_signup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UuidSignupRequest _$UuidSignupRequestFromJson(Map<String, dynamic> json) =>
    UuidSignupRequest(
      uuid: json['uuid'] as String,
      fcmToken: json['fcmToken'] as String,
    );

Map<String, dynamic> _$UuidSignupRequestToJson(UuidSignupRequest instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'fcmToken': instance.fcmToken,
    };
