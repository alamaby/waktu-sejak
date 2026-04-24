import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/event_model.dart';

part 'events_provider.g.dart';

enum SortType { byName, byTimeClosest, byTimeFarthest }

enum ViewType { card, list }

const _uuid = Uuid();

@riverpod
class EventsNotifier extends _$EventsNotifier {
  @override
  List<EventModel> build() => _dummyEvents();

  void addEvent(EventModel event) {
    state = [...state, event];
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void updateEvent(EventModel event) {
    state = [
      for (final e in state) if (e.id == event.id) event else e,
    ];
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
  SortType build() => SortType.byTimeClosest;

  void set(SortType type) => state = type;
}

@riverpod
class ViewTypeNotifier extends _$ViewTypeNotifier {
  @override
  ViewType build() => ViewType.card;

  void toggle() =>
      state = state == ViewType.card ? ViewType.list : ViewType.card;
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
