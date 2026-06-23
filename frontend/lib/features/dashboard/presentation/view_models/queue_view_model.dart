import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../admissions/domain/admission_entity.dart';

final queueViewModelProvider = StreamProvider.autoDispose<List<AdmissionEntity>>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  // Connect explicitly if not connected, although PublicBoard does it on init, Dashboard should do it too
  service.connect();
  return service.queueStream;
});
