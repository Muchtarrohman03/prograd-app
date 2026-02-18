import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final Color? borderColor;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Select item',
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: value,
        borderRadius: BorderRadius.circular(15),
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(hint),
        onChanged: onChanged,
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
      ),
    );
  }
}
