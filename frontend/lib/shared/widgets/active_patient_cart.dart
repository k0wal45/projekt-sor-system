import 'package:esor/core/theme/app_theme.dart';
import 'package:esor/features/dashboard/domain/models/queue_item.dart';
import 'package:flutter/material.dart';

class ActivePatientCard extends StatelessWidget {
  const ActivePatientCard({super.key, required this.queueItem, this.onTap});

  final QueueItem queueItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final admission = queueItem.admission;
    final patient = queueItem.patient;
    final waitingMinutes = queueItem.waitingTime.inMinutes;

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

    return SizedBox(
      width: 280,
      child: Card(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${patient.firstName} ${patient.lastName}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                admission.status.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                              ),
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
                            'OD ZMIANY\nSTATUSU',
                            textAlign: TextAlign.center,
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
      ),
    );
  }
}
