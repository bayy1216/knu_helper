//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:knu_helper/notice/model/site_color.dart';
// import 'package:knu_helper/notice/model/site_enum.dart';
//
// import '../repository/user_site_repository.dart';
//
// final userSiteProvider = StateNotifierProvider<UserSiteStateNotifier,List<SiteColorModel>>((ref) {
//   final repo = ref.watch(userSiteRepositoryProvider);
//   return UserSiteStateNotifier(repository: repo);
// });
//
// class UserSiteStateNotifier extends StateNotifier<List<SiteColorModel>> {
//   final UserSiteRepository repository;
//
//   UserSiteStateNotifier({required this.repository}) : super([]) {
//     getSite();
//   }
//
//   Future<void> getSite() async {
//     final resp = await repository.getSite();
//     state = resp;
//   }
//
//   Future<void> saveSite({required SiteColorModel model}) async {
//     print('구독 : ${SiteEnum.getType[model.site]!.englishName}');
//     repository.saveSite(model: model);
//     await getSite();
//   }
//
//   Future<void> deleteSite({required SiteColorModel model}) async {
//     repository.deleteSite(model: model);
//     await getSite();
//   }
//
// }
