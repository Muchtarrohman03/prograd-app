import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/helpers/job_category_helpers.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shimmer/shimmer.dart';

class JobCategoryAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<JobCategory?> onSelected;
  final JobCategory? initialValue;
  final String hint;

  const JobCategoryAutocompleteField({
    super.key,
    required this.onSelected,
    required this.controller,
    this.initialValue,
    this.hint = 'Cari kategori pekerjaan',
  });

  @override
  State<JobCategoryAutocompleteField> createState() =>
      _JobCategoryAutocompleteFieldState();
}

class _JobCategoryAutocompleteFieldState
    extends State<JobCategoryAutocompleteField> {
  final _controller = TextEditingController();
  final _helper = JobCategoryHelper();

  List<SearchFieldListItem<JobCategory>> _suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!.name;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _helper.fetchJobCategories();

      setState(() {
        _suggestions = categories
            .map(
              (category) => SearchFieldListItem<JobCategory>(
                category.name,
                item: category,
              ),
            )
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    return SearchField<JobCategory>(
      controller: widget.controller,
      suggestions: _suggestions,
      hint: widget.hint,
      suggestionState: Suggestion.expand,
      maxSuggestionsInViewPort: 6,
      itemHeight: 50,
      searchInputDecoration: SearchInputDecoration(
        prefixIcon: const HeroIcon(HeroIcons.clipboardDocumentList),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      onSuggestionTap: (SearchFieldListItem<JobCategory> item) {
        widget.onSelected(item.item);
      },
      emptyWidget: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Kategori tidak ditemukan',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
