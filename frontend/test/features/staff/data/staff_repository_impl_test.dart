import 'package:dio/dio.dart';
import 'package:esor/features/staff/data/staff_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late StaffRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = StaffRepositoryImpl(mockDio);
  });

  group('StaffRepositoryImpl', () {
    final mockResponseData = [
      {
        'id': 1,
        'first_name': 'Jan',
        'last_name': 'Kowalski',
        'role': 'LEKARZ',
      }
    ];

    test('getStaff returns Right(list) on success', () async {
      when(() => mockDio.get(
            '/staff',
            queryParameters: null,
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockResponseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getStaff();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be right'),
        (r) {
          expect(r.length, 1);
          expect(r.first.id, 1);
          expect(r.first.firstName, 'Jan');
          expect(r.first.lastName, 'Kowalski');
        },
      );
    });

    test('getStaff with query returns Right(list)', () async {
      when(() => mockDio.get(
            '/staff',
            queryParameters: {'q': 'Jan'},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockResponseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getStaff(query: 'Jan');

      expect(result.isRight(), isTrue);
    });

    test('getStaff returns Left on error', () async {
      when(() => mockDio.get(
            '/staff',
            queryParameters: null,
          )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await repository.getStaff();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, contains('Nie udało się pobrać personelu')),
        (r) => fail('Should be left'),
      );
    });
  });
}
