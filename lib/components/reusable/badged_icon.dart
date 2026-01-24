import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class BadgedIcon extends StatelessWidget {
  final int count;
  final HeroIcons icon;
  final VoidCallback onPressed;

  const BadgedIcon({
    required this.count,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return IconButton(
        onPressed: onPressed,
        icon: HeroIcon(icon, color: Colors.white),
      );
    }

    return Badge.count(
      offset: const Offset(-3, 7),
      count: count,
      child: IconButton(
        onPressed: onPressed,
        icon: HeroIcon(icon, color: Colors.white),
      ),
    );
  }
}
