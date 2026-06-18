import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/recurrence_calculator.dart';
import '../../core/utils/time_calculator.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import 'confirm_delete_dialog.dart';
import 'event_actions_sheet.dart';
import 'supporter_reward_dialog.dart';

class EventListTile extends ConsumerWidget {
  final EventModel event;

  const EventListTile({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final targetDate = RecurrenceCalculator.effectiveTargetDate(event);
    final diff = TimeCalculator.calculate(targetDate);
    final timeStr = TimeCalculator.localize(diff, l10n);
    final isPast = diff.isPast;
    final isSupporterReward = event.isSupporterReward;
    final shouldDim = isPast && !isSupporterReward;
    final isPinned = event.isPinned;
    final isTablet = MediaQuery.sizeOf(context).width >= 600;

    return Semantics(
      identifier: 'event_list_tile_${event.id}',
      label: event.name,
      button: true,
      child: Dismissible(
        key: Key('event_list_tile_${event.id}'),
        direction: DismissDirection.endToStart,
        background: _DismissBackground(),
        confirmDismiss: (_) => confirmDeleteEvent(context),
        onDismissed: (_) {
          ref.read(eventsNotifierProvider.notifier).deleteEvent(event.id);
        },
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 8 : 16,
            vertical: isTablet ? 5 : 4,
          ),
          color: isSupporterReward
              ? const Color(0xFFFFC857).withValues(alpha: 0.18)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSupporterReward
                ? BorderSide(
                    color: const Color(0xFFFFC857).withValues(alpha: 0.8),
                  )
                : BorderSide.none,
          ),
          child: ListTile(
            key: Key('event_list_tile_tap_${event.id}'),
            onTap: () => isSupporterReward
                ? showSupporterRewardDialog(context, ref, event)
                : showEventActionsSheet(context, ref, event),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 18 : 16,
              vertical: isTablet ? 6 : 8,
            ),
            leading: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: isTablet ? 52 : 48,
                  height: isTablet ? 52 : 48,
                  decoration: BoxDecoration(
                    color: event.color,
                    borderRadius: BorderRadius.circular(12),
                    // Overlay for past events
                    border: shouldDim
                        ? Border.all(
                            color: Colors.black26,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      event.emoji,
                      style: TextStyle(fontSize: isTablet ? 25 : 24),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              event.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 18 : null,
                color: shouldDim
                    ? Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7)
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
                    fontSize: isTablet ? 14 : 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                isSupporterReward
                    ? _SupporterChip(count: event.supportCount)
                    : _StatusChip(isPast: isPast),
              ],
            ),
            trailing: Icon(
              isPinned
                  ? Icons.push_pin
                  : isSupporterReward
                      ? Icons.auto_awesome
                      : isPast
                          ? Icons.history
                          : Icons.arrow_forward,
              color: isSupporterReward
                  ? const Color(0xFFF2A541)
                  : isPinned
                      ? Theme.of(context).colorScheme.primary
                      : isPast
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            isThreeLine: true,
          ),
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
          color: isPast
              ? colorScheme.onSurfaceVariant
              : colorScheme.onPrimaryContainer,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SupporterChip extends StatelessWidget {
  final int count;

  const _SupporterChip({required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC857).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        l10n.supporterRewardBadge(count),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7A4F00),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 8 : 16,
        vertical: isTablet ? 5 : 4,
      ),
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
