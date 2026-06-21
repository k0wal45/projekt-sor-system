import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/ui/login_screen.dart';
import '../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../features/dashboard/presentation/ui/dashboard_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
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
      GoRoute(
        path: '/',
        builder: (context, state) {
          if (authState.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const DashboardScreen();
        },
      ),
    ],
  );
}
