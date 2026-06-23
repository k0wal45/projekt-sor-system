import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/auth/domain/auth_repository.dart';
import 'package:esor/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    final testUser = StaffEntity(
      id: 1,
      firstName: 'Jan',
      lastName: 'Kowalski',
      email: testEmail,
      academicTitle: 'dr',
      role: StaffRole.doctor,
    );

    test('initial state is AsyncData(user) if getMe succeeds', () async {
      // Arrange
      when(
        () => mockRepository.getMe(),
      ).thenAnswer((_) async => right(testUser));

      // Act
      final subscription = container.listen(authViewModelProvider, (_, _) {});
      // final viewModel = container.read(authViewModelProvider.notifier);

      // Riverpod AsyncNotifier's build is called upon first read/listen.
      // We must wait for the future to complete to see the final state.
      await container.read(authViewModelProvider.future);

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state, isA<AsyncData<StaffEntity?>>());
      expect(state.value, testUser);
      subscription.close();
    });

    test(
      'initial state is AsyncData(null) if getMe fails (not logged in)',
      () async {
        // Arrange
        when(() => mockRepository.getMe()).thenAnswer(
          (_) async => left('Brak tokenu. Użytkownik niezalogowany.'),
        );

        // Act
        final subscription = container.listen(authViewModelProvider, (_, _) {});

        // Await build completion
        await container.read(authViewModelProvider.future);

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state, isA<AsyncData<StaffEntity?>>());
        expect(state.value, isNull);
        subscription.close();
      },
    );

    test('login updates state to AsyncData(user) on success', () async {
      // Arrange
      when(
        () => mockRepository.getMe(),
      ).thenAnswer((_) async => left('Not logged in'));
      when(
        () => mockRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => right(testUser));

      final states = <AsyncValue<StaffEntity?>>[];
      container.listen(
        authViewModelProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      // Await initialization
      await container.read(authViewModelProvider.future);
      states.clear(); // Clear initialization states

      // Act
      await container
          .read(authViewModelProvider.notifier)
          .login(testEmail, testPassword);

      // Assert
      expect(states.length, 2);
      expect(states[0], isA<AsyncLoading<StaffEntity?>>());
      expect(states[1], isA<AsyncData<StaffEntity?>>());
      expect(states[1].value, testUser);
      verify(() => mockRepository.login(testEmail, testPassword)).called(1);
    });

    test('login updates state to AsyncError on failure', () async {
      // Arrange
      when(
        () => mockRepository.getMe(),
      ).thenAnswer((_) async => left('Not logged in'));
      when(
        () => mockRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => left('Nieprawidłowy email lub hasło.'));

      final states = <AsyncValue<StaffEntity?>>[];
      container.listen(
        authViewModelProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      // Await initialization
      try {
        await container.read(authViewModelProvider.future);
      } catch (_) {}
      states.clear();

      // Act
      await container
          .read(authViewModelProvider.notifier)
          .login(testEmail, testPassword);

      // Assert
      expect(states.length, 2);
      expect(states[0], isA<AsyncLoading<StaffEntity?>>());
      expect(states[1], isA<AsyncError<StaffEntity?>>());
      expect(states[1].error, 'Nieprawidłowy email lub hasło.');
    });

    test(
      'logout clears user data and updates state to AsyncData(null)',
      () async {
        // Arrange
        when(
          () => mockRepository.getMe(),
        ).thenAnswer((_) async => right(testUser));
        when(() => mockRepository.logout()).thenAnswer((_) async {});

        final states = <AsyncValue<StaffEntity?>>[];
        container.listen(
          authViewModelProvider,
          (previous, next) => states.add(next),
          fireImmediately: false,
        );

        // Await initialization
        await container.read(authViewModelProvider.future);
        states.clear();

        // Act
        await container.read(authViewModelProvider.notifier).logout();

        // Assert
        expect(states.length, 2);
        expect(states[0], isA<AsyncLoading<StaffEntity?>>());
        expect(states[1], isA<AsyncData<StaffEntity?>>());
        expect(states[1].value, isNull);
        verify(() => mockRepository.logout()).called(1);
      },
    );
  });
}
