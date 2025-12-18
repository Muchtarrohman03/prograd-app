import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
    required this.icon,
  });

  final String infoKey;
  final String info;
  final HeroIcons icon; // ✅ ganti tipe data jadi HeroIcons

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),

      child: Row(
        children: [
          HeroIcon(
            icon, // ✅ langsung pakai
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            infoKey,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const Spacer(),
          Text(info, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
