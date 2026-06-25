import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../admissions/domain/admission_entity.dart';

part 'queue_view_model.g.dart';

@Riverpod(keepAlive: true)
class QueueViewModel extends _$QueueViewModel {
  @override
  Stream<List<AdmissionEntity>> build() {
    final service = ref.watch(webSocketServiceProvider);
    return service.queueStream;
  }
}
