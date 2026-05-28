import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';

class RecurrenceCalculator {
  RecurrenceCalculator._();

  static DateTime effectiveTargetDate(EventModel event, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    if (event.recurrenceType != RecurrenceType.none &&
        reference.isBefore(event.targetDate)) {
      return event.targetDate;
    }
    return switch (event.recurrenceType) {
      RecurrenceType.none => event.targetDate,
      RecurrenceType.yearly => _nextYearly(event.targetDate, reference),
      RecurrenceType.monthly => _nextMonthly(event.targetDate, reference),
    };
  }

  static bool isPast(EventModel event, {DateTime? now}) {
    if (event.recurrenceType != RecurrenceType.none) return false;
    return event.targetDate.isBefore(now ?? DateTime.now());
  }

  static DateTime _nextYearly(DateTime source, DateTime now) {
    var occurrence = _clampedDateTime(
      now.year,
      source.month,
      source.day,
      source.hour,
      source.minute,
      source.second,
      source.millisecond,
      source.microsecond,
    );
    if (occurrence.isBefore(now)) {
      occurrence = _clampedDateTime(
        now.year + 1,
        source.month,
        source.day,
        source.hour,
        source.minute,
        source.second,
        source.millisecond,
        source.microsecond,
      );
    }
    return occurrence;
  }

  static DateTime _nextMonthly(DateTime source, DateTime now) {
    var occurrence = _clampedDateTime(
      now.year,
      now.month,
      source.day,
      source.hour,
      source.minute,
      source.second,
      source.millisecond,
      source.microsecond,
    );
    if (occurrence.isBefore(now)) {
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      occurrence = _clampedDateTime(
        nextYear,
        nextMonth,
        source.day,
        source.hour,
        source.minute,
        source.second,
        source.millisecond,
        source.microsecond,
      );
    }
    return occurrence;
  }

  static DateTime _clampedDateTime(
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
  ) {
    final safeDay = day.clamp(1, DateUtils.getDaysInMonth(year, month));
    return DateTime(
      year,
      month,
      safeDay,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
