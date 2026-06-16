import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/auth_mock_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/staff.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(AuthMockDataSource());
}

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<Staff?> build() {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.login(email, password);

    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (staff) {
        state = AsyncData(staff);
      },
    );
  }

  void logout() {
    state = const AsyncData(null);
  }
}
