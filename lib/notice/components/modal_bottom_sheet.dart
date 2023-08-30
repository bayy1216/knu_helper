import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/utils/data_utils.dart';
import 'package:knu_helper/notice/model/site_color.dart';
import 'package:knu_helper/notice/model/site_enum.dart';

import '../../favorite/provider/user_site_provider.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  List<bool> isSelect = List.generate(SiteEnum.values.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: MediaQuery.of(context).size.width * 0.2,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '학과를 선택해 주세요',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
              SizedBox(height: 8.0),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...SiteEnum.values.map((e) {
                        return Consumer(
                          builder: (context, ref, child) {
                            return Material(
                              child: ListTile(
                                onTap: (){
                                  final model = SiteColorModel(site: e.koreaName, hexCode: DataUtils.colorToHexCode(COLOR_SELECT_LIST[0]));
                                  if(isSelect[e.index]){
                                    ref.read(userSiteProvider.notifier).deleteSite(model: model);
                                  }else{
                                    ref.read(userSiteProvider.notifier).saveSite(model: model);
                                  }

                                  isSelect[e.index] = !isSelect[e.index];
                                  setState(() {});
                                },
                                title: Text(e.koreaName),
                                trailing: isSelect[e.index] ? const Icon(Icons.check) : null,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
