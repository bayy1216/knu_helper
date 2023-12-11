import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:knu_helper/user/model/request/uuid_signup_request.dart';
import 'package:uuid/uuid.dart';

import '../../common/const/data.dart';
import '../../common/secure_storage/secure_storage.dart';
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
  );
});

class UserStateNotifier extends StateNotifier<UserInfoBase?> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;

  UserStateNotifier({
    required this.authRepository,
    required this.userRepository,
    required this.storage,
  }) : super(UserInfoLoading()){
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }
    state = UserInfoModel();
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

  // Future<UserInfoBase> login({
  //   required String code,
  //   required String password,
  // }) async {
  //   try {
  //     state = UserInfoLoading();
  //
  //     final fcmToken = await FirebaseMessaging.instance.getToken();
  //     final resp = await authRepository.login(
  //       loginRequest: LoginRequest(code: code, password: password, fcmToken: fcmToken!),
  //     );
  //     //
  //     await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
  //     await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
  //
  //     final userResp = await userRepository.getUserInfo();
  //
  //     state = userResp;
  //     return userResp;
  //   } catch (e) {
  //     state = UserInfoError(message: '로그인에 실패했습니다.');
  //     return Future.value(state);
  //   }
  // }

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