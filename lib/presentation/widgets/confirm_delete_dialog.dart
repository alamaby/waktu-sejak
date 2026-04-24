import 'package:flutter/material.dart';
import '../../core/l10n/generated/app_localizations.dart';

Future<bool> confirmDeleteEvent(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.deleteConfirmTitle),
      content: Text(l10n.deleteConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return confirmed == true;
}
