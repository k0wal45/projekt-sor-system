import 'package:esor/shared/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_models/patient_selection_view_model.dart';

class PatientSelectionScreen extends ConsumerWidget {
  const PatientSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(patientSelectionQueryProvider);
    final patientsState = ref.watch(patientSelectionSearchProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Wybierz Pacjenta'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/patient-form/create');
            },
            icon: const Icon(Icons.person_add),
          ),
          SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Szukaj pacjenta po nazwisku',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (val) {
                ref.read(patientSelectionQueryProvider.notifier).setQuery(val);
              },
            ),
          ),
        ),
      ),
      body: patientsState.when(
        data: (patients) {
          if (patients.isEmpty) {
            return Center(
              child: Text(
                query.isEmpty
                    ? 'Wpisz dane pacjenta, aby wyszukać.'
                    : 'Nie znaleziono pacjentów.',
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final p = patients[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isThreeLine: true,
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      p.lastName[0].toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  title: Text('${p.lastName} ${p.firstName}'),
                  subtitle: Text(
                    'PESEL: ${p.pesel}\nUr. ${DateTimeUtils.formatDate(p.birthDate)}r.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    context.pop(p);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Błąd: $err')),
      ),
    );
  }
}
