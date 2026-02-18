import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/shimmer_text.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeader extends StatelessWidget {
  final String? username;
  final String? email;
  final String? imagePath;
  final bool isLoading;

  final int? jobSubmissionCount;
  final int? absenceCount;
  final int? overtimeCount;

  // 🔥 CALLBACKS
  final VoidCallback? onJobSubmissionTap;
  final VoidCallback? onAbsenceTap;
  final VoidCallback? onOvertimeTap;

  const ProfileHeader({
    super.key,
    required this.imagePath,
    this.username,
    this.email,
    this.isLoading = false,
    this.jobSubmissionCount,
    this.absenceCount,
    this.overtimeCount,
    this.onJobSubmissionTap,
    this.onAbsenceTap,
    this.onOvertimeTap,
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isLoading
                    ? _buildShimmerStatItem()
                    : _buildStatItem(
                        'Laporan\nKerja',
                        jobSubmissionCount ?? 0,
                        onTap: onJobSubmissionTap,
                      ),
                isLoading
                    ? _buildShimmerStatItem()
                    : _buildStatItem(
                        'Laporan\nIzin',
                        absenceCount ?? 0,
                        onTap: onAbsenceTap,
                      ),
                isLoading
                    ? _buildShimmerStatItem()
                    : _buildStatItem(
                        'Pengajuan\nLembur',
                        overtimeCount ?? 0,
                        onTap: onOvertimeTap,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const HeroIcon(
                HeroIcons.chevronDown,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildShimmerStatItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShimmerText(width: 40, height: 30),
        const SizedBox(height: 10),
        ShimmerText(width: 60, height: 11),
      ],
    );
  }
}
