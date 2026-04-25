import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/preferences_provider.dart';

part 'settings_provider.g.dart';

const _kLocaleKey = 'locale';
const _kThemeModeKey = 'theme_mode';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(_kLocaleKey) ?? 'en';
    return Locale(code);
  }

  void setLocale(Locale locale) {
    state = locale;
    ref
        .read(sharedPreferencesProvider)
        .setString(_kLocaleKey, locale.languageCode);
  }
}

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_kThemeModeKey) ?? 'system';
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString(_kThemeModeKey, mode.name);
  }
}
