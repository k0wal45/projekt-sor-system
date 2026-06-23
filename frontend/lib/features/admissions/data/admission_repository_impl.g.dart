// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(admissionRepository)
final admissionRepositoryProvider = AdmissionRepositoryProvider._();

final class AdmissionRepositoryProvider
    extends
        $FunctionalProvider<
          AdmissionRepository,
          AdmissionRepository,
          AdmissionRepository
        >
    with $Provider<AdmissionRepository> {
  AdmissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'admissionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$admissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdmissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdmissionRepository create(Ref ref) {
    return admissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdmissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdmissionRepository>(value),
    );
  }
}

String _$admissionRepositoryHash() =>
    r'40d4e3373f3099e1f4f1fd6d226733b25306dab7';
