// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QueueViewModel)
final queueViewModelProvider = QueueViewModelProvider._();

final class QueueViewModelProvider
    extends $StreamNotifierProvider<QueueViewModel, List<AdmissionEntity>> {
  QueueViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueViewModelHash();

  @$internal
  @override
  QueueViewModel create() => QueueViewModel();
}

String _$queueViewModelHash() => r'c22923f0e1578ddcd476692cff90809108c40091';

abstract class _$QueueViewModel extends $StreamNotifier<List<AdmissionEntity>> {
  Stream<List<AdmissionEntity>> build();
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
