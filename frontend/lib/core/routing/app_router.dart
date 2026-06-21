import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/ui/login_screen.dart';
import '../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../features/dashboard/presentation/ui/dashboard_screen.dart';
import '../../features/dashboard/presentation/ui/main_shell_screen.dart';
import '../../features/search/presentation/ui/search_screen.dart';
import '../../features/settings/presentation/ui/settings_screen.dart';
import '../../features/patients/presentation/ui/patient_form_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellDashboard',
);
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSearch',
);
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSettings',
);

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthLoading = authState.isLoading;
      final isAuthenticated = authState.hasValue && authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (isAuthLoading) {
        return null;
      }

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          if (authState.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/patient-form/:mode',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final modeStr = state.pathParameters['mode']!;
          return PatientFormScreen(mode: modeStr);
        },
      ),
      GoRoute(
        path: '/patient-form/view/:pesel',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final pesel = state.pathParameters['pesel']!;
          return PatientFormScreen(mode: 'view', pesel: pesel);
        },
      ),
    ],
  );
}
