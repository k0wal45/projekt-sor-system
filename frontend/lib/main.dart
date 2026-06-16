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

class ESorApp extends StatelessWidget {
  const ESorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);

    return MaterialApp.router(
      title: 'E-SOR',
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(),
        textTheme: textTheme,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
