import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ActionListTile extends StatelessWidget {
  const ActionListTile({
    super.key,
    required this.title,
    required this.heroicon,
    required this.onTap,
    this.iconcolor,
    this.textcolor,
    this.trailing,
  });

  final String title;
  final HeroIcons heroicon;
  final Widget? trailing;
  final Color? textcolor;
  final Color? iconcolor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: textcolor ?? Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: HeroIcon(heroicon, color: iconcolor ?? Colors.grey),
        trailing:
            trailing ??
            const Icon(CupertinoIcons.forward, color: Colors.grey, size: 18),
      ),
    );
  }
}
