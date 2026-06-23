import 'dart:async';
import 'package:esor/core/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/admission_repository.dart';

part 'triage_form_view_model.g.dart';

@riverpod
class TriageFormViewModel extends _$TriageFormViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<int?> predictKtas(TriageFormDto dto) async {
    state = const AsyncValue.loading();
    final repo = ref.read(admissionRepositoryProvider);
    final result = await repo.predictKtas(dto);

    int? suggestedKtas;
    state = result.fold((err) => AsyncValue.error(err, StackTrace.current), (
      ktas,
    ) {
      suggestedKtas = ktas;
      return const AsyncValue.data(null);
    });
    return suggestedKtas;
  }

  Future<bool> submitTriage(
    TriageFormDto dto,
    int priorityKtas,
    bool isAiPredicted,
  ) async {
    state = const AsyncValue.loading();
    final repo = ref.read(admissionRepositoryProvider);
    final result = await repo.createAdmission(dto, priorityKtas, isAiPredicted);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );

    return !state.hasError;
  }
}
