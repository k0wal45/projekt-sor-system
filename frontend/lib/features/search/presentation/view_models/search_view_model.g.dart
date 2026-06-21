// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'2c146927785523a0ddf51b23b777a9be4afdc092';

abstract class _$SearchQuery extends $Notifier<String> {
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

@ProviderFor(SortOrderNotifier)
final sortOrderProvider = SortOrderNotifierProvider._();

final class SortOrderNotifierProvider
    extends $NotifierProvider<SortOrderNotifier, SortOrder> {
  SortOrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortOrderNotifierHash();

  @$internal
  @override
  SortOrderNotifier create() => SortOrderNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortOrder>(value),
    );
  }
}

String _$sortOrderNotifierHash() => r'14d01108e8b7aa58fbed0a0bb4b8cc3ea7c927d0';

abstract class _$SortOrderNotifier extends $Notifier<SortOrder> {
  SortOrder build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SortOrder, SortOrder>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortOrder, SortOrder>,
              SortOrder,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(fetchedPatients)
final fetchedPatientsProvider = FetchedPatientsProvider._();

final class FetchedPatientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PatientEntity>>,
          List<PatientEntity>,
          FutureOr<List<PatientEntity>>
        >
    with
        $FutureModifier<List<PatientEntity>>,
        $FutureProvider<List<PatientEntity>> {
  FetchedPatientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchedPatientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchedPatientsHash();

  @$internal
  @override
  $FutureProviderElement<List<PatientEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PatientEntity>> create(Ref ref) {
    return fetchedPatients(ref);
  }
}

String _$fetchedPatientsHash() => r'daefda421d6490bd8ff686aac9d2cb66b261ccfb';

@ProviderFor(PatientsSearch)
final patientsSearchProvider = PatientsSearchProvider._();

final class PatientsSearchProvider
    extends $AsyncNotifierProvider<PatientsSearch, List<PatientEntity>> {
  PatientsSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'patientsSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$patientsSearchHash();

  @$internal
  @override
  PatientsSearch create() => PatientsSearch();
}

String _$patientsSearchHash() => r'8117b5a7a994cee298219ecc406bb0ecf0a92b9d';

abstract class _$PatientsSearch extends $AsyncNotifier<List<PatientEntity>> {
  FutureOr<List<PatientEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PatientEntity>>, List<PatientEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PatientEntity>>, List<PatientEntity>>,
              AsyncValue<List<PatientEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(fetchedStaff)
final fetchedStaffProvider = FetchedStaffProvider._();

final class FetchedStaffProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StaffEntity>>,
          List<StaffEntity>,
          FutureOr<List<StaffEntity>>
        >
    with
        $FutureModifier<List<StaffEntity>>,
        $FutureProvider<List<StaffEntity>> {
  FetchedStaffProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchedStaffProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchedStaffHash();

  @$internal
  @override
  $FutureProviderElement<List<StaffEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StaffEntity>> create(Ref ref) {
    return fetchedStaff(ref);
  }
}

String _$fetchedStaffHash() => r'78215fe2e36f2df8a72fc7dd88ecc6cdb1076538';

@ProviderFor(StaffSearch)
final staffSearchProvider = StaffSearchProvider._();

final class StaffSearchProvider
    extends $AsyncNotifierProvider<StaffSearch, List<StaffEntity>> {
  StaffSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffSearchHash();

  @$internal
  @override
  StaffSearch create() => StaffSearch();
}

String _$staffSearchHash() => r'3a9f7833dfd7cddee47472682b0e3a184700f3db';

abstract class _$StaffSearch extends $AsyncNotifier<List<StaffEntity>> {
  FutureOr<List<StaffEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StaffEntity>>, List<StaffEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StaffEntity>>, List<StaffEntity>>,
              AsyncValue<List<StaffEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
