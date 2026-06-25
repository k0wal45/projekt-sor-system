import 'package:esor/core/network/websocket_service.dart';
import 'package:esor/features/dashboard/presentation/view_models/my_patients_provider.dart';
import 'package:esor/features/dashboard/presentation/view_models/queue_view_model.dart';
import 'package:esor/features/dashboard/presentation/widgets/patient_queue_card.dart';
import 'package:esor/features/dashboard/presentation/widgets/under_observation_card.dart';
import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:esor/shared/widgets/esor_logo.dart';
import 'package:esor/shared/widgets/section_header.dart';
import 'package:esor/shared/widgets/status_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({super.key, required this.user});

  final StaffEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueViewModelProvider);
    final myPatients = ref.watch(myPatientsProvider);

    void showConfirmationDialog(BuildContext context, int admissionId) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Potwierdzenie"),
            content: const Text("Czy na pewno chcesz przyjąć tego pacjenta?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  "Anuluj",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final goRouter = GoRouter.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final repo = ref.read(doctorRepositoryProvider);
                  Navigator.of(dialogContext).pop();

                  final result = await repo.assignPatient(admissionId);

                  result.fold(
                    (err) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Błąd przejmowania pacjenta'),
                        ),
                      );
                    },
                    (_) {
                      ref.invalidate(myPatientsProvider);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Zgłoszenie przejęte')),
                      );
                      goRouter.push('/consultation/$admissionId');
                    },
                  );
                },
                child: const Text("Potwierdź"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140.0,
            title: EsorLogo(),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            scrolledUnderElevation: 0.0,
            actions: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 16.0,
                child: Text(
                  user.initials,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    height: 1.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 10.0,
                ),
                child: Text(
                  'Dzień dobry,\nDr. ${user.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.0)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Pacjenci pod obserwacją",
              // action: IconButton(
              //   icon: const Icon(Icons.keyboard_arrow_right_rounded),
              //   onPressed: () {},
              // ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 6.0)),
          myPatients.when(
            data: (patients) {
              if (patients.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: StatusPlaceholder(
                        icon: Icons.info_rounded,
                        title: "Brak pacjentów pod obserwacją.",
                        description:
                            "Tutaj pojawią się pacjenci, których stan będziesz monitorować.",
                      ),
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 108.0,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    primary: false,
                    itemBuilder: (context, index) {
                      final admission = patients[index];
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280.0),
                        child: UnderObservationCard(
                          admission: admission,
                          onTap: () =>
                              context.push('/consultation/${admission.id}'),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10.0),
                    itemCount: patients.length,
                  ),
                ),
              );
            },
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: SizedBox(
                height: 108.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: StatusPlaceholder(
                      icon: Icons.error_rounded,
                      title: "Błąd pobierania danych.",
                      description: "Wystąpił błąd podczas pobierania danych. ",
                      errorMessage: error.toString(),
                      action: ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(myPatientsProvider);
                        },
                        label: const Text("Spróbuj ponownie"),
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            loading: () => SliverToBoxAdapter(
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.0)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Pacjenci w kolejce",
              // action: OutlinedButton.icon(
              //   style: OutlinedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //     ),
              //     padding: EdgeInsets.only(left: 10.0, right: 12.0),
              //   ),
              //   onPressed: () {},
              //   label: const Text("Historia"),
              //   icon: const Icon(Icons.history_rounded),
              // ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 6.0)),
          queue.when(
            data: (queue) {
              if (queue.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: StatusPlaceholder(
                        icon: Icons.info_rounded,
                        title: "Brak pacjentów w kolejce.",
                        description:
                            "Nowi pacjenci pojawią się tutaj, gdy tylko zostaną zgłoszeni.",
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) {
                    final admission = queue[index];
                    return PatientQueueCard(
                      admission: admission,
                      onTap: () =>
                          showConfirmationDialog(context, admission.id),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10.0),
                  itemCount: queue.length,
                ),
              );
            },
            error: (error, stackTrace) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: StatusPlaceholder(
                    icon: Icons.error_rounded,
                    title: "Błąd pobierania danych.",
                    description:
                        "Wystąpił błąd podczas pobierania danych. Spróbuj ponownie później.",
                    errorMessage: error.toString(),
                    action: ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(webSocketServiceProvider);
                      },
                      label: const Text("Spróbuj ponownie"),
                      icon: const Icon(Icons.refresh),
                    ),
                  ),
                ),
              ),
            ),
            loading: () => SliverFillRemaining(
              hasScrollBody: false,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
