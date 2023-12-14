import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/all/site/component/message_popup.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

import '../../../notice/model/response/site_model.dart';
import '../../../notice/model/site_color.dart';
import '../../../user/model/user_model.dart';
import '../../../user/provider/user_provider.dart';
import '../provider/site_provider.dart';
import '../provider/user_site_provider.dart';

class SelectSiteScreen extends ConsumerStatefulWidget {
  static String get routeName => 'select_site';

  const SelectSiteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectSiteScreen> createState() => _SelectSiteScreenState();
}

class _SelectSiteScreenState extends ConsumerState<SelectSiteScreen> {



  late bool userSelectExpanded = true;
  late List<bool> isExpandedList = [];


  @override
  Widget build(BuildContext context) {
    final siteNotifier = ref.watch(asyncSiteNotifier);

    return DefaultLayout(
      body: ListView(
        children: [
          ListTile(
            title: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '선택목록',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '     밀어서 제거',
                    style: TextStyle(
                      fontSize: 9.0,
                      color: BODY_TEXT_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            trailing: userSelectExpanded ?
              const Icon(Icons.keyboard_arrow_up_outlined) :
              const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: () {
              setState(() {
                userSelectExpanded = !userSelectExpanded;
              });
            },
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Consumer(
              builder: (context, ref, child) {
                final siteList = (ref.watch(userProvider) as UserInfoModel).subscribedSites;
                return Column(
                  children: siteList.map((e) {
                    return Dismissible(
                      key: Key(e.site),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) {
                        return Future.value(true);
                      },
                      // 오른쪽에서 왼쪽으로 밀어서 실행합니다.
                      onDismissed: (direction) {
                        ref.read(userProvider.notifier).deleteUserFavoriteSite(site: e.site);
                      },
                      background: Container(
                        color: PRIMARY_COLOR, // 밀어서 실행하는 배경 색상
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await selectSite(context, e.site, ref,update: true);
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.site),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(DataUtils.stringToColorCode(e.color)),
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 1.5,
                              color: Colors.grey,
                              thickness: 0.2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            crossFadeState: userSelectExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 150),
          ),
          Divider(color: Colors.grey, thickness: 0.2, height: 1.5),
          siteNotifier.when(
            data: (List<SiteModel> data) {


              Map<String, List<SiteModel>> siteMap = {};
              data.forEach((e) {
                siteMap.putIfAbsent(e.siteCategoryKorean, () => []);
                siteMap[e.siteCategoryKorean]!.add(e);
              });
              final siteCategory = siteMap.keys;
              final tempList = List.generate(siteCategory.length, (index) => false);
              if(isExpandedList.isEmpty) isExpandedList.addAll(tempList);


              return Column(
                children: siteCategory.map((category){
                  final index = siteCategory.toList().indexOf(category);

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          category,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: isExpandedList[index] ?
                        const Icon(Icons.keyboard_arrow_up_outlined) :
                        const Icon(Icons.keyboard_arrow_down_outlined),
                        onTap: () {
                          setState(() {
                            isExpandedList[index] =
                            !isExpandedList[index];
                          });
                        },
                      ),
                      AnimatedCrossFade(
                        firstChild: Container(),
                        secondChild: Column(
                          children: siteMap[category]!.map((model) {
                            return Column(
                              children: [
                                Consumer(
                                  builder: (context, ref, child) {
                                    return InkWell(
                                      onTap: () async {
                                        await selectSite(context, model.site, ref);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(model.site,style: TextStyle(fontSize: 16.0),),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        crossFadeState: isExpandedList[index]
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 150),
                      ),
                      Divider(color: Colors.grey, thickness: 0.2, height: 1.5)
                    ],
                  );
                }).toList(),
              );

            },
            error: (error, stackTrace) => const SizedBox(),
            loading: () => const SizedBox(),
          ),

        ],
      ),
    );
  }

  Future<void> selectSite(BuildContext context, String site, WidgetRef ref,{bool update = false}) async {
    await showDialog(
      context: context,
      builder: (context) => MessagePopup(
        color: COLOR_SELECT_LIST.first,
        title: site,
        subTitle: "색상을 선택해주세요",
        okCallback: (colorHexCode) {
          if(update){
            ref.read(userProvider.notifier).updateUserFavoriteSite(
              site: site, color: colorHexCode, isAlarm: true,
            );
            return;
          }
          ref.read(userProvider.notifier).addUserFavoriteSite(
            site: site, color: colorHexCode, alarm: true,
          );
          //ref.read(userSiteProvider.notifier).saveSite(model: model);
        },
      ),
    );
    // await Future.delayed(const Duration(milliseconds: 10));
    // ref.read(userSiteProvider.notifier).getSite();
  }


}
