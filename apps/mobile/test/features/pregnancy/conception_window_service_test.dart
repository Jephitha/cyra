import 'package:flutter_test/flutter_test.dart';

import 'package:cyra/features/fertility/models/fertility_models.dart';
import 'package:cyra/features/pregnancy/services/conception_window_service.dart';

void main() {
  group('ConceptionWindowService', () {
    const service = ConceptionWindowService();

    test(
      'builds a bounded uncertainty window from unprotected sex activity',
      () {
        final estimate = service.estimateFromSexActivity(
          positiveTestOrToday: DateTime(2030, 6, 20),
          activity: [
            IntercourseLog(
              id: 'a',
              date: DateTime(2030, 6, 10, 22),
              unprotected: true,
            ),
            IntercourseLog(
              id: 'b',
              date: DateTime(2030, 6, 12, 9),
              unprotected: true,
            ),
          ],
        );

        expect(estimate, isNotNull);
        expect(estimate!.windowStart, DateTime(2030, 6, 5));
        expect(estimate.windowEnd, DateTime(2030, 6, 14));
        expect(estimate.supportingActivityDates, [
          DateTime(2030, 6, 10),
          DateTime(2030, 6, 12),
        ]);
        expect(estimate.copy, contains('estimate, not a confirmation'));
      },
    );

    test('ignores protected activity and dates outside the allowed window', () {
      final estimate = service.estimateFromSexActivity(
        positiveTestOrToday: DateTime(2030, 6, 20),
        activity: [
          IntercourseLog(
            id: 'protected',
            date: DateTime(2030, 6, 15),
            unprotected: false,
          ),
          IntercourseLog(
            id: 'old',
            date: DateTime(2030, 5, 1),
            unprotected: true,
          ),
        ],
      );

      expect(estimate, isNull);
    });
  });
}
