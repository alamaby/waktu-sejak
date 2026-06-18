import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waktu_sejak/data/models/event_model.dart';
import 'package:waktu_sejak/data/services/data_portability_service.dart';

void main() {
  group('DataPortabilityService schema', () {
    test('creates versioned backup payload with events', () {
      final event = _event(id: 'event-1');

      final payload = DataPortabilityService.createBackupPayload([event]);

      expect(payload['app'], 'waktu_sejak');
      expect(payload['version'], 2);
      expect(DateTime.tryParse(payload['exportedAt'] as String), isNotNull);
      expect(payload['events'], hasLength(1));
      expect((payload['events'] as List).single['id'], 'event-1');
    });

    test('parses valid backup JSON', () {
      final payload = DataPortabilityService.createBackupPayload([
        _event(id: 'event-1', recurrenceType: RecurrenceType.yearly),
      ]);

      final events = DataPortabilityService.parseBackupJson(
        jsonEncode(payload),
      );

      expect(events, hasLength(1));
      expect(events.single.id, 'event-1');
      expect(events.single.recurrenceType, RecurrenceType.yearly);
    });

    test('accepts legacy event maps without recurrence type', () {
      final event = _event(id: 'legacy').toJson()..remove('recurrenceType');
      final payload = {
        'app': 'waktu_sejak',
        'version': 1,
        'exportedAt': DateTime(2026, 5, 29).toIso8601String(),
        'events': [event],
      };

      final events = DataPortabilityService.parseBackupJson(
        jsonEncode(payload),
      );

      expect(events.single.recurrenceType, RecurrenceType.none);
    });

    test('rejects unsupported future schema version', () {
      final payload = {
        'app': 'waktu_sejak',
        'version': 999,
        'events': [],
      };

      expect(
        () => DataPortabilityService.parseBackupJson(jsonEncode(payload)),
        throwsA(isA<ImportInvalidFormat>()),
      );
    });

    test('rejects invalid event schema', () {
      final payload = {
        'app': 'waktu_sejak',
        'version': 2,
        'events': [
          {
            'id': 'bad-event',
            'name': 'Bad Event',
            'targetDate': 'not-a-date',
            'emoji': '📅',
            'color': Colors.blue.toARGB32(),
            'createdAt': DateTime(2026, 5, 1).toIso8601String(),
          },
        ],
      };

      expect(
        () => DataPortabilityService.parseBackupJson(jsonEncode(payload)),
        throwsA(isA<ImportInvalidFormat>()),
      );
    });
  });

  group('DataPortabilityService.buildEventsCsv', () {
    test('emits header only for empty event list', () {
      final csv = DataPortabilityService.buildEventsCsv(const []);

      expect(csv, startsWith('Name,Target Date,Emoji,Color (ARGB),'));
      expect(csv.split('\r\n').where((l) => l.isNotEmpty), hasLength(1));
    });

    test('serializes one event per row with all columns', () {
      final event = _event(id: 'event-1').copyWith(
        name: 'Wedding Anniversary',
        emoji: '💍',
        isPinned: true,
      );

      final csv = DataPortabilityService.buildEventsCsv([event]);
      final lines = csv.split('\r\n').where((l) => l.isNotEmpty).toList();

      expect(lines, hasLength(2));
      expect(lines[0], contains('Is Pinned'));
      expect(lines[1], contains('Wedding Anniversary'));
      expect(lines[1], contains('💍'));
      expect(lines[1], contains('true'));
      expect(lines[1], contains(RecurrenceType.none.name));
      expect(lines[1], contains(EventKind.normal.name));
    });

    test('escapes commas, quotes, and newlines per RFC 4180', () {
      final event = _event(id: 'event-1').copyWith(
        name: 'Hello, "world"\nNext line',
      );

      final csv = DataPortabilityService.buildEventsCsv([event]);

      expect(csv, contains('"Hello, ""world""\nNext line"'));
    });

    test('uses ISO 8601 dates and ARGB integer for color', () {
      final event = _event(id: 'event-1');

      final csv = DataPortabilityService.buildEventsCsv([event]);
      final dataRow = csv.split('\r\n')[1];

      expect(dataRow, contains('2026-05-29T12:00:00'));
      expect(dataRow, contains(Colors.blue.toARGB32().toString()));
    });
  });
}

EventModel _event({
  required String id,
  RecurrenceType recurrenceType = RecurrenceType.none,
}) {
  return EventModel(
    id: id,
    name: 'Test Event',
    targetDate: DateTime(2026, 5, 29, 12),
    emoji: '📅',
    color: Colors.blue,
    createdAt: DateTime(2026, 5, 1),
    recurrenceType: recurrenceType,
  );
}
