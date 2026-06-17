import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.local_hospital,
          color: Theme.of(context).colorScheme.primary,
          size: 32.0,
        ),
        const SizedBox(width: 4.0),
        Text(
          'E-SOR',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
      ],
    );
  }
}
