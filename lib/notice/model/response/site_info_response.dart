import 'package:json_annotation/json_annotation.dart';
import 'site_model.dart';



part 'site_info_response.g.dart';

@JsonSerializable(createToJson: false)
class SiteInfoResponse{
  final List<SiteModel> siteInfoList;

  SiteInfoResponse({
    required this.siteInfoList,
  });

  factory SiteInfoResponse.fromJson(Map<String, dynamic> json) => _$SiteInfoResponseFromJson(json);
}