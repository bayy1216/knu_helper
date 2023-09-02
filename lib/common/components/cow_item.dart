import 'package:flutter/material.dart';

import '../const/text_style.dart';

class CowItem extends StatelessWidget {
  final String content;

  const CowItem({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('asset/images/knu_cow_old.png', width: 160),
          const SizedBox(height: 10.0),
          Text(
            content,
            style: contentCommandStyle,
          ),
        ],
      ),
    );
  }
}
