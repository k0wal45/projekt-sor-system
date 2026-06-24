import 'package:flutter/material.dart';

class StatusPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? errorMessage;
  final Widget? action;

  const StatusPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.errorMessage,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              size: 32.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: 8.0),
            Text(
              description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (errorMessage != null) ...[
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 24.0), action!],
        ],
      ),
    );
  }
}
