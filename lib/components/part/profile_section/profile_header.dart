import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String email;

  const ProfileHeader({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage('assets/images/gardener_avatar.png'),
          ),
          const SizedBox(height: 12),
          Text(
            username.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
