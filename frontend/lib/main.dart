import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ESorApp(),
    ),
  );
}

class ESorApp extends ConsumerWidget {
  const ESorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'E-SOR',
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(),
        textTheme: textTheme,
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
