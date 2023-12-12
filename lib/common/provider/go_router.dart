import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/provider/navigation_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(navigationProvider);
  return GoRouter(
    debugLogDiagnostics: true,
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});