import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  // Properti umum yang dapat disesuaikan dari luar
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color confirmColor;
  final VoidCallback? onCancel; // VoidCallback? agar opsional

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = "Ya", // Nilai default
    this.cancelText = "Batal", // Nilai default
    required this.confirmColor,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title, // Menggunakan properti title
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content), // Menggunakan properti content
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Batal
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {
                // Pop dialog, lalu panggil onCancel jika ada
                Navigator.pop(context);
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
            // Tombol Konfirmasi
            TextButton(
              style: TextButton.styleFrom(foregroundColor: confirmColor),
              onPressed: () {
                // Pop dialog, lalu panggil fungsi onConfirm
                Navigator.pop(context);
                onConfirm();
              },
              child: Text(confirmText),
            ),
          ],
        ),
      ],
    );
  }
}

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  required Color confirmColor,
  String confirmText = "Ya",
  String cancelText = "Batal",
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    // Gunakan 'builder' untuk memanggil widget CustomAlertDialog
    builder: (BuildContext dialogContext) {
      return CustomAlertDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
        confirmText: confirmText,
        cancelText: cancelText,
        onCancel: onCancel,
        confirmColor: confirmColor,
      );
    },
  );
}
