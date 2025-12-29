import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/shimmer_text.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeader extends StatelessWidget {
  final String? username;
  final String? email;
  final String? imagePath;
  final bool isLoading;

  const ProfileHeader({
    super.key,
    required this.imagePath,
    this.username,
    this.email,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // AVATAR
          isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(50)),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      imagePath ?? 'assets/images/default_avatar.png',
                    ),
                  ),
                ),

          const SizedBox(height: 12),

          // USERNAME
          isLoading
              ? const ShimmerText(width: 120, height: 18)
              : Text(
                  username!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

          const SizedBox(height: 6),

          // EMAIL
          isLoading
              ? const ShimmerText(width: 180)
              : Text(email!, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
