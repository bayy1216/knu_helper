import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/user/model/request/uuid_signup_request.dart';
import 'package:knu_helper/user/model/response/jwt_token.dart';

import '../../common/dio/dio_client.dart';

final authRepositoryProvider = Provider((ref){
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient: dioClient);
});

class AuthRepository {
  final DioClient _dioClient;
  AuthRepository({required DioClient dioClient}) : _dioClient = dioClient;

  Future<JwtToken> uuidSignup({
    required UuidSignupRequest request,
}) async {
    return await _dioClient.uuidSignup(request);
  }

  Future<JwtToken> loginV1({
    required String uuid,
}) async {
    final request = "Basic $uuid";
    return await _dioClient.loginV1(request);
  }

}