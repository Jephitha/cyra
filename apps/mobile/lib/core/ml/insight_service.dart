import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/core/ml/explanation_engine.dart';
import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/core/prediction/cycle_predictor.dart';
import 'package:cyra/core/prediction/ovulation_detector.dart';

part 'insight_service.g.dart';

@Riverpod(keepAlive: true)
CorrelationEngine correlationEngine(CorrelationEngineRef ref) =>
    CorrelationEngine();

@Riverpod(keepAlive: true)
ExplanationEngine explanationEngine(ExplanationEngineRef ref) =>
    ExplanationEngine();

@Riverpod(keepAlive: true)
CyclePredictor cyclePredictor(CyclePredictorRef ref) => CyclePredictor();

@Riverpod(keepAlive: true)
OvulationDetector ovulationDetector(OvulationDetectorRef ref) =>
    OvulationDetector();

@Riverpod(keepAlive: true)
HealthInsightsEngine healthInsightsEngine(HealthInsightsEngineRef ref) {
  return HealthInsightsEngine(
    ref.watch(correlationEngineProvider),
    ref.watch(explanationEngineProvider),
    ref.watch(cyclePredictorProvider),
    ref.watch(ovulationDetectorProvider),
  );
}
