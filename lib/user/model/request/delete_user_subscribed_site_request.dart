
import 'package:json_annotation/json_annotation.dart';

part 'delete_user_subscribed_site_request.g.dart';

@JsonSerializable()
class DeleteUserSubscribedSiteRequest{
  final String site;

  DeleteUserSubscribedSiteRequest({
    required this.site,
  });

  factory DeleteUserSubscribedSiteRequest.fromJson(Map<String, dynamic> json) => _$DeleteUserSubscribedSiteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteUserSubscribedSiteRequestToJson(this);
}