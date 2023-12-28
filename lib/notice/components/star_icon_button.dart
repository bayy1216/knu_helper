import 'package:flutter/material.dart';

class StarIconButton extends StatelessWidget {
  final bool isFavorite;
  final Function(bool) onStarClick;

  const StarIconButton({
    super.key,
    required this.isFavorite,
    required this.onStarClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onStarClick(isFavorite),
      child: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            crossFadeState: isFavorite
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Icon(
              Icons.star_rounded,
              color: Colors.red,
              size: 30,
            ),
            secondChild: const Icon(
              Icons.star_outline_rounded,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
