import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/all/setting/view/open_source_screen.dart';
import 'package:knu_helper/all/setting/view/privacy_screen.dart';
import 'package:knu_helper/all/site/view/select_site_screen.dart';
import 'package:knu_helper/notice/view/search_notice_screen.dart';
import 'package:knu_helper/user/model/user_model.dart';

import '../../all/setting/view/setting_screen.dart';
import '../../user/provider/user_provider.dart';
import '../../user/view/login_screen.dart';
import '../../user/view/splash_screen.dart';
import '../view/root_tab.dart';

final navigationProvider = ChangeNotifierProvider<NavigationProvider>((ref) {
  return NavigationProvider(ref: ref);
});

class NavigationProvider extends ChangeNotifier {
  final Ref ref;

  NavigationProvider({required this.ref}) {
    ref.listen(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes =>
      [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => RootTab(),
          routes: [
            GoRoute(
              path: 'search_notice',
              name: SearchNoticeScreen.routeName,
              builder: (context, state) => SearchNoticeScreen(),
              routes: [],
            ),
            GoRoute(
              path: 'select_site',
              name: SelectSiteScreen.routeName,
              builder: (context, state) => SelectSiteScreen(),
              routes: [],
            ),
            GoRoute(
              path: 'setting',
              name: SettingScreen.routeName,
              builder: (context, state) => SettingScreen(),
              routes: [
                GoRoute(
                  path: 'opensource',
                  name: OpensourceScreen.routeName,
                  builder: (context, state) => OpensourceScreen(),
                  routes: [],
                ),
                GoRoute(
                  path: 'privacy',
                  name: PrivacyScreen.routeName,
                  builder: (context, state) => PrivacyScreen(),
                  routes: [],
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
      ];

  void logout() {
    ref.read(userProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final user = ref.read(userProvider);

    final isTryLogin = state.fullPath == '/login';

    switch (user) {
    //유저정보 없을시,
    //로그인중이면 그대로, 아니면 로그인 화면으로 가게한다.
      case null:
        return isTryLogin ? null : '/login';
    //유저정보 로딩중이면 그대로
      case UserInfoLoading():
        return null;
    //유저정보 있을시
    //로그인 중이거나, 현재위치가 첫화면일경우 홈으로 가게한다
      case UserInfoModel():
        return isTryLogin || state.fullPath == '/splash'
            ? '/'
            : null;
    //오류 발생시 로그인 화면으로
      case UserInfoError():
        return isTryLogin ? null : '/login';
    }
  }
}
