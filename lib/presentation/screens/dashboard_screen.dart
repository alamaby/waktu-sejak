import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/event_list_tile.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    // Tick every second to refresh time displays
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allEvents = ref.watch(eventsNotifierProvider);
    final events = ref.watch(visibleEventsProvider);
    final viewType = ref.watch(viewTypeNotifierProvider);
    final sortType = ref.watch(sortTypeNotifierProvider);
    final hasActiveFilters = ref.watch(hasActiveEventFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // View toggle button
          Semantics(
            identifier: 'dashboard_view_toggle_button',
            button: true,
            child: IconButton(
              key: const Key('dashboard_view_toggle_button'),
              tooltip:
                  viewType == ViewType.card ? l10n.listView : l10n.cardView,
              icon: Icon(
                viewType == ViewType.card
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
              onPressed: () =>
                  ref.read(viewTypeNotifierProvider.notifier).toggle(),
            ),
          ),
          // Sort popup menu
          Semantics(
            identifier: 'dashboard_sort_button',
            button: true,
            child: PopupMenuButton<SortType>(
              key: const Key('dashboard_sort_button'),
              tooltip: l10n.sortLabel,
              icon: const Icon(Icons.sort),
              initialValue: sortType,
              onSelected: (type) =>
                  ref.read(sortTypeNotifierProvider.notifier).set(type),
              itemBuilder: (_) => [
                PopupMenuItem(
                  key: const Key('sort_by_name_option'),
                  value: SortType.byName,
                  child: Semantics(
                    identifier: 'sort_by_name_option',
                    button: true,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_by_alpha,
                          size: 18,
                          color: sortType == SortType.byName
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.sortByName),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  key: const Key('sort_by_time_closest_option'),
                  value: SortType.byTimeClosest,
                  child: Semantics(
                    identifier: 'sort_by_time_closest_option',
                    button: true,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 18,
                          color: sortType == SortType.byTimeClosest
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.sortByTimeClosest),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  key: const Key('sort_by_time_farthest_option'),
                  value: SortType.byTimeFarthest,
                  child: Semantics(
                    identifier: 'sort_by_time_farthest_option',
                    button: true,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          size: 18,
                          color: sortType == SortType.byTimeFarthest
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.sortByTimeFarthest),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const _DashboardFilters(),
          Expanded(
            child: events.isEmpty
                ? _EmptyState(
                    message: allEvents.isEmpty || !hasActiveFilters
                        ? l10n.noEvents
                        : l10n.noMatchingEvents,
                    showClearFilters: allEvents.isNotEmpty && hasActiveFilters,
                  )
                : viewType == ViewType.card
                    ? _CardGrid(events: events)
                    : _EventList(events: events),
          ),
        ],
      ),
    );
  }
}

class _DashboardFilters extends ConsumerStatefulWidget {
  const _DashboardFilters();

  @override
  ConsumerState<_DashboardFilters> createState() => _DashboardFiltersState();
}

class _DashboardFiltersState extends ConsumerState<_DashboardFilters> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(eventSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(eventSearchQueryProvider);
    final statusFilter = ref.watch(eventStatusFilterNotifierProvider);
    final emojiFilter = ref.watch(eventEmojiFilterProvider);
    final emojis = ref.watch(availableEventEmojisProvider);
    final hasActiveFilters = ref.watch(hasActiveEventFiltersProvider);

    if (_searchController.text != query) {
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              identifier: 'dashboard_search_field',
              textField: true,
              child: TextField(
                key: const Key('dashboard_search_field'),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchEvents,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : Semantics(
                          identifier: 'dashboard_search_clear_button',
                          button: true,
                          child: IconButton(
                            key: const Key('dashboard_search_clear_button'),
                            tooltip: l10n.clearFilters,
                            icon: const Icon(Icons.close),
                            onPressed: () => ref
                                .read(eventSearchQueryProvider.notifier)
                                .clear(),
                          ),
                        ),
                  isDense: true,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (value) =>
                    ref.read(eventSearchQueryProvider.notifier).set(value),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _StatusFilterChip(
                          label: l10n.filterAll,
                          filter: EventStatusFilter.all,
                          selected: statusFilter == EventStatusFilter.all,
                        ),
                        const SizedBox(width: 8),
                        _StatusFilterChip(
                          label: l10n.filterPast,
                          filter: EventStatusFilter.past,
                          selected: statusFilter == EventStatusFilter.past,
                        ),
                        const SizedBox(width: 8),
                        _StatusFilterChip(
                          label: l10n.filterUpcoming,
                          filter: EventStatusFilter.upcoming,
                          selected: statusFilter == EventStatusFilter.upcoming,
                        ),
                      ],
                    ),
                  ),
                ),
                if (hasActiveFilters)
                  Semantics(
                    identifier: 'dashboard_clear_filters_button',
                    button: true,
                    child: IconButton(
                      key: const Key('dashboard_clear_filters_button'),
                      tooltip: l10n.clearFilters,
                      icon: const Icon(Icons.filter_alt_off_outlined),
                      onPressed: () {
                        ref.read(eventSearchQueryProvider.notifier).clear();
                        ref
                            .read(eventStatusFilterNotifierProvider.notifier)
                            .set(EventStatusFilter.all);
                        ref.read(eventEmojiFilterProvider.notifier).set(null);
                      },
                    ),
                  ),
              ],
            ),
            if (emojis.isNotEmpty) ...[
              const SizedBox(height: 8),
              Semantics(
                label: l10n.filterByEmoji,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final emoji in emojis) ...[
                        Semantics(
                          identifier: 'dashboard_emoji_filter_$emoji',
                          button: true,
                          selected: emojiFilter == emoji,
                          child: ChoiceChip(
                            key: Key('dashboard_emoji_filter_$emoji'),
                            label: Text(
                              emoji,
                              style: const TextStyle(fontSize: 18),
                            ),
                            selected: emojiFilter == emoji,
                            tooltip: l10n.filterByEmoji,
                            onSelected: (selected) {
                              ref
                                  .read(eventEmojiFilterProvider.notifier)
                                  .set(selected ? emoji : null);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusFilterChip extends ConsumerWidget {
  final String label;
  final EventStatusFilter filter;
  final bool selected;

  const _StatusFilterChip({
    required this.label,
    required this.filter,
    required this.selected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      identifier: 'dashboard_status_filter_${filter.name}',
      button: true,
      selected: selected,
      child: FilterChip(
        key: Key('dashboard_status_filter_${filter.name}'),
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) =>
            ref.read(eventStatusFilterNotifierProvider.notifier).set(filter),
      ),
    );
  }
}

class _CardGrid extends StatelessWidget {
  final List<EventModel> events;

  const _CardGrid({required this.events});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: events.length,
      itemBuilder: (_, index) => EventCard(event: events[index]),
    );
  }
}

class _EventList extends StatelessWidget {
  final List<EventModel> events;

  const _EventList({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: events.length,
      itemBuilder: (_, index) => EventListTile(event: events[index]),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  final String message;
  final bool showClearFilters;

  const _EmptyState({
    required this.message,
    this.showClearFilters = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            if (showClearFilters) ...[
              const SizedBox(height: 16),
              Semantics(
                identifier: 'empty_state_clear_filters_button',
                button: true,
                child: TextButton.icon(
                  key: const Key('empty_state_clear_filters_button'),
                  onPressed: () {
                    ref.read(eventSearchQueryProvider.notifier).clear();
                    ref
                        .read(eventStatusFilterNotifierProvider.notifier)
                        .set(EventStatusFilter.all);
                    ref.read(eventEmojiFilterProvider.notifier).set(null);
                  },
                  icon: const Icon(Icons.filter_alt_off_outlined),
                  label: Text(l10n.clearFilters),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
