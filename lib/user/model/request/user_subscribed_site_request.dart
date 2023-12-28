import 'package:json_annotation/json_annotation.dart';

part 'user_subscribed_site_request.g.dart';

@JsonSerializable()
class UserSubscribedSiteRequest {
  final String site;
  final String color;
  final bool alarm;

  UserSubscribedSiteRequest({
    required this.site,
    required this.color,
    required this.alarm,
  });

  factory UserSubscribedSiteRequest.fromJson(Map<String, dynamic> json) => _$UserSubscribedSiteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserSubscribedSiteRequestToJson(this);
}