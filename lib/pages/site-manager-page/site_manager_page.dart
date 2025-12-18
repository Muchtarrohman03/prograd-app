import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class SiteManagerPage extends StatefulWidget {
  const SiteManagerPage({super.key, required this.child});

  final Widget child;

  @override
  State<SiteManagerPage> createState() => _SiteManagerPageState();
}

class _SiteManagerPageState extends State<SiteManagerPage> {
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/site-manager/view-users')) currentIndex = 1;
    if (location.startsWith('/site-manager/view-submissions')) currentIndex = 2;
    if (location.startsWith('/site-manager/profile')) currentIndex = 3;

    return Scaffold(
      body: widget.child,
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
        currentIndex: currentIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/site-manager');
              break;
            case 1:
              context.go('/site-manager/view-users');
              break;
            case 2:
              context.go('/site-manager/view-submissions');
              break;
            case 3:
              context.go('/site-manager/profile');
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
