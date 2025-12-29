import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laravel_flutter/helpers/dialog_helper.dart';

import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';

class ConfirmJobSubmissionPage extends StatefulWidget {
  final JobCategory category;
  final File imageFile;

  const ConfirmJobSubmissionPage({
    super.key,
    required this.category,
    required this.imageFile,
  });

  @override
  State<ConfirmJobSubmissionPage> createState() =>
      _ConfirmJobSubmissionPageState();
}

class _ConfirmJobSubmissionPageState extends State<ConfirmJobSubmissionPage> {
  bool isLoading = false;

  Future<void> _submitJobSubmission() async {
    setState(() => isLoading = true);

    try {
      await ApiService().postJobSubmission(
        widget.category.id,
        widget.imageFile,
      );

      if (!mounted) return;

      await DialogHelper.showAutoDismissSuccess(
        context,
        message: 'Laporanmu berhasil dibuat !',
        onFinish: () {
          context.pop();
        },
      );
    } catch (e) {
      if (!mounted) return;

      await DialogHelper.showAutoDismissError(
        context,
        message: 'Terjadi kesalahan',
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Job Submission')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Nama job category
              Text(
                widget.category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// Preview image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  widget.imageFile,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const Spacer(),

              /// Tombol konfirmasi
              ConfirmButton(
                isLoading: isLoading,
                text: 'Konfirmasi Pengajuan',
                action: _submitJobSubmission,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
