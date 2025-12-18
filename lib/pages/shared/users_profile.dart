import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/confirm_alert_dialog.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/services/auth_service.dart';
import 'package:laravel_flutter/components/reusable/info.dart'; // pastikan benar

class UsersProfile extends StatefulWidget {
  const UsersProfile({super.key});

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  final storage = FlutterSecureStorage();

  final apiService = ApiService();
  final authService = AuthService();

  // 🔥 load data profile
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = apiService.getMyProfile(); // ⬅ tanpa token
  }

  Future<void> logout(BuildContext context) async {
    final token = await storage.read(key: 'token');

    if (token != null) {
      try {
        await apiService.logout(token);
      } catch (e) {
        debugPrint("Logout API error: $e");
      }
    }

    await authService.clearLoginData();

    // ⬇ GoRouter yang handle navigasi
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("User Profile"),
        centerTitle: true,
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data profil"));
          }

          final data = snapshot.data!["data"];
          final username = data["username"];
          final email = data["email"];
          final division = data["division"];
          final roleList = data["role"]; // array
          final role = (roleList is List && roleList.isNotEmpty)
              ? roleList[0]
              : "-";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // =======================
                // HEADER PROFIL
                // =======================
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.green.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 20),

                // =======================
                // CARD INFO
                // =======================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem("Role", role),
                      _buildInfoItem("Division", division),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // =======================
                // DATA PROFILE DETAIL
                // =======================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Info(
                        infoKey: "Nama",
                        info: username,
                        icon: HeroIcons.user,
                      ),
                      Info(
                        infoKey: "Email",
                        info: email,
                        icon: HeroIcons.envelope,
                      ),
                      Info(
                        infoKey: "Role",
                        info: role,
                        icon: HeroIcons.identification,
                      ),
                      Info(
                        infoKey: "Sektor",
                        info: division,
                        icon: HeroIcons.buildingOffice,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Aksi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings, color: Colors.grey.shade800),
                      const SizedBox(width: 8),
                      Text(
                        "Pengaturan",
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showCustomAlertDialog(
                        context: context,
                        title: 'Konfirmasi Logout',
                        content: 'Anda yakin ingin meninggalkan aplikasi ?',
                        confirmText: 'Logout',
                        onConfirm: () => logout(context),
                        confirmColor: Colors.red,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Logout", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
