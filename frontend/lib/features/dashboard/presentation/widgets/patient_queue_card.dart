import 'package:esor/core/providers/clock_provider.dart';
import 'package:esor/core/theme/priority_colors.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/features/dashboard/presentation/widgets/priority_chip.dart';
import 'package:esor/shared/utils/date_time_utils.dart';
import 'package:esor/shared/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientQueueCard extends StatelessWidget {
  const PatientQueueCard({super.key, required this.admission, this.onTap});

  final AdmissionEntity admission;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final age = DateTime.now().year - (admission.patient?.birthDate.year ?? 0);

    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.getPriorityColor(admission.priorityKtas),
                width: 8,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID: #${admission.id} • PESEL: ${admission.patient?.pesel}",
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        "${admission.patient?.firstName} ${admission.patient?.lastName}, ${StringUtils.formatAge(age)}",
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          PriorityChip(priority: admission.priorityKtas),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              admission.chiefComplaint,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                _LiveWaitTimeText(admissionDate: admission.admissionDate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveWaitTimeText extends ConsumerWidget {
  final DateTime admissionDate;

  const _LiveWaitTimeText({required this.admissionDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(clockProvider);

    final theme = Theme.of(context);
    final ticketTime = DateTimeUtils.formatTicketStatus(admissionDate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          ticketTime.$1,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        Text(
          ticketTime.$2,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 8.0,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
