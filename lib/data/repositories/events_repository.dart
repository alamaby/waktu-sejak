import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/preferences_provider.dart';
import '../models/event_model.dart';

part 'events_repository.g.dart';

const _kEventsKey = 'events';
const _kEventsSeededKey = 'events_seeded';

class EventsRepository {
  final SharedPreferences _prefs;

  EventsRepository(this._prefs);

  List<EventModel> load() {
    final raw = _prefs.getString(_kEventsKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<EventModel> events) {
    final encoded = jsonEncode(events.map((e) => e.toJson()).toList());
    return _prefs.setString(_kEventsKey, encoded);
  }

  bool get hasSeeded => _prefs.getBool(_kEventsSeededKey) ?? false;

  Future<void> markSeeded() => _prefs.setBool(_kEventsSeededKey, true);
}

@Riverpod(keepAlive: true)
EventsRepository eventsRepository(Ref ref) =>
    EventsRepository(ref.watch(sharedPreferencesProvider));
