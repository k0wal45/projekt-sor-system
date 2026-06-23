import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../features/patients/domain/patient_entity.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../features/staff/domain/staff_entity.dart';

part 'search_view_model.g.dart';

enum SortOrder { ascending, descending }

class _CancelledException implements Exception {
  const _CancelledException();
}

extension DebounceAndCancelExtension on Ref {
  Future<void> debounce([
    Duration duration = const Duration(milliseconds: 500),
  ]) async {
    var didDispose = false;
    onDispose(() => didDispose = true);
    await Future<void>.delayed(duration);
    if (didDispose) {
      throw const _CancelledException();
    }
  }
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

@riverpod
class SortOrderNotifier extends _$SortOrderNotifier {
  @override
  SortOrder build() => SortOrder.ascending;

  void toggle() {
    state = state == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
  }
}

@riverpod
Future<List<PatientEntity>> fetchedPatients(Ref ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.isNotEmpty && query.length < 3) {
    return [];
  }

  await ref.debounce();

  final repo = ref.watch(patientRepositoryProvider);
  final result = await repo.getPatients(query: query);

  return result.fold(
    (err) => throw Exception(err),
    (patients) => patients,
  );
}

@riverpod
class PatientsSearch extends _$PatientsSearch {
  @override
  FutureOr<List<PatientEntity>> build() async {
    final sortOrder = ref.watch(sortOrderProvider);
    final fetched = await ref.watch(fetchedPatientsProvider.future);

    final list = List<PatientEntity>.from(fetched);
    list.sort((a, b) {
      final comp = a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
      return sortOrder == SortOrder.ascending ? comp : -comp;
    });
    return list;
  }
}

@riverpod
Future<List<StaffEntity>> fetchedStaff(Ref ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.isNotEmpty && query.length < 3) {
    return [];
  }

  await ref.debounce();

  final repo = ref.watch(staffRepositoryProvider);
  final result = await repo.getStaff(query: query);

  return result.fold(
    (err) => throw Exception(err),
    (staff) => staff,
  );
}

@riverpod
class StaffSearch extends _$StaffSearch {
  @override
  FutureOr<List<StaffEntity>> build() async {
    final sortOrder = ref.watch(sortOrderProvider);
    final fetched = await ref.watch(fetchedStaffProvider.future);

    final list = List<StaffEntity>.from(fetched);
    list.sort((a, b) {
      final comp = a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
      return sortOrder == SortOrder.ascending ? comp : -comp;
    });
    return list;
  }
}
