import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/components/modal_bottom_sheet.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';
import 'package:knu_helper/notice/view/notice_web_view.dart';
import 'package:knu_helper/user/provider/user_site_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/const/admob_id.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  final ScrollController controller = ScrollController();

  int periodDay = 7;

  late BannerAd banner;

  @override
  void initState() {
    init();
    super.initState();
    controller.addListener(listener);
    banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? '' : androidAdmobId,
      request: const AdRequest(),
    )..load();
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirst = prefs.getBool('isFirst') ?? true;
    if (isFirst) {
      await prefs.setBool('isFirst', false);

      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ModalBottomSheet(),
      ).then((value) async {
        await ref.read(userSiteProvider.notifier).saveSite(
              model: SiteColorModel(
                site: SiteEnum.knu.koreaName,
                hexCode: DataUtils.colorToHexCode(COLOR_SELECT_LIST[0]),
              ),
            );
      });
    }
  }

  void listener() async {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      int result = await ref
          .read(noticeProvider.notifier)
          .paginate(fetchMore: true, periodDay: periodDay);
      print('result:$result');
      if (result == 0) {
        while (result == 0) {
          result = await ref
              .read(noticeProvider.notifier)
              .paginate(fetchMore: true, periodDay: periodDay);
          print('result:$result');
          periodDay += 14;
          if (periodDay >= 98) {
            print('마지막입니다');
            ref.read(noticeProvider.notifier).updateToEnd();
            return;
          }
        }
        periodDay = 7;
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noticeProvider);
    print("[noti]REBUILD");
    if (state is CursorPaginationLoading) {
      return Container(color: Colors.transparent);
    }
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(noticeProvider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시시도'),
          ),
        ],
      );
    }
    final cp = state as CursorPagination<NoticeModel>;

    return SafeArea(
      child: DefaultLayout(
        title: '검색하기',
        actions: [
          IconButton(
            onPressed: () {
              print('gd');
              ref
                  .read(noticeProvider.notifier)
                  .paginate(fetchMore: true, periodDay: 5);
            },
            icon: const Icon(Icons.search),
          )
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(noticeProvider.notifier).paginate(forceRefetch: true);
          },
          child: ListView.separated(
            controller: controller,
            itemCount: cp.data.length + 3,
            itemBuilder: (context, index) {
              if (index == cp.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: cp is CursorPaginationRefetchingMore
                        ? CircularProgressIndicator()
                        : Text('마지막 데이터 입니다.'),
                  ),
                );
              }
              if (index == 4 || index == 11) {
                return Column(
                  children: [
                    AdWidget(
                      ad: banner,
                    ),
                    NoticeCard.fromModel(
                      model: cp.data[index],
                      onStarClick: () {
                        ref.read(databaseProvider).insertNotice(cp.data[index]);
                        ref
                            .read(noticeProvider.notifier)
                            .toggleStar(model: cp.data[index], value: true);
                      },
                      offStarClick: () {
                        ref.read(databaseProvider).deleteNotice(cp.data[index]);
                        ref
                            .read(noticeProvider.notifier)
                            .toggleStar(model: cp.data[index], value: false);
                      },
                      isFavorite: cp.isFavorite![index],
                    ),

                  ],
                );
              }


              return NoticeCard.fromModel(
                model: cp.data[index],
                onStarClick: () {
                  ref.read(databaseProvider).insertNotice(cp.data[index]);
                  ref
                      .read(noticeProvider.notifier)
                      .toggleStar(model: cp.data[index], value: true);
                },
                offStarClick: () {
                  ref.read(databaseProvider).deleteNotice(cp.data[index]);
                  ref
                      .read(noticeProvider.notifier)
                      .toggleStar(model: cp.data[index], value: false);
                },
                isFavorite: cp.isFavorite![index],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8.0);
            },
          ),
        ),
      ),
    );
  }
}
