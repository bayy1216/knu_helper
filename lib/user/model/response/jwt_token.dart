
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jwt_token.g.dart';

@JsonSerializable(createToJson: false)
class JwtToken{
  final String accessToken;
  final String refreshToken;

  JwtToken({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtToken.fromJson(Map<String, dynamic> json) => _$JwtTokenFromJson(json);
}