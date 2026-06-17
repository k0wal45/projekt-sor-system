import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/models/queue_item.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_mock_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardMockDataSource _dataSource;

  DashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<QueueItem>>> getQueue() async {
    try {
      final queue = await _dataSource.fetchQueue();
      return Right(queue);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QueueItem>>> getActivePatients(String doctorId) async {
    try {
      final active = await _dataSource.fetchActivePatients(doctorId);
      return Right(active);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
