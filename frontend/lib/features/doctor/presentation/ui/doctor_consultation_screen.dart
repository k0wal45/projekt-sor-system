import 'package:esor/features/dashboard/presentation/view_models/my_patients_provider.dart';
import 'package:esor/features/dashboard/presentation/widgets/patient_queue_card.dart';
import 'package:esor/shared/widgets/custom_chip.dart';
import 'package:esor/shared/widgets/section_header.dart';
import 'package:esor/shared/widgets/status_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_models/doctor_view_model.dart';

class DoctorConsultationScreen extends ConsumerStatefulWidget {
  final int admissionId;
  const DoctorConsultationScreen({super.key, required this.admissionId});

  @override
  ConsumerState<DoctorConsultationScreen> createState() =>
      _DoctorConsultationScreenState();
}

class _DoctorConsultationScreenState
    extends ConsumerState<DoctorConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testTypeController = TextEditingController();
  final _testDescController = TextEditingController();

  final _interviewController = TextEditingController();
  final _icd10Controller = TextEditingController();
  String _selectedDecision = 'WYPIS_DO_DOMU';

  @override
  void dispose() {
    _testTypeController.dispose();
    _testDescController.dispose();
    _interviewController.dispose();
    _icd10Controller.dispose();
    super.dispose();
  }

  void _completeConsultation() async {
    if (!_formKey.currentState!.validate()) return;

    final interview = _interviewController.text;
    final icd10 = _icd10Controller.text;

    final success = await ref
        .read(completeConsultationViewModelProvider.notifier)
        .invoke(widget.admissionId, interview, icd10, _selectedDecision);

    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wizyta zakończona.')));

      // Invalidate the MyPatients provider so the Dashboard updates
      ref.invalidate(myPatientsProvider);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ref.watch(orderDiagnosticsViewModelProvider).isLoading;
    final isCompleting = ref
        .watch(completeConsultationViewModelProvider)
        .isLoading;
    final isAnyLoading = isOrdering || isCompleting;
    final admission = ref.watch(
      admissionDetailsViewModelProvider(widget.admissionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Konsultacja'),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              SectionHeader(title: "Informacje o pacjencie"),
              admission.when(
                data: (admission) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PatientQueueCard(
                          admission: admission!,
                          showTwoLines: true,
                          onTap: () => context.push(
                            '/patient-form/view/${admission.patient?.pesel}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SectionHeader(title: "Parametry Triage"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            CustomChip(text: "HR: ${admission.hr}bpm"),
                            CustomChip(
                              text: "BP: ${admission.sbp}/${admission.dbp}mmHg",
                            ),
                            CustomChip(text: "BT: ${admission.bt}°C"),
                            CustomChip(text: "RR: ${admission.rr}/min"),
                            CustomChip(text: "Pain: ${admission.painLevel}/10"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.errorContainer,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Text(
                          "Główna skarga: ${admission.chiefComplaint}",
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
                error: (err, stack) {
                  return Center(
                    child: StatusPlaceholder(
                      icon: Icons.error_rounded,
                      title: "Błąd pobierania danych",
                      errorMessage: err.toString(),
                    ),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),

              SectionHeader(title: "Zakończenie wizyty"),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _interviewController,
                  decoration: const InputDecoration(
                    labelText: 'Wywiad / Opis wizyty',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'To pole jest wymagane';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _icd10Controller,
                  decoration: const InputDecoration(
                    labelText: 'Diagnoza',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'To pole jest wymagane';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedDecision,
                  decoration: const InputDecoration(
                    labelText: 'Decyzja wyjściowa',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'WYPIS_DO_DOMU',
                      child: Text('Wypis do domu'),
                    ),
                    DropdownMenuItem(
                      value: 'HOSPITALIZACJA',
                      child: Text('Hospitalizacja'),
                    ),
                    DropdownMenuItem(
                      value: 'TRANSFER_NA_ODDZIAL',
                      child: Text('Transfer na oddział'),
                    ),
                    DropdownMenuItem(value: 'ZGON', child: Text('Zgon')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDecision = val);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: isAnyLoading ? null : _completeConsultation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: isCompleting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('ZAKOŃCZ KONSULTACJĘ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
