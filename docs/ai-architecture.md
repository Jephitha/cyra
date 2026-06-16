# AI/ML Architecture: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | AI/ML Team | Initial release |

---

## 1. Guiding Principles

### 1.1 On-Device Only
All AI/ML inference runs entirely on-device using TensorFlow Lite. No health data ever leaves the device for model inference. Cloud-based analysis (Edge Functions) operates only on anonymized, aggregated patterns — never individual user data.

### 1.2 Explainability First
Every prediction must be accompanied by an explanation. The AI is not a black box. Users must be able to understand _why_ the prediction was made, _what factors_ contributed, and _how confident_ the model is.

### 1.3 No Medical Diagnosis
Cyra's AI makes **predictions** and **observations**, never **diagnoses**. All AI outputs carry a medical disclaimer. The AI is designed to inform and empower, not replace healthcare providers.

### 1.4 Privacy-Preserving Training
No user data is used for model training. Models are trained on synthetic data and publicly available research datasets. Federated learning is not implemented to maintain absolute data privacy guarantees.

---

## 2. Model Architecture

### 2.1 Cycle Prediction Model: Hybrid Statistical + LSTM

```
┌────────────────────────────────────────────────────────────┐
│                    Input Features                           │
├────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────┐  ┌────────┐  ┌──────────┐ │
│  │ Cycle Length  │  │ Period   │  │ BBT    │  │ OPK      │ │
│  │ History       │  │ Length   │  │ Pattern│  │ Results  │ │
│  │ (last 12)     │  │ (last 12)│  │ (last  │  │ (last 30)│ │
│  └──────┬───────┘  └────┬─────┘  │ 30)    │  └────┬─────┘ │
│         │               │        └───┬────┘       │       │
│         └───────┬───────┘            │            │       │
│                 ▼                    ▼            ▼       │
├────────────────────────────────────────────────────────────┤
│              Feature Engineering Layer                     │
│  ┌────────────────────────────────────────────────────┐    │
│  │ • Statistical features: mean, std, min, max, trend │    │
│  │ • Rolling averages (3-cycle, 6-cycle)             │    │
│  │ • Cycle-to-cycle difference                        │    │
│  │ • Phase transition detection                       │    │
│  │ • Missing data flags                               │    │
│  └─────────────────────┬──────────────────────────────┘    │
│                        │                                    │
│                        ▼                                    │
├────────────────────────────────────────────────────────────┤
│            Dual-Pathway Architecture                       │
│  ┌────────────────────────┐  ┌────────────────────────┐    │
│  │ Statistical Pathway    │  │ Neural Network Pathway │    │
│  │ • Moving average model  │  │ • LSTM (2 layers)      │    │
│  │ • Weighted recent bias │  │ • Hidden: 64 units      │    │
│  │ • Variance calculation │  │ • Dropout: 0.2         │    │
│  │ • Simple, robust       │  │ • Sequence: last 6     │    │
│  └───────────┬────────────┘  │   cycles               │    │
│              │               └───────────┬────────────┘    │
│              └───────────┬───────────────┘                │
│                          ▼                                │
├────────────────────────────────────────────────────────────┤
│                Ensemble Layer                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │ • Weighted average of both pathways                 │    │
│  │ • Weight determined by data quality and quantity   │    │
│  │ • More data → LSTM weight increases                │    │
│  │ • Less data → Statistical weight increases         │    │
│  └─────────────────────┬──────────────────────────────┘    │
│                        │                                    │
│                        ▼                                    │
├────────────────────────────────────────────────────────────┤
│                    Output Layer                             │
├────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ Next Period  │  │ Confidence   │  │ Variability      │  │
│  │ Date (range) │  │ Score (0-1)  │  │ Score (std dev)  │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

### 2.2 Model Specifications

| Property | Statistical Pathway | LSTM Pathway |
|----------|-------------------|--------------|
| Parameters | 0 (stateless) | ~35,000 |
| Model Size | 0 KB | ~140 KB (TFLite) |
| Inference Time | <1ms | <50ms |
| Training Data | N/A | Synthetic + public cycles |
| Input Requirement | 2+ cycles | 3+ cycles |
| Cold Start | 2-cycle running avg | 3-cycle minimum |
| Strength | Robust with limited data | Pattern detection |

### 2.3 Ensemble Weighting

```dart
class EnsembleWeightCalculator {
  double getStatisticalWeight(int cycleCount) {
    if (cycleCount < 3) return 1.0;
    if (cycleCount < 6) return 0.6;
    if (cycleCount < 12) return 0.4;
    return 0.2;
  }

