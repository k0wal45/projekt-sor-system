import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/secure_storage_service.dart';

part 'theme_mode_notifier.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.light;
  }

  Future<void> _loadSavedTheme() async {
    final storage = ref.read(secureStorageServiceProvider);
    final saved = await storage.read(_themeKey);
    if (saved != null) {
      state = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final storage = ref.read(secureStorageServiceProvider);
    await storage.write(_themeKey, state == ThemeMode.dark ? 'dark' : 'light');
  }
}
