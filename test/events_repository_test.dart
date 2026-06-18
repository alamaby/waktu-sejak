import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waktu_sejak/data/models/event_model.dart';
import 'package:waktu_sejak/data/repositories/events_repository.dart';

void main() {
  group('EventsRepository.load', () {
    test('returns empty list for malformed JSON', () async {
      SharedPreferences.setMockInitialValues({
        'events': '{not-json',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = EventsRepository(prefs);

      final events = repo.load();
      await Future<void>.delayed(Duration.zero);

      expect(events, isEmpty);
      expect(
        prefs.getKeys().where((key) => key.startsWith('events_corrupt_backup')),
        isNotEmpty,
      );
    });

    test('returns empty list for non-list JSON', () async {
      SharedPreferences.setMockInitialValues({
        'events': jsonEncode({'events': []}),
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = EventsRepository(prefs);

      final events = repo.load();

      expect(events, isEmpty);
    });

    test('skips invalid event items and keeps valid ones', () async {
      final valid = _event(id: 'valid').toJson();
      SharedPreferences.setMockInitialValues({
        'events': jsonEncode([
          valid,
          {'id': 'invalid'},
          'not-an-event',
        ]),
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = EventsRepository(prefs);

      final events = repo.load();

      expect(events, hasLength(1));
      expect(events.single.id, 'valid');
    });

    test('preserves isPinned when present in JSON', () async {
      final pinned = _event(id: 'pinned').copyWith(isPinned: true).toJson();
      SharedPreferences.setMockInitialValues({
        'events': jsonEncode([pinned]),
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = EventsRepository(prefs);

      final events = repo.load();

      expect(events.single.isPinned, isTrue);
    });

    test('defaults isPinned to false when missing in JSON', () async {
      final oldPayload = _event(id: 'old').toJson()..remove('isPinned');
      SharedPreferences.setMockInitialValues({
        'events': jsonEncode([oldPayload]),
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = EventsRepository(prefs);

      final events = repo.load();

      expect(events.single.isPinned, isFalse);
    });
  });
}

EventModel _event({required String id}) {
  return EventModel(
    id: id,
    name: 'Test Event',
    targetDate: DateTime(2026, 5, 29, 12),
    emoji: '📅',
    color: Colors.blue,
    createdAt: DateTime(2026, 5, 1),
  );
}
