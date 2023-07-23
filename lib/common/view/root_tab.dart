import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knu_helper/all/view/all_screen.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/notice/view/favorite_screen.dart';
import 'package:knu_helper/notice/view/notice_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'root';

  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  late int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          NoticeScreen(),
          FavoriteScreen(),
          // Container(child: Text('2'),),
          AllScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 22,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _tapCount++;
          controller.animateTo(index,duration: 200.ms);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: index == 0
                ? FaIcon(FontAwesomeIcons.house).animate().scale(duration: 150.ms,begin: Offset(0.95, 0.95))
                : FaIcon(FontAwesomeIcons.house),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: index == 1
                ? FaIcon(FontAwesomeIcons.solidStar).animate().scale(duration: 150.ms,begin: Offset(0.95, 0.95))
                : FaIcon(FontAwesomeIcons.solidStar),
            label: '즐겨찾기',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.accessibility),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: index == 2
                ? FaIcon(FontAwesomeIcons.bars).animate().scale(duration: 150.ms,begin: Offset(0.95, 0.95))
                : FaIcon(FontAwesomeIcons.bars),
            label: '전체',
          ),
        ],
      ),
    );
  }
}
