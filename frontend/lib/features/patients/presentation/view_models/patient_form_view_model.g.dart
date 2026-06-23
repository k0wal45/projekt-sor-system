// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PatientFormViewModel)
final patientFormViewModelProvider = PatientFormViewModelProvider._();

final class PatientFormViewModelProvider
    extends
        $NotifierProvider<PatientFormViewModel, AsyncValue<PatientEntity?>> {
  PatientFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'patientFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$patientFormViewModelHash();

  @$internal
  @override
  PatientFormViewModel create() => PatientFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PatientEntity?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PatientEntity?>>(value),
    );
  }
}

String _$patientFormViewModelHash() =>
    r'5bb7614338574d29582d373306497f9b0f837ba4';

abstract class _$PatientFormViewModel
    extends $Notifier<AsyncValue<PatientEntity?>> {
  AsyncValue<PatientEntity?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PatientEntity?>, AsyncValue<PatientEntity?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PatientEntity?>,
                AsyncValue<PatientEntity?>
              >,
              AsyncValue<PatientEntity?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
