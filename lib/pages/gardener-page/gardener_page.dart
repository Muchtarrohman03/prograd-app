import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class GardenerPage extends StatefulWidget {
  const GardenerPage({super.key, required this.navShell});

  final StatefulNavigationShell navShell;

  @override
  State<GardenerPage> createState() => _GardenerPageState();
}

class _GardenerPageState extends State<GardenerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navShell,
      bottomNavigationBar: BottomNavigationBar(
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
            icon: HeroIcon(HeroIcons.clock, style: HeroIconStyle.outline),
            activeIcon: HeroIcon(HeroIcons.clock, style: HeroIconStyle.solid),
            label: "Riwayat",
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
