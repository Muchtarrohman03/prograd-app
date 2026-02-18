import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class RoundedHistoryTile extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String? subtitle;
  final List<Widget> details;

  const RoundedHistoryTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: HeroIcon(icon, color: Colors.green.shade800, size: 20),
        ),

        // 🔥 Gunakan Column agar subtitle benar-benar optional
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),

        children: details,
      ),
    );
  }
}
