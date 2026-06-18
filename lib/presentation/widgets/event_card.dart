import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/utils/recurrence_calculator.dart';
import '../../core/utils/time_calculator.dart';
import '../../data/models/event_model.dart';
import 'event_actions_sheet.dart';
import 'supporter_reward_dialog.dart';

class EventCard extends ConsumerWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final targetDate = RecurrenceCalculator.effectiveTargetDate(event);
    final diff = TimeCalculator.calculate(targetDate);
    final timeStr = TimeCalculator.localize(diff, l10n);
    final textColor = AppColors.textColorOn(event.color);
    final isPast = diff.isPast;
    final isSupporterReward = event.isSupporterReward;
    final isPinned = event.isPinned;
    final isTablet = MediaQuery.sizeOf(context).width >= 600;

    return Semantics(
      identifier: 'event_card_${event.id}',
      label: event.name,
      button: true,
      child: GestureDetector(
        key: Key('event_card_${event.id}'),
        onTap: () => isSupporterReward
            ? showSupporterRewardDialog(context, ref, event)
            : showEventActionsSheet(context, ref, event),
        child: Stack(
          children: [
            Card(
              color: event.color,
              elevation: isSupporterReward
                  ? 6
                  : isPinned
                      ? 4
                      : (isPast ? 1 : 3),
              shape: RoundedRectangleBorder(
                side: isSupporterReward
                    ? BorderSide(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 1.5,
                      )
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: isSupporterReward
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFE7A3),
                            Color(0xFFFFC857),
                            Color(0xFFF2A541),
                          ],
                        ),
                      )
                    : isPast
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black.withValues(alpha: 0.15),
                          )
                        : null,
                padding: EdgeInsets.all(isTablet ? 18 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              event.emoji,
                              style: TextStyle(fontSize: isTablet ? 30 : 28),
                            ),
                            if (isPinned) ...[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.push_pin,
                                size: isTablet ? 18 : 16,
                                color: textColor,
                              ),
                            ],
                          ],
                        ),
                        isSupporterReward
                            ? _SupporterBadge(
                                count: event.supportCount,
                                textColor: textColor,
                              )
                            : _StatusBadge(
                                isPast: isPast, textColor: textColor),
                      ],
                    ),
                    Spacer(flex: isTablet ? 2 : 3),
                    Text(
                      event.name,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 17 : 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _DurationChip(
                      text: timeStr,
                      textColor: textColor,
                      isTablet: isTablet,
                    ),
                  ],
                ),
              ),
            ),
            // Long-press hint overlay (invisible, just enables context)
          ],
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final String text;
  final Color textColor;
  final bool isTablet;

  const _DurationChip({
    required this.text,
    required this.textColor,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: textColor.withValues(alpha: 0.28),
            width: 1,
          ),
        ),
        child: Text.rich(
          _buildSpans(text, textColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  TextSpan _buildSpans(String input, Color color) {
    final base = TextStyle(
      color: color,
      fontSize: isTablet ? 14 : 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final emphasized = base.copyWith(fontWeight: FontWeight.w800);

    final regex = RegExp(r'\d+');
    final spans = <TextSpan>[];
    var index = 0;
    for (final match in regex.allMatches(input)) {
      if (match.start > index) {
        spans.add(TextSpan(text: input.substring(index, match.start)));
      }
      spans.add(TextSpan(text: match.group(0), style: emphasized));
      index = match.end;
    }
    if (index < input.length) {
      spans.add(TextSpan(text: input.substring(index)));
    }
    return TextSpan(style: base, children: spans);
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

class _SupporterBadge extends StatelessWidget {
  final int count;
  final Color textColor;

  const _SupporterBadge({
    required this.count,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(
        l10n.supporterRewardBadge(count),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
