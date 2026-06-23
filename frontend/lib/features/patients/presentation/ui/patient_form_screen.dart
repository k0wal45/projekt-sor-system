import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/patient_entity.dart';
import '../view_models/patient_form_view_model.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final String mode;
  final String? pesel;

  const PatientFormScreen({super.key, required this.mode, this.pesel});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _currentMode;

  int _patientId = 0;

  final _peselController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    if (_currentMode != 'create' && widget.pesel != null) {
      _loadPatientData(widget.pesel!);
    }
  }

  void _loadPatientData(String pesel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(patientFormViewModelProvider.notifier).loadPatient(pesel);
    });
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) return;

    final parsedBirthDate = DateTime.tryParse(_birthDateController.text);
    if (parsedBirthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Błędna data urodzenia')));
      return;
    }

    final parsedGender =
        Gender.values.any(
          (e) => e.value == _genderController.text.toUpperCase(),
        )
        ? Gender.values.firstWhere(
            (e) => e.value == _genderController.text.toUpperCase(),
          )
        : null;

    if (parsedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wybierz płeć')));
      return;
    }

    final parsedBloodGroup =
        BloodGroup.values.any(
          (e) =>
              e.value.toUpperCase() == _bloodGroupController.text.toUpperCase(),
        )
        ? BloodGroup.values.firstWhere(
            (e) =>
                e.value.toUpperCase() ==
                _bloodGroupController.text.toUpperCase(),
          )
        : null;

    if (parsedBloodGroup == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wybierz grupę krwi')));
      return;
    }

    final patient = PatientEntity(
      id: _patientId,
      pesel: _peselController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      birthDate: parsedBirthDate,
      gender: parsedGender,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      emergencyContactName: _emergencyNameController.text,
      emergencyContactPhone: _emergencyPhoneController.text,
      bloodGroup: parsedBloodGroup,
      allergies: _allergiesController.text,
      chronicDiseases: _chronicDiseasesController.text,
    );

    final success = await ref.read(patientFormViewModelProvider.notifier).savePatient(patient, _currentMode == 'create');

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zapisano pomyślnie!')),
      );
      if (_currentMode == 'create') {
        context.pop();
      } else {
        setState(() {
          _currentMode = 'view';
        });
      }
    } else {
      final err = ref.read(patientFormViewModelProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override
  void dispose() {
    _peselController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _chronicDiseasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isView = _currentMode == 'view';
    final isCreate = _currentMode == 'create';
    final state = ref.watch(patientFormViewModelProvider);

    ref.listen(patientFormViewModelProvider, (previous, next) {
      if (previous?.value != next.value && next.value != null && !next.isLoading && !next.hasError) {
        final patient = next.value!;
        _patientId = patient.id;
        _peselController.text = patient.pesel;
        _firstNameController.text = patient.firstName;
        _lastNameController.text = patient.lastName;
        final y = patient.birthDate.year.toString().padLeft(4, '0');
        final m = patient.birthDate.month.toString().padLeft(2, '0');
        final d = patient.birthDate.day.toString().padLeft(2, '0');
        _birthDateController.text = '$y-$m-$d';
        _genderController.text = patient.gender.value;
        _addressController.text = patient.address;
        _phoneController.text = patient.phone;
        _emailController.text = patient.email;
        _emergencyNameController.text = patient.emergencyContactName;
        _emergencyPhoneController.text = patient.emergencyContactPhone;
        _bloodGroupController.text = patient.bloodGroup?.value ?? '';
        _allergiesController.text = patient.allergies;
        _chronicDiseasesController.text = patient.chronicDiseases;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCreate
              ? 'Nowy Pacjent'
              : (isView ? 'Podgląd Pacjenta' : 'Edycja Pacjenta'),
        ),
        actions: [
          if (isView)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edytuj',
              onPressed: () {
                setState(() => _currentMode = 'edit');
              },
            ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.hasError && state.value == null
          ? Center(child: Text(state.error.toString()))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      _peselController,
                      'PESEL',
                      isView,
                      readOnlyIfEdit: !isCreate,
                    ),
                    _buildField(_firstNameController, 'Imię', isView),
                    _buildField(_lastNameController, 'Nazwisko', isView),
                    _buildBirthDateField(isView),
                    _buildGenderDropdown(isView),
                    _buildField(_addressController, 'Adres', isView),
                    _buildField(_phoneController, 'Telefon', isView),
                    _buildField(_emailController, 'Email', isView),
                    _buildField(
                      _emergencyNameController,
                      'Imię i nazwisko osoby kontaktowej',
                      isView,
                    ),
                    _buildField(
                      _emergencyPhoneController,
                      'Telefon osoby kontaktowej',
                      isView,
                    ),
                    _buildBloodGroupDropdown(isView),
                    _buildField(_allergiesController, 'Alergie', isView),
                    _buildField(
                      _chronicDiseasesController,
                      'Choroby przewlekłe',
                      isView,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    if (!isView)
                      ElevatedButton.icon(
                        onPressed: _savePatient,
                        icon: const Icon(Icons.save),
                        label: const Text('Zapisz dane'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    bool isView, {
    bool readOnlyIfEdit = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: isView || readOnlyIfEdit,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: isView || readOnlyIfEdit,
          fillColor: (isView || readOnlyIfEdit)
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : null,
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Pole nie może być puste' : null,
      ),
    );
  }

  Widget _buildBirthDateField(bool isView) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _birthDateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Data Urodzenia (YYYY-MM-DD)',
          border: const OutlineInputBorder(),
          filled: isView,
          fillColor: isView
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : null,
          suffixIcon: isView ? null : const Icon(Icons.calendar_today),
        ),
        onTap: isView
            ? null
            : () async {
                final initialDate =
                    DateTime.tryParse(_birthDateController.text) ??
                    DateTime(2000);
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  final y = picked.year.toString().padLeft(4, '0');
                  final m = picked.month.toString().padLeft(2, '0');
                  final d = picked.day.toString().padLeft(2, '0');
                  _birthDateController.text = '$y-$m-$d';
                }
              },
        validator: (value) =>
            value == null || value.isEmpty ? 'Pole nie może być puste' : null,
      ),
    );
  }

  Widget _buildGenderDropdown(bool isView) {
    if (isView) {
      return _buildField(_genderController, 'Płeć', true);
    }
    final currentValue = _genderController.text.toUpperCase();
    final initialValue = Gender.values.any((e) => e.value == currentValue)
        ? Gender.values.firstWhere((e) => e.value == currentValue)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Gender>(
        initialValue: initialValue,
        decoration: const InputDecoration(
          labelText: 'Płeć',
          border: OutlineInputBorder(),
        ),
        hint: const Text('Wybierz płeć'),
        items: Gender.values.map((g) {
          String label = g.value;
          if (g == Gender.m) label = 'Mężczyzna (M)';
          if (g == Gender.k) label = 'Kobieta (K)';
          if (g == Gender.other) label = 'Inna (INNY)';
          return DropdownMenuItem(value: g, child: Text(label));
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            _genderController.text = val.value;
          } else {
            _genderController.clear();
          }
        },
        validator: (value) => value == null ? 'Pole nie może być puste' : null,
      ),
    );
  }

  Widget _buildBloodGroupDropdown(bool isView) {
    if (isView) {
      return _buildField(_bloodGroupController, 'Grupa krwi', true);
    }
    final currentValue = _bloodGroupController.text.toUpperCase();
    final initialValue =
        BloodGroup.values.any((e) => e.value.toUpperCase() == currentValue)
        ? BloodGroup.values.firstWhere(
            (e) => e.value.toUpperCase() == currentValue,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<BloodGroup>(
        initialValue: initialValue,
        decoration: const InputDecoration(
          labelText: 'Grupa krwi',
          border: OutlineInputBorder(),
        ),
        hint: const Text('Wybierz grupę krwi'),
        items: BloodGroup.values.map((bg) {
          return DropdownMenuItem(value: bg, child: Text(bg.value));
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            _bloodGroupController.text = val.value;
          } else {
            _bloodGroupController.clear();
          }
        },
        validator: (value) => value == null ? 'Pole nie może być puste' : null,
      ),
    );
  }
}
