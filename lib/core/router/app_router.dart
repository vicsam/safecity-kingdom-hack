import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/guest_report_screen.dart';
import '../../features/auth/screens/report_success_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/citizen/screens/citizen_home_screen.dart';
import '../../features/citizen/screens/citizen_profile_screen.dart';
import '../../features/responder/screens/responder_feed_screen.dart';
import '../../features/responder/screens/responder_incident_detail_screen.dart';
import '../../features/responder/screens/responder_map_screen.dart';
import '../../features/responder/screens/responder_maintenance_screen.dart';
import '../../features/citizen/screens/report_incident_screen.dart';
import '../../features/citizen/screens/track_report_screen.dart';
import '../../shared/shells/citizen_shell.dart';
import '../../shared/shells/responder_shell.dart';
import '../../shared/shells/supervisor_shell.dart';
import '../../shared/shells/manager_shell.dart';

class AppRouter {
  AppRouter._();

  // Route names
  static const String routeLogin = 'login';
  static const String routeRegister = 'register';

  // Citizen routes
  static const String routeCitizenHome = 'home';
  static const String routeCitizenReport = 'report';
  static const String routeCitizenReportDetail = 'detail';
  static const String routeCitizenProfile = 'profile';

  // Responder routes
  static const String routeResponderFeed = 'feed';
  static const String routeResponderIncident = 'incident';
  static const String routeResponderMap = 'map';
  static const String routeResponderMaintenance = 'maintenance';
  static const String routeResponderProfile = 'profile';

  // Supervisor routes
  static const String routeSupervisorFeed = 'feed';
  static const String routeSupervisorEscalations = 'escalations';
  static const String routeSupervisorTeam = 'team';
  static const String routeSupervisorMap = 'map';
  static const String routeSupervisorMaintenance = 'maintenance';

  // Manager routes
  static const String routeManagerDashboard = 'dashboard';
  static const String routeManagerIncidents = 'incidents';
  static const String routeManagerEscalations = 'escalations';
  static const String routeManagerSupervisors = 'supervisors';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = authAsync.value;
      final isLoading = authAsync.isLoading;

      if (isLoading) return null;

      final isLoggedIn = user != null;
      final path = state.uri.path;

      // Public routes — no auth needed
      final publicRoutes = ['/', '/login', '/register', '/report/success'];
      final isPublicRoute = publicRoutes.any((r) => path.startsWith(r));

      // Not logged in + trying to access protected route → go to login
      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      // Logged in + on login/register → go to role dashboard
      if (isLoggedIn && (path == '/login' || path == '/register')) {
        return switch (user.role) {
          'city_manager' => '/manager/dashboard',
          'supervisor' => '/supervisor/feed',
          'responder' => '/responder/feed',
          _ => '/citizen/home',
        };
      }

      return null;
    },
    routes: [
      // Public routes (no auth required)
      GoRoute(
        path: '/',
        name: 'guest_report',
        builder: (context, state) => const GuestReportScreen(),
      ),
      GoRoute(
        path: '/report/success',
        name: 'report_success',
        builder: (context, state) {
          final reportId =
              state.uri.queryParameters['reportId'] ?? 'RC-0000';
          return ReportSuccessScreen(reportId: reportId);
        },
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: AppRouter.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouter.routeRegister,
        builder: (context, state) {
          final guestReportId = state.uri.queryParameters['reportId'];
          return RegisterScreen(guestReportId: guestReportId);
        },
      ),

      // Citizen full-screen routes (no bottom nav shell)
      GoRoute(
        path: '/citizen/report',
        name: 'citizen_report',
        builder: (context, state) => const ReportIncidentScreen(),
      ),
      GoRoute(
        path: '/citizen/report/:id',
        name: 'citizen_report_detail',
        builder: (context, state) {
          // TODO: Create ReportDetailScreen
          return const Placeholder();
        },
      ),

      // Citizen shell route
      ShellRoute(
        builder: (context, state, child) => CitizenShell(child: child),
        routes: [
          GoRoute(
            path: '/citizen/home',
            name: 'citizen_home',
            builder: (context, state) => const CitizenHomeScreen(),
          ),
          GoRoute(
            path: '/citizen/track',
            name: 'citizen_track',
            builder: (context, state) => const TrackReportScreen(),
          ),
          GoRoute(
            path: '/citizen/profile',
            name: 'citizen_profile',
            builder: (context, state) => const CitizenProfileScreen(),
          ),
        ],
      ),

      // Responder shell route
      ShellRoute(
        builder: (context, state, child) => ResponderShell(child: child),
        routes: [
          GoRoute(
            path: '/responder/feed',
            name: 'responder_feed',
            builder: (context, state) => const ResponderFeedScreen(),
          ),
          GoRoute(
            path: '/responder/incident/:id',
            name: 'responder_incident',
            builder: (context, state) =>
                const ResponderIncidentDetailScreen(),
          ),
          GoRoute(
            path: '/responder/map',
            name: 'responder_map',
            builder: (context, state) => const ResponderMapScreen(),
          ),
          GoRoute(
            path: '/responder/maintenance',
            name: 'responder_maintenance',
            builder: (context, state) =>
                const ResponderMaintenanceScreen(),
          ),
          GoRoute(
            path: '/responder/profile',
            name: 'responder_profile',
            builder: (context, state) {
              // TODO: Create ResponderProfileScreen
              return const Placeholder();
            },
          ),
        ],
      ),

      // Supervisor shell route
      ShellRoute(
        builder: (context, state, child) => SupervisorShell(child: child),
        routes: [
          GoRoute(
            path: '/supervisor/feed',
            name: 'supervisor_feed',
            builder: (context, state) {
              // TODO: Create SupervisorFeedScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/supervisor/escalations',
            name: 'supervisor_escalations',
            builder: (context, state) {
              // TODO: Create EscalationsScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/supervisor/team',
            name: 'supervisor_team',
            builder: (context, state) {
              // TODO: Create TeamManagementScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/supervisor/map',
            name: 'supervisor_map',
            builder: (context, state) {
              // TODO: Create SupervisorMapScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/supervisor/maintenance',
            name: 'supervisor_maintenance',
            builder: (context, state) {
              // TODO: Create MaintenanceScreen
              return const Placeholder();
            },
          ),
        ],
      ),

      // Manager shell route
      ShellRoute(
        builder: (context, state, child) => ManagerShell(child: child),
        routes: [
          GoRoute(
            path: '/manager/dashboard',
            name: 'manager_dashboard',
            builder: (context, state) {
              // TODO: Create ManagerDashboardScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/manager/incidents',
            name: 'manager_incidents',
            builder: (context, state) {
              // TODO: Create IncidentsListScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/manager/escalations',
            name: 'manager_escalations',
            builder: (context, state) {
              // TODO: Create EscalationsScreen
              return const Placeholder();
            },
          ),
          GoRoute(
            path: '/manager/supervisors',
            name: 'manager_supervisors',
            builder: (context, state) {
              // TODO: Create SupervisorsScreen
              return const Placeholder();
            },
          ),
        ],
      ),
    ],
  );
});
