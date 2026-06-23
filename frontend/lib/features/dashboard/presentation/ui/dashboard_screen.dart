
import 'package:esor/features/doctor/presentation/view_models/doctor_view_model.dart';

import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_models/my_patients_provider.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../view_models/queue_view_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.green;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kolejka SOR')),
      floatingActionButton: authState.value?.role != StaffRole.doctor
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/triage-form'),
              icon: const Icon(Icons.add),
              label: const Text('Nowy Triage'),
            )
          : null,
      body: authState.value?.role == StaffRole.doctor
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pacjenci pod obserwacją (Twoi pacjenci)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(child: _buildMyPatientsList(ref)),
                const Divider(height: 1, thickness: 2),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Kolejka oczekujących',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(child: _buildQueueList(ref, authState.value)),
              ],
            )
          : _buildQueueList(ref, authState.value),
    );
  }

  Widget _buildMyPatientsList(WidgetRef ref) {
    final state = ref.watch(myPatientsProvider);

    return state.when(
      data: (patients) {
        if (patients.isEmpty) {
          return const Center(child: Text('Brak pacjentów pod obserwacją.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            final admission = patients[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getPriorityColor(admission.priorityKtas),
                  child: Text(
                    admission.priorityKtas.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  'Zgłoszenie #${admission.id} (Pacjent ID: ${admission.patientId})',
                ),
                subtitle: Text('Status: ${admission.status.value}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  GoRouter.of(context).push('/consultation/${admission.id}');
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Błąd: $error')),
    );
  }

  Widget _buildQueueList(WidgetRef ref, StaffEntity? user) {
    final queueState = ref.watch(visibleQueueProvider);

    return queueState.when(
      data: (visibleQueue) {

        if (visibleQueue.isEmpty) {
          return const Center(child: Text('Kolejka jest pusta.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: visibleQueue.length,
          itemBuilder: (itemContext, index) {
            final admission = visibleQueue[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: _getPriorityColor(admission.priorityKtas),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getPriorityColor(admission.priorityKtas),
                  child: Text(
                    admission.priorityKtas.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  'Zgłoszenie #${admission.id} (Pacjent ID: ${admission.patientId})',
                ),
                subtitle: Text(
                  'Czas: ${admission.admissionDate.toLocal().toString().substring(11, 16)} | AI: ${admission.isAiPredicted ? "Tak" : "Nie"}',
                ),
                trailing: user?.role == StaffRole.doctor
                    ? IconButton(
                        icon: const Icon(Icons.assignment_ind),
                        tooltip: 'Przejmij pacjenta',
                        onPressed: () async {
                          final goRouter = GoRouter.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          
                          final success = await ref
                              .read(doctorViewModelProvider.notifier)
                              .assignPatient(admission.id);

                          if (success) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Zgłoszenie przejęte'),
                              ),
                            );
                            // Najpierw nawigujemy (używamy zachowanego routera, omijając problem z mounted)
                            await goRouter.push('/consultation/${admission.id}');
                            
                            // A po powrocie z ekranu (czyli gdy future się zakończy) odświeżamy listę:
                            ref.invalidate(myPatientsProvider);
                          } else {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Błąd przejmowania'),
                              ),
                            );
                          }
                        },
                      )
                    : null,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Błąd: $error')),
    );
  }
}
