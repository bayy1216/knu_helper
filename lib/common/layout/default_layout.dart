import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final double elevation;
  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
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
      body: child,
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
      title: Text(
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