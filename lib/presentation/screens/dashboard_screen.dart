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
    final events = ref.watch(sortedEventsProvider);
    final viewType = ref.watch(viewTypeNotifierProvider);
    final sortType = ref.watch(sortTypeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // View toggle button
          IconButton(
            tooltip: viewType == ViewType.card ? l10n.listView : l10n.cardView,
            icon: Icon(
              viewType == ViewType.card
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
            ),
            onPressed: () =>
                ref.read(viewTypeNotifierProvider.notifier).toggle(),
          ),
          // Sort popup menu
          PopupMenuButton<SortType>(
            tooltip: l10n.sortLabel,
            icon: const Icon(Icons.sort),
            initialValue: sortType,
            onSelected: (type) =>
                ref.read(sortTypeNotifierProvider.notifier).set(type),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: SortType.byName,
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
              PopupMenuItem(
                value: SortType.byTimeClosest,
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
              PopupMenuItem(
                value: SortType.byTimeFarthest,
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
            ],
          ),
        ],
      ),
      body: events.isEmpty
          ? _EmptyState(l10n: l10n)
          : viewType == ViewType.card
              ? _CardGrid(events: events)
              : _EventList(events: events),
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

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noEvents,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
