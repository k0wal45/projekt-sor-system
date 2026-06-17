import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 0.0,
      ),
      body: const Center(child: Text('Settings Placeholder')),
    );
  }
}
