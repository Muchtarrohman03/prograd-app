import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class GardenerHistoryPage extends StatefulWidget {
  const GardenerHistoryPage({super.key});

  @override
  State<GardenerHistoryPage> createState() => _GardenerHistoryPageState();
}

class _GardenerHistoryPageState extends State<GardenerHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            "Halaman Riwayat",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                icon: HeroIcon(
                  HeroIcons.clipboardDocumentCheck,
                  color: Colors.white,
                ),
                child: Text(
                  'kerja',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                ),
              ),
              Tab(
                icon: HeroIcon(HeroIcons.clock, color: Colors.white),
                child: Text(
                  'lembur',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                ),
              ),
              Tab(
                icon: HeroIcon(HeroIcons.calendar, color: Colors.white),
                child: Text(
                  'izin',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: Colors.green.shade100,
              child: HeroIcon(
                HeroIcons.clipboardDocumentCheck,
                color: Colors.white,
                size: 40,
              ),
            ),
            Container(
              color: Colors.green.shade200,
              child: HeroIcon(HeroIcons.clock, color: Colors.white, size: 40),
            ),
            Container(
              color: Colors.green.shade300,
              child: HeroIcon(
                HeroIcons.calendarDateRange,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
