import 'package:esor/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_mode_notifier.dart';
import '../../../auth/presentation/view_models/auth_view_model.dart';
import '../../../staff/domain/staff_entity.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: ListView(
        children: [
          SectionHeader(title: "Użytkownik"),
          const SizedBox(height: 2),
          authState.when(
            data: (user) {
              if (user == null) {
                return const Card(
                  child: ListTile(
                    leading: Icon(Icons.person_off),
                    title: Text('Niezalogowany'),
                  ),
                );
              }
              return _buildUserInfoCard(context, user);
            },
            loading: () => const Card(
              child: ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Ładowanie...'),
              ),
            ),
            error: (error, _) => Card(
              child: ListTile(
                leading: const Icon(Icons.error),
                title: Text('Błąd: $error'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(title: "Wygląd"),
          const SizedBox(height: 2),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: SwitchListTile(
              title: const Text('Tryb ciemny'),
              subtitle: Text(
                themeMode == ThemeMode.dark ? 'Aktywny' : 'Nieaktywny',
              ),
              secondary: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              value: themeMode == ThemeMode.dark,
              onChanged: (_) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(title: "Konto"),
          const SizedBox(height: 2),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Wyloguj się'),
              onTap: () {
                ref.read(authViewModelProvider.notifier).logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, StaffEntity user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Text(
                    '${user.firstName.isNotEmpty ? user.firstName[0] : ''}${user.lastName.isNotEmpty ? user.lastName[0] : ''}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.academicTitle.isNotEmpty ? '${user.academicTitle} ' : ''}${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.role.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (user.email.isNotEmpty) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(user.email),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
