import 'package:flutter_test/flutter_test.dart';

import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/core/ml/explanation_engine.dart';
import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/core/prediction/cycle_predictor.dart';
import 'package:cyra/core/prediction/ovulation_detector.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';

void main() {
  test('synced sleep and HRV become honest dashboard context', () async {
    final engine = HealthInsightsEngine(
      CorrelationEngine(),
      ExplanationEngine(),
      CyclePredictor(),
      OvulationDetector(),
    );

    final result = await engine.generateDashboardInsights(
      cycles: const [],
      recentDays: const [],
      bbtRecords: const [],
      symptoms: const [],
      wearableSummary: const WearableDataSummary(
        averageTemperature: 36.5,
        averageHeartRate: 62,
        averageSleepHours: 6.8,
        averageHrv: 44,
        stepCount: 0,
        dataPointCount: 20,
      ),
      currentDate: DateTime(2026, 7, 13),
    );

    expect(result.healthTips, hasLength(2));
    expect(result.healthTips!.first, contains('synced sleep'));
    expect(result.healthTips!.last, contains('own baseline'));
  });

  test('wearable point preserves source identity through JSON', () {
    final point = WearableDataPoint(
      timestamp: DateTime(2026, 7, 13, 7),
      value: 36.6,
      type: 'temperature',
      source: 'Example wearable',
      externalId: 'health-record-1',
    );

    final restored = WearableDataPoint.fromJson(point.toJson());

    expect(restored.externalId, 'health-record-1');
    expect(restored.source, 'Example wearable');
  });
}