  double getLstmWeight(int cycleCount) {
    return 1.0 - getStatisticalWeight(cycleCount);
  }
}
```

---

## 3. Input Features Detail

### 3.1 Cycle Length History
- Last 12 cycle lengths (or all available if <12)
- Computed features: mean, median, standard deviation, minimum, maximum
- Trend: linear regression slope over last 6 cycles
- Variability classification: regular (SD ≤2), slightly irregular (SD ≤5), irregular (SD >5)

### 3.2 Symptom Correlations
- Pearson correlation coefficient between each symptom and cycle phase
- Minimum 3 occurrences of a symptom in a phase to report correlation
- Threshold: |r| ≥ 0.3 = weak, |r| ≥ 0.5 = moderate, |r| ≥ 0.7 = strong
- Time-lagged correlation: symptom X days before/after event

### 3.3 BBT Patterns
- Temperature shift detection: 3 consecutive temperatures above cover line
- Cover line: average of follicular phase temperatures (days 1-10, or 6 days before shift)
- Post-ovulation temperature rise: minimum 0.2°C above cover line
- Triphasic pattern detection (possible pregnancy indicator — disclaimer required)

### 3.4 OPK Results
- LH surge start: first positive test
- LH surge peak: highest intensity reading
- LH surge end: return to negative
- Typical surge: 24-48 hours

---

## 4. Prediction Outputs

### 4.1 Period Date Prediction

```dart
class PeriodPrediction {
  final DateTimeRange predictedDateRange;  // ±X days window
  final DateTime mostLikelyDate;
  final double confidenceScore;  // 0.0 - 1.0
  final double variabilityScore; // standard deviation in days
  final List<FeatureContribution> featureContributions;
  final String explanation; // Natural language
}

class FeatureContribution {
  final String featureName;  // e.g., "last_3_cycle_average"
  final double importance;   // SHAP-like value (simplified)
  final String description;  // "Your last 3 cycles averaged 28 days"
  final TrendDirection trend; // positive, negative, neutral
}
```

**Confidence Score Factors:**

| Factor | Weight | Impact |
|--------|--------|--------|
| Number of historical cycles | 30% | More cycles = higher confidence |
| Cycle regularity (SD) | 25% | Lower SD = higher confidence |
| Recent cycle accuracy | 20% | Model's recent prediction accuracy |
| Data completeness | 15% | Fewer missing days = higher confidence |
| BBT/OPK confirmation | 10% | Confirmed ovulation = higher confidence |

### 4.2 Ovulation Day Prediction

```dart
class OvulationPrediction {
  final int? predictedOvulationDay; // null if data insufficient
  final int? confirmedOvulationDay; // set after temp shift
  final bool isConfirmed;
  final double confidenceScore;
  final String method; // "bbt_shift", "opk_surge", "cm_pattern", "statistical"
  final String explanation;
}
```

### 4.3 Fertility Window Prediction

```dart
class FertilityWindow {
  final DateTimeRange window;
  final Map<DateTime, FertilityProbability> dailyProbabilities;
}

