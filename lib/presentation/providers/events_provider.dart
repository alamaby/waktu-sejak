import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/recurrence_calculator.dart';
import '../../data/local/preferences_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/events_repository.dart';
import '../../data/services/home_widget_service.dart';

part 'events_provider.g.dart';

enum SortType { byName, byTimeClosest, byTimeFarthest }

enum ViewType { card, list }

enum EventStatusFilter { all, past, upcoming }

const _uuid = Uuid();
const supporterRewardEventId = 'support_developer_reward';
const _kLocaleKey = 'locale';
const _kSortTypeKey = 'sort_type';
const _kViewTypeKey = 'view_type';

@riverpod
class EventsNotifier extends _$EventsNotifier {
  @override
  List<EventModel> build() {
    final repo = ref.watch(eventsRepositoryProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    if (!repo.hasSeeded) {
      final seed = _dummyEvents(prefs.getString(_kLocaleKey));
      repo.save(seed).then((_) {
        repo.markSeeded();
        HomeWidgetService.sync(prefs: prefs);
      });
      return seed;
    }
    final loaded = repo.load();
    HomeWidgetService.sync(prefs: prefs);
    return loaded;
  }

  void addEvent(EventModel event) {
    state = [...state, event];
    _persist();
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
    _persist();
  }

  void updateEvent(EventModel event) {
    state = [
      for (final e in state)
        if (e.id == event.id) event else e,
    ];
    _persist();
  }

  int importAppend(List<EventModel> incoming) {
    final existingIds = state.map((e) => e.id).toSet();
    final toAdd = incoming.where((e) => !existingIds.contains(e.id)).toList();
    if (toAdd.isEmpty) return 0;
    state = [...state, ...toAdd];
    _persist();
    return toAdd.length;
  }

  void upsertSupporterReward({
    required String name,
    required int supportCount,
  }) {
    final now = DateTime.now();
    final reward = EventModel(
      id: supporterRewardEventId,
      name: name,
      targetDate: now,
      emoji: '💛',
      color: const Color(0xFFFFC857),
      createdAt: now,
      kind: EventKind.supporter,
      supportCount: supportCount,
    );

    final existingIndex =
        state.indexWhere((event) => event.id == supporterRewardEventId);
    state = existingIndex == -1
        ? [reward, ...state]
        : [
            for (final event in state)
              if (event.id == supporterRewardEventId)
                reward.copyWith(createdAt: event.createdAt)
              else
                event,
          ];
    _persist();
  }

  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);
    ref.read(eventsRepositoryProvider).save(state).then((_) {
      HomeWidgetService.sync(prefs: prefs);
    });
  }

  List<EventModel> _dummyEvents(String? localeCode) {
    final now = DateTime.now();
    final l10n = _seedLocalizations(localeCode);
    return [
      EventModel(
        id: _uuid.v4(),
        name: l10n.sampleStartedUniversity,
        targetDate: DateTime(2019, 9, 2, 8, 0),
        emoji: '🎓',
        color: AppColors.skyBlue,
        createdAt: now,
      ),
      EventModel(
        id: _uuid.v4(),
        name: l10n.sampleNextVacation,
        targetDate: now.add(const Duration(days: 45)),
        emoji: '✈️',
        color: AppColors.bluishGreen,
        createdAt: now,
      ),
      EventModel(
        id: _uuid.v4(),
        name: l10n.sampleWeddingAnniversary,
        targetDate: DateTime(2022, 6, 15, 10, 0),
        emoji: '💍',
        color: AppColors.vermillion,
        createdAt: now,
      ),
      EventModel(
        id: _uuid.v4(),
        name: l10n.sampleProjectDeadline,
        targetDate: now.add(const Duration(days: 7)),
        emoji: '📅',
        color: AppColors.orange,
        createdAt: now,
      ),
    ];
  }

  AppLocalizations _seedLocalizations(String? localeCode) {
    final platformCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final languageCode = (localeCode ?? platformCode) == 'id' ? 'id' : 'en';
    return lookupAppLocalizations(Locale(languageCode));
  }
}

