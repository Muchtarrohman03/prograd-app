import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? labeltext;
  final String? hintText;
  final Color? borderColor;
  const CustomTextfield({
    super.key,
    required this.controller,
    this.labeltext,
    this.hintText,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: labeltext,
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
