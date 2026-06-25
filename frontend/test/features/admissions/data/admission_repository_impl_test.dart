import 'package:dio/dio.dart';
import 'package:esor/features/admissions/data/admission_repository_impl.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/admissions/domain/admission_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AdmissionRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = AdmissionRepositoryImpl(mockDio);
  });

  group('AdmissionRepositoryImpl', () {
    final testTriageDto = TriageFormDto(
      patientId: 1,
      arrivalMode: ArrivalMode.onFoot,
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

    final testAdmissionJson = {
      'id': 1,
      'id_pacjenta': 1,
      'id_osoby_przyjmujacej': 1,
      'data_przyjecia': '2023-10-27T10:00:00Z',
      'forma_przybycia': 'Pieszo',
      'injury': false,
      'mental_status': 'W pełni świadomy',
      'pain': false,
      'pain_lvl': 0,
      'hr': 80,
      'sbp': 120,
      'dbp': 80,
      'rr': 16,
      'bt': 36.6,
      'chief_complaint': 'Headache',
      'priority_ktas': 3,
      'is_ai_predicted': true,
      'status_przyjecia': 'W_POCZEKALNI',
    };

    group('predictKtas', () {
      test('returns Right(ktas) on success', () async {
        // Arrange
        when(
          () => mockDio.post(
            '/admissions/predict-ktas',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/admissions/predict-ktas'),
            data: {'suggested_priority_ktas': 3},
            statusCode: 200,
          ),
        );

        // Act
        final result = await repository.predictKtas(testTriageDto);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should not return left'),
          (ktas) => expect(ktas, 3),
        );
      });

      test('returns Left on error', () async {
        // Arrange
        when(
          () => mockDio.post(
            '/admissions/predict-ktas',
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('API failure'));

        // Act
        final result = await repository.predictKtas(testTriageDto);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, contains('Błąd przewidywania priorytetu:')),
          (r) => fail('Should not return right'),
        );
      });
    });

    group('createAdmission', () {
      test('returns Right(AdmissionEntity) on success', () async {
        // Arrange
        when(
          () => mockDio.post('/admissions', data: any(named: 'data')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/admissions'),
            data: {'admission': testAdmissionJson},
            statusCode: 200,
          ),
        );

        // Act
        final result = await repository.createAdmission(testTriageDto, 3, true);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should not return left'), (admission) {
          expect(admission.id, 1);
          expect(admission.priorityKtas, 3);
          expect(admission.status, AdmissionStatus.inQueue);
        });
      });

      test('returns Left on error', () async {
        // Arrange
        when(
          () => mockDio.post('/admissions', data: any(named: 'data')),
        ).thenThrow(Exception('Failed to create'));

        // Act
        final result = await repository.createAdmission(testTriageDto, 3, true);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, contains('Błąd rejestracji przyjęcia:')),
          (r) => fail('Should not return right'),
        );
      });
    });

    group('getAdmissions', () {
      test('returns Right(List<AdmissionEntity>) on success', () async {
        // Arrange
        when(
          () => mockDio.get(
            '/admissions',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/admissions'),
            data: [testAdmissionJson],
            statusCode: 200,
          ),
        );

        // Act
        final result = await repository.getAdmissions();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should not return left'), (list) {
          expect(list.length, 1);
          expect(list.first.id, 1);
        });
      });

      test('returns Left on error', () async {
        // Arrange
        when(
          () => mockDio.get(
            '/admissions',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Failed to fetch'));

        // Act
        final result = await repository.getAdmissions();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, contains('Nie udało się pobrać kolejki przyjęć:')),
          (r) => fail('Should not return right'),
        );
      });
    });
  });
}
