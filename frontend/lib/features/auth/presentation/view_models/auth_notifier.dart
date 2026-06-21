import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/models/user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    return _checkAuthStatus();
  }

  Future<User?> _checkAuthStatus() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.fetchProfile();

    return result.fold(
      (failure) {
        if (failure is AuthFailure) {
          return null; // Niezalogowany
        }
        throw failure; // Inne błędy (np. brak neta)
      },
      (user) => user,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login(email, password);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(null);
  }
}
