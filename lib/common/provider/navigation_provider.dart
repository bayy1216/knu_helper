import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../all/setting/view/open_source_screen.dart';
import '../../all/setting/view/privacy_screen.dart';
import '../../all/setting/view/setting_screen.dart';
import '../../all/site/view/select_site_screen.dart';
import '../../notice/view/notice_web_view.dart';
import '../../notice/view/search_notice_screen.dart';
import '../../user/model/user_model.dart';

import '../../all/view/all_screen.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../notice/view/notice_screen.dart';
import '../../user/provider/user_provider.dart';
import '../../user/view/login_screen.dart';
import '../../user/view/splash_screen.dart';
import '../view/root_tab.dart';
import 'go_router.dart';

final _shellNoticeKey = GlobalKey<NavigatorState>(debugLabel: 'shellNotice');
final _shellFavoriteKey = GlobalKey<NavigatorState>(debugLabel: 'shellFavorite');
final _shellAllKey = GlobalKey<NavigatorState>(debugLabel: 'shellAll');


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

  List<RouteBase> get routes =>
      [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return RootTab(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellNoticeKey,
              routes: [
                GoRoute(
                  path: '/notice',
                  name: NoticeScreen.routeName,
                  builder: (context, state) => const NoticeScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootNavigatorKey,
                      path: 'search_notice',
                      name: SearchNoticeScreen.routeName,
                      builder: (context, state) => SearchNoticeScreen(),
                      routes: const [],
                    ),
                    GoRoute(
                      parentNavigatorKey: rootNavigatorKey,
                      path: 'notice_web_view/:url',
                      name: NoticeWebView.routeName,
                      builder: (context, state){
                        final url = state.pathParameters['url']!;
                        return NoticeWebView(url: url);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellFavoriteKey,
              routes: [
                GoRoute(
                  path: '/favorite',
                  name: FavoriteScreen.routeName,
                  builder: (context, state) => const FavoriteScreen(),
                  routes: const [],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellAllKey,
              routes: [
                GoRoute(
                  path: '/all',
                  name: AllScreen.routeName,
                  builder: (context, state) => const AllScreen(),
                  routes: [
                    GoRoute(
                      path: 'select_site',
                      name: SelectSiteScreen.routeName,
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => const SelectSiteScreen(),
                      routes: const [],
                    ),
                    GoRoute(
                      path: 'setting',
                      name: SettingScreen.routeName,
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => const SettingScreen(),
                      routes: [
                        GoRoute(
                          path: 'opensource',
                          name: OpensourceScreen.routeName,
                          parentNavigatorKey: rootNavigatorKey,
                          builder: (context, state) => const OpensourceScreen(),
                          routes: const [],
                        ),
                        GoRoute(
                          path: 'privacy',
                          name: PrivacyScreen.routeName,
                          parentNavigatorKey: rootNavigatorKey,
                          builder: (context, state) => const PrivacyScreen(),
                          routes: const [],
                        ),
                      ],
                    ),
                  ],
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
            ? '/notice'
            : null;
    //오류 발생시 로그인 화면으로
      case UserInfoError():
        return isTryLogin ? null : '/login';
    }
  }
}
