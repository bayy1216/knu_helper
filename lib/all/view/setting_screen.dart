import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/all/view/open_source_screen.dart';
import 'package:knu_helper/all/view/privacy_screen.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:package_info/package_info.dart';

class SettingScreen extends StatelessWidget {
  static String get routeName => 'setting';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return DefaultLayout(
      title: '설정',
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ListTile(
            onTap: () => context.goNamed(OpensourceScreen.routeName),
            title: const Text('오픈소스 라이선스', style: TextStyle(fontSize: 15)),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () => context.goNamed(PrivacyScreen.routeName),
            title: const Text('개인정보 처리 방침', style: TextStyle(fontSize: 15)),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            title: const Text('앱버전'),
            subtitle: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                else if (snapshot.hasError) {
                  return const Text(
                    'Error',
                    style: TextStyle(fontSize: 20),
                  );
                }
                return Text(snapshot.data!.version);
              }
            ),
          ),
        ],
      ),
    );
  }
}
