import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/dashboard/domain/models/queue_item.dart';
import '../../features/dashboard/domain/models/patient.dart';

class QueuePatientCard extends StatelessWidget {
  final QueueItem item;
  final VoidCallback? onTap;

  const QueuePatientCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final admission = item.admission;
    final patient = item.patient;
    final waitingMinutes = item.waitingTime.inMinutes;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    ExtendedColor getExtendedColor() {
      switch (admission.priorityKtas) {
        case 1:
          return MaterialTheme.priority1;
        case 2:
          return MaterialTheme.priority2;
        case 3:
          return MaterialTheme.priority3;
        case 4:
          return MaterialTheme.priority4;
        case 5:
          return MaterialTheme.priority5;
        default:
          return MaterialTheme.priority5;
      }
    }

    final extColor = getExtendedColor();
    final colorFamily = isDark ? extColor.dark : extColor.light;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(0),
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 8.0,
              child: Container(color: colorFamily.color),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${admission.id} • ${patient.pesel}',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${patient.firstName} ${patient.lastName}, ${patient.age} lat',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: colorFamily.colorContainer,
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(color: colorFamily.color),
                                ),
                                child: Text(
                                  'KTAS ${admission.priorityKtas}',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: colorFamily.onColorContainer,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  admission.chiefComplaint,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$waitingMinutes min',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                        ),
                        Text(
                          'OCZEKUJE',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
