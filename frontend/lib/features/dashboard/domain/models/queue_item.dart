import 'package:freezed_annotation/freezed_annotation.dart';
import 'patient.dart';
import 'admission.dart';

part 'queue_item.freezed.dart';

@freezed
abstract class QueueItem with _$QueueItem {
  const factory QueueItem({
    required Patient patient,
    required Admission admission,
  }) = _QueueItem;
}

extension QueueItemExtension on QueueItem {
  Duration get waitingTime => DateTime.now().difference(admission.admissionTime);
}
