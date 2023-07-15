import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/provider/favorite_provider.dart';
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

    return ListView.separated(
      itemCount: state.length,
      itemBuilder: (context, index) {
        return NoticeCard.fromModel(
          model: state[index],
          onStarClick: (){
            ref.read(databaseProvider).insertNotice(state[index]);
            ref.read(noticeProvider.notifier).toggleStar(model: state[index], value: true);
            print("[favo]onstar");
          },
          offStarClick: () {
            ref.read(databaseProvider).deleteNotice(state[index]);
            ref.read(noticeProvider.notifier).toggleStar(model: state[index], value: false);
          },
          isFavorite: true,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }
}
