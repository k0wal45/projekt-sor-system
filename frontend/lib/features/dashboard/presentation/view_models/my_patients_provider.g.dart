// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_patients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyPatients)
final myPatientsProvider = MyPatientsProvider._();

final class MyPatientsProvider
    extends $AsyncNotifierProvider<MyPatients, List<AdmissionEntity>> {
  MyPatientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPatientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPatientsHash();

  @$internal
  @override
  MyPatients create() => MyPatients();
}

String _$myPatientsHash() => r'f6b72ac347a62db81c672043269a97a50679ef73';

abstract class _$MyPatients extends $AsyncNotifier<List<AdmissionEntity>> {
  FutureOr<List<AdmissionEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AdmissionEntity>>, List<AdmissionEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdmissionEntity>>,
                List<AdmissionEntity>
              >,
              AsyncValue<List<AdmissionEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
