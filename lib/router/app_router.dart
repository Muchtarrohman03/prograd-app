import 'package:go_router/go_router.dart';
import 'package:laravel_flutter/pages/gardener-page/gardener_history_page.dart';
import 'package:laravel_flutter/pages/gardener-page/gardener_home_page.dart';
import 'package:laravel_flutter/pages/gardener-page/gardener_page.dart';
import 'package:laravel_flutter/pages/shared/job_submissions/job_submission_page.dart';
import 'package:laravel_flutter/pages/shared/login_page.dart';
import 'package:laravel_flutter/pages/shared/users_profile.dart';
import 'package:laravel_flutter/pages/site-manager-page/site_manager_home_page.dart';
import 'package:laravel_flutter/pages/site-manager-page/site_manager_page.dart';
import 'package:laravel_flutter/pages/site-manager-page/site_manager_view_submissions.dart';
import 'package:laravel_flutter/pages/site-manager-page/site_manager_view_user.dart';
import 'package:laravel_flutter/pages/staff-page/staff_history_page.dart';
import 'package:laravel_flutter/pages/staff-page/staff_home_page.dart';
import 'package:laravel_flutter/pages/staff-page/staff_page.dart';
import 'package:laravel_flutter/pages/supervisor-page/supervisor_acc.dart';
import 'package:laravel_flutter/pages/supervisor-page/supervisor_home_page.dart';
import 'package:laravel_flutter/pages/supervisor-page/supervisor_page.dart';
import 'package:laravel_flutter/services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final data = await AuthService().getLoginData();

        if (data == null) return '/login';

        switch (data['role']) {
          case 'gardener':
            return '/gardener';
          case 'staff':
            return '/staff';
          case 'site_manager':
            return '/site-manager';
          case 'supervisor':
            return '/supervisor';
          default:
            return '/login';
        }
      },
    ),

    /// LOGIN
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),

    /// =======================
    /// GARDENER SHELL
    /// =======================
    ShellRoute(
      builder: (context, state, child) {
        return GardenerPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/gardener',
          builder: (_, __) => const GardenerHomePage(),
        ),
        GoRoute(
          path: '/gardener/history',
          builder: (_, __) => const GardenerHistoryPage(),
        ),
        GoRoute(
          path: '/gardener/profile',
          builder: (_, __) => const UsersProfile(),
        ),
      ],
    ),

    /// =======================
    /// STAFF SHELL
    /// =======================
    ShellRoute(
      builder: (context, state, child) {
        return StaffPage(child: child);
      },
      routes: [
        GoRoute(path: '/staff', builder: (_, __) => const StaffHomePage()),
        GoRoute(
          path: '/staff/history',
          builder: (_, __) => const StaffHistoryPage(),
        ),
        GoRoute(
          path: '/staff/profile',
          builder: (_, __) => const UsersProfile(),
        ),
      ],
    ),

    /// =======================
    /// SUPERVISOR SHELL
    /// =======================
    ShellRoute(
      builder: (context, state, child) {
        return SupervisorPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/supervisor',
          builder: (_, __) => const SupervisorHomePage(),
        ),
        GoRoute(
          path: '/supervisor/acc',
          builder: (_, __) => const SupervisorAcc(),
        ),
        GoRoute(
          path: '/supervisor/profile',
          builder: (_, __) => const UsersProfile(),
        ),
      ],
    ),

    /// =======================
    /// SITE MANAGER SHELL
    /// =======================
    ShellRoute(
      builder: (context, state, child) {
        return SiteManagerPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/site-manager',
          builder: (_, __) => const SiteManagerHomePage(),
        ),
        GoRoute(
          path: '/site-manager/view-submissions',
          builder: (_, __) => const SiteManagerViewSubmissions(),
        ),
        GoRoute(
          path: '/site-manager/view-users',
          builder: (_, __) => const SiteManagerViewUser(),
        ),
        GoRoute(
          path: '/site-manager/profile',
          builder: (_, __) => const UsersProfile(),
        ),
      ],
    ),
    GoRoute(
      path: 'job-submission',
      builder: (_, __) => const JobSubmissionPage(),
    ),
  ],
);
