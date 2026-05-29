import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/preferences_provider.dart';
import '../models/event_model.dart';

part 'events_repository.g.dart';

const _kEventsKey = 'events';
const _kEventsSeededKey = 'events_seeded';
const _kCorruptEventsBackupPrefix = 'events_corrupt_backup';

class EventsRepository {
  final SharedPreferences _prefs;

  EventsRepository(this._prefs);

  List<EventModel> load() {
    final raw = _prefs.getString(_kEventsKey);
    if (raw == null || raw.isEmpty) return const [];

    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      _backupCorruptedRaw(raw);
      return const [];
    }

    if (decoded is! List) {
      _backupCorruptedRaw(raw);
      return const [];
    }

    final events = <EventModel>[];
    var hasInvalidItems = false;
    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        hasInvalidItems = true;
        continue;
      }

      try {
        events.add(EventModel.fromJson(item));
      } catch (_) {
        hasInvalidItems = true;
      }
    }

    if (hasInvalidItems) {
      _backupCorruptedRaw(raw);
    }

    return events;
  }

  Future<void> save(List<EventModel> events) {
    final encoded = jsonEncode(events.map((e) => e.toJson()).toList());
    return _prefs.setString(_kEventsKey, encoded);
  }

  bool get hasSeeded => _prefs.getBool(_kEventsSeededKey) ?? false;

  Future<void> markSeeded() => _prefs.setBool(_kEventsSeededKey, true);

  void _backupCorruptedRaw(String raw) {
    final timestamp = DateTime.now().toIso8601String();
    unawaited(
      _prefs.setString('$_kCorruptEventsBackupPrefix:$timestamp', raw),
    );
  }
}

@Riverpod(keepAlive: true)
EventsRepository eventsRepository(Ref ref) =>
    EventsRepository(ref.watch(sharedPreferencesProvider));
