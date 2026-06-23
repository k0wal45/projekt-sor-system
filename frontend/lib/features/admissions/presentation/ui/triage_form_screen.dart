import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/admission_repository.dart';
import '../view_models/triage_form_view_model.dart';
import '../../../patients/domain/patient_entity.dart';
import '../../../../core/providers/repository_providers.dart';

class TriageFormScreen extends ConsumerStatefulWidget {
  final int? patientId;
  const TriageFormScreen({super.key, this.patientId});

  @override
  ConsumerState<TriageFormScreen> createState() => _TriageFormScreenState();
}

class _TriageFormScreenState extends ConsumerState<TriageFormScreen> {
  final _formKey = GlobalKey<FormState>();

  PatientEntity? _selectedPatient;
  bool _isLoadingPatient = false;

  @override
  void initState() {
    super.initState();
    if (widget.patientId != null) {
      _loadPatient(widget.patientId!);
    }
  }

  Future<void> _loadPatient(int id) async {
    setState(() => _isLoadingPatient = true);
    final repo = ref.read(patientRepositoryProvider);
    final result = await repo.getPatients();
    if (mounted) {
      setState(() {
        _isLoadingPatient = false;
        result.fold(
          (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd pobierania pacjenta: $l'))),
          (patients) {
            try {
              _selectedPatient = patients.firstWhere((p) => p.id == id);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nie znaleziono pacjenta o podanym ID')));
            }
          },
        );
      });
    }
  }

  ArrivalMode? _arrivalMode;
  MentalStatus? _mentalStatus;

  final _painLevelController = TextEditingController();
  final _hrController = TextEditingController();
  final _sbpController = TextEditingController();
  final _dbpController = TextEditingController();
  final _rrController = TextEditingController();
  final _btController = TextEditingController();
  final _chiefComplaintController = TextEditingController();

  bool _injury = false;
  bool _pain = false;

  int? _selectedPriority;
  bool _isAiPredicted = false;

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _painLevelController.dispose();
    _hrController.dispose();
    _sbpController.dispose();
    _dbpController.dispose();
    _rrController.dispose();
    _btController.dispose();
    super.dispose();
  }

  TriageFormDto _buildDto() {
    return TriageFormDto(
      patientId: _selectedPatient!.id,
      arrivalMode: _arrivalMode!,
      injury: _injury,
      mentalStatus: _mentalStatus!,
      pain: _pain,
      painLevel: int.tryParse(_painLevelController.text) ?? 0,
      hr: int.tryParse(_hrController.text) ?? 0,
      sbp: int.tryParse(_sbpController.text) ?? 0,
      dbp: int.tryParse(_dbpController.text) ?? 0,
      rr: int.tryParse(_rrController.text) ?? 0,
      bt: double.tryParse(_btController.text) ?? 36.6,
      chiefComplaint: _chiefComplaintController.text,
    );
  }

  Future<void> _askAi() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wypełnij parametry życiowe i objawy, aby AI mogło zadziałać.',
          ),
        ),
      );
      return;
    }

    final dto = _buildDto();
    final suggested = await ref
        .read(triageFormViewModelProvider.notifier)
        .predictKtas(dto);

    if (!mounted) return;

    if (suggested != null) {
      setState(() {
        _selectedPriority = suggested;
        _isAiPredicted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI zasugerowało priorytet $suggested')),
      );
    } else {
      final state = ref.read(triageFormViewModelProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd AI: ${state.error}')));
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Musisz wybrać pacjenta przed zapisaniem.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Musisz wybrać priorytet przed zapisaniem.'),
        ),
      );
      return;
    }

    final dto = _buildDto();
    final success = await ref
        .read(triageFormViewModelProvider.notifier)
        .submitTriage(dto, _selectedPriority!, _isAiPredicted);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pacjent pomyślnie przyjęty na SOR.')),
      );
      context.pop();
    } else {
      final state = ref.read(triageFormViewModelProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd: ${state.error}')));
      }
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.green;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(triageFormViewModelProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Triage - Przyjęcie Pacjenta')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isLoadingPatient)
                      const Center(child: CircularProgressIndicator())
                    else if (_selectedPatient == null)
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await context.push<PatientEntity>('/patient-selection');
                          if (result != null && mounted) {
                            setState(() {
                              _selectedPatient = result;
                            });
                          }
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Wybierz pacjenta'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      )
                    else
                      Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text('${_selectedPatient!.firstName} ${_selectedPatient!.lastName}'),
                          subtitle: Text('PESEL: ${_selectedPatient!.pesel}'),
                          trailing: TextButton(
                            onPressed: () async {
                              final result = await context.push<PatientEntity>('/patient-selection');
                              if (result != null && mounted) {
                                setState(() {
                                  _selectedPatient = result;
                                });
                              }
                            },
                            child: const Text('Zmień'),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Parametry życiowe i wywiad',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _chiefComplaintController,
                      decoration: const InputDecoration(
                        labelText: 'Objawy główne (chief complaint)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? 'Wymagane' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ArrivalMode>(
                      initialValue: _arrivalMode,
                      decoration: const InputDecoration(
                        labelText: 'Forma przybycia',
                        border: OutlineInputBorder(),
                      ),
                      items: ArrivalMode.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _arrivalMode = v),
                      validator: (v) => v == null ? 'Wymagane' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<MentalStatus>(
                      initialValue: _mentalStatus,
                      decoration: const InputDecoration(
                        labelText: 'Stan umysłowy',
                        border: OutlineInputBorder(),
                      ),
                      items: MentalStatus.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _mentalStatus = v),
                      validator: (v) => v == null ? 'Wymagane' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('Uraz'),
                            value: _injury,
                            onChanged: (val) => setState(() => _injury = val),
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('Ból'),
                            value: _pain,
                            onChanged: (val) => setState(() => _pain = val),
                          ),
                        ),
                      ],
                    ),
                    if (_pain) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _painLevelController,
                        decoration: const InputDecoration(
                          labelText: 'Poziom bólu (1-10)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Wymagane' : null,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(_hrController, 'HR (Tętno)'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNumberField(
                            _rrController,
                            'RR (Oddech)',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNumberField(_btController, 'BT (Temp)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            _sbpController,
                            'SBP (Skurczowe)',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNumberField(
                            _dbpController,
                            'DBP (Rozkurczowe)',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),

                    Text(
                      'Ocena Priorytetu KTAS',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        final priority = index + 1;
                        final isSelected = _selectedPriority == priority;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPriority = priority;
                              _isAiPredicted = false;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _getPriorityColor(priority)
                                  : Colors.transparent,
                              border: Border.all(
                                color: _getPriorityColor(priority),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              priority.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : _getPriorityColor(priority),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _askAi,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Zasugeruj priorytet z AI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.deepPurple.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('ZAREJESTRUJ NA SOR'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) => v!.isEmpty ? 'Brak' : null,
    );
  }
}
