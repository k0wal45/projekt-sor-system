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
        title: const Text('Wybierz Pacjenta'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Szukaj pacjenta (PESEL, imię, nazwisko)...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                ref.read(patientSelectionQueryProvider.notifier).setQuery(val);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/patient-form/create');
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Nowy Pacjent'),
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
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('${patient.firstName} ${patient.lastName}'),
                subtitle: Text('PESEL: ${patient.pesel}'),
                onTap: () {
                  context.pop(patient);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Błąd: $err')),
      ),
    );
  }
}
