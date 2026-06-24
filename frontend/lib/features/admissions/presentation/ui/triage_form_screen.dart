import 'package:esor/core/theme/priority_colors.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/shared/widgets/form_header.dart';
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
          (l) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Błąd pobierania pacjenta: $l')),
          ),
          (patients) {
            try {
              _selectedPatient = patients.firstWhere((p) => p.id == id);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nie znaleziono pacjenta o podanym ID'),
                ),
              );
            }
          },
        );
      });
    }
  }

  ArrivalMode? _arrivalMode;
  MentalStatus? _mentalStatus;
  final _hrController = TextEditingController();
  final _sbpController = TextEditingController();
  final _dbpController = TextEditingController();
  final _rrController = TextEditingController();
  final _btController = TextEditingController();
  final _chiefComplaintController = TextEditingController();

  double _painLevel = 0;
  bool _injury = false;
  bool _pain = false;

  int? _selectedPriority;
  bool _isAiPredicted = false;

  @override
  void dispose() {
    _chiefComplaintController.dispose();
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
      painLevel: _painLevel.toInt(),
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
        const SnackBar(
          content: Text('Musisz wybrać pacjenta przed zapisaniem.'),
        ),
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(triageFormViewModelProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text('Rejestracja przyjęcia'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _submit();
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 4),
                    if (_isLoadingPatient)
                      const Center(child: CircularProgressIndicator())
                    else if (_selectedPatient == null)
                      Container(
                        decoration: BoxDecoration(
                          // color: Theme.of(
                          //   context,
                          // ).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            radius: 20,
                            child: const Icon(Icons.person_search_rounded),
                          ),
                          title: const Text('Wybierz pacjenta z bazy'),
                          subtitle: const Text(
                            'Kliknij aby wyszukać lub utworzyć przyjmowanego pacjenta',
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            final result = await context.push<PatientEntity>(
                              '/patient-selection',
                            );
                            if (result != null && mounted) {
                              setState(() {
                                _selectedPatient = result;
                              });
                            }
                          },
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            radius: 20,
                            child: const Icon(Icons.person_rounded),
                          ),
                          title: Text(
                            '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}',
                          ),
                          subtitle: Text('PESEL: ${_selectedPatient!.pesel}'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            final result = await context.push<PatientEntity>(
                              '/patient-selection',
                            );
                            if (result != null && mounted) {
                              setState(() {
                                _selectedPatient = result;
                              });
                            }
                          },
                        ),
                      ),

                    const SizedBox(height: 8),
                    FormHeader(
                      icon: Icons.door_back_door_outlined,
                      title: 'Parametry Triage',
                    ),
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
                      validator: (v) =>
                          v == null ? 'Wybierz formę przybycia' : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Czy to uraz fizyczny?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    SegmentedButton<bool>(
                      style: SegmentedButton.styleFrom(
                        visualDensity: const VisualDensity(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        selectedBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.18),
                      ),

                      selected: {_injury},
                      onSelectionChanged: (value) {
                        setState(() => _injury = value.first);
                      },
                      segments: const [
                        ButtonSegment(value: true, label: Text('Tak')),
                        ButtonSegment(value: false, label: Text('Nie')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<MentalStatus>(
                      initialValue: _mentalStatus,
                      decoration: const InputDecoration(
                        labelText: 'Stan świadomości',
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
                      validator: (v) =>
                          v == null ? 'Wybierz stan świadomości' : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Czy pacjent odczuwa ból?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    SegmentedButton<bool>(
                      style: SegmentedButton.styleFrom(
                        visualDensity: const VisualDensity(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        selectedBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.18),
                      ),

                      selected: {_pain},
                      onSelectionChanged: (value) {
                        setState(() => _pain = value.first);
                      },
                      segments: const [
                        ButtonSegment(value: true, label: Text('Tak')),
                        ButtonSegment(value: false, label: Text('Nie')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _chiefComplaintController,
                      decoration: const InputDecoration(
                        labelText: 'Główna skarga',
                        hintText: 'Wpisz główną skargę pacjenta',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Podaj główną skargę';
                        if (v.length < 3) return 'Zbyt krótki opis';
                        return null;
                      },
                    ),
                    if (_pain) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Poziom bólu (0-10)?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Slider(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        value: _painLevel,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _painLevel.round().toString(),
                        onChanged: (value) {
                          setState(() => _painLevel = value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0 - brak bólu',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(fontSize: 10.0),
                          ),
                          Text(
                            'Najsilniejszy ból - 10',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    FormHeader(
                      icon: Icons.monitor_heart_outlined,
                      title: 'Parametry życiowe',
                    ),
                    _buildNumberField(
                      _btController,
                      'Temperatura (°C)',
                      min: 20,
                      max: 45,
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      _sbpController,
                      'Ciśnienie skurczowe (SBP)',
                      min: 40,
                      max: 250,
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      _dbpController,
                      'Ciśnienie rozkurczowe (DBP)',
                      min: 40,
                      max: 250,
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      _hrController,
                      'Tętno (HR)',
                      min: 20,
                      max: 250,
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      _rrController,
                      'Oddech (RR)',
                      min: 0,
                      max: 100,
                    ),

                    const SizedBox(height: 16),
                    FormHeader(
                      icon: Icons.priority_high_rounded,
                      title: 'Priorytet przyjęcia (KTAS)',
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).getPriorityContainerColor(priority)
                                  : Colors.transparent,
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).getPriorityColor(priority),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              priority.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).getPriorityColor(priority),
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
                      label: const Text('Zasugeruj przy uyciu SI'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNumberField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    double? min,
    double? max,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator:
          validator ??
          (v) {
            if (v == null || v.isEmpty) return 'Podaj wartość';
            final parsed = double.tryParse(v.replaceAll(',', '.'));
            if (parsed == null) return 'Podaj poprawną liczbę';
            if (min != null && parsed < min) {
              return 'Min. wartość to ${min == min.toInt() ? min.toInt() : min}';
            }
            if (max != null && parsed > max) {
              return 'Max. wartość to ${max == max.toInt() ? max.toInt() : max}';
            }
            if (parsed < 0) return 'Wartość nie może być ujemna';
            return null;
          },
    );
  }
}
