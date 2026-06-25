import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/routing/app_router.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_mode_notifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-SOR',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
