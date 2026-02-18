import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String title;
  final Color color;
  final VoidCallback? onPressed;
  final HeroIcons? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          : icon != null
          ? HeroIcon(icon!, size: 12, color: color)
          : const SizedBox.shrink(),
      label: Text(title, style: TextStyle(fontSize: 12, color: color)),
    );
  }
}
