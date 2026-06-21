import 'package:esor/features/auth/presentation/view_models/auth_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/queue_item.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../data/datasources/dashboard_mock_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../../auth/domain/models/staff.dart';

part 'dashboard_viewmodel.freezed.dart';
part 'dashboard_viewmodel.g.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default([]) List<QueueItem> queue,
    @Default([]) List<QueueItem> activePatients,
  }) = _DashboardState;
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(DashboardMockDataSource());
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  FutureOr<DashboardState> build() async {
    return _fetchData();
  }

  Future<DashboardState> _fetchData() async {
    final repository = ref.read(dashboardRepositoryProvider);
    final authState = ref.read(authProvider);

    final staff = authState.value;

    final queueResult = await repository.getQueue();
    List<QueueItem> queue = [];
    queueResult.fold((l) => throw Exception(l.message), (r) => queue = r);

    List<QueueItem> active = [];
    // Only fetch active patients for doctors
    // if (staff != null && staff.role == StaffRole.doctor) {
    //   final activeResult = await repository.getActivePatients(staff.id);
    //   activeResult.fold((l) => throw Exception(l.message), (r) => active = r);
    // }

    return DashboardState(queue: queue, activePatients: active);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchData());
  }
}
