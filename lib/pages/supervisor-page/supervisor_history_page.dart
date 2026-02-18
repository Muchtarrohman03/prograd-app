import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/part/absence/absences_history.dart';
import 'package:laravel_flutter/components/part/job_submission/job_submission_history.dart';
import 'package:laravel_flutter/components/part/overtime/overtime_history.dart';

class SupervisorHistoryPage extends StatefulWidget {
  const SupervisorHistoryPage({super.key});

  @override
  State<SupervisorHistoryPage> createState() => _SupervisorHistoryPageState();
}

class _SupervisorHistoryPageState extends State<SupervisorHistoryPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Kerja'),
    Tab(text: 'Lembur'),
    Tab(text: 'Izin'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Halaman Riwayat',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          /// TABBAR DI LUAR APPBAR
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              tabs: _tabs,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.green.shade900,
              labelStyle: const TextStyle(fontSize: 16),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          /// TAB CONTENT (SCROLLABLE)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                JobSubmissionHistory(),
                OvertimeHistory(),
                AbsenceHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
