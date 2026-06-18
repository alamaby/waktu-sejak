import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import '../screens/event_form_screen.dart';
import 'confirm_delete_dialog.dart';

enum _EventAction { edit, duplicate, togglePin, delete }

Future<void> showEventActionsSheet(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
  final l10n = AppLocalizations.of(context);
  final action = await showModalBottomSheet<_EventAction>(
    context: context,
    showDragHandle: true,
    builder: (sheetCtx) => _EventActionsSheet(event: event),
  );

  if (!context.mounted || action == null) return;

  switch (action) {
    case _EventAction.edit:
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EventFormScreen(editingEvent: event),
        ),
      );
    case _EventAction.duplicate:
      final newName = '${event.name}${l10n.eventCopySuffix}';
      final newId = ref
          .read(eventsNotifierProvider.notifier)
          .duplicateEvent(event, newName: newName);
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.eventDuplicated),
          action: SnackBarAction(
            label: l10n.edit,
            onPressed: () {
              final created = ref
                  .read(eventsNotifierProvider)
                  .where((e) => e.id == newId)
                  .firstOrNull;
              if (created == null) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EventFormScreen(editingEvent: created),
                ),
              );
            },
          ),
        ),
      );
    case _EventAction.togglePin:
      ref.read(eventsNotifierProvider.notifier).togglePin(event.id);
    case _EventAction.delete:
      final confirmed = await confirmDeleteEvent(context);
      if (confirmed) {
        ref.read(eventsNotifierProvider.notifier).deleteEvent(event.id);
      }
  }
}

class _EventActionsSheet extends StatelessWidget {
  final EventModel event;

  const _EventActionsSheet({required this.event});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
            child: Row(
              children: [
                Text(event.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (!event.isSupporterReward) ...[
            Semantics(
              identifier: 'event_action_edit_button',
              button: true,
              child: ListTile(
                key: const Key('event_action_edit_button'),
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.edit),
                onTap: () => Navigator.of(context).pop(_EventAction.edit),
              ),
            ),
            Semantics(
              identifier: 'event_action_duplicate_button',
              button: true,
              child: ListTile(
                key: const Key('event_action_duplicate_button'),
                leading: const Icon(Icons.content_copy_outlined),
                title: Text(l10n.duplicate),
                onTap: () => Navigator.of(context).pop(_EventAction.duplicate),
              ),
            ),
            Semantics(
              identifier: 'event_action_toggle_pin_button',
              button: true,
              child: ListTile(
                key: const Key('event_action_toggle_pin_button'),
                leading: Icon(
                  event.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                title: Text(event.isPinned ? l10n.unpin : l10n.pin),
                onTap: () => Navigator.of(context).pop(_EventAction.togglePin),
              ),
            ),
          ],
          Semantics(
            identifier: 'event_action_delete_button',
            button: true,
            child: ListTile(
              key: const Key('event_action_delete_button'),
              leading: Icon(Icons.delete_outline, color: colorScheme.error),
              title:
                  Text(l10n.delete, style: TextStyle(color: colorScheme.error)),
              onTap: () => Navigator.of(context).pop(_EventAction.delete),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
