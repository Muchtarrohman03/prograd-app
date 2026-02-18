import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/part/profile_section/profile_header.dart';
import 'package:laravel_flutter/components/reusable/action_list_tile.dart';
import 'package:laravel_flutter/components/reusable/confirm_alert_dialog.dart';
import 'package:laravel_flutter/components/reusable/info.dart';
import 'package:laravel_flutter/components/reusable/single_section.dart';
import 'package:laravel_flutter/components/reusable/stat_overview_bottom_sheet.dart';
import 'package:laravel_flutter/helpers/profile_avatar_resolver.dart';
import 'package:laravel_flutter/models/stat_overview.dart';
import 'package:laravel_flutter/providers/job_submission_draft_provider.dart';
import 'package:laravel_flutter/providers/overtime_draft_provider.dart';
import 'package:laravel_flutter/router/auth_state.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // pastikan benar

class StaffProfilePage extends ConsumerStatefulWidget {
  const StaffProfilePage({super.key});

  @override
  ConsumerState<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends ConsumerState<StaffProfilePage> {
  final storage = FlutterSecureStorage();
  final apiService = ApiService();
  final authService = AuthService();

  // 🔥 load data profile
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  final StreamController<Map<String, dynamic>> _profileController =
      StreamController.broadcast();

  StatOverview? _statOverview;
  bool _isStatLoading = true;

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchStatOverview();
  }

  Future<void> _fetchStatOverview() async {
    try {
      setState(() {
        _isStatLoading = true;
      });

      final stat = await apiService.getStatOverview();

      setState(() {
        _statOverview = stat;
        _isStatLoading = false;
      });
    } catch (e) {
      debugPrint('Fetch stat overview error: $e');
      setState(() {
        _isStatLoading = false;
      });
    }
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
      await Future.wait([_fetchProfile(), _fetchStatOverview()]);

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
    // 2️⃣ Hapus data lokal
    await ref.read(draftListProvider.notifier).clearDrafts();
    await ref.read(overtimeDraftListProvider.notifier).clearDrafts();
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
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _profileController.stream,
          builder: (context, snapshot) {
            final bool isLoading = _isLoading;
            final bool hasError = snapshot.hasError || _hasError;
            // SAFE DATA PARSING
            final data = snapshot.data?["data"];
            final username = data?["username"] ?? "-";
            final email = data?["email"] ?? "-";
            final division = data?["division"] ?? "-";
            final gender = data?["gender"] ?? "-";
            final roleList = data?["role"];
            final role = (roleList is List && roleList.isNotEmpty)
                ? roleList.first
                : "-";
            final avatarPath = resolveProfileAvatar(role: role, gender: gender);

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
                  // HEADER (WITH SHIMMER)
                  ProfileHeader(
                    username: username,
                    email: email,
                    imagePath: avatarPath,
                    isLoading: isLoading || _isStatLoading,
                    jobSubmissionCount:
                        _statOverview?.jobSubmissions.total ?? 0,
                    absenceCount: _statOverview?.absences.total ?? 0,
                    overtimeCount: _statOverview?.overtime.total ?? 0,
                    onJobSubmissionTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => StatOverviewBottomSheet(
                          icon: HeroIcon(HeroIcons.clipboardDocumentCheck),
                          title: 'Laporan Kerja',
                          stat: _statOverview!.jobSubmissions,
                        ),
                      );
                    },

                    onAbsenceTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => StatOverviewBottomSheet(
                          icon: HeroIcon(HeroIcons.calendarDays),
                          title: 'Laporan Izin',
                          stat: _statOverview!.absences,
                        ),
                      );
                    },

                    onOvertimeTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => StatOverviewBottomSheet(
                          icon: HeroIcon(HeroIcons.clock),
                          title: 'Pengajuan Lembur',
                          stat: _statOverview!.overtime,
                        ),
                      );
                    },
                  ),

                  // INFO SECTION
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SingleSection(
                          title: "Profil",
                          children: [
                            Info(
                              infoKey: "Nama",
                              info: username,
                              icon: HeroIcons.user,
                              isLoading: isLoading,
                            ),
                            Info(
                              infoKey: "Email",
                              info: email,
                              icon: HeroIcons.envelope,
                              isLoading: isLoading,
                            ),
                            Info(
                              infoKey: "Peran",
                              info: role,
                              icon: HeroIcons.userCircle,
                              isLoading: isLoading,
                            ),
                            Info(
                              infoKey: "Divisi",
                              info: division,
                              icon: HeroIcons.buildingOffice,
                              isLoading: isLoading,
                            ),
                            Info(
                              infoKey: "Jenis Kelamin",
                              info: gender,
                              icon: HeroIcons.userCircle,
                              isLoading: isLoading,
                            ),
                          ],
                        ),
                        // ERROR MESSAGE (OPTIONAL)
                        if (hasError)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red.shade100.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red.shade400,
                                    ),
                                    Text(
                                      "Gagal memuat data profil",
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // ACTIONS (ALWAYS ON)
                        SingleSection(
                          title: "Aksi",
                          children: [
                            ActionListTile(
                              title: "Pengaturan",
                              heroicon: HeroIcons.cog6Tooth,
                              onTap: () {},
                            ),
                            ActionListTile(
                              title: "Bantuan",
                              heroicon: HeroIcons.questionMarkCircle,

                              onTap: () {},
                            ),
                            ActionListTile(
                              title: "Logout",
                              heroicon: HeroIcons.arrowRightStartOnRectangle,
                              iconcolor: Colors.red,
                              textcolor: Colors.red,
                              onTap: () {
                                showCustomAlertDialog(
                                  context: context,
                                  title: "Konfirmasi Logout",
                                  content: "Apakah Anda yakin ingin logout?",
                                  confirmColor: Colors.red,
                                  onConfirm: () async {
                                    await logout(context);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // FOOTER
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Versi Aplikasi 1.0.0",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Made by: Muchtar Rohman",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
