import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class WelcomeAppbar extends StatelessWidget {
  const WelcomeAppbar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hallo,\n$name.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: HeroIcon(
              HeroIcons.bell,
              style: HeroIconStyle.solid,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
