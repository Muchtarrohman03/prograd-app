import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/auto_dismiss_dialog.dart';

class DialogHelper {
  static Future<void> showAutoDismissSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onFinish,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AutoDismissDialog(
        lottiePath: 'assets/lottie/Success.json',
        title: 'Berhasil',
        message: message,
      ),
    );

    await Future.delayed(duration);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    onFinish?.call();
  }

  static Future<void> showAutoDismissError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AutoDismissDialog(
        lottiePath: 'assets/lottie/Error animation.json',
        title: 'Gagal',
        message: message,
      ),
    );

    await Future.delayed(duration);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
