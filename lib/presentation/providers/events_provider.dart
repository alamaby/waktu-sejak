import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../data/local/preferences_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/events_repository.dart';
import '../../data/services/home_widget_service.dart';

part 'events_provider.g.dart';

enum SortType { byName, byTimeClosest, byTimeFarthest }

enum ViewType { card, list }

const _uuid = Uuid();
const _kSortTypeKey = 'sort_type';
const _kViewTypeKey = 'view_type';

@riverpod
class EventsNotifier extends _$EventsNotifier {
  @override
  List<EventModel> build() {
    final repo = ref.watch(eventsRepositoryProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    if (!repo.hasSeeded) {
      final seed = _dummyEvents();
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
      for (final e in state) if (e.id == event.id) event else e,
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

  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);
    ref.read(eventsRepositoryProvider).save(state).then((_) {
      HomeWidgetService.sync(prefs: prefs);
    });
  }

  List<EventModel> _dummyEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: _uuid.v4(),
        name: 'Started University',
        targetDate: DateTime(2019, 9, 2, 8, 0),
        emoji: '🎓',
        color: AppColors.skyBlue,
        createdAt: now,
      ),
      EventModel(
        id: _uuid.v4(),
        name: 'Next Vacation',
        targetDate: now.add(const Duration(days: 45)),
        emoji: '✈️',
        color: AppColors.bluishGreen,
        createdAt: now,
      ),
      EventModel(
        id: _uuid.v4(),
        name: 'Wedding Anniversary',
        targetDate: DateTime(2022, 6, 15, 10, 0),
        emoji: '💍',
        color: AppColors.vermillion,
        createdAt: now,
      ),
      EventModel(
        id: _uuid.v4(),
        name: 'Project Deadline',
        targetDate: now.add(const Duration(days: 7)),
        emoji: '📅',
        color: AppColors.orange,
        createdAt: now,
      ),
    ];
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
class SelectedTab extends _$SelectedTab {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

@riverpod
List<EventModel> sortedEvents(Ref ref) {
  final events = ref.watch(eventsNotifierProvider);
  final sortType = ref.watch(sortTypeNotifierProvider);
  final now = DateTime.now();

  final sorted = [...events];

  switch (sortType) {
    case SortType.byName:
      sorted.sort((a, b) => a.name.compareTo(b.name));
    case SortType.byTimeClosest:
      sorted.sort(
        (a, b) => a.targetDate
            .difference(now)
            .abs()
            .compareTo(b.targetDate.difference(now).abs()),
      );
    case SortType.byTimeFarthest:
      sorted.sort(
        (a, b) => b.targetDate
            .difference(now)
            .abs()
            .compareTo(a.targetDate.difference(now).abs()),
      );
  }

  return sorted;
}
