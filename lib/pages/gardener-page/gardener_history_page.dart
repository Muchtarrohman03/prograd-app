import 'package:flutter/material.dart';

class GardenerHistoryPage extends StatefulWidget {
  const GardenerHistoryPage({super.key});

  @override
  State<GardenerHistoryPage> createState() => _GardenerHistoryPageState();
}

class _GardenerHistoryPageState extends State<GardenerHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Riwayat Gardener"),
        centerTitle: true,
      ),
      body: const Center(child: Text("Halaman Riwayat Gardener")),
    );
  }
}
