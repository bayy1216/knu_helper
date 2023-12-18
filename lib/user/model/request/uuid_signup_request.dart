import 'package:json_annotation/json_annotation.dart';

part 'uuid_signup_request.g.dart';

@JsonSerializable()
class UuidSignupRequest{
  final String uuid;
  final String fcmToken;

  UuidSignupRequest({
    required this.uuid,
    required this.fcmToken,
  });

  factory UuidSignupRequest.fromJson(Map<String, dynamic> json) => _$UuidSignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UuidSignupRequestToJson(this);
}