import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/preferences_provider.dart';
import '../../data/services/home_widget_service.dart';

part 'settings_provider.g.dart';

const _kLocaleKey = 'locale';
const _kThemeModeKey = 'theme_mode';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(_kLocaleKey) ?? _defaultLocaleCode();
    return Locale(code);
  }

  void setLocale(Locale locale) {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_kLocaleKey, locale.languageCode).then((_) {
      HomeWidgetService.sync(prefs: prefs);
    });
  }
}

String _defaultLocaleCode() {
  final platformCode =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return platformCode == 'id' ? 'id' : 'en';
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
