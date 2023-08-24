import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/utils/data_utils.dart';

class MessagePopup extends StatefulWidget {
  final String title;
  final String subTitle;
  final Color color;
  final Function(String value) okCallback;

  const MessagePopup({
    Key? key,
    required this.color,
    required this.title,
    required this.okCallback,
    required this.subTitle,
  }) : super(key: key);

  @override
  State<MessagePopup> createState() => _MessagePopupState();
}

class _MessagePopupState extends State<MessagePopup> {
  late Color selectColor;
  @override
  void initState() {
    super.initState();
    selectColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.zero,
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.subTitle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              crossAxisCount: 5, // 열의 개수
              shrinkWrap: true, // 크기에 맞게 축소
              physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
              childAspectRatio: 1, // 가로와 세로 비율을 1:1로 설정
              children: COLOR_SELECT_LIST.map((e) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectColor = e;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 원형 모양 설정
                      color: e,
                      border: Border.all(
                        color: selectColor == e ? Colors.grey : Colors.white,
                        width: selectColor == e ? 2.0 : 0.0,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: Text('취소'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.okCallback(DataUtils.colorToHexCode(selectColor));
                        context.pop();
                      },
                      child: Text('확인'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}