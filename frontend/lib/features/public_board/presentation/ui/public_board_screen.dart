import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../admissions/domain/admission_entity.dart';

class PublicBoardScreen extends ConsumerStatefulWidget {
  const PublicBoardScreen({super.key});

  @override
  ConsumerState<PublicBoardScreen> createState() => _PublicBoardScreenState();
}

class _PublicBoardScreenState extends ConsumerState<PublicBoardScreen> {
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
    final stream = ref.watch(webSocketServiceProvider).queueStream;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolejka SOR - Poczekalnia'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: StreamBuilder<List<AdmissionEntity>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Oczekiwanie na dane z serwera...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Błąd połączenia: ${snapshot.error}'));
          }

          final queue = snapshot.data ?? [];
          
          final visibleQueue = queue.where((e) => e.status == AdmissionStatus.inQueue).toList();

          if (visibleQueue.isEmpty) {
            return const Center(child: Text('Brak oczekujących pacjentów.', style: TextStyle(fontSize: 24)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visibleQueue.length,
            itemBuilder: (context, index) {
              final admission = visibleQueue[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: _getPriorityColor(admission.priorityKtas),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: _getPriorityColor(admission.priorityKtas),
                    radius: 30,
                    child: Text(
                      'P${admission.priorityKtas}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  title: Text(
                    'Zgłoszenie #${admission.id}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rejestracja: ${admission.admissionDate.toLocal().toString().substring(11, 16)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
