import 'package:esor/core/network/websocket_service.dart';
import 'package:esor/features/dashboard/presentation/view_models/queue_view_model.dart';
import 'package:esor/features/dashboard/presentation/widgets/patient_queue_card.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:esor/shared/widgets/esor_logo.dart';
import 'package:esor/shared/widgets/status_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DefaultDashboardScreen extends ConsumerWidget {
  const DefaultDashboardScreen({super.key, required this.user});

  final StaffEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: EsorLogo(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 18.0,
              child: Text(
                user.initials,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  height: 1.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () => context.push('/triage-form'),
        icon: const Icon(Icons.add),
        label: const Text('Nowe zgłoszenie'),
        heroTag: "add-admission-button",
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 12.0)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pacjenci w kolejce",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.only(left: 10.0, right: 12.0),
                      ),
                      onPressed: () {},
                      label: const Text("Historia"),
                      icon: const Icon(Icons.history_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 6.0)),
          queue.when(
            data: (queue) {
              if (queue.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: StatusPlaceholder(
                        icon: Icons.info_rounded,
                        title: "Brak pacjentów w kolejce.",
                        description:
                            "Nowi pacjenci pojawią się tutaj, gdy tylko zostaną zgłoszeni.",
                        action: ElevatedButton.icon(
                          onPressed: () => context.push('/triage-form'),
                          label: const Text("Utwórz zgłoszenie"),
                          icon: const Icon(Icons.add),
                        ),
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
                    return PatientQueueCard(admission: admission);
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
                  padding: const EdgeInsets.only(bottom: 60.0),
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
