import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/info.dart';

class ProfileInfoSection extends StatelessWidget {
  final String username;
  final String email;
  final String role;
  final String division;
  final String gender;
  final bool isLoading;

  const ProfileInfoSection({
    super.key,
    required this.username,
    required this.email,
    required this.role,
    required this.gender,
    required this.division,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          const Text(
            "Info",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Info(
                  infoKey: "Nama",
                  info: username,
                  icon: HeroIcons.user,
                  isLoading: isLoading,
                ),
                Info(
                  infoKey: "Email",
                  info: email,
                  icon: HeroIcons.envelope,
                  isLoading: isLoading,
                ),
                Info(
                  infoKey: "Role",
                  info: role,
                  icon: HeroIcons.identification,
                  isLoading: isLoading,
                ),
                Info(
                  infoKey: "Sektor",
                  info: division,
                  icon: HeroIcons.buildingOffice,
                  isLoading: isLoading,
                ),
                Info(
                  infoKey: "Jenis Kelamin",
                  info: gender,
                  icon: HeroIcons.user,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
