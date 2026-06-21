import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_models/search_view_model.dart';
import '../../../../features/staff/domain/staff_entity.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPatientsTab = _tabController.index == 0;
    final sortOrder = ref.watch(sortOrderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyszukiwarka'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pacjenci'),
            Tab(text: 'Personel'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Szukaj po nazwisku (min. 3 znaki)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      ref.read(searchQueryProvider.notifier).setQuery(val);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    sortOrder == SortOrder.ascending
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  tooltip: 'Sortuj',
                  onPressed: () {
                    ref.read(sortOrderProvider.notifier).toggle();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPatientsList(), _buildStaffList()],
            ),
          ),
        ],
      ),
      floatingActionButton: isPatientsTab
          ? FloatingActionButton(
              onPressed: () {
                context.push('/patient-form/create');
              },
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }

  Widget _buildPatientsList() {
    final patientsState = ref.watch(patientsSearchProvider);

    return Column(
      children: [
        if (patientsState.isLoading && patientsState.hasValue)
          const LinearProgressIndicator(),
        Expanded(
          child: patientsState.when(
            skipLoadingOnReload: true,
            data: (patients) {
              if (patients.isEmpty) {
                return const Center(child: Text('Brak wyników.'));
              }
              return ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final p = patients[index];
                  return ListTile(
                    title: Text('${p.lastName} ${p.firstName}'),
                    subtitle: Text('PESEL: ${p.pesel}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push('/patient-form/view/${p.pesel}');
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Błąd: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffList() {
    final staffState = ref.watch(staffSearchProvider);

    return Column(
      children: [
        if (staffState.isLoading && staffState.hasValue)
          const LinearProgressIndicator(),
        Expanded(
          child: staffState.when(
            skipLoadingOnReload: true,
            data: (staff) {
              if (staff.isEmpty) {
                return const Center(child: Text('Brak wyników.'));
              }
              return ListView.builder(
                itemCount: staff.length,
                itemBuilder: (context, index) {
                  final s = staff[index];
                  return ListTile(
                    title: Text('${s.lastName} ${s.firstName}'),
                    subtitle: Text('Rola: ${s.role.displayName}'),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Błąd: $e')),
          ),
        ),
      ],
    );
  }
}
