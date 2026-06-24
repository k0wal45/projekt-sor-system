import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const FormHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
