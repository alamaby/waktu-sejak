import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class TimeDiff {
  final bool isPast;
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const TimeDiff({
    required this.isPast,
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  bool get isZero =>
      years == 0 &&
      months == 0 &&
      days == 0 &&
      hours == 0 &&
      minutes == 0 &&
      seconds == 0;
}

class TimeCalculator {
  TimeCalculator._();

  static TimeDiff calculate(DateTime target) {
    final now = DateTime.now();
    final isPast = target.isBefore(now);
    final from = isPast ? target : now;
    final to = isPast ? now : target;

    int years = to.year - from.year;
    int months = to.month - from.month;
    int days = to.day - from.day;
    int hours = to.hour - from.hour;
    int mins = to.minute - from.minute;
    int secs = to.second - from.second;

    // Borrow-carry from smallest unit upwards
    if (secs < 0) {
      mins -= 1;
      secs += 60;
    }
    if (mins < 0) {
      hours -= 1;
      mins += 60;
    }
    if (hours < 0) {
      days -= 1;
      hours += 24;
    }
    if (days < 0) {
      months -= 1;
      // Days in the month before `to`
      final prevMonth = to.month == 1 ? 12 : to.month - 1;
      final prevYear = to.month == 1 ? to.year - 1 : to.year;
      days += DateUtils.getDaysInMonth(prevYear, prevMonth);
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    return TimeDiff(
      isPast: isPast,
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: mins,
      seconds: secs,
    );
  }

  static String localize(TimeDiff diff, AppLocalizations l10n) {
    if (diff.isZero) return l10n.justNow;

    if (diff.isPast) {
      if (diff.years > 0 && diff.months > 0 && diff.days > 0) {
        return l10n.timeAgoYMD(diff.years, diff.months, diff.days);
      }
      if (diff.years > 0 && diff.months > 0) {
        return l10n.timeAgoYM(diff.years, diff.months);
      }
      if (diff.years > 0) {
        return l10n.timeAgoY(diff.years);
      }
      if (diff.months > 0 && diff.days > 0) {
        return l10n.timeAgoMD(diff.months, diff.days);
      }
      if (diff.months > 0) {
        return l10n.timeAgoM(diff.months);
      }
      if (diff.days > 0) {
        if (diff.hours > 0 || diff.minutes > 0 || diff.seconds > 0) {
          return l10n.timeAgoDHMS(diff.days, diff.hours, diff.minutes, diff.seconds);
        }
        return l10n.timeAgoD(diff.days);
      }
      return l10n.timeAgoHMS(diff.hours, diff.minutes, diff.seconds);
    } else {
      if (diff.years > 0 && diff.months > 0 && diff.days > 0) {
        return l10n.timeUntilYMD(diff.years, diff.months, diff.days);
      }
      if (diff.years > 0 && diff.months > 0) {
        return l10n.timeUntilYM(diff.years, diff.months);
      }
      if (diff.years > 0) {
        return l10n.timeUntilY(diff.years);
      }
      if (diff.months > 0 && diff.days > 0) {
        return l10n.timeUntilMD(diff.months, diff.days);
      }
      if (diff.months > 0) {
        return l10n.timeUntilM(diff.months);
      }
      if (diff.days > 0) {
        if (diff.hours > 0 || diff.minutes > 0 || diff.seconds > 0) {
          return l10n.timeUntilDHMS(diff.days, diff.hours, diff.minutes, diff.seconds);
        }
        return l10n.timeUntilD(diff.days);
      }
      return l10n.timeUntilHMS(diff.hours, diff.minutes, diff.seconds);
    }
  }
}
