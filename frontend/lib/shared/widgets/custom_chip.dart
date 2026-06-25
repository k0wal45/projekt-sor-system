import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = theme.colorScheme.onSurfaceVariant;
    final backgroundColor = theme.colorScheme.surfaceContainerHigh;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: foregroundColor),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
