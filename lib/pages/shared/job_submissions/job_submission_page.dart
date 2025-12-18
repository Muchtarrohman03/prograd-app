import 'package:flutter/material.dart';

class JobSubmissionPage extends StatefulWidget {
  const JobSubmissionPage({super.key});

  @override
  State<JobSubmissionPage> createState() => _JobSubmissionPageState();
}

class _JobSubmissionPageState extends State<JobSubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan Pekerjaan')),
      body: const Center(child: Text('Halaman Pengajuan Pekerjaan')),
    );
  }
}
