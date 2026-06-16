import '../../../../core/errors/exceptions.dart';
import '../../domain/models/staff.dart';

class AuthMockDataSource {
  Future<Staff> login(String email, String password) async {
    // Symulacja opóźnienia sieciowego
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin' && password == 'admin') {
      return const Staff(
        id: '1',
        firstName: 'Jan',
        lastName: 'Kowalski',
        academicTitle: 'lek. med.',
        role: StaffRole.doctor,
        loginEmail: 'admin',
      );
    } else if (email == 'paramedic' && password == 'paramedic') {
      return const Staff(
        id: '2',
        firstName: 'Anna',
        lastName: 'Nowak',
        role: StaffRole.paramedic,
        loginEmail: 'paramedic',
      );
    } else {
      throw InvalidCredentialsException();
    }
  }
}
