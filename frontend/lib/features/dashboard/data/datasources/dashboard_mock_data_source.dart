import '../../domain/models/patient.dart';
import '../../domain/models/admission.dart';
import '../../domain/models/queue_item.dart';

class DashboardMockDataSource {
  Future<List<QueueItem>> fetchQueue() async {
    await Future.delayed(const Duration(seconds: 1));

    final patients = [
      Patient(id: 'p1', firstName: 'Jan', lastName: 'Kowalski', pesel: '90010112345', dateOfBirth: DateTime(1990, 1, 1), gender: 'M'),
      Patient(id: 'p2', firstName: 'Anna', lastName: 'Nowak', pesel: '85050598765', dateOfBirth: DateTime(1985, 5, 5), gender: 'F'),
      Patient(id: 'p3', firstName: 'Piotr', lastName: 'Zieliński', pesel: '70030355555', dateOfBirth: DateTime(1970, 3, 3), gender: 'M'),
      Patient(id: 'p4', firstName: 'Maria', lastName: 'Wiśniewska', pesel: '60080811111', dateOfBirth: DateTime(1960, 8, 8), gender: 'F'),
      Patient(id: 'p5', firstName: 'Tomasz', lastName: 'Wójcik', pesel: '95020222222', dateOfBirth: DateTime(1995, 2, 2), gender: 'M'),
    ];

    final now = DateTime.now();

    final admissions = [
      Admission(id: 'A001', patientId: 'p1', admissionTime: now.subtract(const Duration(minutes: 15)), priorityKtas: 1, chiefComplaint: 'Ból w klatce piersiowej', status: AdmissionStatus.inWaitingRoom),
      Admission(id: 'A002', patientId: 'p2', admissionTime: now.subtract(const Duration(minutes: 45)), priorityKtas: 2, chiefComplaint: 'Duszności', status: AdmissionStatus.inWaitingRoom),
      Admission(id: 'A003', patientId: 'p3', admissionTime: now.subtract(const Duration(minutes: 120)), priorityKtas: 3, chiefComplaint: 'Ból brzucha', status: AdmissionStatus.inWaitingRoom),
      Admission(id: 'A004', patientId: 'p4', admissionTime: now.subtract(const Duration(minutes: 200)), priorityKtas: 4, chiefComplaint: 'Zwichnięcie kostki', status: AdmissionStatus.inWaitingRoom),
      Admission(id: 'A005', patientId: 'p5', admissionTime: now.subtract(const Duration(minutes: 5)), priorityKtas: 5, chiefComplaint: 'Lekkie przecięcie palca', status: AdmissionStatus.inWaitingRoom),
    ];

    return List.generate(patients.length, (i) => QueueItem(patient: patients[i], admission: admissions[i]));
  }
  
  Future<List<QueueItem>> fetchActivePatients(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return [
      QueueItem(
        patient: Patient(id: 'p6', firstName: 'Katarzyna', lastName: 'Lewandowska', pesel: '80040444444', dateOfBirth: DateTime(1980, 4, 4), gender: 'F'),
        admission: Admission(id: 'A006', patientId: 'p6', attendingDoctorId: doctorId, admissionTime: now.subtract(const Duration(minutes: 60)), priorityKtas: 2, chiefComplaint: 'Złamanie otwarte', status: AdmissionStatus.waitingForResults),
      ),
      QueueItem(
        patient: Patient(id: 'p7', firstName: 'Michał', lastName: 'Kamiński', pesel: '92070777777', dateOfBirth: DateTime(1992, 7, 7), gender: 'M'),
        admission: Admission(id: 'A007', patientId: 'p7', attendingDoctorId: doctorId, admissionTime: now.subtract(const Duration(minutes: 30)), priorityKtas: 3, chiefComplaint: 'Uraz głowy', status: AdmissionStatus.inOffice),
      ),
    ];
  }
}
