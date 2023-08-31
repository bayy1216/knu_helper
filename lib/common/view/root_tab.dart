import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knu_helper/all/view/all_screen.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/favorite/view/favorite_screen.dart';
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          NoticeScreen(),
          FavoriteScreen(),
          AllScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 22,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            controller.animateTo(index,duration: 200.ms);
          },
          currentIndex: index,
          items: BottomNavPage.values.map((e){
            return BottomNavigationBarItem(icon: index == e.index
                ? e.faIcon.animate().scale(duration: 150.ms,begin: const Offset(0.9, 0.9))
                : e.faIcon,
              label: e.korean,
            );
          }).toList()
        ),
      ),
    );
  }
}


enum BottomNavPage {
  notice('홈', FaIcon(FontAwesomeIcons.house)),
  favorite('즐겨찾기', FaIcon(FontAwesomeIcons.solidStar)),
  all('전체', FaIcon(FontAwesomeIcons.bars));

  final String korean;
  final FaIcon faIcon;

  const BottomNavPage(this.korean, this.faIcon);
}