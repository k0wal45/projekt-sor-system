// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triage_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TriageFormViewModel)
final triageFormViewModelProvider = TriageFormViewModelProvider._();

final class TriageFormViewModelProvider
    extends $NotifierProvider<TriageFormViewModel, AsyncValue<void>> {
  TriageFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triageFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triageFormViewModelHash();

  @$internal
  @override
  TriageFormViewModel create() => TriageFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$triageFormViewModelHash() =>
    r'af5233fefb8ba00b2c630cb88fab5217f6464fc9';

abstract class _$TriageFormViewModel extends $Notifier<AsyncValue<void>> {
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
