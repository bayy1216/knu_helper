import 'package:flutter/material.dart';
import 'package:knu_helper/common/const/text_style.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final String? title;
  final Widget? titleWidget;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final double elevation;
  const DefaultLayout({
    required this.body,
    this.backgroundColor,
    this.title,
    this.titleWidget,
    this.actions,
    this.bottomNavigationBar,
    this.elevation = 1.5,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(){
    if(title == null){
      return null;
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: elevation,
      title: titleWidget ?? Text(
        title!,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,

        ),
      ),
      centerTitle: false,
      foregroundColor: Colors.black,
      actions: actions,
    );
  }
}