// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssignPatientViewModel)
final assignPatientViewModelProvider = AssignPatientViewModelProvider._();

final class AssignPatientViewModelProvider
    extends $NotifierProvider<AssignPatientViewModel, AsyncValue<void>> {
  AssignPatientViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignPatientViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignPatientViewModelHash();

  @$internal
  @override
  AssignPatientViewModel create() => AssignPatientViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$assignPatientViewModelHash() =>
    r'ae805d75c80e7f976e4b773b536b9c4a135a6174';

abstract class _$AssignPatientViewModel extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(UpdateStatusViewModel)
final updateStatusViewModelProvider = UpdateStatusViewModelProvider._();

final class UpdateStatusViewModelProvider
    extends $NotifierProvider<UpdateStatusViewModel, AsyncValue<void>> {
  UpdateStatusViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateStatusViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateStatusViewModelHash();

  @$internal
  @override
  UpdateStatusViewModel create() => UpdateStatusViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$updateStatusViewModelHash() =>
    r'7138177d272f6b986c661799fdda1d6ab51b20ba';

abstract class _$UpdateStatusViewModel extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(OrderDiagnosticsViewModel)
final orderDiagnosticsViewModelProvider = OrderDiagnosticsViewModelProvider._();

final class OrderDiagnosticsViewModelProvider
    extends $NotifierProvider<OrderDiagnosticsViewModel, AsyncValue<void>> {
  OrderDiagnosticsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderDiagnosticsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderDiagnosticsViewModelHash();

  @$internal
  @override
  OrderDiagnosticsViewModel create() => OrderDiagnosticsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$orderDiagnosticsViewModelHash() =>
    r'ada2f28530f803724b5615aaaf00ea7930cb06a1';

abstract class _$OrderDiagnosticsViewModel extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(CompleteConsultationViewModel)
final completeConsultationViewModelProvider =
    CompleteConsultationViewModelProvider._();

final class CompleteConsultationViewModelProvider
    extends $NotifierProvider<CompleteConsultationViewModel, AsyncValue<void>> {
  CompleteConsultationViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeConsultationViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeConsultationViewModelHash();

  @$internal
  @override
  CompleteConsultationViewModel create() => CompleteConsultationViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$completeConsultationViewModelHash() =>
    r'b2fc2ffe8dc7272b7734e9498995228a3c4496a1';

abstract class _$CompleteConsultationViewModel
    extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(AdmissionDetailsViewModel)
final admissionDetailsViewModelProvider = AdmissionDetailsViewModelFamily._();

final class AdmissionDetailsViewModelProvider
    extends
        $AsyncNotifierProvider<AdmissionDetailsViewModel, AdmissionEntity?> {
  AdmissionDetailsViewModelProvider._({
    required AdmissionDetailsViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'admissionDetailsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$admissionDetailsViewModelHash();

  @override
  String toString() {
    return r'admissionDetailsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdmissionDetailsViewModel create() => AdmissionDetailsViewModel();

  @override
  bool operator ==(Object other) {
    return other is AdmissionDetailsViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$admissionDetailsViewModelHash() =>
    r'1f6c51020a1188073b51e10f5319bd06c204129b';

final class AdmissionDetailsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          AdmissionDetailsViewModel,
          AsyncValue<AdmissionEntity?>,
          AdmissionEntity?,
          FutureOr<AdmissionEntity?>,
          int
        > {
  AdmissionDetailsViewModelFamily._()
    : super(
        retry: null,
        name: r'admissionDetailsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdmissionDetailsViewModelProvider call(int admissionId) =>
      AdmissionDetailsViewModelProvider._(argument: admissionId, from: this);

  @override
  String toString() => r'admissionDetailsViewModelProvider';
}

abstract class _$AdmissionDetailsViewModel
    extends $AsyncNotifier<AdmissionEntity?> {
  late final _$args = ref.$arg as int;
  int get admissionId => _$args;

  FutureOr<AdmissionEntity?> build(int admissionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AdmissionEntity?>, AdmissionEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdmissionEntity?>, AdmissionEntity?>,
              AsyncValue<AdmissionEntity?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
