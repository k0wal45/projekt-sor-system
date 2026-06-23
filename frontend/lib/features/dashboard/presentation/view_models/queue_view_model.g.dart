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
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueViewModelHash();

  @$internal
  @override
  QueueViewModel create() => QueueViewModel();
}

String _$queueViewModelHash() => r'b290f6b4c94195cf18b2f67000c7d0e387f6bcf4';

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

@ProviderFor(visibleQueue)
final visibleQueueProvider = VisibleQueueProvider._();

final class VisibleQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdmissionEntity>>,
          List<AdmissionEntity>,
          Stream<List<AdmissionEntity>>
        >
    with
        $FutureModifier<List<AdmissionEntity>>,
        $StreamProvider<List<AdmissionEntity>> {
  VisibleQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleQueueHash();

  @$internal
  @override
  $StreamProviderElement<List<AdmissionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AdmissionEntity>> create(Ref ref) {
    return visibleQueue(ref);
  }
}

String _$visibleQueueHash() => r'b2caa80a17adadbd972934e3b55ff125b91486dd';
