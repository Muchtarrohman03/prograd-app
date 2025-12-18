import 'package:flutter/material.dart';

class RoundedInputText extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String labeldata;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final bool isPassword; // ✅ opsional password

  const RoundedInputText({
    super.key,
    required this.hintText,
    required this.controller,
    required this.labeldata,
    required this.icon,
    this.validator,
    this.isPassword = false, // default bukan password
  });

  @override
  State<RoundedInputText> createState() => _RoundedInputTextState();
}

class _RoundedInputTextState extends State<RoundedInputText> {
  bool _obscureText = true; // ✅ default password tertutup

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // aktifkan kalau password
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        cursorColor: Colors.grey,
        controller: widget.controller,
        style: const TextStyle(color: Colors.green),
        obscureText: widget.isPassword ? _obscureText : false, // ✅ kontrol
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          if (value == null || value.isEmpty) {
            return 'Harap isi form ini';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.green, size: 20),
          labelText: widget.labeldata,
          labelStyle: const TextStyle(color: Colors.green),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          floatingLabelStyle: const TextStyle(color: Colors.green),

          // ✅ Tambah toggle hanya jika password
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
