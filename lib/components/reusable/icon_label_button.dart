import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class IconLabelButton extends StatelessWidget {
  final HeroIcons icon;
  final String label;
  final Color iconcolor;
  final Color containercolor;
  final VoidCallback onPressed;

  const IconLabelButton({
    super.key,
    required this.icon,
    required this.iconcolor,
    required this.containercolor,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: containercolor,
              shadowColor: Colors.grey.withValues(alpha: 0.3),
              elevation: 4,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: HeroIcon(
              icon,
              size: 40,
              color: iconcolor,
              style: HeroIconStyle.solid,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,

          child: Text(
            label,
            textAlign: TextAlign.center,
            softWrap: true, // biar teks bisa turun
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }
}
