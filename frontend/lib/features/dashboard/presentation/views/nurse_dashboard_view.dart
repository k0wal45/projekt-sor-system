import 'package:esor/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import '../../domain/models/queue_item.dart';
import '../../../../shared/widgets/queue_patient_card.dart';

class NurseDashboardView extends StatelessWidget {
  final List<QueueItem> queue;
  final VoidCallback onRefresh;

  const NurseDashboardView({
    super.key,
    required this.queue,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: CustomScrollView(
          slivers: [
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
