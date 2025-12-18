import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class GardenerPage extends StatefulWidget {
  const GardenerPage({super.key, required this.child});

  final Widget child;

  @override
  State<GardenerPage> createState() => _GardenerPageState();
}

class _GardenerPageState extends State<GardenerPage> {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/gardener/history')) currentIndex = 1;
    if (location.startsWith('/gardener/profile')) currentIndex = 2;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/gardener');
              break;
            case 1:
              context.go('/gardener/history');
              break;
            case 2:
              context.go('/gardener/profile');
              break;
          }
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
