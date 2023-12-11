import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../user/model/request/uuid_signup_request.dart';
import '../../user/model/response/jwt_token.dart';
import '../const/data.dart';

part 'dio_client.g.dart';

final dioClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class DioClient {
  factory DioClient(Dio dio, {String baseUrl}) = _DioClient;

  @POST('/auth/signup/v1')
  Future<JwtToken> uuidSignup(@Body() UuidSignupRequest request);

  @POST('/auth/login/v1')
  Future<JwtToken> loginV1(@Header("Authorization") String loginUuid);

}