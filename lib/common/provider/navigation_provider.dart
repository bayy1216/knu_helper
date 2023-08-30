import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/all/view/open_source_screen.dart';
import 'package:knu_helper/all/view/privacy_screen.dart';
import 'package:knu_helper/all/view/select_site_screen.dart';
import 'package:knu_helper/all/view/setting_screen.dart';
import 'package:knu_helper/notice/view/search_notice_screen.dart';

import '../view/root_tab.dart';

final navigationProvider = ChangeNotifierProvider<NavigationProvider>((ref) {
  return NavigationProvider(ref: ref);
});

class NavigationProvider extends ChangeNotifier {
  final Ref ref;

  NavigationProvider({
    required this.ref,
  });

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => RootTab(),
          routes: [
            GoRoute(
              path: 'search_notice',
              name: SearchNoticeScreen.routeName,
              builder: (context, state) => SearchNoticeScreen(),
              routes: [

              ],
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
      ];

  String? redirectLogic(BuildContext context, GoRouterState state) {
    return null;
  }
}
