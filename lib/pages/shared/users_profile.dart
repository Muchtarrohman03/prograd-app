import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laravel_flutter/components/part/profile_section/profile_actions_section.dart';
import 'package:laravel_flutter/components/part/profile_section/profile_header.dart';
import 'package:laravel_flutter/components/part/profile_section/profile_info_section.dart';
import 'package:laravel_flutter/components/reusable/confirm_alert_dialog.dart';
import 'package:laravel_flutter/pages/shared/profile_shimmer.dart';
import 'package:laravel_flutter/router/auth_state.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // pastikan benar

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
  // late Future<Map<String, dynamic>> _profileFuture;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  final StreamController<Map<String, dynamic>> _profileController =
      StreamController.broadcast();

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final response = await apiService.getMyProfile();
      _profileController.add(response);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _profileController.addError(e);
    }
  }

  Future<void> _onRefresh() async {
    try {
      await _fetchProfile();
      await Future.delayed(const Duration(milliseconds: 300));
      _refreshController.refreshCompleted();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> logout(BuildContext context) async {
    final token = await storage.read(key: 'token');

    // 1️⃣ Hit API logout (opsional)
    if (token != null) {
      try {
        await apiService.logout(token);
      } catch (e) {
        debugPrint("Logout API error: $e");
      }
    }

    // 2️⃣ Update AUTH STATE (INI YANG PENTING)
    await context.read<AuthState>().logout();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _profileController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _profileController.stream,
          builder: (context, snapshot) {
            // ======================
            // LOADING
            // ======================
            if (_isLoading && !snapshot.hasData) {
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: const ProfileShimmer(),
              );
            }

            // ======================
            // ERROR
            // ======================
            if (_hasError || snapshot.hasError) {
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: kBottomNavigationBarHeight + 24,
                  ),
                  children: const [
                    SizedBox(height: 300),
                    Center(
                      child: Text(
                        "Gagal memuat data profil",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }

            // ======================
            // SUCCESS
            // ======================
            final data = snapshot.data!["data"];
            final username = data["username"];
            final email = data["email"];
            final division = data["division"];
            final roleList = data["role"];
            final role = (roleList is List && roleList.isNotEmpty)
                ? roleList[0]
                : "-";

            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight + 24,
                ),
                children: [
                  ProfileHeader(username: username, email: email),

                  ProfileInfoSection(
                    username: username,
                    email: email,
                    role: role,
                    division: division,
                  ),

                  ProfileActionsSection(
                    onLogout: () {
                      showCustomAlertDialog(
                        context: context,
                        title: 'Konfirmasi Logout',
                        content: 'Anda yakin ingin meninggalkan aplikasi ?',
                        confirmText: 'Logout',
                        onConfirm: () => logout(context),
                        confirmColor: Colors.red,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
