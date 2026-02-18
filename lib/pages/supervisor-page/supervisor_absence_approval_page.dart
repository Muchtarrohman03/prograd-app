import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/part/absence/absence_tile.dart';
import 'package:laravel_flutter/components/part/absence/absence_update_status_bottom_sheet.dart';
import 'package:laravel_flutter/components/reusable/ilustration.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/models/absence.dart';
import 'package:laravel_flutter/services/api_service.dart';

class SupervisorAbsenceApprovalPage extends StatefulWidget {
  const SupervisorAbsenceApprovalPage({super.key});

  @override
  State<SupervisorAbsenceApprovalPage> createState() =>
      _SupervisorAbsenceApprovalPageState();
}

class _SupervisorAbsenceApprovalPageState
    extends State<SupervisorAbsenceApprovalPage> {
  late Future<List<Absence>> _future;
  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<List<Absence>> _fetchData() async {
    // Ganti dengan logika untuk mengambil data absensi dari API
    return ApiService().getDivisionAbsences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          'Approval Pengajuan Absensi',
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
                message: 'Belum ada pengajuan absensi yang perlu disetujui.',
                imagePath: 'assets/images/empty.png',
              ),
            );
          } else {
            final absences = snapshot.data!;
            return ListView.builder(
              itemCount: absences.length,
              itemBuilder: (context, index) {
                final absence = absences[index];
                return AbsenceTile(
                  absence: absence,
                  validationMode: true,
                  onValidate: () {
                    // Implementasi logika validasi absensi
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => AbsenceUpdateStatusBottomSheet(
                        absenceId: absence.id,
                        currentStatus: absence.status,
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
