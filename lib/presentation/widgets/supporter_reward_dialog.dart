import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import 'confirm_delete_dialog.dart';

const supporterThankYouAnimationAsset =
    'assets/animations/supporter_thank_you.json';

Future<void> showSupporterRewardDialog(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => _SupporterRewardDialog(event: event),
  );

  if (!context.mounted || shouldDelete != true) return;

  final confirmed = await confirmDeleteEvent(context);
  if (confirmed) {
    ref.read(eventsNotifierProvider.notifier).deleteEvent(event.id);
  }
}

class _SupporterRewardDialog extends StatelessWidget {
  final EventModel event;

  const _SupporterRewardDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      iconPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      icon: SizedBox(
        width: 180,
        height: 140,
        child: Lottie.asset(
          supporterThankYouAnimationAsset,
          repeat: false,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        l10n.supporterRewardDialogTitle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SupporterBadge(count: event.supportCount),
          const SizedBox(height: 12),
          Text(
            l10n.supporterRewardDialogBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
          label: Text(
            l10n.delete,
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

class _SupporterBadge extends StatelessWidget {
  final int count;

  const _SupporterBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC857).withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFC857).withValues(alpha: 0.7),
        ),
      ),
      child: Text(
        l10n.supporterRewardBadge(count),
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
