import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../models/queue_item.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<QueueItem>>> getQueue();
  Future<Either<Failure, List<QueueItem>>> getActivePatients(String doctorId);
}
