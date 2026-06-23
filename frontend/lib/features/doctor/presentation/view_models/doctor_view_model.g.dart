// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DoctorViewModel)
final doctorViewModelProvider = DoctorViewModelProvider._();

final class DoctorViewModelProvider
    extends $NotifierProvider<DoctorViewModel, AsyncValue<void>> {
  DoctorViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorViewModelHash();

  @$internal
  @override
  DoctorViewModel create() => DoctorViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$doctorViewModelHash() => r'3b07a929945e07501a688bffd95d26391c942f00';

abstract class _$DoctorViewModel extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
