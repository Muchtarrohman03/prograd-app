import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';

class CreateAbsences extends StatefulWidget {
  const CreateAbsences({super.key});

  @override
  State<CreateAbsences> createState() => _CreateAbsencesState();
}

class _CreateAbsencesState extends State<CreateAbsences> {
  final bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Izin")),
      body: Center(
        child: ConfirmButton(
          isLoading: isLoading,
          action: () {},
          text: "Buat Izin",
        ),
      ),
    );
  }
}
