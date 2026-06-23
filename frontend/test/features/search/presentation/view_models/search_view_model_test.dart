import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/patients/domain/patient_entity.dart';
import 'package:esor/features/patients/domain/patient_repository.dart';
import 'package:esor/features/search/presentation/view_models/search_view_model.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:esor/features/staff/domain/staff_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockPatientRepository mockPatientRepo;
  late MockStaffRepository mockStaffRepo;

  setUp(() {
    mockPatientRepo = MockPatientRepository();
    mockStaffRepo = MockStaffRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        patientRepositoryProvider.overrideWithValue(mockPatientRepo),
        staffRepositoryProvider.overrideWithValue(mockStaffRepo),
      ],
    );
  }

  group('SearchViewModel', () {
    PatientEntity createTestPatient(int id, String firstName, String lastName) {
      return PatientEntity(
        id: id,
        pesel: '12345678901',
        firstName: firstName,
        lastName: lastName,
        birthDate: DateTime(1990),
        gender: Gender.m,
        address: 'Warszawa',
        phone: '123456789',
        email: 'test@test.pl',
        emergencyContactName: 'Anna',
        emergencyContactPhone: '987654321',
        bloodGroup: null,
        allergies: 'Brak',
        chronicDiseases: 'Brak',
      );
    }

    final patientA = createTestPatient(1, 'Adam', 'Abacki');
    final patientB = createTestPatient(2, 'Bogdan', 'Babacki');

    final staffA = StaffEntity(
      id: 1,
      firstName: 'Adam',
      lastName: 'Abacki',
      role: StaffRole.doctor,
    );

    final staffB = StaffEntity(
      id: 2,
      firstName: 'Bogdan',
      lastName: 'Babacki',
      role: StaffRole.nurse,
    );

    test('SearchQuery initial state is empty string', () {
      final container = createContainer();
      expect(container.read(searchQueryProvider), '');
    });

    test('SearchQuery setQuery updates state', () {
      final container = createContainer();
      container.read(searchQueryProvider.notifier).setQuery('test');
      expect(container.read(searchQueryProvider), 'test');
    });

    test('SortOrderNotifier toggle changes state', () {
      final container = createContainer();
      expect(container.read(sortOrderProvider), SortOrder.ascending);

      container.read(sortOrderProvider.notifier).toggle();
      expect(container.read(sortOrderProvider), SortOrder.descending);
    });

    test(
      'fetchedPatients returns empty list if query length is less than 3',
      () async {
        final container = createContainer();
        container.read(searchQueryProvider.notifier).setQuery('ab');

        final result = await container.read(fetchedPatientsProvider.future);

        expect(result, isEmpty);
        verifyNever(
          () => mockPatientRepo.getPatients(query: any(named: 'query')),
        );
      },
    );

    test(
      'fetchedPatients returns patients list if query length is >= 3 and repository succeeds',
      () async {
        final container = createContainer();
        when(
          () => mockPatientRepo.getPatients(query: 'aba'),
        ).thenAnswer((_) async => right([patientA, patientB]));

        container.read(searchQueryProvider.notifier).setQuery('aba');

        final subscription = container.listen(
          fetchedPatientsProvider,
          (_, _) {},
        );

        await Future.delayed(const Duration(milliseconds: 600));

        final result = await container.read(fetchedPatientsProvider.future);

        expect(result.length, 2);
        expect(result, contains(patientA));

        verify(() => mockPatientRepo.getPatients(query: 'aba')).called(1);
        subscription.close();
      },
    );

    test('PatientsSearch sorts patients correctly', () async {
      final container = createContainer();
      when(() => mockPatientRepo.getPatients(query: 'aba')).thenAnswer(
        (_) async => right([patientB, patientA]),
      ); // Return out of order

      container.read(searchQueryProvider.notifier).setQuery('aba');

      final subscription = container.listen(patientsSearchProvider, (_, _) {});

      await Future.delayed(const Duration(milliseconds: 600));

      // Ascending
      var result = await container.read(patientsSearchProvider.future);
      expect(result.first.lastName, 'Abacki');
      expect(result.last.lastName, 'Babacki');

      // Toggle to Descending
      container.read(sortOrderProvider.notifier).toggle();

      result = await container.read(patientsSearchProvider.future);
      expect(result.first.lastName, 'Babacki');
      expect(result.last.lastName, 'Abacki');

      subscription.close();
    });

    test(
      'fetchedStaff returns empty list if query length is less than 3',
      () async {
        final container = createContainer();
        container.read(searchQueryProvider.notifier).setQuery('ab');

        final result = await container.read(fetchedStaffProvider.future);

        expect(result, isEmpty);
        verifyNever(() => mockStaffRepo.getStaff(query: any(named: 'query')));
      },
    );

    test(
      'fetchedStaff returns staff list if query length is >= 3 and repository succeeds',
      () async {
        final container = createContainer();
        when(
          () => mockStaffRepo.getStaff(query: 'aba'),
        ).thenAnswer((_) async => right([staffA, staffB]));

        container.read(searchQueryProvider.notifier).setQuery('aba');

        final subscription = container.listen(fetchedStaffProvider, (_, _) {});

        await Future.delayed(const Duration(milliseconds: 600));

        final result = await container.read(fetchedStaffProvider.future);

        expect(result.length, 2);
        expect(result, contains(staffA));

        verify(() => mockStaffRepo.getStaff(query: 'aba')).called(1);
        subscription.close();
      },
    );

    test('StaffSearch sorts staff correctly', () async {
      final container = createContainer();
      when(
        () => mockStaffRepo.getStaff(query: 'aba'),
      ).thenAnswer((_) async => right([staffB, staffA])); // Return out of order

      container.read(searchQueryProvider.notifier).setQuery('aba');

      final subscription = container.listen(staffSearchProvider, (_, _) {});

      await Future.delayed(const Duration(milliseconds: 600));

      // Ascending
      var result = await container.read(staffSearchProvider.future);
      expect(result.first.lastName, 'Abacki');
      expect(result.last.lastName, 'Babacki');

      // Toggle to Descending
      container.read(sortOrderProvider.notifier).toggle();

      result = await container.read(staffSearchProvider.future);
      expect(result.first.lastName, 'Babacki');
      expect(result.last.lastName, 'Abacki');

      subscription.close();
    });
  });
}
