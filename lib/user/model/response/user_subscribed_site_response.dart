import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_subscribed_site_response.g.dart';

@JsonSerializable(createToJson: false)
class UserSubscribedSiteResponse{
  final List<UserSubscribedSiteModel> data;

  UserSubscribedSiteResponse({
    required this.data,
  });

  factory UserSubscribedSiteResponse.fromJson(Map<String, dynamic> json) => _$UserSubscribedSiteResponseFromJson(json);
}


@JsonSerializable(createToJson: false)
class UserSubscribedSiteModel{
  final String site;
  final String color;
  final bool isAlarm;

  UserSubscribedSiteModel({
    required this.site,
    required this.color,
    required this.isAlarm,
  });

  factory UserSubscribedSiteModel.fromJson(Map<String, dynamic> json) => _$UserSubscribedSiteModelFromJson(json);
}