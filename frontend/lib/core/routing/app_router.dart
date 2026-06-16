import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PlaceholderHomeScreen(),
    ),
  ],
);

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-SOR Dashboard'),
      ),
      body: const Center(
        child: Text('Witaj w aplikacji E-SOR'),
      ),
    );
  }
}
