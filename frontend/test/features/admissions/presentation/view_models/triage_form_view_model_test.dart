import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/admissions/domain/admission_repository.dart';
import 'package:esor/features/admissions/presentation/view_models/triage_form_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAdmissionRepository extends Mock implements AdmissionRepository {}

void main() {
  late MockAdmissionRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAdmissionRepository();
    container = ProviderContainer(
      overrides: [
        admissionRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TriageFormViewModel', () {
    final testTriageDto = TriageFormDto(
      patientId: 1,
      arrivalMode: ArrivalMode.pieszo,
      injury: false,
      mentalStatus: MentalStatus.fullyConscious,
      pain: false,
      painLevel: 0,
      hr: 80,
      sbp: 120,
      dbp: 80,
      rr: 16,
      bt: 36.6,
      chiefComplaint: 'Headache',
    );

    final testAdmission = AdmissionEntity(
      id: 1,
      patientId: 1,
      registrarId: 1,
      admissionDate: DateTime.now(),
      arrivalMode: ArrivalMode.pieszo,
      injury: false,
      mentalStatus: MentalStatus.fullyConscious,
      pain: false,
      painLevel: 0,
      hr: 80,
      sbp: 120,
      dbp: 80,
      rr: 16,
      bt: 36.6,
      chiefComplaint: 'Headache',
      priorityKtas: 3,
      isAiPredicted: true,
      status: AdmissionStatus.inQueue,
    );

    test('initial state is AsyncData(null)', () {
      final state = container.read(triageFormViewModelProvider);
      expect(state, const AsyncData<void>(null));
    });

    group('predictKtas', () {
      test('updates state to AsyncLoading then AsyncData(null) and returns ktas on success', () async {
        // Arrange
        when(() => mockRepository.predictKtas(testTriageDto))
            .thenAnswer((_) async => right(3));

        final states = <AsyncValue<void>>[];
        container.listen(
          triageFormViewModelProvider,
          (previous, next) => states.add(next),
          fireImmediately: false,
        );

        // Act
        final result = await container.read(triageFormViewModelProvider.notifier).predictKtas(testTriageDto);

        // Assert
        expect(result, 3);
        expect(states.length, 2);
        expect(states[0], isA<AsyncLoading<void>>());
        expect(states[1], isA<AsyncData<void>>());
        verify(() => mockRepository.predictKtas(testTriageDto)).called(1);
      });

      test('updates state to AsyncError on failure and returns null', () async {
        // Arrange
        when(() => mockRepository.predictKtas(testTriageDto))
            .thenAnswer((_) async => left('Błąd API'));

        final states = <AsyncValue<void>>[];
        container.listen(
          triageFormViewModelProvider,
          (previous, next) => states.add(next),
          fireImmediately: false,
        );

        // Act
        final result = await container.read(triageFormViewModelProvider.notifier).predictKtas(testTriageDto);

        // Assert
        expect(result, isNull);
        expect(states.length, 2);
        expect(states[0], isA<AsyncLoading<void>>());
        expect(states[1], isA<AsyncError<void>>());
        expect(states[1].error, 'Błąd API');
        verify(() => mockRepository.predictKtas(testTriageDto)).called(1);
      });
    });

    group('submitTriage', () {
      test('updates state to AsyncData(null) and returns true on success', () async {
        // Arrange
        when(() => mockRepository.createAdmission(testTriageDto, 3, true))
            .thenAnswer((_) async => right(testAdmission));

        final states = <AsyncValue<void>>[];
        container.listen(
          triageFormViewModelProvider,
          (previous, next) => states.add(next),
          fireImmediately: false,
        );

        // Act
        final result = await container.read(triageFormViewModelProvider.notifier).submitTriage(testTriageDto, 3, true);

        // Assert
        expect(result, isTrue);
        expect(states.length, 2);
        expect(states[0], isA<AsyncLoading<void>>());
        expect(states[1], isA<AsyncData<void>>());
        verify(() => mockRepository.createAdmission(testTriageDto, 3, true)).called(1);
      });

      test('updates state to AsyncError and returns false on failure', () async {
        // Arrange
        when(() => mockRepository.createAdmission(testTriageDto, 3, true))
            .thenAnswer((_) async => left('Błąd tworzenia'));

        final states = <AsyncValue<void>>[];
        container.listen(
          triageFormViewModelProvider,
          (previous, next) => states.add(next),
          fireImmediately: false,
        );

        // Act
        final result = await container.read(triageFormViewModelProvider.notifier).submitTriage(testTriageDto, 3, true);

        // Assert
        expect(result, isFalse);
        expect(states.length, 2);
        expect(states[0], isA<AsyncLoading<void>>());
        expect(states[1], isA<AsyncError<void>>());
        expect(states[1].error, 'Błąd tworzenia');
        verify(() => mockRepository.createAdmission(testTriageDto, 3, true)).called(1);
      });
    });
  });
}
