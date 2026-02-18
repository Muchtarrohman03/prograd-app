import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/part/overtime/overtime_tile.dart';
import 'package:laravel_flutter/components/reusable/custom_date_picker.dart';
import 'package:laravel_flutter/components/reusable/ilustration.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/models/overtime.dart';
import 'package:laravel_flutter/services/api_service.dart';

class OvertimeHistory extends StatefulWidget {
  const OvertimeHistory({super.key});

  @override
  State<OvertimeHistory> createState() => _OvertimeHistoryState();
}

class _OvertimeHistoryState extends State<OvertimeHistory> {
  DateTime _date = DateTime.now();
  late Future<List<Overtime>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchDataOvertime();
  }

  Future<List<Overtime>> _fetchDataOvertime() {
    final formattedDate = _date
        .toIso8601String()
        .split('T')
        .first; // YYYY-MM-DD

    return ApiService().getMyOvertimesByDate(formattedDate);
  }

  void _onDateChanged(DateTime value) {
    setState(() {
      _date = value;
      _future = _fetchDataOvertime();
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
          child: FutureBuilder<List<Overtime>>(
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
                    message: 'Belum ada catatan lembur pada tanggal ini.',
                    imagePath: 'assets/images/empty.png',
                  ),
                );
              }

              final overtimes = snapshot.data ?? [];
              if (overtimes.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeroIcon(
                          HeroIcons.clock,
                          size: 60,
                          color: Colors.green,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada catatan lembur ditemukan.',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total ${overtimes.length} Lembur',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: overtimes.length,
                      itemBuilder: (context, index) {
                        final overtime = overtimes[index];
                        return OvertimeTile(item: overtime);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
