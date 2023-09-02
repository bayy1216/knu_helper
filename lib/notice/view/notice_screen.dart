import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knu_helper/all/provider/user_site_provider.dart';
import 'package:knu_helper/common/components/cow_item.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/model/cursor_pagination_model.dart';
import 'package:knu_helper/notice/components/notice_card.dart';
import 'package:knu_helper/notice/model/notice_model.dart';
import 'package:knu_helper/notice/provider/notice_provider.dart';
import 'package:knu_helper/notice/view/search_notice_screen.dart';


import '../../common/const/admob_id.dart';


class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  final ScrollController controller = ScrollController();


  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    BannerAd(
      adUnitId: Platform.isIOS ? '' : androidAdmobId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Ad loaded.');
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    ).load();
  }


  void listener() async {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      final len = (ref.read(noticeProvider) as CursorPagination).data.length;
      final afterLen = await ref.read(noticeProvider.notifier).paginate(fetchMore: true);
      print('after : $afterLen');
      if(len == afterLen){
        ref.read(noticeProvider.notifier).updateToEnd();
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(noticeProvider);
    final userSite = ref.watch(userSiteProvider);
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
        title: '공지사항',
        actions: [
          IconButton(
            tooltip: '검색',
            onPressed: () {
              context.goNamed(SearchNoticeScreen.routeName);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.search),
          )
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(noticeProvider.notifier).paginate(forceRefetch: true);
          },
          child: userSite.isEmpty ?  const CowItem(content: '설정에서 원하는 사이트를 추가해 보세요') : ListView.separated(
            controller: controller,
            itemCount: cp.data.length + 1,
            itemBuilder: (context, index) {
              if (index == cp.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: cp is CursorPaginationRefetchingMore
                        ? const CircularProgressIndicator()
                        : const Text('마지막 데이터 입니다.'),
                  ),
                );
              }
              if (index == 4) {
                if (_bannerAd  != null) {
                  return Column(
                    children: [
                      Container(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                      NoticeCard.fromModel(
                        model: cp.data[index],
                        isFavorite: cp.isFavorite![index],
                        onStarClick: (value) {
                          ref.read(noticeProvider.notifier).toggleStar(model: cp.data[index], value: value);
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(); // 광고 로드 실패 시 빈 컨테이너를 반환하거나 다른 처리를 수행합니다.
                }
              }


              return NoticeCard.fromModel(
                model: cp.data[index],
                isFavorite: cp.isFavorite![index],
                onStarClick: (value) {
                  ref.read(noticeProvider.notifier).toggleStar(model: cp.data[index], value: value);
                },
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


