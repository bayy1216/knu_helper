import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:knu_helper/user/model/request/uuid_signup_request.dart';
import 'package:uuid/uuid.dart';

import '../../common/const/data.dart';
import '../../common/secure_storage/secure_storage.dart';
import '../../notice/provider/notice_provider.dart';
import '../model/request/delete_user_subscribed_site_request.dart';
import '../model/request/user_subscribed_site_request.dart';
import '../model/response/user_subscribed_site_response.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';

final userProvider = StateNotifierProvider<UserStateNotifier,UserInfoBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserStateNotifier(
    authRepository: authRepository,
    userRepository: userRepository,
    storage: storage,
    ref: ref,
  );
});

class UserStateNotifier extends StateNotifier<UserInfoBase?> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  final Ref ref;

  UserStateNotifier({
    required this.authRepository,
    required this.userRepository,
    required this.storage,
    required this.ref,
  }) : super(UserInfoLoading()){
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    print(accessToken);

    if (refreshToken == null || accessToken == null) {
      //로그인 안한 상태
      state = null;
      return;
    }
    state = UserInfoModel(subscribedSites: []);
    final resp = await userRepository.getUserFavoriteSite();
    state = UserInfoModel(subscribedSites: resp.data);
  }

  Future<void> addUserFavoriteSite({
    required String site,
    required String color,
    required bool alarm,
  }) async {
    final model = UserSubscribedSiteModel(site: site, color: color, isAlarm: alarm);
    //긍정적 응답
    final sites = (state as UserInfoModel).subscribedSites;
    if(sites.any((element) => element.site == site)){
      await updateUserFavoriteSite(site: site, color: color, isAlarm: alarm);
      return;
    }
    final pSites = sites..add(model);
    state = (state as UserInfoModel).copyWith(subscribedSites: pSites);

    final request = UserSubscribedSiteRequest(site: site, color: color, alarm: alarm);
    await userRepository.addUserFavoriteSite(request: request);
    ref.read(noticeProvider.notifier).paginate(forceRefetch: true);
  }

  Future<void> updateUserFavoriteSite({
    required String site,
    required String color,
    required bool isAlarm,
  }) async {
    //긍적적 응답
    final sites = (state as UserInfoModel).subscribedSites;
    final updateSite = UserSubscribedSiteModel(site: site, color: color, isAlarm: isAlarm);
    final pSites = sites.map((e) => e.site == site ? updateSite : e).toList();
    state = (state as UserInfoModel).copyWith(subscribedSites: pSites);

    final request = UserSubscribedSiteRequest(site: site, color: color, alarm: isAlarm);
    await userRepository.updateUserFavoriteSite(request: request);
  }

  Future<void> deleteUserFavoriteSite({
    required String site,
  }) async {
    //긍정적 응답
    final sites = (state as UserInfoModel).subscribedSites;
    final pSites = sites.where((e) => e.site != site).toList();
    state = (state as UserInfoModel).copyWith(subscribedSites: pSites);

    final request = DeleteUserSubscribedSiteRequest(site: site);
    await userRepository.deleteUserFavoriteSite(request: request);
    ref.read(noticeProvider.notifier).paginate(forceRefetch: true);
  }


  Future<void> signUp() async {
    final uuid = const Uuid().v4();
    await storage.write(key: UUID_KEY, value: uuid);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final request = UuidSignupRequest(uuid: uuid, fcmToken: fcmToken!);
    final resp = await authRepository.uuidSignup(
      request: request,
    );
    await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
    await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

    await getMe();
  }

  Future<void> loginV1()async{
    final uuid = await storage.read(key: UUID_KEY);

    final resp = await authRepository.loginV1(
      uuid: uuid!,
    );

    await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
    await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
    await getMe();
  }



  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}