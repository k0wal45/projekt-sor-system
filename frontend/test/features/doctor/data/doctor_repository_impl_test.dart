import 'package:dio/dio.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/doctor/data/doctor_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DoctorRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = DoctorRepositoryImpl(mockDio);
  });

  group('DoctorRepositoryImpl', () {
    final mockResponseData = [
      {
        'id': 1,
        'id_pacjenta': 1,
        'id_osoby_przyjmujacej': 1,
        'data_przyjecia': '2023-10-10T10:00:00Z',
        'forma_przybycia': 'Karetka publiczna',
        'injury': false,
        'mental_status': 'W pełni świadomy',
        'pain': false,
        'pain_lvl': 0,
        'hr': 70,
        'sbp': 120,
        'dbp': 80,
        'rr': 16,
        'bt': 36.6,
        'chief_complaint': 'Ból głowy',
        'priority_ktas': 3,
        'is_ai_predicted': false,
        'status_przyjecia': 'W_POCZEKALNI',
      }
    ];

    test('getDoctorAdmissions returns Right(list) on success', () async {
      when(() => mockDio.get(
            '/doctor/admissions',
            queryParameters: null,
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockResponseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getDoctorAdmissions(history: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 1);
          expect(r.first.chiefComplaint, 'Ból głowy');
        },
      );
    });

    test('getDoctorAdmissions with history returns Right(list)', () async {
      when(() => mockDio.get(
            '/doctor/admissions',
            queryParameters: {'history': 'true'},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockResponseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getDoctorAdmissions(history: true);

      expect(result.isRight(), isTrue);
    });

    test('getDoctorAdmissions returns Left on error', () async {
      when(() => mockDio.get(
            '/doctor/admissions',
            queryParameters: null,
          )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await repository.getDoctorAdmissions();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, contains('Nie udało się pobrać przypisanych pacjentów')),
        (r) => fail('Should be left'),
      );
    });

    test('assignPatient returns Right on success', () async {
      when(() => mockDio.put('/admissions/1/assign')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      final result = await repository.assignPatient(1);

      expect(result.isRight(), isTrue);
    });

    test('updateAdmissionStatus returns Right on success', () async {
      when(() => mockDio.patch(
            '/admissions/1/status',
            data: {'status_przyjecia': AdmissionStatus.inConsultation.value},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      final result = await repository.updateAdmissionStatus(1, AdmissionStatus.inConsultation);

      expect(result.isRight(), isTrue);
    });

    test('orderDiagnostics returns Right on success', () async {
      when(() => mockDio.post(
            '/diagnostic-orders',
            data: {
              'id_przyjecia': 1,
              'typ_badania': 'USG',
              'opis_zlecenia': 'Test',
            },
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      final result = await repository.orderDiagnostics(1, 'USG', 'Test');

      expect(result.isRight(), isTrue);
    });

    test('completeConsultation returns Right on success', () async {
      when(() => mockDio.post(
            '/consultations',
            data: {
              'id_przyjecia': 1,
              'wywiad_lekarski': 'Wywiad',
              'rozpoznanie_icd10': 'J00',
              'decyzja_wyjsciowa': 'Do domu',
            },
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      final result = await repository.completeConsultation(1, 'Wywiad', 'J00', 'Do domu');

      expect(result.isRight(), isTrue);
    });

    test('updateAdmissionStatus returns Left on error', () async {
      when(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await repository.updateAdmissionStatus(1, AdmissionStatus.completed);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, contains('Nie udało się zaktualizować statusu')),
        (r) => fail('Should be left'),
      );
    });
  });
}
