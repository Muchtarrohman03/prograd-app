import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/part/overtime/overtime_tile.dart';
import 'package:laravel_flutter/components/part/overtime/overtime_update_status_bottom_sheet.dart';
import 'package:laravel_flutter/components/reusable/ilustration.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/models/overtime.dart';
import 'package:laravel_flutter/services/api_service.dart';

class SupervisorOvertimeApprovalPage extends StatefulWidget {
  const SupervisorOvertimeApprovalPage({super.key});

  @override
  State<SupervisorOvertimeApprovalPage> createState() =>
      _SupervisorOvertimeApprovalPageState();
}

class _SupervisorOvertimeApprovalPageState
    extends State<SupervisorOvertimeApprovalPage> {
  late Future<List<Overtime>> _future;
  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<List<Overtime>> _fetchData() async {
    // Ganti dengan logika untuk mengambil data lembur dari API
    return ApiService().getDivisionOvertime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          'Approval Pengajuan Lembur',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ShimmerTile(
                  baseColor: Colors.green.shade100,
                  highlightColor: Colors.green.shade50,
                  showSubtitle: true,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Ilustration(
                message: 'Error : $snapshot.error',
                imagePath: 'assets/images/error.png',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Ilustration(
                message: 'Belum ada pengajuan lembur yang perlu disetujui.',
                imagePath: 'assets/images/empty.png',
              ),
            );
          } else {
            final submissions = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final item = submissions[index];
                return OvertimeTile(
                  item: item,
                  validationMode: true,
                  onValidate: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => OvertimeUpdateStatusBottomSheet(
                        submissionId: item.id,
                        currentStatus: item.status,
                        onSuccess: () {
                          setState(() {
                            _future = _fetchData();
                          });
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
