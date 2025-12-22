import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class SupervisorPage extends StatefulWidget {
  const SupervisorPage({super.key, required this.navShell});

  final StatefulNavigationShell navShell;

  @override
  State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {
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
            icon: HeroIcon(
              HeroIcons.clipboardDocumentCheck,
              style: HeroIconStyle.outline,
            ),
            activeIcon: HeroIcon(
              HeroIcons.clipboardDocumentCheck,
              style: HeroIconStyle.solid,
            ),
            label: "Persetujuan",
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
