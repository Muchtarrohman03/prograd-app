import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/app_snackbar.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';
import 'package:laravel_flutter/components/reusable/custom_dropdown.dart';
import 'package:laravel_flutter/services/api_service.dart';

class AbsenceUpdateStatusBottomSheet extends StatefulWidget {
  final int absenceId;
  final String? currentStatus;
  final VoidCallback onSuccess;
  const AbsenceUpdateStatusBottomSheet({
    super.key,
    required this.absenceId,
    required this.currentStatus,
    required this.onSuccess,
  });

  @override
  State<AbsenceUpdateStatusBottomSheet> createState() =>
      _AbsenceUpdateStatusBottomSheetState();
}

class _AbsenceUpdateStatusBottomSheetState
    extends State<AbsenceUpdateStatusBottomSheet> {
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
      await ApiService().updateAbsence(
        id: widget.absenceId,
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
      AppSnackBar.show(
        context,
        message: 'Gagal memperbarui status',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
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
