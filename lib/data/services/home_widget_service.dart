import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/time_calculator.dart';
import '../models/event_model.dart';

class HomeWidgetService {
  HomeWidgetService._();

  static const _maxItems = 3;
  static const _androidProvider = 'WaktuSejakWidgetProvider';
  static const _eventsKey = 'events';
  static const _localeKey = 'locale';

  static bool get _supported => !kIsWeb && Platform.isAndroid;

  static Future<void> sync({SharedPreferences? prefs}) async {
    if (!_supported) return;
    final p = prefs ?? await SharedPreferences.getInstance();

    final events = _loadEvents(p);
    final now = DateTime.now();
    events.sort((a, b) => a.targetDate
        .difference(now)
        .abs()
        .compareTo(b.targetDate.difference(now).abs()));
    final top = events.take(_maxItems).toList();

    final langCode = p.getString(_localeKey) ?? 'en';
    final l10n = await AppLocalizations.delegate.load(Locale(langCode));

    await HomeWidget.saveWidgetData<int>('count', top.length);
    await HomeWidget.saveWidgetData<String>('empty_label', l10n.widgetEmpty);
    await HomeWidget.saveWidgetData<String>('title_label', l10n.widgetTitle);

    for (var i = 0; i < _maxItems; i++) {
      if (i < top.length) {
        final e = top[i];
        final diff = TimeCalculator.calculate(e.targetDate);
        await HomeWidget.saveWidgetData<String>('event_${i}_id', e.id);
        await HomeWidget.saveWidgetData<String>('event_${i}_emoji', e.emoji);
        await HomeWidget.saveWidgetData<String>('event_${i}_title', e.name);
        await HomeWidget.saveWidgetData<String>(
            'event_${i}_subtitle', TimeCalculator.localize(diff, l10n));
        await HomeWidget.saveWidgetData<int>(
            'event_${i}_color', e.color.toARGB32());
      } else {
        await HomeWidget.saveWidgetData<String>('event_${i}_id', null);
        await HomeWidget.saveWidgetData<String>('event_${i}_emoji', null);
        await HomeWidget.saveWidgetData<String>('event_${i}_title', null);
        await HomeWidget.saveWidgetData<String>('event_${i}_subtitle', null);
        await HomeWidget.saveWidgetData<int>('event_${i}_color', null);
      }
    }

    await HomeWidget.saveWidgetData<String>(
        'last_synced', DateTime.now().toIso8601String());

    await HomeWidget.updateWidget(
      name: _androidProvider,
      androidName: _androidProvider,
    );
  }

  static List<EventModel> _loadEvents(SharedPreferences prefs) {
    final raw = prefs.getString(_eventsKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
