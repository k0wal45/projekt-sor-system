import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dashboard/domain/models/patient.dart';
import '../../../auth/domain/models/staff.dart';

part 'search_viewmodel.g.dart';

class SearchState {
  final List<Patient> patients;
  final List<Staff> staffList;

  SearchState({this.patients = const [], this.staffList = const []});
}

@riverpod
class SearchViewModel extends _$SearchViewModel {
  @override
  FutureOr<SearchState> build() async {
    return _search('');
  }

  Future<SearchState> _search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allPatients = [
      Patient(id: 'p1', firstName: 'Jan', lastName: 'Kowalski', pesel: '90010112345', dateOfBirth: DateTime(1990, 1, 1), gender: 'M'),
      Patient(id: 'p2', firstName: 'Anna', lastName: 'Nowak', pesel: '85050598765', dateOfBirth: DateTime(1985, 5, 5), gender: 'F'),
      Patient(id: 'p3', firstName: 'Piotr', lastName: 'Zieliński', pesel: '70030355555', dateOfBirth: DateTime(1970, 3, 3), gender: 'M'),
    ];

    final allStaff = [
      const Staff(id: 's1', firstName: 'Adam', lastName: 'Lekarski', role: StaffRole.doctor, loginEmail: 'adam'),
      const Staff(id: 's2', firstName: 'Ewa', lastName: 'Ratownicza', role: StaffRole.paramedic, loginEmail: 'ewa'),
    ];

    if (query.isEmpty) {
      return SearchState(patients: allPatients, staffList: allStaff);
    }

    final lowerQuery = query.toLowerCase();

    return SearchState(
      patients: allPatients.where((p) => 
        p.firstName.toLowerCase().contains(lowerQuery) || 
        p.lastName.toLowerCase().contains(lowerQuery) || 
        p.pesel.contains(query)
      ).toList(),
      staffList: allStaff.where((s) => 
        s.firstName.toLowerCase().contains(lowerQuery) || 
        s.lastName.toLowerCase().contains(lowerQuery)
      ).toList(),
    );
  }

  void updateQuery(String query) async {
    state = const AsyncLoading();
    final result = await _search(query);
    state = AsyncData(result);
  }
}
