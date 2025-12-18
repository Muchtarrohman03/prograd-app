import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isReady = false; // apakah auth sudah di-load
  bool isLoggedIn = false; // apakah user login
  String? role; // role user

  /// Dipanggil 1x saat app start
  Future<void> load() async {
    final data = await _authService.getLoginData();

    if (data != null) {
      isLoggedIn = true;
      role = data['role'];
    } else {
      isLoggedIn = false;
      role = null;
    }

    isReady = true;
    notifyListeners();
  }

  /// Dipanggil setelah login berhasil
  Future<void> login(String role) async {
    isLoggedIn = true;
    this.role = role;
    notifyListeners();
  }

  /// Dipanggil saat logout
  Future<void> logout() async {
    await _authService.clearLoginData();
    isLoggedIn = false;
    role = null;
    notifyListeners();
  }
}
