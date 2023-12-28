import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          iconSize: 24,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            _goBranch(index);
          },
          currentIndex: index,
          items: BottomNavPage.values.map((e){
            final icon = BottomNavPage.getIcon(e.index, index);
            return BottomNavigationBarItem(icon: index == e.index
                ? icon.animate().scale(duration: 150.ms,begin: const Offset(0.9, 0.9))
                : icon,
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
  home('홈'),
  favorite('즐겨찾기'),
  all('전체');

  final String korean;
  static SvgPicture getIcon(int index,int currentIndex){
    Color color = index == currentIndex ? PRIMARY_COLOR : const Color(0xff818181);
    return SvgPicture.asset(
      'asset/icons/${BottomNavPage.values[index].name}.svg',
      width: 21,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
  const BottomNavPage(this.korean);
}