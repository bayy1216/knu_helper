import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';
import 'package:knu_helper/user/provider/user_site_provider.dart';

class SelectSiteScreen extends StatefulWidget {
  static String get routeName => 'select_site';

  const SelectSiteScreen({Key? key}) : super(key: key);

  @override
  State<SelectSiteScreen> createState() => _SelectSiteScreenState();
}

class _SelectSiteScreenState extends State<SelectSiteScreen> {
  List<bool> isExpandedList =
      List.generate(SiteCategory.values.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: ListView(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final siteList = ref.watch(userSiteProvider);
              return Column(
                children: siteList
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
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
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          ExpansionPanelList(
            animationDuration: Duration(milliseconds: 500),
            elevation: 1,
            expandedHeaderPadding: EdgeInsets.all(0),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isExpandedList[index] = !isExpanded;
              });
            },
            children: SiteCategory.values
                .map(
                  (category) => ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(category.koreaName,
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      );
                    },
                    body: Column(
                      children: SiteEnum.values
                          .where((element) => element.category == category)
                          .map((site) => Consumer(
                                builder: (context, ref, child) {
                                  return ListTile(
                                    onTap: () {
                                      ref
                                          .read(userSiteProvider.notifier)
                                          .saveSite(
                                            model: SiteColorModel(
                                                site: site.koreaName,
                                                hexCode: 'ff22ff'),
                                          );
                                    },
                                    title: Text(site.koreaName),
                                  );
                                },
                              ))
                          .toList(),
                    ),
                    isExpanded: isExpandedList[category.index],
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
