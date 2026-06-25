import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/admissions/domain/admission_repository.dart';
import 'package:esor/features/auth/domain/auth_repository.dart';
import 'package:esor/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:esor/features/dashboard/presentation/view_models/my_patients_provider.dart';
import 'package:esor/features/patients/domain/patient_entity.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAdmissionRepository extends Mock implements AdmissionRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAdmissionRepository mockAdmissionRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAdmissionRepo = MockAdmissionRepository();
    mockAuthRepo = MockAuthRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        admissionRepositoryProvider.overrideWithValue(mockAdmissionRepo),
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
    );
  }

  group('MyPatients', () {
    final testDoctor = StaffEntity(
      id: 1,
      firstName: 'Adam',
      lastName: 'Lekarz',
      role: StaffRole.doctor,
    );

    final testNurse = StaffEntity(
      id: 2,
      firstName: 'Anna',
      lastName: 'Pielegniarka',
      role: StaffRole.nurse,
    );

    AdmissionEntity createTestAdmission({
      required int id,
      required int patientId,
      required AdmissionStatus status,
      required int doctorId,
    }) {
      return AdmissionEntity(
        id: id,
        patientId: patientId,
        registrarId: 1,
        doctorId: doctorId,
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
        chiefComplaint: 'Ból głowy',
        priorityKtas: 3,
        isAiPredicted: false,
        status: status,
        patient: PatientEntity(
          id: patientId,
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

    final admission1 = createTestAdmission(
      id: 1,
      patientId: 1,
      status: AdmissionStatus.inConsultation,
      doctorId: 1,
    );

    final admission2 = createTestAdmission(
      id: 2,
      patientId: 2,
      status: AdmissionStatus.waitingForResults,
      doctorId: 1,
    );

    final admission3 = createTestAdmission(
      id: 3,
      patientId: 3,
      status: AdmissionStatus.inConsultation,
      doctorId: 2,
    );

    test('returns empty list if user is not authenticated', () async {
      final container = createContainer();

      // authViewModelProvider starts with initial state depending on repo.getMe() or just null
      // Let's mock getMe to return error so user is null
      when(() => mockAuthRepo.getMe()).thenAnswer((_) async => left('No user'));

      final subscription = container.listen(myPatientsProvider, (_, _) {});

      // wait for auth
      await container
          .read(authViewModelProvider.future)
          .catchError((_) => null);

      final result = await container.read(myPatientsProvider.future);

      expect(result, isEmpty);
      verifyNever(
        () => mockAdmissionRepo.getAdmissions(status: any(named: 'status')),
      );
      subscription.close();
    });

    test('returns empty list if user is not a doctor', () async {
      final container = createContainer();

      when(
        () => mockAuthRepo.getMe(),
      ).thenAnswer((_) async => right(testNurse));

      final subscription = container.listen(myPatientsProvider, (_, _) {});

      await container.read(authViewModelProvider.future);

      final result = await container.read(myPatientsProvider.future);

      expect(result, isEmpty);
      verifyNever(
        () => mockAdmissionRepo.getAdmissions(status: any(named: 'status')),
      );
      subscription.close();
    });

    test('returns admissions filtered by current doctor id', () async {
      final container = createContainer();

      when(
        () => mockAuthRepo.getMe(),
      ).thenAnswer((_) async => right(testDoctor));

      when(
        () => mockAdmissionRepo.getAdmissions(
          status: AdmissionStatus.inConsultation,
        ),
      ).thenAnswer((_) async => right([admission1, admission3]));

      when(
        () => mockAdmissionRepo.getAdmissions(
          status: AdmissionStatus.waitingForResults,
        ),
      ).thenAnswer((_) async => right([admission2]));

      final subscription = container.listen(myPatientsProvider, (_, _) {});

      await container.read(authViewModelProvider.future);

      final result = await container.read(myPatientsProvider.future);

      expect(result.length, 2);
      expect(result.contains(admission1), isTrue);
      expect(result.contains(admission2), isTrue);
      expect(
        result.contains(admission3),
        isFalse,
      ); // filtered out because doctorId != 1

      subscription.close();
    });

    test('throws exception if getAdmissions returns error', () async {
      final container = createContainer();

      when(
        () => mockAuthRepo.getMe(),
      ).thenAnswer((_) async => right(testDoctor));

      when(
        () => mockAdmissionRepo.getAdmissions(
          status: AdmissionStatus.inConsultation,
        ),
      ).thenAnswer((_) async => left('Błąd API'));

      when(
        () => mockAdmissionRepo.getAdmissions(
          status: AdmissionStatus.waitingForResults,
        ),
      ).thenAnswer((_) async => right([admission2]));

      final subscription = container.listen(myPatientsProvider, (_, _) {});

      await container.read(authViewModelProvider.future);

      // Try to read future but catch immediately, or just read the state after a short delay
      // Since it's a FutureProvider (async build), we can await its future to let it resolve,
      // but catching it might hang if it retries.
      // Better approach: just wait a tick for the provider to update, then read state.
      // Wait a short amount of time for the async build to complete and throw the error
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(myPatientsProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Błąd API'));

      subscription.close();
    });
  });
}
