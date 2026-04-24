import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/time_calculator.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import 'confirm_delete_dialog.dart';
import 'event_actions_sheet.dart';

class EventListTile extends ConsumerWidget {
  final EventModel event;

  const EventListTile({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final diff = TimeCalculator.calculate(event.targetDate);
    final timeStr = TimeCalculator.localize(diff, l10n);
    final isPast = diff.isPast;

    return Dismissible(
      key: Key(event.id),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      confirmDismiss: (_) => confirmDeleteEvent(context),
      onDismissed: (_) {
        ref.read(eventsNotifierProvider.notifier).deleteEvent(event.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          onTap: () => showEventActionsSheet(context, ref, event),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(12),
                  // Overlay for past events
                  border: isPast
                      ? Border.all(
                          color: Colors.black26,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    event.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            event.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isPast
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              _StatusChip(isPast: isPast),
            ],
          ),
          trailing: Icon(
            isPast ? Icons.history : Icons.arrow_forward,
            color: isPast
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          isThreeLine: true,
        ),
      ),
    );
  }

}

class _StatusChip extends StatelessWidget {
  final bool isPast;
  const _StatusChip({required this.isPast});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPast
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPast ? l10n.pastLabel : l10n.upcomingLabel,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isPast ? colorScheme.onSurfaceVariant : colorScheme.onPrimaryContainer,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}
