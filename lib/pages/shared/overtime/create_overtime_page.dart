import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/badged_icon.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/helpers/job_category_helpers.dart';
import 'package:laravel_flutter/models/job_category.dart';
// import 'package:laravel_flutter/providers/job_submission_draft_provider.dart';
import 'package:laravel_flutter/providers/overtime_draft_provider.dart';

class CreateOvertimePage extends ConsumerStatefulWidget {
  const CreateOvertimePage({super.key});

  @override
  ConsumerState<CreateOvertimePage> createState() => _CreateOvertimePageState();
}

class _CreateOvertimePageState extends ConsumerState<CreateOvertimePage> {
  late Future<List<JobCategory>> _futureCategories;
  bool _isCreatingDraft = false;
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

  @override
  Widget build(BuildContext context) {
    final draftCount = ref.watch(overtimeDraftListProvider).length;
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade300,
        centerTitle: true,
        title: _isSearching
            ? AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 1000),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Cari nama jobdesk',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value.toLowerCase();
                    });
                  },
                ),
              )
            : const Text(
                'Buat Draft Lembur',
                style: TextStyle(color: Colors.white),
              ),

        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _query = '';
                      _searchController.clear();
                    });
                    FocusScope.of(context).unfocus();
                  },
                )
              : BadgedIcon(
                  count: draftCount,
                  onPressed: () {
                    context.pushNamed('overtime-draft');
                  },
                  icon: HeroIcons.clock,
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
                return ShimmerTile(
                  baseColor: Colors.green.shade100,
                  highlightColor: Colors.green.shade50,
                );
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
                    child: HeroIcon(HeroIcons.clock, color: Colors.green[800]),
                  ),
                  title: Text(category.name),
                  subtitle: Text(category.description ?? 'Tidak ada deskripsi'),
                  trailing: const HeroIcon(HeroIcons.plusCircle),

                  onTap: () async {
                    if (_isCreatingDraft) return;

                    setState(() => _isCreatingDraft = true);

                    try {
                      // 🔥 SATU-SATUNYA CARA BUAT DRAFT
                      await ref
                          .read(overtimeDraftListProvider.notifier)
                          .createDraft(category: category);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: Text(
                            'Draft "${category.name}" berhasil dibuat',
                          ),
                          backgroundColor: Colors.green.shade600,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Gagal membuat draft job submission',
                          ),
                          backgroundColor: Colors.red.shade600,
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isCreatingDraft = false);
                      }
                    }

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
