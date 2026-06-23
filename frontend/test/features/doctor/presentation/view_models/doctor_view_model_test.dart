import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/doctor/domain/doctor_repository.dart';
import 'package:esor/features/doctor/presentation/view_models/doctor_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorRepository extends Mock implements DoctorRepository {}

void main() {
  late MockDoctorRepository mockRepo;

  setUp(() {
    mockRepo = MockDoctorRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        doctorRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  }

  group('DoctorViewModel', () {
    test('initial state is AsyncData(null)', () {
      final container = createContainer();
      final state = container.read(doctorViewModelProvider);
      expect(state, const AsyncData<void>(null));
    });

    test('assignPatient updates state to AsyncData on success and returns true', () async {
      final container = createContainer();
      when(() => mockRepo.assignPatient(1)).thenAnswer((_) async => right(null));

      final viewModel = container.read(doctorViewModelProvider.notifier);
      final result = await viewModel.assignPatient(1);

      expect(result, isTrue);
      expect(container.read(doctorViewModelProvider), const AsyncData<void>(null));
      verify(() => mockRepo.assignPatient(1)).called(1);
    });

    test('assignPatient updates state to AsyncError on failure and returns false', () async {
      final container = createContainer();
      when(() => mockRepo.assignPatient(1)).thenAnswer((_) async => left('Error'));

      final viewModel = container.read(doctorViewModelProvider.notifier);
      final result = await viewModel.assignPatient(1);

      expect(result, isFalse);
      expect(container.read(doctorViewModelProvider).hasError, isTrue);
      expect(container.read(doctorViewModelProvider).error.toString(), contains('Error'));
    });

    test('updateStatus updates state to AsyncData on success and returns true', () async {
      final container = createContainer();
      when(() => mockRepo.updateAdmissionStatus(1, AdmissionStatus.inConsultation))
          .thenAnswer((_) async => right(null));

      final viewModel = container.read(doctorViewModelProvider.notifier);
      final result = await viewModel.updateStatus(1, AdmissionStatus.inConsultation);

      expect(result, isTrue);
      expect(container.read(doctorViewModelProvider), const AsyncData<void>(null));
    });

    test('orderDiagnostics updates state to AsyncData on success and returns true', () async {
      final container = createContainer();
      when(() => mockRepo.orderDiagnostics(1, 'USG', 'Test'))
          .thenAnswer((_) async => right(null));

      final viewModel = container.read(doctorViewModelProvider.notifier);
      final result = await viewModel.orderDiagnostics(1, 'USG', 'Test');

      expect(result, isTrue);
      expect(container.read(doctorViewModelProvider), const AsyncData<void>(null));
    });

    test('completeConsultation updates state to AsyncData on success and returns true', () async {
      final container = createContainer();
      when(() => mockRepo.completeConsultation(1, 'Wywiad', 'J00', 'Do domu'))
          .thenAnswer((_) async => right(null));

      final viewModel = container.read(doctorViewModelProvider.notifier);
      final result = await viewModel.completeConsultation(1, 'Wywiad', 'J00', 'Do domu');

      expect(result, isTrue);
      expect(container.read(doctorViewModelProvider), const AsyncData<void>(null));
    });

    test('completeConsultation returns false on error', () async {
      final container = createContainer();
      when(() => mockRepo.completeConsultation(1, 'Wywiad', 'J00', 'Do domu'))
          .thenAnswer((_) async => left('Api error'));

      final viewModel = container.read(doctorViewModelProvider.notifier);
      final result = await viewModel.completeConsultation(1, 'Wywiad', 'J00', 'Do domu');

      expect(result, isFalse);
      expect(container.read(doctorViewModelProvider).hasError, isTrue);
      expect(container.read(doctorViewModelProvider).error.toString(), contains('Api error'));
    });
  });
}
