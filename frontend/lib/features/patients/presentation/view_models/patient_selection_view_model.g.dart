// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_selection_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PatientSelectionQuery)
final patientSelectionQueryProvider = PatientSelectionQueryProvider._();

final class PatientSelectionQueryProvider
    extends $NotifierProvider<PatientSelectionQuery, String> {
  PatientSelectionQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'patientSelectionQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$patientSelectionQueryHash();

  @$internal
  @override
  PatientSelectionQuery create() => PatientSelectionQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$patientSelectionQueryHash() =>
    r'c6fdb96fae5763cbda08eb0e294d71e9e87d47d7';

abstract class _$PatientSelectionQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(patientSelectionSearch)
final patientSelectionSearchProvider = PatientSelectionSearchProvider._();

final class PatientSelectionSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PatientEntity>>,
          List<PatientEntity>,
          FutureOr<List<PatientEntity>>
        >
    with
        $FutureModifier<List<PatientEntity>>,
        $FutureProvider<List<PatientEntity>> {
  PatientSelectionSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'patientSelectionSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$patientSelectionSearchHash();

  @$internal
  @override
  $FutureProviderElement<List<PatientEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PatientEntity>> create(Ref ref) {
    return patientSelectionSearch(ref);
  }
}

String _$patientSelectionSearchHash() =>
    r'60007e1da2aefb7afa38ff418b6c025b62347378';
