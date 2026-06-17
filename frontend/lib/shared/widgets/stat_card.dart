import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color? iconContainerColor;
  final Color? iconBorderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
    this.iconContainerColor,
    this.iconBorderColor,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalIconColor = iconColor ?? theme.colorScheme.onPrimaryContainer;
    final finalTextColor = textColor ?? theme.colorScheme.onSurface;
    final finalContainerColor =
        iconContainerColor ?? theme.colorScheme.primaryContainer;
    final finalIconBorderColor = iconBorderColor ?? finalIconColor;
    final finalBackground =
        backgroundColor ?? theme.colorScheme.surfaceContainerLow;
    final finalBorderColor = borderColor ?? theme.colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: finalBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: finalBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: finalContainerColor,
              shape: BoxShape.circle,
              border: Border.all(color: finalIconBorderColor),
            ),
            child: Icon(icon, color: finalIconColor, size: 24.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: finalTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: finalTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
