import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class SupervisorPage extends StatefulWidget {
  const SupervisorPage({super.key, required this.child});

  final Widget child;

  @override
  State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/supervisor/acc')) currentIndex = 1;
    if (location.startsWith('/supervisor/profile')) currentIndex = 2;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/supervisor');
              break;
            case 1:
              context.go('/supervisor/acc');
              break;
            case 2:
              context.go('/supervisor/profile');
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
