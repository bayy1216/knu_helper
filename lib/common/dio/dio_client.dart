import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/dio/dio.dart';
import 'package:knu_helper/notice/model/request/paginate_notice_queries.dart';
import 'package:retrofit/retrofit.dart';


import '../../notice/model/response/notice_model.dart';
import '../../user/model/request/delete_user_subscribed_site_request.dart';
import '../../user/model/request/user_subscribed_site_request.dart';
import '../../user/model/request/uuid_signup_request.dart';
import '../../user/model/response/jwt_token.dart';
import '../../user/model/response/user_subscribed_site_response.dart';
import '../const/data.dart';
import '../model/offset_pagination_model.dart';

part 'dio_client.g.dart';

final dioClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class DioClient {
  factory DioClient(Dio dio, {String baseUrl}) = _DioClient;

  @Headers({"accessToken" : "false"})
  @POST('/auth/signup/v1')
  Future<JwtToken> uuidSignup(@Body() UuidSignupRequest request);

  @Headers({"accessToken" : "false"})
  @POST('/auth/login/v1')
  Future<JwtToken> loginV1(@Header("Authorization") String loginUuid);

  ////////////////////////////////

  @GET('/user/favorite-site')
  Future<UserSubscribedSiteResponse> getUserFavoriteSite();

  @POST('/user/favorite-site')
  Future<void> addUserFavoriteSite(@Body() UserSubscribedSiteRequest request);

  @PUT('/user/favorite-site')
  Future<void> updateUserFavoriteSite(@Body() UserSubscribedSiteRequest request);

  @DELETE('/user/favorite-site')
  Future<void> deleteUserFavoriteSite(@Body() DeleteUserSubscribedSiteRequest request);

  ////////////////////////////////

  @GET('/notice')
  Future<OffsetPagination<NoticeModel>> paginateNotice(@Queries() PaginateNoticeQueries queries);


}