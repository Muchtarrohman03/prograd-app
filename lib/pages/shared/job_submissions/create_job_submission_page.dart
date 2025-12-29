import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/helpers/job_category_helpers.dart';
import 'package:laravel_flutter/models/job_category.dart';

class CreateJobSubmissionPage extends StatefulWidget {
  const CreateJobSubmissionPage({super.key});

  @override
  State<CreateJobSubmissionPage> createState() =>
      _CreateJobSubmissionPageState();
}

class _CreateJobSubmissionPageState extends State<CreateJobSubmissionPage> {
  late Future<List<JobCategory>> _futureCategories;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureCategories = JobCategoryHelper().fetchJobCategories();
  }

  Future<void> pickImageFromCamera(JobCategory category) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      final file = File(image.path);

      if (!mounted) return;

      context.push(
        '/gardener/job-submission/confirm-job-submission',
        extra: {'category': category, 'image': file},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Buat Laporan Pekerjaan'),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade300,
        onPressed: () {},
        child: HeroIcon(HeroIcons.magnifyingGlass, color: Colors.green.shade50),
      ),
      body: FutureBuilder<List<JobCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ShimmerTile();
              },
            );
          }

          // error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // data kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Job category tidak tersedia'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Card(
                color: Colors.grey.shade50,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: HeroIcon(
                      HeroIcons.documentText,
                      color: Colors.green[800],
                    ),
                  ),
                  title: Text(
                    category.name, // ✅ hanya field name
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    category.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  trailing: HeroIcon(
                    HeroIcons.camera,
                    color: Colors.grey.shade800,
                  ),
                  onTap: () async {
                    await pickImageFromCamera(category);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
