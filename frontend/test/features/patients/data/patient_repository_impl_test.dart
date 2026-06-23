import 'package:dio/dio.dart';
import 'package:esor/features/patients/data/patient_repository_impl.dart';
import 'package:esor/features/patients/domain/patient_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PatientRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = PatientRepositoryImpl(mockDio);
  });

  group('PatientRepositoryImpl', () {
    final testPatientJson = {
      'id': 1,
      'pesel': '12345678901',
      'first_name': 'Jan',
      'last_name': 'Kowalski',
      'date_of_birth': '1990-01-01',
      'gender': 'M',
      'address': 'Testowa 1',
      'phone': '123123123',
      'email': 'jan@test.pl',
      'emergency_contact_name': 'Anna Kowalska',
      'emergency_contact_phone': '321321321',
      'blood_group': 'A+',
      'allergies': 'Brak',
      'chronic_diseases': 'Brak',
    };

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

    group('getPatients', () {
      test('returns Right(List<PatientEntity>) on success', () async {
        // Arrange
        when(() => mockDio.get(
              '/patients',
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/patients'),
              data: [testPatientJson],
              statusCode: 200,
            ));

        // Act
        final result = await repository.getPatients();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should not return left'),
          (patients) {
            expect(patients.length, 1);
            expect(patients.first.pesel, '12345678901');
            expect(patients.first.gender, Gender.m);
          },
        );
      });

      test('returns Left on API error', () async {
        // Arrange
        when(() => mockDio.get(
              '/patients',
              queryParameters: any(named: 'queryParameters'),
            )).thenThrow(Exception('API error'));

        // Act
        final result = await repository.getPatients();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, contains('Nie udało się pobrać pacjentów:')),
          (r) => fail('Should not return right'),
        );
      });
    });

    group('getPatient', () {
      test('returns Right(PatientEntity) on success', () async {
        // Arrange
        when(() => mockDio.get(
              '/patients/12345678901',
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/patients/12345678901'),
              data: testPatientJson,
              statusCode: 200,
            ));

        // Act
        final result = await repository.getPatient('12345678901');

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should not return left'),
          (patient) => expect(patient.firstName, 'Jan'),
        );
      });

      test('returns Left on API error', () async {
        // Arrange
        when(() => mockDio.get(
              '/patients/12345678901',
            )).thenThrow(Exception('API error'));

        // Act
        final result = await repository.getPatient('12345678901');

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });

    group('createPatient', () {
      test('returns Right(void) on success', () async {
        // Arrange
        when(() => mockDio.post(
              '/patients',
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/patients'),
              statusCode: 200,
            ));

        // Act
        final result = await repository.createPatient(testPatientEntity);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockDio.post('/patients', data: testPatientEntity.toJson())).called(1);
      });

      test('returns Left on error', () async {
        // Arrange
        when(() => mockDio.post(
              '/patients',
              data: any(named: 'data'),
            )).thenThrow(Exception('Creation failed'));

        // Act
        final result = await repository.createPatient(testPatientEntity);

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });

    group('updatePatient', () {
      test('returns Right(void) on success', () async {
        // Arrange
        when(() => mockDio.put(
              '/patients/12345678901',
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/patients/12345678901'),
              statusCode: 200,
            ));

        // Act
        final result = await repository.updatePatient(testPatientEntity);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockDio.put('/patients/12345678901', data: testPatientEntity.toJson())).called(1);
      });

      test('returns Left on error', () async {
        // Arrange
        when(() => mockDio.put(
              '/patients/12345678901',
              data: any(named: 'data'),
            )).thenThrow(Exception('Update failed'));

        // Act
        final result = await repository.updatePatient(testPatientEntity);

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });
  });
}
