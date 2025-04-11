import 'package:app/core/utils/time_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatTimeAgo', () {
    test('returns "just now" if under a minute', () {
      final now = DateTime.now();
      final result = formatTimeAgo(now.subtract(const Duration(seconds: 30)));
      expect(result, 'just now');
    });

    test('returns minutes', () {
      final now = DateTime.now();
      final result = formatTimeAgo(now.subtract(const Duration(minutes: 3)));
      expect(result, '3m');
    });

    test('returns hours', () {
      final now = DateTime.now();
      final result = formatTimeAgo(now.subtract(const Duration(hours: 2)));
      expect(result, '2h');
    });

    test('returns days', () {
      final now = DateTime.now();
      final result = formatTimeAgo(now.subtract(const Duration(days: 5)));
      expect(result, '5d');
    });
  });

  group('formatFullDateTime', () {
    test('formats as dd/MM/yyyy h:mm a', () {
      final time = DateTime(2025, 12, 24, 9, 30);
      final result = formatFullDateTime(time);
      expect(result, '24/12/2025 9:30 AM');
    });
  });
}
