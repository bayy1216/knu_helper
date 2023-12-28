import 'package:flutter/material.dart';

import '../../common/const/text_style.dart';

class ChipItem extends StatelessWidget {
  final Color color;
  final String text;

  const ChipItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(text, style: chipStyle),
    );
  }
}
