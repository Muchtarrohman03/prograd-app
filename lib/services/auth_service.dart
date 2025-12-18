import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<void> saveLoginData(String token, String username, String role) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'role', value: role);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, dynamic>?> getLoginData() async {
    final token = await storage.read(key: 'token');
    final role = await storage.read(key: 'role');
    if (token == null || role == null) return null;
    return {"token": token, "role": role};
  }

  Future<void> clearLoginData() async {
    await storage.deleteAll();
  }
}
