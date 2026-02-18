import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/helpers/job_category_helpers.dart';

/// ==========================
/// JOB CATEGORIES (API)
/// ==========================
final jobCategoriesProvider = FutureProvider<List<JobCategory>>((ref) async {
  return JobCategoryHelper().fetchJobCategories();
});

/// ==========================
/// SEARCH QUERY
/// ==========================
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

/// ==========================
/// SEARCH MODE
/// ==========================
class IsSearchingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void open() => state = true;
  void close() => state = false;
}

final isSearchingProvider = NotifierProvider<IsSearchingNotifier, bool>(
  IsSearchingNotifier.new,
);

/// ==========================
/// CREATING DRAFT FLAG
/// ==========================
class IsCreatingDraftNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;
  void stop() => state = false;
}

final isCreatingDraftProvider = NotifierProvider<IsCreatingDraftNotifier, bool>(
  IsCreatingDraftNotifier.new,
);

/// ==========================
/// TEXT CONTROLLER
/// ==========================
final searchControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// ==========================
/// FILTERED CATEGORIES
/// ==========================
final filteredCategoriesProvider = Provider<AsyncValue<List<JobCategory>>>((
  ref,
) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final categoriesAsync = ref.watch(jobCategoriesProvider);

  return categoriesAsync.whenData((categories) {
    if (query.isEmpty) return categories;

    return categories
        .where((c) => c.name.toLowerCase().contains(query))
        .toList();
  });
});
