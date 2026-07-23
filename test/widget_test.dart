import 'package:flutter_test/flutter_test.dart';
import 'package:return_clothing_tracker/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('calculates a return deadline', () {
      final purchaseDate = DateTime(2026, 7, 1);

      expect(
        AppDateUtils.calculateReturnDeadline(purchaseDate, 30),
        DateTime(2026, 7, 31),
      );
    });

    test('identifies dates on the same day', () {
      expect(
        AppDateUtils.isSameDay(
          DateTime(2026, 7, 23, 9),
          DateTime(2026, 7, 23, 18),
        ),
        isTrue,
      );
    });

    test('returns month names', () {
      expect(AppDateUtils.getMonthName(7), 'July');
      expect(AppDateUtils.getAbbreviatedMonthName(7), 'Jul');
    });
  });
}
