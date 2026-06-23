import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../admissions/domain/admission_entity.dart';

part 'queue_view_model.g.dart';

@riverpod
class QueueViewModel extends _$QueueViewModel {
  @override
  Stream<List<AdmissionEntity>> build() {
    final service = ref.watch(webSocketServiceProvider);
    return service.queueStream;
  }
}

@riverpod
Stream<List<AdmissionEntity>> visibleQueue(Ref ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.queueStream.map(
    (queue) => queue.where((e) => e.status == AdmissionStatus.inQueue).toList(),
  );
}
