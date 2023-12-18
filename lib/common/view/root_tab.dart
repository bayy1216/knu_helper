import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:knu_helper/all/view/all_screen.dart';
import 'package:knu_helper/common/const/color.dart';
import 'package:knu_helper/common/layout/default_layout.dart';
import 'package:knu_helper/favorite/view/favorite_screen.dart';
import 'package:knu_helper/notice/view/notice_screen.dart';

class RootTab extends StatelessWidget {
  static String get routeName => 'root';
  final StatefulNavigationShell navigationShell;

  const RootTab({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    return DefaultLayout(
      body: navigationShell,
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
            _goBranch(index);
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

  void _goBranch(int index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
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