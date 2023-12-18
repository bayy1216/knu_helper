import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/component/cow_item.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/favorite/provider/favorite_provider.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';

import '../../common/utils/data_utils.dart';
import '../../notice/view/notice_web_view.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_provider.dart';

class FavoriteScreen extends ConsumerWidget {
  static const routeName = 'favorite';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteStreamProvider);
    final subScribedSites = (ref.watch(userProvider) as UserInfoModel).subscribedSites;

    return state.when(
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        if(data.isEmpty){
          return CowItem(content: '증겨찾기를 추가해 보세요.');
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final model = data[index];
            final colorHexcode = subScribedSites.firstWhere((element) => element.site == model.site).color;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  context.goNamed(
                    NoticeWebView.favoriteRouteName,
                    pathParameters: {'url': model.url},
                  );
                },
                child: NoticeCard.fromModel(
                  color: Color(DataUtils.stringToColorCode(colorHexcode)),
                  model: model,
                  isFavorite: true,
                  onStarClick: (value) {
                    ref.read(favoriteStreamProvider.notifier).starClick(model: model, isDelete: true);
                  },
                ),
              ),
            );
          },
        );
      },
    );


  }
}