@riverpod
class SortTypeNotifier extends _$SortTypeNotifier {
  @override
  SortType build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final idx = prefs.getInt(_kSortTypeKey);
    if (idx == null || idx < 0 || idx >= SortType.values.length) {
      return SortType.byTimeClosest;
    }
    return SortType.values[idx];
  }

  void set(SortType type) {
    state = type;
    ref.read(sharedPreferencesProvider).setInt(_kSortTypeKey, type.index);
  }
}

@riverpod
class ViewTypeNotifier extends _$ViewTypeNotifier {
  @override
  ViewType build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final idx = prefs.getInt(_kViewTypeKey);
    if (idx == null || idx < 0 || idx >= ViewType.values.length) {
      return ViewType.card;
    }
    return ViewType.values[idx];
  }

  void toggle() {
    final next = state == ViewType.card ? ViewType.list : ViewType.card;
    state = next;
    ref.read(sharedPreferencesProvider).setInt(_kViewTypeKey, next.index);
  }
}

@riverpod
class EventSearchQuery extends _$EventSearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query;

  void clear() => state = '';
}

@riverpod
class EventStatusFilterNotifier extends _$EventStatusFilterNotifier {
  @override
  EventStatusFilter build() => EventStatusFilter.all;

  void set(EventStatusFilter filter) => state = filter;
}

@riverpod
class EventEmojiFilter extends _$EventEmojiFilter {
  @override
  String? build() => null;

  void set(String? emoji) => state = emoji;
}

@riverpod
class SelectedTab extends _$SelectedTab {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

final dashboardClockProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final controller = StreamController<DateTime>();
  final timer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => controller.add(DateTime.now()),
  );

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

@riverpod
List<String> availableEventEmojis(Ref ref) {
  final events = ref.watch(eventsNotifierProvider);
  final emojis = <String>{};
  for (final event in events) {
    emojis.add(event.emoji);
  }
  return emojis.toList()..sort();
}

@riverpod
bool hasActiveEventFilters(Ref ref) {
  final query = ref.watch(eventSearchQueryProvider).trim();
  final status = ref.watch(eventStatusFilterNotifierProvider);
  final emoji = ref.watch(eventEmojiFilterProvider);
  return query.isNotEmpty || status != EventStatusFilter.all || emoji != null;
}

@riverpod
List<EventModel> visibleEvents(Ref ref) {
  final events = ref.watch(eventsNotifierProvider);
  final query = ref.watch(eventSearchQueryProvider).trim().toLowerCase();
  final statusFilter = ref.watch(eventStatusFilterNotifierProvider);
  final emojiFilter = ref.watch(eventEmojiFilterProvider);
  final sortType = ref.watch(sortTypeNotifierProvider);
  final now = ref.watch(dashboardClockProvider).valueOrNull ?? DateTime.now();

  final visible = events.where((event) {
    final matchesQuery =
        query.isEmpty || event.name.toLowerCase().contains(query);
    final isPast = RecurrenceCalculator.isPast(event, now: now);
    final matchesStatus = switch (statusFilter) {
      EventStatusFilter.all => true,
      EventStatusFilter.past => isPast,
      EventStatusFilter.upcoming => !isPast,
    };
    final matchesEmoji = emojiFilter == null || event.emoji == emojiFilter;
    return matchesQuery && matchesStatus && matchesEmoji;
  }).toList();

  switch (sortType) {
    case SortType.byName:
      visible.sort((a, b) => a.name.compareTo(b.name));
    case SortType.byTimeClosest:
      visible.sort(
        (a, b) => RecurrenceCalculator.effectiveTargetDate(a, now: now)
            .difference(now)
            .abs()
            .compareTo(
              RecurrenceCalculator.effectiveTargetDate(b, now: now)
                  .difference(now)
                  .abs(),
            ),
      );
    case SortType.byTimeFarthest:
      visible.sort(
        (a, b) => RecurrenceCalculator.effectiveTargetDate(b, now: now)
            .difference(now)
            .abs()
            .compareTo(
              RecurrenceCalculator.effectiveTargetDate(a, now: now)
                  .difference(now)
                  .abs(),
            ),
      );
  }

  return visible;
}
