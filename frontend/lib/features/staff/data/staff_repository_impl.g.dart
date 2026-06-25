// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(staffRepository)
final staffRepositoryProvider = StaffRepositoryProvider._();

final class StaffRepositoryProvider
    extends
        $FunctionalProvider<StaffRepository, StaffRepository, StaffRepository>
    with $Provider<StaffRepository> {
  StaffRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRepositoryHash();

  @$internal
  @override
  $ProviderElement<StaffRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StaffRepository create(Ref ref) {
    return staffRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffRepository>(value),
    );
  }
}

String _$staffRepositoryHash() => r'30cadc1273772263c74d24ef61de3e8123d0f4c9';
