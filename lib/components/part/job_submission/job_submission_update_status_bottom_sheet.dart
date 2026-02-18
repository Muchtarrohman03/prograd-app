import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/app_snackbar.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';
import 'package:laravel_flutter/components/reusable/custom_dropdown.dart';
import 'package:laravel_flutter/services/api_service.dart';

class JobSubmissionStatusUpdateBottomSheet extends StatefulWidget {
  final int submissionId;
  final String? currentStatus;
  final VoidCallback onSuccess;

  const JobSubmissionStatusUpdateBottomSheet({
    super.key,
    required this.submissionId,
    required this.onSuccess,
    this.currentStatus,
  });

  @override
  State<JobSubmissionStatusUpdateBottomSheet> createState() =>
      _JobSubmissionStatusUpdateBottomSheetState();
}

class _JobSubmissionStatusUpdateBottomSheetState
    extends State<JobSubmissionStatusUpdateBottomSheet> {
  String? selectedStatus;
  bool isLoading = false;

  final List<String> statusList = const ['pending', 'approved', 'rejected'];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus; // auto select status lama
  }

  Future<void> _updateStatus() async {
    if (selectedStatus == null) return;

    // 🔥 Cegah submit kalau status sama
    if (selectedStatus == widget.currentStatus) {
      AppSnackBar.show(
        context,
        message: 'Status tidak perlu berubah',
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService().updateJobSubmissionStatus(
        id: widget.submissionId,
        status: selectedStatus!,
      );

      if (!mounted) return;

      // 🔥 Tutup BottomSheet
      Navigator.pop(context);

      widget.onSuccess();
      AppSnackBar.show(
        context,
        message: 'Status berhasil diperbarui',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      AppSnackBar.show(
        context,
        message: 'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Update Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          CustomDropdown(
            value: selectedStatus,
            hint: 'Pilih status',
            items: statusList,
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
          ),

          const SizedBox(height: 20),

          ConfirmButton(
            isLoading: isLoading,
            text: 'Confirm',
            action: _updateStatus,
          ),
        ],
      ),
    );
  }
}
