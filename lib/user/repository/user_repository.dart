import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/user/model/request/delete_user_subscribed_site_request.dart';

import '../../common/dio/dio_client.dart';
import '../model/request/user_subscribed_site_request.dart';
import '../model/response/user_subscribed_site_response.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);

  return UserRepository(dioClient: dioClient);
});

class UserRepository {
  final DioClient _dioClient;

  UserRepository({required DioClient dioClient}) : _dioClient = dioClient;

  Future<UserSubscribedSiteResponse> getUserFavoriteSite() async {
    return await _dioClient.getUserFavoriteSite();
  }

  Future<void> addUserFavoriteSite({
    required UserSubscribedSiteRequest request,
  }) async {
    return await _dioClient.addUserFavoriteSite(request);
  }

  Future<void> updateUserFavoriteSite({
    required UserSubscribedSiteRequest request,
  }) async {
    return await _dioClient.updateUserFavoriteSite(request);
  }

  Future<void> deleteUserFavoriteSite({
    required DeleteUserSubscribedSiteRequest request,
  }) async {
    return await _dioClient.deleteUserFavoriteSite(request);
  }
}
