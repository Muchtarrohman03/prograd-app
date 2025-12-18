import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/services/auth_service.dart';

class SupervisorHomePage extends StatefulWidget {
  const SupervisorHomePage({super.key});

  @override
  State<SupervisorHomePage> createState() => _SupervisorHomePageState();
}

class _SupervisorHomePageState extends State<SupervisorHomePage> {
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
      appBar: AppBar(title: Text("Hai, $username.  Role: $role")),
    );
  }
}
