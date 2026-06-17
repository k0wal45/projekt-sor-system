import 'package:esor/core/theme/app_theme.dart';
import 'package:esor/shared/widgets/active_patient_cart.dart';
import 'package:esor/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import '../../../../features/auth/domain/models/staff.dart';
import '../../domain/models/queue_item.dart';
import '../../../../shared/widgets/queue_patient_card.dart';
import '../../../../shared/widgets/stat_card.dart';

class DoctorDashboardView extends StatelessWidget {
  final Staff staff;
  final List<QueueItem> queue;
  final List<QueueItem> activePatients;
  final VoidCallback onRefresh;

  const DoctorDashboardView({
    super.key,
    required this.staff,
    required this.queue,
    required this.activePatients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final criticalCount = queue
        .where(
          (q) => q.admission.priorityKtas == 1 || q.admission.priorityKtas == 2,
        )
        .length;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priority4Family = isDark
        ? MaterialTheme.priority4.dark
        : MaterialTheme.priority4.light;
    final priority1Family = isDark
        ? MaterialTheme.priority1.dark
        : MaterialTheme.priority1.light;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140.0,
            title: AppLogo(),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            scrolledUnderElevation: 0.0,
            actions: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 16.0,
                child: Text(
                  'XX',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 10.0,
                ),
                child: Text(
                  'Dzień dobry,\nDr. ${staff.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '${activePatients.length}',
                          label: 'Aktywnych pacjentów',
                          icon: Icons.personal_injury,
                          iconColor: priority4Family.onColorContainer,
                          iconContainerColor: priority4Family.colorContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          value: '$criticalCount',
                          label: 'Stan krytyczny w kolejce',
                          icon: Icons.warning,
                          iconColor: priority1Family.onColor,
                          iconContainerColor: priority1Family.color,
                          iconBorderColor: priority1Family.color,
                          backgroundColor: priority1Family.colorContainer,
                          borderColor: priority1Family.color,
                          textColor: priority1Family.onColorContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pacjenci pod obserwacją',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                itemCount: activePatients.length,
                itemBuilder: (context, index) {
                  final item = activePatients[index];
                  return ActivePatientCard(queueItem: item, onTap: () {});
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 12.0);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 12.0,
              left: 16.0,
              right: 16.0,
              bottom: 4.0,
            ),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 48.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pacjenci w kolejce',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 32.0,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.history_rounded, size: 20),
                        label: const Text('Historia'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList.separated(
              itemCount: queue.length,
              itemBuilder: (context, index) {
                final item = queue[index];
                return QueuePatientCard(item: item, onTap: () {});
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12.0),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.0)),
        ],
      ),
    );
  }
}
