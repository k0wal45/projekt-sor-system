import 'package:esor/features/auth/presentation/view_models/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/models/staff.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'nurse_dashboard_view.dart';
import 'doctor_dashboard_view.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final dashboardState = ref.watch(dashboardViewModelProvider);

    final staff = authState.value;

    if (staff == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return dashboardState.when(
      data: (state) {
        if (staff.role == "LEKRARZ") {
          return DoctorDashboardView(
            staff: Staff(
              id: staff.id.toString(),
              firstName: staff.firstName,
              lastName: staff.lastName,
              role: StaffRole.doctor,
              loginEmail: staff.email,
            ),
            queue: state.queue,
            activePatients: state.activePatients,
            onRefresh: () =>
                ref.read(dashboardViewModelProvider.notifier).refresh(),
          );
        } else {
          return NurseDashboardView(
            queue: state.queue,
            onRefresh: () =>
                ref.read(dashboardViewModelProvider.notifier).refresh(),
          );
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Wystąpił błąd: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(dashboardViewModelProvider.notifier).refresh(),
                child: const Text('Spróbuj ponownie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
