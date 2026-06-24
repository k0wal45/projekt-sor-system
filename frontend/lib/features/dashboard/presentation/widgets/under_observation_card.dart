import 'package:esor/core/theme/priority_colors.dart';
import 'package:esor/features/admissions/domain/admission_entity.dart';
import 'package:esor/shared/utils/string_utils.dart';
import 'package:flutter/material.dart';

class UnderObservationCard extends StatelessWidget {
  const UnderObservationCard({super.key, required this.admission, this.onTap});

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
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${admission.patient?.firstName} ${admission.patient?.lastName}",
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          "ID: #${admission.id} • WIEK: ${StringUtils.formatAge(age)}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 16.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  admission.chiefComplaint,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
