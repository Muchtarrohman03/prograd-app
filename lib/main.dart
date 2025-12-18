import 'package:flutter/material.dart';
import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'BeVietnamPro',
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(fontSize: 11),
          unselectedLabelStyle: TextStyle(fontSize: 10),
        ),
      ),

      routerConfig: appRouter,
    );
  }
}
