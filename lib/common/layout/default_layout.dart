import 'package:flutter/material.dart';

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
    this.elevation = 0,
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
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      foregroundColor: Colors.black,
      actions: actions,
    );
  }
}