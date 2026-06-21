import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            ref.read(authViewModelProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Wyloguj się'),
        ),
      ),
    );
  }
}
