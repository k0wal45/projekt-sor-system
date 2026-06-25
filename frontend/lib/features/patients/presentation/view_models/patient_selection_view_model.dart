import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/patient_entity.dart';
import '../../../../core/providers/repository_providers.dart';

part 'patient_selection_view_model.g.dart';

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
class PatientSelectionQuery extends _$PatientSelectionQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

@riverpod
Future<List<PatientEntity>> patientSelectionSearch(Ref ref) async {
  final query = ref.watch(patientSelectionQueryProvider);

  if (query.isNotEmpty && query.length < 3) {
    return []; // Return empty if query is too short
  }

  if (query.isNotEmpty) {
    await ref.debounce();
  }

  final repo = ref.watch(patientRepositoryProvider);
  final result = await repo.getPatients(query: query);

  return result.fold(
    (err) => throw err,
    (patients) => patients,
  );
}
