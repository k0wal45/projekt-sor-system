import 'package:esor/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:esor/features/dashboard/presentation/widgets/default_dashboard_view.dart';
import 'package:esor/features/dashboard/presentation/widgets/doctor_dashboard_view.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:esor/shared/widgets/status_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          ref.read(authViewModelProvider.notifier).logout();
          return Scaffold();
        }

        if (user.role == StaffRole.doctor) {
          return DoctorDashboardScreen(user: user);
        }

        return DefaultDashboardScreen(user: user);
      },
      loading: () =>
          Scaffold(body: const Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) {
        return Scaffold(
          body: StatusPlaceholder(
            icon: Icons.error_rounded,
            title: "Błąd uwierzytelniania",
            description:
                "Wystąpił błąd podczas uwierzytelniania. Spróbuj zalogować się ponownie.",
            errorMessage: error.toString(),
            action: ElevatedButton.icon(
              onPressed: () {
                ref.read(authViewModelProvider.notifier).logout();
              },
              label: Text("Wyloguj"),
              icon: Icon(Icons.logout),
            ),
          ),
        );
      },
    );
  }
}
