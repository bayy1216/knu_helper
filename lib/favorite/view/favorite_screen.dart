import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/component/cow_item.dart';
import '../../notice/components/notice_card.dart';
import '../provider/favorite_provider.dart';

import '../../common/layout/default_layout.dart';
import '../../common/utils/data_utils.dart';
import '../../notice/view/notice_web_view.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_provider.dart';

class FilterNoticeSite extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  change(String? site) {
    state = site;
  }
}

final favoriteFilterProvider =
    NotifierProvider<FilterNoticeSite, String?>(FilterNoticeSite.new);

class FavoriteScreen extends ConsumerWidget {
  static const routeName = 'favorite';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteStreamProvider);
    final subScribedSites =
        (ref.watch(userProvider) as UserInfoModel).subscribedSites;
    final filterSite = ref.watch(favoriteFilterProvider);

    return DefaultLayout(
      title: '',
      titleWidget: Row(
        children: [

          filterSite == null ? Text(
            '즐겨찾기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ) : Text(
            filterSite,
            style: TextStyle(
              color: Color(DataUtils.stringToColorCode(
                  subScribedSites.firstWhere((element) => element.site == filterSite).color)),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4.0),
          GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  // return AlertDialog(
                  //   alignment: Alignment.topLeft,
                  //   insetPadding: EdgeInsets.only(left: 10, top: 55),
                  //   contentPadding: const EdgeInsets.all(0),
                  //   content: Container(
                  //     child: Column(
                  //       children: subScribedSites.map((e) {
                  //         return Text(e.site);
                  //       }).toList(),
                  //     ),
                  //   ),
                  // );
                  final vertical = 12.0;
                  final childd = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: vertical),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              ref
                                  .read(favoriteFilterProvider.notifier)
                                  .change(null);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: vertical,
                                horizontal: 18.0,
                              ),
                              child: const Text(
                                '전체',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          ...subScribedSites.map((e) {
                            return InkWell(
                              onTap: () {
                                ref
                                    .read(favoriteFilterProvider.notifier)
                                    .change(e.site);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: vertical,
                                  horizontal: 18.0,
                                ),
                                child: Text(
                                  e.site,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                        DataUtils.stringToColorCode(e.color)),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                  final DialogTheme dialogTheme = DialogTheme.of(context);
                  final dialogChild = Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 180.0,
                        maxWidth: 180.0,
                      ),
                      child: Material(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(4.0),
                        elevation: 0,
                        type: MaterialType.card,
                        child: childd,
                      ),
                    ),
                  );

                  return AnimatedPadding(
                    padding: MediaQuery.viewInsetsOf(context) +
                        (EdgeInsets.only(left: 12, top: 55)),
                    duration: Duration.zero,
                    curve: Curves.decelerate,
                    child: MediaQuery.removeViewInsets(
                      removeLeft: true,
                      removeTop: true,
                      removeRight: true,
                      removeBottom: true,
                      context: context,
                      child: dialogChild,
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.keyboard_arrow_down_outlined),
          ),
        ],
      ),
      body: state.when(
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (data) {
          if (filterSite != null) {
            data = data.where((element) => element.site == filterSite).toList();
          }
          if (data.isEmpty) {
            return const CowItem(content: '즐겨찾기를 추가해 보세요.');
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final model = data[index];
              final colorHexcode = subScribedSites
                  .firstWhere((element) => element.site == model.site)
                  .color;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                      ref
                          .read(favoriteStreamProvider.notifier)
                          .starClick(model: model, isDelete: true);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
