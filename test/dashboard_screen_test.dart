import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waktu_sejak/core/l10n/generated/app_localizations.dart';
import 'package:waktu_sejak/data/local/preferences_provider.dart';
import 'package:waktu_sejak/data/models/event_model.dart';
import 'package:waktu_sejak/presentation/screens/dashboard_screen.dart';

void main() {
  testWidgets('shows dashboard empty state', (tester) async {
    await _pumpDashboard(tester, events: []);

    expect(
      find.text('No events yet. Tap Create to add one.'),
      findsOneWidget,
    );
  });

  testWidgets('shows populated dashboard events', (tester) async {
    await _pumpDashboard(
      tester,
      events: [
        _event(id: 'alpha', name: 'Alpha Event'),
        _event(id: 'beta', name: 'Beta Event'),
      ],
    );

    expect(find.text('Alpha Event'), findsOneWidget);
    expect(find.text('Beta Event'), findsOneWidget);
  });

  testWidgets('filters dashboard events by search query', (tester) async {
    await _pumpDashboard(
      tester,
      events: [
        _event(id: 'alpha', name: 'Alpha Event'),
        _event(id: 'beta', name: 'Beta Event'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('dashboard_search_field')),
      'Alpha',
    );
    await tester.pump();

    expect(find.text('Alpha Event'), findsOneWidget);
    expect(find.text('Beta Event'), findsNothing);
  });
}

Future<void> _pumpDashboard(
  WidgetTester tester, {
  required List<EventModel> events,
}) async {
  SharedPreferences.setMockInitialValues({
    'events_seeded': true,
    'events': jsonEncode(events.map((event) => event.toJson()).toList()),
  });
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DashboardScreen(),
      ),
    ),
  );
  await tester.pump();
}

EventModel _event({
  required String id,
  required String name,
}) {
  return EventModel(
    id: id,
    name: name,
    targetDate: DateTime(2026, 5, 29, 12),
    emoji: '📅',
    color: Colors.blue,
    createdAt: DateTime(2026, 5, 1),
  );
}
