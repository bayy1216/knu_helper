import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/all/view/open_source_screen.dart';
import 'package:knu_helper/all/view/select_site_screen.dart';
import 'package:knu_helper/all/view/setting_screen.dart';
import 'package:knu_helper/notice/view/notice_web_view.dart';

import '../../common/view/root_tab.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  });

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => RootTab(),
          routes: [
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
              ],
            ),
          ],
        ),
      ];

  String? redirectLogic(BuildContext context, GoRouterState state) {
    return null;
  }
}
