import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/search_viewmodel.dart';
import '../../../dashboard/domain/models/patient.dart';
import '../../../auth/domain/models/staff.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchViewModelProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          scrolledUnderElevation: 0.0,
          toolbarHeight: 66.0,
          titleSpacing: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 4.0),
            child: TextField(
              onChanged: (value) =>
                  ref.read(searchViewModelProvider.notifier).updateQuery(value),
              decoration: InputDecoration(
                hintText: 'Szukaj według nazwiska lub PESELu',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                  child: const Icon(Icons.search),
                ),
                prefixIconConstraints: const BoxConstraints(maxWidth: 40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: 16.0),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Pacjenci'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge),
                    SizedBox(width: 8),
                    Text('Personel'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: searchState.when(
          data: (state) => TabBarView(
            children: [
              _buildPatientList(state.patients),
              _buildStaffList(state.staffList),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildPatientList(List<Patient> patients) {
    if (patients.isEmpty) return const Center(child: Text('Brak wyników'));
    return ListView.separated(
      itemCount: patients.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(0),
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  patient.firstName[0],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              title: Text(
                '${patient.firstName} ${patient.lastName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'PESEL: ${patient.pesel}\nUr. ${patient.dateOfBirth.year}-${patient.dateOfBirth.month.toString().padLeft(2, '0')}-${patient.dateOfBirth.day.toString().padLeft(2, '0')}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
              contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }

  Widget _buildStaffList(List<Staff> staff) {
    if (staff.isEmpty) return const Center(child: Text('Brak wyników'));
    return ListView.separated(
      itemCount: staff.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final s = staff[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(0),
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  s.firstName[0],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              title: Text(
                '${s.firstName} ${s.lastName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Rola: ${s.role.name}'),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
              contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
