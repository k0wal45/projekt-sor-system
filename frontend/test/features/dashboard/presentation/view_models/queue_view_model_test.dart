import 'dart:async';
import 'package:esor/core/network/websocket_service.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/dashboard/presentation/view_models/queue_view_model.dart';
import 'package:esor/features/patients/domain/patient_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWebSocketService extends Mock implements WebSocketService {}

void main() {
  late MockWebSocketService mockWebSocketService;

  setUp(() {
    mockWebSocketService = MockWebSocketService();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        webSocketServiceProvider.overrideWithValue(mockWebSocketService),
      ],
    );
  }

  group('QueueViewModel', () {
    AdmissionEntity createTestAdmission({
      required int id,
      required AdmissionStatus status,
    }) {
      return AdmissionEntity(
        id: id,
        patientId: id,
        registrarId: 1,
        doctorId: 1,
        admissionDate: DateTime.now(),
        arrivalMode: ArrivalMode.publicAmbulance,
        injury: false,
        mentalStatus: MentalStatus.fullyConscious,
        pain: false,
        painLevel: 0,
        hr: 70,
        sbp: 120,
        dbp: 80,
        rr: 16,
        bt: 36.6,
        chiefComplaint: 'Test',
        priorityKtas: 3,
        isAiPredicted: false,
        status: status,
        patient: PatientEntity(
          id: id,
          firstName: '',
          lastName: '',
          pesel: '',
          birthDate: DateTime.now(),
          gender: Gender.m,
          address: '',
          phone: '',
          email: '',
          emergencyContactName: '',
          emergencyContactPhone: '',
          bloodGroup: null,
          allergies: '',
          chronicDiseases: '',
        ),
      );
    }

    final admissionInQueue1 = createTestAdmission(
      id: 1,
      status: AdmissionStatus.inQueue,
    );

    final admissionInQueue2 = createTestAdmission(
      id: 2,
      status: AdmissionStatus.inQueue,
    );

    final admissionInConsultation = createTestAdmission(
      id: 3,
      status: AdmissionStatus.inConsultation,
    );

    test('QueueViewModel returns the stream from WebSocketService', () async {
      final container = createContainer();

      final streamData = [
        [admissionInQueue1, admissionInConsultation],
        [admissionInQueue1, admissionInQueue2, admissionInConsultation],
      ];

      when(
        () => mockWebSocketService.queueStream,
      ).thenAnswer((_) => Stream.fromIterable(streamData));

      // We need to listen to the provider to keep it alive
      final subscription = container.listen(queueViewModelProvider, (_, _) {});

      final list = await container.read(queueViewModelProvider.future);

      expect(list, isNotEmpty);
      expect(list.contains(admissionInQueue1), isTrue);

      subscription.close();
    });

    test(
      'QueueViewModel propagates error from WebSocketService stream',
      () async {
        final container = createContainer();

        final controller = StreamController<List<AdmissionEntity>>.broadcast();
        when(
          () => mockWebSocketService.queueStream,
        ).thenAnswer((_) => controller.stream);

        final subscription = container.listen(
          queueViewModelProvider,
          (_, _) {},
        );

        // Verify initial state is loading
        expect(container.read(queueViewModelProvider).isLoading, isTrue);

        controller.addError('test error');

        // Allow microtasks to run
        await Future.microtask(() {});

        final state = container.read(queueViewModelProvider);
        expect(state.hasError, isTrue);
        expect(state.error, equals('test error'));

        subscription.close();
      },
    );
  });
}
