import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/preferences_provider.dart';

part 'settings_provider.g.dart';

const _kLocaleKey = 'locale';

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
