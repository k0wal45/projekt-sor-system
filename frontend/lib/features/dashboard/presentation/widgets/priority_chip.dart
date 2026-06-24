import 'package:esor/core/theme/priority_colors.dart';
import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final int priority;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = theme.getPriorityColor(priority);
    final backgroundColor = theme.getPriorityContainerColor(priority);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: foregroundColor),
      ),
      child: Text(
        "KTAS $priority",
        style: theme.textTheme.labelSmall?.copyWith(color: foregroundColor),
      ),
    );
  }
}
