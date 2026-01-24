import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';
import 'package:laravel_flutter/components/reusable/custom_date_picker.dart';
import 'package:laravel_flutter/components/reusable/custom_dropdown.dart';
import 'package:laravel_flutter/components/reusable/custom_image_picker.dart';
import 'package:laravel_flutter/components/reusable/custom_textfield.dart';
import 'package:laravel_flutter/helpers/dialog_helper.dart';
import 'package:laravel_flutter/services/api_service.dart';

class CreateAbsences extends StatefulWidget {
  const CreateAbsences({super.key});

  @override
  State<CreateAbsences> createState() => _CreateAbsencesState();
}

class _CreateAbsencesState extends State<CreateAbsences> {
  File? _imageFile;
  bool isCaptured = true;
  bool isLoading = false;
  String? selectedReason;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        isCaptured = true;
      });
    }
  }

  Future<void> _submitAbsence() async {
    setState(() {
      isLoading = true;
    });

    if (selectedReason == null) {
      _showError('Jelaskan Alasan Izin Anda');
      return;
    }

    if (_imageFile == null) {
      _showError('Lampirkan Foto Bukti');
      return;
    }

    try {
      await ApiService().postAbsence(
        start,
        end,
        selectedReason.toString(),
        _imageFile!,
        descriptionController.text,
      );

      if (!mounted) return;
      await DialogHelper.showAutoDismissSuccess(
        context,
        message: 'Izin telah diajukan, dan menunggu persertujuan !',
      );
      context.pop();
    } catch (e) {
      _showError(e.toString());
      await DialogHelper.showAutoDismissError(
        context,
        message: 'Terjadi kesalahan',
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Buat Izin", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange.shade300,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'alasan absensi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            _splitter(),
            CustomDropdown(
              value: selectedReason,
              borderColor: Colors.orange.shade300,
              hint: 'Pilih alasan absen',
              items: const ['sakit', 'darurat', 'lainnya'],
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                });
              },
            ),
            _spacer(),
            Text(
              'mulai',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            _splitter(),
            CustomDatePicker(
              colorTheme: Colors.orange.shade300,
              date: start,
              onChanged: (value) {
                setState(() {
                  start = value;
                });
              },
            ),
            _spacer(),
            Text(
              'selesai',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            _splitter(),
            CustomDatePicker(
              colorTheme: Colors.orange.shade300,
              date: start,
              onChanged: (value) {
                setState(() {
                  end = value;
                });
              },
            ),
            _spacer(),
            Text(
              'Gambar Bukti',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            _splitter(),
            Container(
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CustomImagePicker(captureAction: pickImageFromCamera),
            ),
            _spacer(),
            Text(
              'deskripsi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            _splitter(),
            CustomTextfield(
              controller: descriptionController,
              hintText: 'Jelaskan Alasannya',
            ),
            _spacer(),
            ConfirmButton(
              buttonColor: Colors.orange.shade300,
              isLoading: isLoading,
              action: _submitAbsence,
              text: "Buat Izin",
            ),
          ],
        ),
      ),
    );
  }

  Widget _spacer() {
    return const SizedBox(height: 20);
  }

  Widget _splitter() {
    return const SizedBox(height: 5);
  }
}
