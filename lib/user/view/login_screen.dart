import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';

import '../provider/user_provider.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('login_screen');
    return DefaultLayout(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).signUp();
            },
            child: Text('시작하기'),
          ),
          Text('이미 계정이 있으신가요?'),
        ],
      ),
    );
  }
}
