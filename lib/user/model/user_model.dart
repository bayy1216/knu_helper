import 'package:knu_helper/user/model/response/user_subscribed_site_response.dart';

sealed class UserInfoBase{}

class UserInfoLoading extends UserInfoBase{}

class UserInfoModel extends UserInfoBase {
  final List<UserSubscribedSiteModel> subscribedSites;

  UserInfoModel({
    required this.subscribedSites,
  });

  UserInfoModel copyWith({
    List<UserSubscribedSiteModel>? subscribedSites,
  }) {
    return UserInfoModel(
      subscribedSites: subscribedSites ?? this.subscribedSites,
    );
  }
}

class UserInfoError extends UserInfoBase{
  final String message;

  UserInfoError({
    required this.message,
  });
}