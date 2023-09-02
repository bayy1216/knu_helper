import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/all/component/message_popup.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

import '../../notice/model/site_color.dart';
import '../provider/user_site_provider.dart';

class SelectSiteScreen extends StatefulWidget {
  static String get routeName => 'select_site';

  const SelectSiteScreen({Key? key}) : super(key: key);

  @override
  State<SelectSiteScreen> createState() => _SelectSiteScreenState();
}

class _SelectSiteScreenState extends State<SelectSiteScreen> {
  List<bool> isExpandedList = List.generate(
      SiteCategory.values.length + 1, (index) => index == 0 ? true : false);

  @override
  Widget build(BuildContext context) {
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
            trailing: isExpandedList[0] ?
              const Icon(Icons.keyboard_arrow_up_outlined) :
              const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: () {
              setState(() {
                isExpandedList[0] = !isExpandedList[0];
              });
            },
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Consumer(
              builder: (context, ref, child) {
                final siteList = ref.watch(userSiteProvider);
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
                        ref.read(databaseProvider).deleteSiteColor(e);
                        ref.read(userSiteProvider.notifier).getSite();
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
                          await showDialogToSelect(context, e, ref);
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
                                      color: Color(DataUtils.stringToColorCode(e.hexCode)),
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
            crossFadeState: isExpandedList[0] ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 150),
          ),
          Divider(color: Colors.grey, thickness: 0.2, height: 1.5),
          ...SiteCategory.values.map((category) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    category.koreaName,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: isExpandedList[category.index + 1] ?
                  const Icon(Icons.keyboard_arrow_up_outlined) :
                  const Icon(Icons.keyboard_arrow_down_outlined),
                  onTap: () {
                    setState(() {
                      isExpandedList[category.index + 1] =
                          !isExpandedList[category.index + 1];
                    });
                  },
                ),
                AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Column(
                    children: SiteEnum.values
                        .where((element) => element.category == category)
                        .map((site) {
                      return Column(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              return InkWell(
                                onTap: () async {
                                  await selectSite(context, site, ref);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(site.koreaName,style: TextStyle(fontSize: 16.0),),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  crossFadeState: isExpandedList[category.index + 1]
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 150),
                ),
                Divider(color: Colors.grey, thickness: 0.2, height: 1.5)
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> selectSite(BuildContext context, SiteEnum site, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => MessagePopup(
        color: COLOR_SELECT_LIST.first,
        title: site.koreaName,
        subTitle: "색상을 선택해주세요",
        okCallback: (colorHexCode) {
          final model = SiteColorModel(
            site: site.koreaName,
            hexCode: colorHexCode,
          );
          ref.read(databaseProvider).createSiteColor(model);
        },
      ),
    );
    await Future.delayed(const Duration(milliseconds: 10));
    ref.read(userSiteProvider.notifier).getSite();
  }

  Future<void> showDialogToSelect(BuildContext context, SiteColorModel e, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => MessagePopup(
        color: Color(DataUtils.stringToColorCode(e.hexCode)),
        title: e.site,
        subTitle: "색상을 선택해주세요",
        okCallback: (colorHexCode) {
          final model = SiteColorModel(
            site: e.site,
            hexCode: colorHexCode,
          );
          ref.read(databaseProvider).createSiteColor(model);
        },
      ),
    );
    await Future.delayed(const Duration(milliseconds: 10));
    ref.read(userSiteProvider.notifier).getSite();
  }
}
