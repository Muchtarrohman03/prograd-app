import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class SiteManagerPage extends StatefulWidget {
  const SiteManagerPage({super.key, required this.navShell});

  final StatefulNavigationShell navShell;

  @override
  State<SiteManagerPage> createState() => _SiteManagerPageState();
}

class _SiteManagerPageState extends State<SiteManagerPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ⬅ PENTING
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 11, // ⬅ kecilkan di sini
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        currentIndex: widget.navShell.currentIndex,
        onTap: (i) {
          widget.navShell.goBranch(i);
        },
        backgroundColor: Colors.green.shade50,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.home, style: HeroIconStyle.outline),
            activeIcon: HeroIcon(HeroIcons.home, style: HeroIconStyle.solid),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.map, style: HeroIconStyle.outline),
            activeIcon: HeroIcon(HeroIcons.map, style: HeroIconStyle.solid),
            label: "Posisi",
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.clipboardDocumentList,
              style: HeroIconStyle.outline,
            ),
            activeIcon: HeroIcon(
              HeroIcons.clipboardDocumentList,
              style: HeroIconStyle.solid,
            ),
            label: "Pengajuan",
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.userCircle, style: HeroIconStyle.outline),
            activeIcon: HeroIcon(
              HeroIcons.userCircle,
              style: HeroIconStyle.solid,
            ),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
