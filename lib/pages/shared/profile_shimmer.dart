import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HEADER SHIMMER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(radius: 45, backgroundColor: Colors.white),
                  const SizedBox(height: 12),
                  _box(width: 120, height: 18),
                  const SizedBox(height: 6),
                  _box(width: 180, height: 14),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 80, height: 18),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: _box(height: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _box(height: 45),
                  const SizedBox(height: 15),
                  _box(height: 45),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _box({double width = double.infinity, double height = 16}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
