import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';
import 'package:laravel_flutter/components/reusable/custom_image_picker.dart';
import 'package:laravel_flutter/components/reusable/custom_textfield.dart';
import 'package:laravel_flutter/components/reusable/custom_time_picker.dart';
import 'package:laravel_flutter/components/reusable/jobcategory_auto_complete_field.dart';
import 'package:laravel_flutter/helpers/dialog_helper.dart';
import 'package:laravel_flutter/helpers/job_category_helpers.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:searchfield/searchfield.dart';

class CreateOvertime extends StatefulWidget {
  const CreateOvertime({super.key});

  @override
  State<CreateOvertime> createState() => _CreateOvertimeState();
}

class _CreateOvertimeState extends State<CreateOvertime> {
  File? _imageFile;

  bool isCaptured = true;
  bool isLoading = false;

  JobCategory? selectedCategory;
  List<SearchFieldListItem<JobCategory>> jobCategorySuggestions = [];

  final _JobCategoryController = TextEditingController();
  final _helper = JobCategoryHelper();

  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay _timeStart = TimeOfDay.now();
  TimeOfDay _timeEnd = TimeOfDay(hour: 0, minute: 0);
  bool _isTimeAfter(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  Future<void> _fetchJobCategories() async {
    try {
      final categories = await _helper.fetchJobCategories();

      setState(() {
        jobCategorySuggestions = categories
            .map((e) => SearchFieldListItem<JobCategory>(e.name, item: e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

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

  Future<void> _submitOvertime() async {
    if (selectedCategory == null) {
      _showError('Jenis pekerjaan wajib dipilih');
      return;
    }

    if (_imageFile == null) {
      _showError('Foto pekerjaan wajib diambil');
      return;
    }

    if (!_isTimeAfter(_timeStart, _timeEnd)) {
      _showError('Waktu selesai harus setelah waktu mulai');
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService().postOvertime(
        selectedCategory!.id,
        _timeStart,
        _timeEnd,
        _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        _imageFile!,
      );

      if (!mounted) return;
      await DialogHelper.showAutoDismissSuccess(
        context,
        message: 'Lembur berhasil Diajukan !',
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
  void initState() {
    super.initState();
    _fetchJobCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Buat Lembur", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Jenis Pekerjaan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                JobCategoryAutocompleteField(
                  controller: _JobCategoryController,
                  onSelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  suggestions: jobCategorySuggestions,
                  isLoading: isLoading,
                ),
                SizedBox(height: 15),
                Text(
                  'Waktu Lembur',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'mulai',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            CustomTimePicker(
                              time: _timeStart,
                              onChanged: (value) {
                                setState(() {
                                  _timeStart = value; // ⬅️ otomatis +7 jam
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'selesai',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            CustomTimePicker(
                              time: _timeEnd,
                              onChanged: (value) {
                                setState(() {
                                  _timeEnd = value; // tetap bisa diedit manual
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                CustomTextfield(
                  controller: _descriptionController,
                  hintText: 'Tuliskan deskripsi (opsional)',
                ),
                SizedBox(height: 15),
                Text(
                  'Foto Perkerjaan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
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

                SizedBox(height: 20),
                ConfirmButton(
                  isLoading: isLoading,
                  action: _submitOvertime,
                  text: 'Ajukan Lembur',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
