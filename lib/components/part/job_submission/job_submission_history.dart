import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/part/job_submission/job_submission_tile.dart';
import 'package:laravel_flutter/components/reusable/custom_date_picker.dart';
import 'package:laravel_flutter/components/reusable/ilustration.dart';
import 'package:laravel_flutter/components/reusable/shimmer_tile.dart';
import 'package:laravel_flutter/models/job_submission.dart';
import 'package:laravel_flutter/services/api_service.dart';

class JobSubmissionHistory extends StatefulWidget {
  const JobSubmissionHistory({super.key});

  @override
  State<JobSubmissionHistory> createState() => _JobSubmissionHistoryState();
}

class _JobSubmissionHistoryState extends State<JobSubmissionHistory> {
  DateTime _date = DateTime.now();
  late Future<List<JobSubmission>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<List<JobSubmission>> _fetchData() {
    final formattedDate = _date
        .toIso8601String()
        .split('T')
        .first; // YYYY-MM-DD

    return ApiService().getMySubmissionsByDate(formattedDate);
  }

  void _onDateChanged(DateTime value) {
    setState(() {
      _date = value;
      _future = _fetchData();
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
          child: FutureBuilder<List<JobSubmission>>(
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
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final items = snapshot.data ?? [];

              if (items.isEmpty) {
                return Center(
                  child: Ilustration(
                    message: 'Belum ada pengajuan pekerjaan pada tanggal ini.',
                    imagePath: 'assets/images/empty.png',
                  ),
                );
              }

              return Column(
                children: [
                  /// SUMMARY (CENTER)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total ${items.length} pekerjaan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return JobSubmissionTile(item: item);
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
