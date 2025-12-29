import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'shimmer_text.dart'; // ⬅️ helper shimmer kamu

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
    required this.icon,
    this.isLoading = false,
  });

  final String infoKey;
  final String info;
  final HeroIcons icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          HeroIcon(icon, color: Colors.grey),
          const SizedBox(width: 12),

          // LABEL
          isLoading
              ? const ShimmerText(width: 80, height: 14)
              : Text(
                  infoKey,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),

          isLoading ? const SizedBox.shrink() : const Spacer(),

          // 🔥 VALUE / SHIMMER
          isLoading
              ? const ShimmerText(width: 100, height: 14)
              : Text(
                  info,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }
}
