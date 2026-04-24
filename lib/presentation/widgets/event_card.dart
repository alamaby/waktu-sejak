import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/time_calculator.dart';
import '../../data/models/event_model.dart';
import 'event_actions_sheet.dart';

class EventCard extends ConsumerWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final diff = TimeCalculator.calculate(event.targetDate);
    final timeStr = TimeCalculator.localize(diff, l10n);
    final textColor = AppColors.textColorOn(event.color);
    final isPast = diff.isPast;

    return GestureDetector(
      onTap: () => showEventActionsSheet(context, ref, event),
      child: Stack(
        children: [
          Card(
            color: event.color,
            elevation: isPast ? 1 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: isPast
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withValues(alpha: 0.15),
                    )
                  : null,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      _StatusBadge(isPast: isPast, textColor: textColor),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    event.name,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Long-press hint overlay (invisible, just enables context)
        ],
      ),
    );
  }

}

class _StatusBadge extends StatelessWidget {
  final bool isPast;
  final Color textColor;

  const _StatusBadge({required this.isPast, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        isPast ? l10n.pastLabel : l10n.upcomingLabel,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
