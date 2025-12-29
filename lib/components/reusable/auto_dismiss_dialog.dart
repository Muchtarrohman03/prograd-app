import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: unused_element
class AutoDismissDialog extends StatelessWidget {
  final String lottiePath;
  final String title;
  final String message;

  const AutoDismissDialog({
    required this.lottiePath,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(lottiePath, height: 120, repeat: true),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
