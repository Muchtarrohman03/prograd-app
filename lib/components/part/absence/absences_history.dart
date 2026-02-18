import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/part/absence/absence_tile.dart';
import 'package:laravel_flutter/components/reusable/custom_date_picker.dart';
import 'package:laravel_flutter/components/reusable/ilustration.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/models/absence.dart';
import 'package:laravel_flutter/services/api_service.dart';

class AbsenceHistory extends StatefulWidget {
  const AbsenceHistory({super.key});

  @override
  State<AbsenceHistory> createState() => _AbsenceHistoryState();
}

class _AbsenceHistoryState extends State<AbsenceHistory> {
  DateTime _date = DateTime.now();
  late Future<List<Absence>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchDataAbsence();
  }

  //ambil data absence dari API
  Future<List<Absence>> _fetchDataAbsence() async {
    final formattedDate = _date
        .toIso8601String()
        .split('T')
        .first; // YYYY-MM-DD
    return ApiService().getMyAbsencesByDate(formattedDate);
  }

  void _onDateChanged(DateTime value) {
    setState(() {
      _date = value;
      _future = _fetchDataAbsence();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// DATE PICKERa
        Padding(
          padding: const EdgeInsets.all(14),
          child: CustomDatePicker(
            colorTheme: Colors.green.shade300,
            date: _date,
            onChanged: _onDateChanged,
          ),
        ),

        /// CONTENT
        Expanded(
          child: FutureBuilder<List<Absence>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ShimmerTile(
                      baseColor: Colors.green.shade100,
                      highlightColor: Colors.green.shade50,
                      showSubtitle: false,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Ilustration(
                    message: 'Belum ada catatan absensi pada tanggal ini.',
                    imagePath: 'assets/images/empty.png',
                  ),
                );
              } else {
                final absences = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: absences.length,
                  itemBuilder: (context, index) {
                    final absence = absences[index];
                    return AbsenceTile(absence: absence);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
