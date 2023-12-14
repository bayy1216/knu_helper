import 'package:json_annotation/json_annotation.dart';

part 'site_model.g.dart';

@JsonSerializable(createToJson: false)
class SiteModel{
  final String site;
  final String siteCategoryKorean;

  SiteModel({
    required this.site,
    required this.siteCategoryKorean,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) => _$SiteModelFromJson(json);
}