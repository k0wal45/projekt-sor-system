import 'package:esor/features/dashboard/presentation/view_models/my_patients_provider.dart';
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
    final interview = _interviewController.text;
    final icd10 = _icd10Controller.text;

    if (interview.isEmpty || icd10.isEmpty) return;

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Konsultacja - Zgłoszenie #${widget.admissionId}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Zakończenie Wizyty',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _interviewController,
              decoration: const InputDecoration(
                labelText: 'Wywiad / Opis wizyty',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _icd10Controller,
              decoration: const InputDecoration(
                labelText: 'Kod ICD-10 (Rozpoznanie)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isAnyLoading ? null : _completeConsultation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
              ),
              child: isCompleting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('ZAKOŃCZ KONSULTACJĘ'),
            ),
          ],
        ),
      ),
    );
  }
}
