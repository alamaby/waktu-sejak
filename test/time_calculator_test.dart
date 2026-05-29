import 'package:flutter_test/flutter_test.dart';
import 'package:waktu_sejak/core/utils/time_calculator.dart';

void main() {
  group('TimeCalculator.calculate', () {
    test('returns zero diff when target equals now', () {
      final now = DateTime(2026, 5, 29, 12);

      final diff = TimeCalculator.calculate(now, now: now);

      expect(diff.isPast, isFalse);
      expect(diff.isZero, isTrue);
    });

    test('calculates past boundary within the same minute', () {
      final now = DateTime(2026, 5, 29, 12);
      final target = DateTime(2026, 5, 29, 11, 59, 30);

      final diff = TimeCalculator.calculate(target, now: now);

      expect(diff.isPast, isTrue);
      expectDiff(diff, seconds: 30);
    });

    test('calculates future boundary within the same minute', () {
      final now = DateTime(2026, 5, 29, 12);
      final target = DateTime(2026, 5, 29, 12, 0, 30);

      final diff = TimeCalculator.calculate(target, now: now);

      expect(diff.isPast, isFalse);
      expectDiff(diff, seconds: 30);
    });

    test('handles midnight rollover', () {
      final now = DateTime(2026, 5, 29, 23, 59, 30);
      final target = DateTime(2026, 5, 30, 0, 0, 15);

      final diff = TimeCalculator.calculate(target, now: now);

      expect(diff.isPast, isFalse);
      expectDiff(diff, seconds: 45);
    });

    test('handles leap year future dates', () {
      final now = DateTime(2024, 2, 28);
      final target = DateTime(2024, 2, 29);

      final diff = TimeCalculator.calculate(target, now: now);

      expect(diff.isPast, isFalse);
      expectDiff(diff, days: 1);
    });

    test('handles end-of-month dates', () {
      final now = DateTime(2024, 1, 31);
      final target = DateTime(2024, 2, 29);

      final diff = TimeCalculator.calculate(target, now: now);

      expect(diff.isPast, isFalse);
      expectDiff(diff, days: 29);
    });
  });
}

void expectDiff(
  TimeDiff diff, {
  int years = 0,
  int months = 0,
  int days = 0,
  int hours = 0,
  int minutes = 0,
  int seconds = 0,
}) {
  expect(diff.years, years);
  expect(diff.months, months);
  expect(diff.days, days);
  expect(diff.hours, hours);
  expect(diff.minutes, minutes);
  expect(diff.seconds, seconds);
}
