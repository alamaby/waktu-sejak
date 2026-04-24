import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import '../screens/event_form_screen.dart';
import 'confirm_delete_dialog.dart';

enum _EventAction { edit, delete }

Future<void> showEventActionsSheet(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
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
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.edit),
            onTap: () => Navigator.of(context).pop(_EventAction.edit),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: colorScheme.error),
            title: Text(l10n.delete, style: TextStyle(color: colorScheme.error)),
            onTap: () => Navigator.of(context).pop(_EventAction.delete),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
