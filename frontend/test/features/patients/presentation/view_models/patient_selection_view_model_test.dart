import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/patients/domain/patient_entity.dart';
import 'package:esor/features/patients/domain/patient_repository.dart';
import 'package:esor/features/patients/presentation/view_models/patient_selection_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

void main() {
  late MockPatientRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockPatientRepository();
    container = ProviderContainer(
      overrides: [
        patientRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PatientSelectionQuery', () {
    test('initial state is empty string', () {
      final query = container.read(patientSelectionQueryProvider);
      expect(query, '');
    });

    test('setQuery updates state', () {
      container.read(patientSelectionQueryProvider.notifier).setQuery('Kowalski');
      final query = container.read(patientSelectionQueryProvider);
      expect(query, 'Kowalski');
    });
  });

  group('patientSelectionSearch', () {
    final testPatientEntity = PatientEntity(
      id: 1,
      pesel: '12345678901',
      firstName: 'Jan',
      lastName: 'Kowalski',
      birthDate: DateTime.utc(1990, 1, 1),
      gender: Gender.m,
      address: 'Testowa 1',
      phone: '123123123',
      email: 'jan@test.pl',
      emergencyContactName: 'Anna Kowalska',
      emergencyContactPhone: '321321321',
      bloodGroup: BloodGroup.aPlus,
      allergies: 'Brak',
      chronicDiseases: 'Brak',
    );

    test('returns empty list if query length is less than 3', () async {
      // Arrange
      when(() => mockRepository.getPatients(query: any(named: 'query')))
          .thenAnswer((_) async => right([]));
          
      // Act
      final subscription = container.listen(patientSelectionSearchProvider, (_, __) {});
      container.read(patientSelectionQueryProvider.notifier).setQuery('Ko');
      
      final result = await container.read(patientSelectionSearchProvider.future);

      // Assert
      expect(result, isEmpty);
      // Wait, getPatients with empty query is called once on initial listen
      verify(() => mockRepository.getPatients(query: '')).called(1);
      verifyNever(() => mockRepository.getPatients(query: 'Ko'));
      subscription.close();
    });

    test('returns patients list if query length is >= 3 and repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getPatients(query: any(named: 'query')))
          .thenAnswer((_) async => right([testPatientEntity]));

      // Act
      final subscription = container.listen(patientSelectionSearchProvider, (_, __) {});
      // initial load
      await container.read(patientSelectionSearchProvider.future);
      
      container.read(patientSelectionQueryProvider.notifier).setQuery('Kowalski');
      
      // wait for debounce
      await Future.delayed(const Duration(milliseconds: 600));
      final result = await container.read(patientSelectionSearchProvider.future);

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.lastName, 'Kowalski');
      verify(() => mockRepository.getPatients(query: 'Kowalski')).called(1);
      subscription.close();
    });

    test('throws exception if repository returns Left', () async {
      // Arrange
      when(() => mockRepository.getPatients(query: 'Kowalski'))
          .thenAnswer((_) async => left<String, List<PatientEntity>>('Błąd serwera'));

      // Act
      // Set query BEFORE listening, so it starts with 'Kowalski' immediately
      container.read(patientSelectionQueryProvider.notifier).setQuery('Kowalski');
      
      final subscription = container.listen(patientSelectionSearchProvider, (_, __) {});
      
      // wait for debounce
      await Future.delayed(const Duration(milliseconds: 600));

      final state = container.read(patientSelectionSearchProvider);
      
      // Assert
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Błąd serwera'));
      
      verify(() => mockRepository.getPatients(query: 'Kowalski')).called(1);
      subscription.close();
    });
  });
}
