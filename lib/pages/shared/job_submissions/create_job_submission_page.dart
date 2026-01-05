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
  bool _isSearching = false; // 🔍 mode search aktif
  String _query = ''; // keyword pencarian
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCategories = JobCategoryHelper().fetchJobCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JobCategory> _filterCategories(List<JobCategory> categories) {
    if (_query.isEmpty) return categories;

    return categories
        .where((c) => c.name.toLowerCase().contains(_query))
        .toList();
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
        '/gardener/create-job-submission/confirm-job-submission',
        extra: {'category': category, 'image': file},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: _isSearching
            ? AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 1000),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Cari nama jobdesk',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value.toLowerCase();
                    });
                  },
                ),
              )
            : const Text('Buat Laporan Pekerjaan'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _query = '';
                  _searchController.clear();
                });
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),

      floatingActionButton: !_isSearching
          ? FloatingActionButton(
              backgroundColor: Colors.green.shade300,
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              child: HeroIcon(
                HeroIcons.magnifyingGlass,
                color: Colors.green.shade50,
              ),
            )
          : null,

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
          final filteredCategories = _filterCategories(categories);

          if (_query.isNotEmpty && filteredCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Job category "$_query" tidak ditemukan',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];

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
                  title: Text(category.name),
                  subtitle: Text(category.description),
                  trailing: HeroIcon(HeroIcons.camera),
                  onTap: () async {
                    await pickImageFromCamera(category);
                    setState(() {
                      _isSearching = false;
                      _query = '';
                      _searchController.clear();
                    });
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
