import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/all/component/message_popup.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/database/drift_database.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

import '../../favorite/provider/user_site_provider.dart';

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
      child: ListView(
        children: [
          ExpansionPanelList(
            animationDuration: Duration(milliseconds: 300),
            elevation: 1,
            expandedHeaderPadding: const EdgeInsets.all(0),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isExpandedList[index] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '선택목록',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: '     밀어서 제거',
                            style: TextStyle(fontSize: 9.0,color: BODY_TEXT_COLOR,fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                    // Text('선택 목록',
                    //     style: TextStyle(fontWeight: FontWeight.w700)),
                  );
                },
                body: Consumer(
                  builder: (context, ref, child) {
                    final siteList = ref.watch(userSiteProvider);
                    return Column(
                      children: siteList.map((e) {
                        return Dismissible(
                          key: Key(e.site), // 고유한 키를 설정합니다.
                          direction: DismissDirection.horizontal, // 오른쪽에서 왼쪽으로 밀어서 실행합니다.
                          onDismissed: (direction) {
                            final data = SiteColorsCompanion(
                              hexCode: Value(e.hexCode),
                              site: Value(e.site),
                            );
                            ref.read(databaseProvider).deleteSiteColor(data);
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
                              await showDialog(
                                context: context,
                                builder: (context) => MessagePopup(
                                  color: Color(
                                      DataUtils.stringToColorCode(e.hexCode)),
                                  title: e.site,
                                  subTitle: "색상을 선택해주세요",
                                  okCallback: (colorHexCode) {
                                    ref.read(databaseProvider).createSiteColor(
                                          SiteColorsCompanion(
                                            hexCode: Value(colorHexCode),
                                            site: Value(e.site),
                                          ),
                                        );
                                  },
                                ),
                              ).then((value)async{
                                await Future.delayed(const Duration(milliseconds: 10));
                                ref.read(userSiteProvider.notifier).getSite();
                              });
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.site),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(
                                              DataUtils.stringToColorCode(e.hexCode)),
                                        ),
                                        width: 20,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1.5,color: Colors.grey,thickness: 0.2),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                isExpanded: isExpandedList[0],
              ),
              ...SiteCategory.values.map((category) {
                int categoryIndex = category.index + 1;
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(category.koreaName,
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    );
                  },
                  body: Column(
                    children: SiteEnum.values
                        .where((element) => element.category == category)
                        .map((site) {
                      return Consumer(
                        builder: (context, ref, child) {
                          return ListTile(
                            onTap: () async{
                              await showDialog(
                                  context: context,
                                  builder: (context) => MessagePopup(
                                color: COLOR_SELECT_LIST.first,
                                title: site.koreaName,
                                subTitle: "색상을 선택해주세요",
                                okCallback: (colorHexCode) {
                                  ref.read(databaseProvider).createSiteColor(
                                    SiteColorsCompanion(
                                      hexCode: Value(colorHexCode),
                                      site: Value(site.koreaName),
                                    ),
                                  );
                                },
                              ),
                              ).then((value)async{
                              await Future.delayed(const Duration(milliseconds: 10));
                              ref.read(userSiteProvider.notifier).getSite();
                              });

                            },
                            title: Text(site.koreaName),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  isExpanded: isExpandedList[categoryIndex],
                );
              }).toList()
            ],
          )
        ],
      ),
    );
  }
}
