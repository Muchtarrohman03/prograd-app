import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/services/auth_service.dart';

class GardenerHomePage extends StatefulWidget {
  const GardenerHomePage({super.key});

  @override
  State<GardenerHomePage> createState() => _GardenerHomePageState();
}

class _GardenerHomePageState extends State<GardenerHomePage> {
  final storage = FlutterSecureStorage();
  int currentPageIndex = 0;
  String username = "";
  String role = "";
  final apiService = ApiService();
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    username = await storage.read(key: 'username') ?? '';
    role = await storage.read(key: 'role') ?? '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hallo,\n$username.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: HeroIcon(
                HeroIcons.bell,
                style: HeroIconStyle.solid,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to the Gardener Home Page!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Here you can manage your gardening tasks and view your assignments.",
                style: TextStyle(fontSize: 16),
              ),
              // Tambahkan widget lain sesuai kebutuhan
            ],
          ),
        ),
      ),
    );
  }
}
