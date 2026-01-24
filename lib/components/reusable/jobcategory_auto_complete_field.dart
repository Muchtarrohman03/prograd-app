import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shimmer/shimmer.dart';

class JobCategoryAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<JobCategory?> onSelected;
  final List<SearchFieldListItem<JobCategory>> suggestions;
  final bool isLoading;
  final String hint;

  const JobCategoryAutocompleteField({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.suggestions,
    required this.isLoading,
    this.hint = 'Cari kategori pekerjaan',
  });

  @override
  State<JobCategoryAutocompleteField> createState() =>
      _JobCategoryAutocompleteFieldState();
}

class _JobCategoryAutocompleteFieldState
    extends State<JobCategoryAutocompleteField> {
  @override
  Widget build(BuildContext context) {
    return SearchField<JobCategory>(
      controller: widget.controller,
      suggestions: widget.isLoading
          ? _shimmerSuggestions()
          : widget.suggestions,
      hint: widget.hint,
      suggestionState: Suggestion.expand,
      itemHeight: 50,
      maxSuggestionsInViewPort: 6,
      searchInputDecoration: SearchInputDecoration(
        prefixIcon: const HeroIcon(HeroIcons.clipboardDocumentList),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      onSuggestionTap: (item) {
        widget.controller.text = item.searchKey;
        widget.onSelected(item.item);
      },
      emptyWidget: widget.isLoading
          ? const SizedBox.shrink()
          : const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Kategori tidak ditemukan',
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }

  /// 👇 shimmer muncul di suggestion list
  List<SearchFieldListItem<JobCategory>> _shimmerSuggestions() {
    return List.generate(
      5,
      (index) => SearchFieldListItem<JobCategory>(
        '',
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