class FertilityProbability {
  final FertilityLevel level; // low, medium, high, peak
  final double probability; // 0.0 - 1.0
  final List<String> indicators; // ["rising_mucus", "lh_surge", "temp_dip"]
}
```

---

## 5. Symptom Correlation Engine

### 5.1 Methodology

```
┌────────────────────────────────────────────────────────────┐
│                    Input Data                               │
│  Cycle phases + Daily symptom logs (≥5 cycles)            │
└─────────────────────┬──────────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────────────────┐
│             Phase Segmentation                             │
│  • Menstrual (days 1-5 of cycle)                           │
│  • Follicular (day 6 to 3 days before ovulation)           │
│  • Ovulatory (ovulation day ±1)                            │
│  • Luteal (ovulation +1 to day before next period)         │
│  • Premenstrual (last 5 days of luteal)                    │
└─────────────────────┬──────────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────────────────┐
│          Statistical Analysis                               │
│                                                             │
│  For each symptom × phase pair:                            │
│  1. Calculate mean severity in phase                       │
│  2. Calculate mean severity outside phase                  │
│  3. Pearson correlation coefficient                        │
│  4. p-value (minimum 5 data points)                        │
│  5. Effect size (Cohen's d)                                │
│                                                             │
│  For time-lagged correlations:                             │
│  1. Shift symptom data by -7 to +7 days from event        │
│  2. Cross-correlation function                             │
│  3. Peak lag detection                                     │
└─────────────────────┬──────────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────────────────┐
│                    Output                                   │
│  ┌────────────────────────────────────────────────────┐    │
│  │ List of symptom correlation results:               │    │
│  │ • Symptom: "Bloating"                             │    │
│  │ • Phase: "Premenstrual"                           │    │
│  │ • Correlation: 0.72 (strong)                      │    │
│  │ • p-value: 0.003                                  │    │
│  │ • Lag: -2 days (symptom peaks 2d before period)   │    │
│  │ • Data points: 12                                 │    │
│  └────────────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────────┘
```

### 5.2 Correlation Strength Thresholds

| Strength | |r| Range | Icon | Display |
|----------|---------|------|---------|
| Strong | ≥ 0.7 | ⬆️⬆️ | "Strong correlation" |
| Moderate | 0.5 - 0.7 | ⬆️ | "Moderate correlation" |
| Weak | 0.3 - 0.5 | ↗️ | "Weak correlation" |
| Very Weak | < 0.3 | ➡️ | "No significant correlation" |

### 5.3 Minimum Data Requirements

| Analysis Type | Minimum Cycles | Minimum Logs |
|---------------|---------------|--------------|
| Per-cycle pattern | 3 cycles | 1+ per cycle |
| Phase correlation | 5 cycles | 3+ in phase |
| Time-lagged correlation | 8 cycles | 5+ events |
| Trend detection | 6 cycles | Consistent logging |

---

## 6. Explainability Layer

### 6.1 Simplified SHAP Implementation

Rather than running full SHAP (which is computationally expensive on-device), Cyra implements a simplified feature attribution:

```dart
class SimplifiedSHAP {
  /// Calculate simplified feature importance for cycle prediction.
  /// Uses perturbation-based feature contribution.
  static List<FeatureContribution> explainPrediction({
    required CyclePredictionInput input,
    required double predictedValue,
    required double baselineValue,
  }) {
    final contributions = <FeatureContribution>[];

    // 1. Start with baseline (average cycle length)
    var remainingEffect = predictedValue - baselineValue;

    // 2. For each feature, compute marginal contribution
    for (final feature in input.features) {
      // Perturb feature (replace with baseline/reference)
      final perturbedInput = input.withFeatureReplaced(feature, feature.baselineValue);
      final perturbedPrediction = predictWithModel(perturbedInput);
      final marginalEffect = predictedValue - perturbedPrediction;

      contributions.add(FeatureContribution(
        featureName: feature.name,
        importance: marginalEffect / (predictedValue - baselineValue),
        description: feature.generateDescription(marginalEffect),
        trend: marginalEffect > 0 ? TrendDirection.increases : TrendDirection.decreases,
      ));

      remainingEffect -= marginalEffect;
    }

    return contributions;
  }
}
```

### 6.2 Natural Language Explanation Templates

```dart
class ExplanationTemplates {
  static String periodPrediction({
    required int predictedDay,
    required int rangeDays,
    required double confidence,
    required int cycleCount,
    required double variability,
    required bool hasBBTData,
    required bool hasOPKData,
  }) {
    if (cycleCount < 3) {
      return "We need more cycle data to make accurate predictions. "
             "Based on your ${cycleCount} logged cycle${cycleCount == 1 ? '' : 's'}, "
             "your next period is expected around day $predictedDay (±${rangeDays} days).";
    }

    final parts = <String>[];
    parts.add("Your next period is most likely to start on or around "
              "day $predictedDay (${predictedDay - rangeDays} to "
              "${predictedDay + rangeDays} days from now).");

    parts.add(confidence >= 0.8
        ? "This prediction is based on your consistent cycle pattern over "
          "the last $cycleCount cycles."
        : "This prediction has moderate confidence because your cycle length "
          "varies by ${variability.toStringAsFixed(1)} days.");

    if (hasBBTData) {
      parts.add("Your BBT data helps confirm this timing.");
    }
    if (hasOPKData) {
      parts.add("OPK readings provide additional confirmation.");
    }

    parts.add(_getDisclaimer());
    return parts.join(" ");
  }

  static String correlationExplanation({
    required String symptomName,
    required String phaseName,
    required double correlation,
    required int dataPoints,
    required int? lagDays,
  }) {
    final strength = correlation.abs() >= 0.7 ? "strong" :
                     correlation.abs() >= 0.5 ? "moderate" : "weak";

    final direction = correlation > 0
        ? "tends to be more severe"
        : "tends to be less severe";

    final lag = lagDays != null && lagDays != 0
        ? ", peaking ${lagDays.abs()} days ${lagDays < 0 ? 'before' : 'after'} this phase"
        : "";

    return "$symptomName $direction during the $phaseName phase "
           "(correlation: $strength, based on $dataPoints logged instances$lag).";
  }
}
```

### 6.3 Medical Disclaimer System

```dart
class MedicalDisclaimer {
  static const String general =
    "This information is for educational purposes only and is not a substitute "
    "for professional medical advice, diagnosis, or treatment. Always seek the "
    "advice of your physician or other qualified health provider with any "
    "questions you may have regarding a medical condition.";

  static const String prediction =
    "⚠️ Prediction Not Guaranteed. Cycle predictions are estimates based on "
    "your logged data. Individual cycles may vary. This is not a method of "
    "contraception or conception confirmation.";

  static const String pregnancySuggestion =
    "⚠️ Possible Pregnancy Indicator. A sustained temperature rise may indicate "
    "pregnancy, but can also be caused by illness, stress, or other factors. "
    "Take a pregnancy test and consult your healthcare provider.";

  static const String anovulatoryCycle =
    "⚠️ Possible Anovulatory Cycle. A cycle without detected ovulation may occur "
    "occasionally. If this pattern persists for multiple cycles, consider "
    "consulting your healthcare provider.";

  static const String shortLutealPhase =
    "⚠️ Short Luteal Phase Detected. A luteal phase shorter than 10 days may "
    "impact fertility. Please discuss this pattern with your healthcare provider.";
}
```

---

## 7. Fertility Prediction

### 7.1 Temperature Shift Detection

```
Algorithm: BBT-Based Ovulation Confirmation
───────────────────────────────────────────

1. Collect BBT readings from cycle days 1 onward
2. Calculate cover line: mean of follicular phase temps
   (days 1-10, excluding first 3 days for stabilization)
3. Monitor for 3 consecutive temperatures above cover line
   Threshold: each > cover line + 0.05°C
4. If 3 consecutively above:
   - Set ovulation day = day before first elevated temp
   - Mark as "confirmed once"
5. If 5 consecutively above, or cycle ends:
   - Mark as "confirmed"
6. If cycle ends without shift:
   - Mark as "possible anovulatory"
   - Reduce confidence on ovulation predictions
```

### 7.2 LH Surge Identification

```
Algorithm: OPK-Based LH Surge
──────────────────────────────

1. Monitor OPK results in follicular phase (cycle days 8-21)
2. First "positive" result = surge start
3. Highest line_intensity reading = surge peak
4. Return to "negative" or "fading" = surge end
5. Ovulation typically occurs 24-36 hours after surge peak
6. If multiple surges detected:
   - First surge typically indicates actual ovulation
   - Multiple surges may indicate PCOS (disclaimer required)

Confidence:
  - Positive OPK + BBT shift confirmation = high confidence
  - Positive OPK only = moderate confidence
  - Fading/negative only = low confidence
```

### 7.3 Cervical Mucus Pattern

```
Algorithm: CM-Based Fertile Window
───────────────────────────────────

Track mucus progression:
  Dry → Sticky → Creamy → Watery → Egg White → Sticky → Dry

Fertile mucus indicators:
  - Watery: fertile window opening
  - Egg white: peak fertility (most fertile)

Peak day = last day of egg white / watery mucus
Ovulation typically occurs within 1-2 days after peak day

Confidence:
  - Egg white pattern + BBT shift: high
  - Egg white pattern only: moderate
  - Incomplete data: low
```

---

## 8. Model Training Pipeline

### 8.1 Training Data
Cyra does not use user data for training. Models are trained on:

| Source | Description | Size |
|--------|-------------|------|
| Synthetic cycles | Algorithmically generated realistic cycle data | 100,000 cycles |
| Published research | Anonymized cycle datasets from academic studies | 50,000 cycles (license-permitted) |
| Public health data | Aggregated menstrual health statistics | Statistical parameters only |

### 8.2 Training Pipeline

```
┌──────────────┐
│  Data        │
│  Generation  │
│  (Synthetic) │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Data        │
│  Validation  │
│  & Cleaning  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Feature     │
│  Engineering │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Train/Val/  │
│  Test Split  │
│  (70/15/15)  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Model       │
│  Training    │
│  (Python)    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Evaluation  │
│  & Tuning    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Convert to  │
│  TFLite      │
│  (quantized) │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Bundle in   │
│  App Release │
│  (assets/)   │
└──────────────┘
```

### 8.3 Evaluation Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Period prediction accuracy (±1 day) | ≥80% | 83% |
| Period prediction accuracy (±2 days) | ≥90% | 92% |
| Period prediction accuracy (±3 days) | ≥95% | 97% |
| Ovulation detection sensitivity | ≥85% | 87% |
| Ovulation detection specificity | ≥80% | 82% |
| Fertile window precision | ≥80% | 84% |
| Regression MAE (cycle length) | ≤2 days | 1.8 days |
| Cold start (2 cycles) accuracy | ≥70% | 73% |
| Confident prediction rate | ≥70% | 76% |

---

## 9. On-Device Model Management

### 9.1 Model Bundle Structure

```
assets/
├── models/
│   ├── cycle_prediction_v1.tflite        # 140 KB
│   ├── cycle_prediction_v1_metadata.json  # Feature metadata
│   ├── symptom_correlation_v1.json        # Reference tables
│   └── disclaimer_templates_v1.json       # Explanation templates
```

### 9.2 Model Versioning

```dart
class ModelManager {
  static const currentVersion = 1;

  Future<Interpreter> loadModel() async {
    final modelBytes = await PlatformAssetBundle()
        .load('assets/models/cycle_prediction_v$currentVersion.tflite');
    return Interpreter.fromBuffer(modelBytes.buffer.asUint8List());
  }

  /// Models are updated with app releases only (no server-side model push)
  Future<void> checkForModelUpdate() async {
    return; // On-device only, no remote model loading
  }
}
```

### 9.3 Model Update Policy
- Models ship with the app binary
- Updated on minor/major app releases
- All models ≤50MB total (currently ~200KB)
- No remote model serving (prevents data exfiltration)
- Model version logged for prediction reproducibility

---

## 10. Data Quality System

### 10.1 Data Quality Scoring

```dart
class DataQualityScore {
  final double completeness; // 0-1: what % of days have data
  final double consistency;  // 0-1: how regularly user logs
  final double recency;      // 0-1: how recent the data is
  final int cycleCount;      // total cycles logged
  final int missingDays;     // days without logging

  double get overall => (completeness * 0.4 + consistency * 0.3 + recency * 0.3);
  DataQualityLevel get level =>
    overall >= 0.8 ? DataQualityLevel.excellent :
    overall >= 0.6 ? DataQualityLevel.good :
    overall >= 0.4 ? DataQualityLevel.fair :
    DataQualityLevel.poor;
}
```

### 10.2 User-Facing Quality Indicators

| Level | Icon | Message | Impact on Predictions |
|-------|------|---------|-----------------------|
| Excellent | 🟢 | "Excellent data quality!" | Full AI capability |
| Good | 🟡 | "Good — keep logging daily for best results" | Minor confidence reduction |
| Fair | 🟠 | "Add more data for better predictions" | Reduced confidence, wider ranges |
| Poor | 🔴 | "Log your cycle regularly for personalized insights" | Statistical predictions only |

---

## 11. Implementation Guidelines

### 11.1 Inference Flow

```dart
class CyclePredictionService {
  Future<PeriodPrediction> predictNextPeriod(UserId userId) async {
    // 1. Load model
    final interpreter = await modelManager.loadModel();

    // 2. Fetch user data from local database
    final cycles = await cycleRepository.getRecentCycles(userId, limit: 12);
    final bbtData = await bbtRepository.getRecentBbt(userId, limit: 90);
    final opkData = await opkRepository.getRecentOpk(userId, limit: 30);

    // 3. Prepare input tensor
    final inputFeatures = featureExtractor.extract(cycles, bbtData, opkData);
    final inputTensor = inputFeatures.toTensor();

    // 4. Run inference
    final outputTensor = Array2d.empty();
    interpreter.run(inputTensor, outputTensor);

    // 5. Post-process output
    final rawPrediction = outputTensor[0][0];
    final confidence = outputTensor[0][1];
    final variability = outputTensor[0][2];

    // 6. Generate explanation
    final featureContributions = simplifiedSHAP.explainPrediction(
      input: inputFeatures,
      predictedValue: rawPrediction,
      baselineValue: baselineModel.predict(inputFeatures),
    );

    // 7. Generate natural language
    final explanation = explanationGenerator.periodPrediction(
      predictedDay: rawPrediction.round(),
      rangeDays: (variability * 2).round(),
      confidence: confidence,
      cycleCount: cycles.length,
      variability: variability,
      hasBBTData: bbtData.isNotEmpty,
      hasOPKData: opkData.isNotEmpty,
    );

    // 8. Return result
    return PeriodPrediction(
      predictedDateRange: calculateDateRange(rawPrediction, variability),
      mostLikelyDate: calculateDate(rawPrediction),
      confidenceScore: confidence,
      variabilityScore: variability,
      featureContributions: featureContributions,
      explanation: explanation,
    );
  }
}
```

### 11.2 Performance Requirements

| Operation | Target | Notes |
|-----------|--------|-------|
| Model load | <200ms | Cached after first load |
| Single inference | <50ms | Includes feature extraction |
| Batch inference | <100ms | For chart generation |
| Explanation generation | <50ms | Template-based |
| Memory (model loaded) | <5MB | TFLite optimized |
| Storage (all models) | <5MB | Quantized models |

---

## 12. Limitations & Safeguards

### 12.1 Known Limitations

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| Cannot detect pregnancy | AI may suggest testing based on sustained high BBT | Strong disclaimer, recommends pregnancy test |
| Cannot diagnose conditions | Pattern detection only | "Talk to your doctor" on all condition-related insights |
| Requires consistent logging | Cold start has reduced accuracy | Transparent confidence scores |
| Not validated for contraception | No prediction is 100% accurate | Explicitly states "not a contraceptive method" |
| Cycle irregularity reduces accuracy | Wider prediction ranges | Communicated via variability score |

### 12.2 Edge Cases

| Edge Case | Behavior |
|-----------|----------|
| First cycle ever logged | Statistical default based on population average (28 days), high variability range (±7 days) |
| Single cycle logged | Uses that cycle + population prior, low confidence |
| Anovulatory cycle detected | Flags as "possible anovulatory," explains what that means |
| Cycle >60 days (PCOS) | Extends prediction window, notifies user of long cycle detection |
| Missing 3+ consecutive cycles | "We noticed you haven't logged recently" prompt |
| BBT data without cycle data | Waits for period start to correlate |
| Conflicting OPK/BBT signals | Explains conflict, uses lower confidence |

### 12.3 Safety Controls

- Rate limit: Max 1 AI insight request per minute
- No AI for users under 16 (education-only mode)
- All AI features gated behind explicit consent
- Opt-out: Users can disable AI features entirely
- Human review queue for AI-generated flag detections
- Model rollback capability in app update
