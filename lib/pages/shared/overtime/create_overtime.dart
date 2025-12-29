import 'package:flutter/material.dart';

class CreateOvertime extends StatefulWidget {
  const CreateOvertime({super.key});

  @override
  State<CreateOvertime> createState() => _CreateOvertimeState();
}

class _CreateOvertimeState extends State<CreateOvertime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Lembur")),
      body: Center(child: Text("Create Overtime Page")),
    );
  }
}
