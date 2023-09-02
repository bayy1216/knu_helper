import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/components/cow_item.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/favorite/provider/favorite_provider.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoriteProvider);
    print("[favo]REBUILD");
    if(state.isEmpty){
      return const CowItem(content:'즐겨찾기를 추가해 보세요');
    }

    return ListView.separated(
      itemCount: state.length,
      itemBuilder: (context, index) {
        return NoticeCard.fromModel(
          model: state[index],
          isFavorite: true,
          onStarClick: (value) {
            ref.read(noticeProvider.notifier).toggleStar(model: state[index], value: value);
            ref.read(favoriteProvider.notifier).getFavorite();
          },
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }
}
