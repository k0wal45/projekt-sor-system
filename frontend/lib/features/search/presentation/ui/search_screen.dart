import 'package:esor/shared/utils/date_time_utils.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 0.0,
        toolbarHeight: 66.0,
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 4.0),
          child: TextField(
            onChanged: (val) {
              ref.read(searchQueryProvider.notifier).setQuery(val);
            },
            decoration: InputDecoration(
              hintText: 'Szukaj według nazwiska',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                child: const Icon(Icons.search),
              ),
              prefixIconConstraints: const BoxConstraints(maxWidth: 40),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
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
            icon: Icon(
              sortOrder == SortOrder.ascending
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
            ),
            tooltip: 'Sortuj',
            onPressed: () {
              ref.read(sortOrderProvider.notifier).toggle();
            },
          ),
          const SizedBox(width: 16.0),
        ],
        bottom: TabBar(
          controller: _tabController,
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
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPatientsList(), _buildStaffList()],
            ),
          ),
        ],
      ),
      floatingActionButton: isPatientsTab
          ? FloatingActionButton.extended(
              label: const Text('Dodaj pacjenta'),
              icon: const Icon(Icons.person_add),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                context.push('/patient-form/create');
              },
              heroTag: 'patient-add',
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
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
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
                        context.push('/patient-form/view/${p.pesel}');
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
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: staff.length,
                itemBuilder: (context, index) {
                  final s = staff[index];
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
                      isThreeLine: true,
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          s.lastName[0].toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                      title: Text('${s.lastName} ${s.firstName}'),
                      subtitle: Text(
                        'Rola: ${s.role.displayName}\nEmail: ${s.email}',
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
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
