import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../staff/domain/staff_entity.dart';
import 'package:esor/core/providers/repository_providers.dart';

part 'auth_view_model.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<StaffEntity?> build() async {
    // Attempt to load user data if token exists
    return _initAuth();
  }

  Future<StaffEntity?> _initAuth() async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.getMe();
    
    return result.fold(
      (error) => null, // Not logged in
      (user) => user,  // Logged in
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    
    final result = await repo.login(email, password);
    
    state = result.fold(
      (error) => AsyncError(error, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(null);
  }
}
