import 'package:flutter/material.dart';

class Ilustration extends StatelessWidget {
  final String message;
  final String imagePath;
  const Ilustration({
    super.key,
    required this.message,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
