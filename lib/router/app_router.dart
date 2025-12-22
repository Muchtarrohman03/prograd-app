import 'package:go_router/go_router.dart';
import 'package:laravel_flutter/pages/gardener-page/gardener_history_page.dart';
import 'package:laravel_flutter/pages/gardener-page/gardener_home_page.dart';
import 'package:laravel_flutter/pages/gardener-page/gardener_page.dart';
import 'package:laravel_flutter/pages/shared/job_submissions/job_submission_page.dart';
import 'package:laravel_flutter/pages/shared/login_page.dart';
import 'package:laravel_flutter/pages/shared/splash_page.dart';
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
import 'package:laravel_flutter/router/auth_state.dart';

GoRouter appRouter(AuthState authState) => GoRouter(
  initialLocation: '/',
  refreshListenable: authState, // 🔥 INI KUNCI UTAMA

  redirect: (context, state) {
    if (!authState.isReady) return null;

    final location = state.matchedLocation;
    final isLogin = location == '/login';
    final isRoot = location == '/';

    // ❌ Belum login → ke login
    if (!authState.isLoggedIn) {
      return isLogin ? null : '/login';
    }

    // ✅ Sudah login & di ROOT → arahkan ke home sesuai role
    if (isRoot) {
      switch (authState.role) {
        case 'gardener':
          return '/gardener';
        case 'staff':
          return '/staff';
        case 'site_manager':
          return '/site-manager';
        case 'supervisor':
          return '/supervisor';
      }
    }

    // ✅ Sudah login tapi masih di login page
    if (isLogin) {
      switch (authState.role) {
        case 'gardener':
          return '/gardener';
        case 'staff':
          return '/staff';
        case 'site_manager':
          return '/site-manager';
        case 'supervisor':
          return '/supervisor';
      }
    }

    return null;
  },

  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashPage()),
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),

    /// =======================
    /// GARDENER STATEFUL SHELL
    /// =======================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShel) {
        return GardenerPage(navShell: navShel);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/gardener',
              builder: (_, __) => const GardenerHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/gardener/history',
              builder: (_, __) => const GardenerHistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/gardener/profile',
              builder: (_, __) => const UsersProfile(),
            ),
          ],
        ),
      ],
    ),

    /// =======================
    /// STAFF STATEFUL SHELL
    /// =======================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShell) {
        return StaffPage(navShell: navShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/staff', builder: (_, __) => const StaffHomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/history',
              builder: (_, __) => const StaffHistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staff/profile',
              builder: (_, __) => const UsersProfile(),
            ),
          ],
        ),
      ],
    ),

    /// =======================
    /// SUPERVISOR STATEFUL SHELL
    /// =======================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShell) {
        return SupervisorPage(navShell: navShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/supervisor',
              builder: (_, __) => const SupervisorHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/supervisor/acc',
              builder: (_, __) => const SupervisorAcc(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/supervisor/profile',
              builder: (_, __) => const UsersProfile(),
            ),
          ],
        ),
      ],
    ),

    /// =======================
    /// SITE MANAGER SHELL
    /// =======================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShell) {
        return SiteManagerPage(navShell: navShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/site-manager',
              builder: (_, __) => const SiteManagerHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/site-manager/view-submissions',
              builder: (_, __) => const SiteManagerViewSubmissions(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/site-manager/view-users',
              builder: (_, __) => const SiteManagerViewUser(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/site-manager/profile',
              builder: (_, __) => const UsersProfile(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: 'job-submission',
      builder: (_, __) => const JobSubmissionPage(),
    ),
  ],
);
