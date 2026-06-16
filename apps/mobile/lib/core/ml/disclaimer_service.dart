import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/features/fertility/models/fertility_models.dart';

class DisclaimerService {
  String getDisclaimer(InsightTopic topic) {
    switch (topic) {
      case InsightTopic.periodPrediction:
        return 'Period predictions are based on your logged cycle data and '
            'may not be accurate for irregular cycles, during significant '
            'lifestyle changes, or when starting or stopping hormonal contraception. '
            'This information is for personal tracking purposes only and is '
            'not a diagnostic tool.';

      case InsightTopic.ovulationDetection:
        return 'Ovulation detection is based on temperature patterns, '
            'OPK test results, and cervical mucus observations you log. '
            'This information is for educational and personal tracking purposes '
            'only. It is not a reliable method of contraception and should not '
            'be used as a primary method for avoiding pregnancy. If you are '
            'trying to conceive, this information can help identify your '
            'fertile window but does not guarantee pregnancy.';

      case InsightTopic.symptomCorrelation:
        return 'Symptom correlations are statistical observations of your '
            'self-reported data. They identify patterns but do not indicate '
            'medical conditions or replace clinical diagnosis. If you '
            'experience concerning or persistent symptoms, consult a '
            'healthcare provider.';

      case InsightTopic.cycleRegularity:
        return 'Cycle regularity analysis is based on your logged cycle '
            'lengths. Variations can be normal and are influenced by many '
            'factors including stress, diet, exercise, and sleep. This '
            'information is for educational purposes and is not a medical '
            'assessment of reproductive health.';

      case InsightTopic.fertilityWindow:
        return 'Fertile window estimates use calendar-based calculations and '
            'your logged data. These estimates have inherent limitations and '
            'are not guaranteed to be accurate. No fertility tracking method '
            'is 100% effective for either achieving or avoiding pregnancy. '
            'Consult a healthcare provider for personalized family planning advice.';

      case InsightTopic.conceptionTips:
        return 'Conception information is based on general fertility research '
            'and your personal cycle data. Individual fertility varies widely. '
            'If you have been trying to conceive for over 12 months (or 6 months '
            'if over 35), consider consulting a fertility specialist.';

      case InsightTopic.pregnancyMilestone:
        return 'Pregnancy milestone information is for educational purposes and '
            'reflects general developmental timelines. Every pregnancy is unique. '
            'This information does not replace prenatal care or medical advice '
            'from your healthcare provider. Always consult your provider '
            'regarding your specific pregnancy.';
    }
  }

  bool requiresDisclaimer(InsightTopic topic) {
    return true;
  }

  String get fullMedicalDisclaimer => '''
The information provided by Cyra is for general informational purposes only. All content, including text, graphics, images, and data, is for educational and personal tracking purposes only.

Cyra is not a medical device and does not provide medical advice, diagnosis, or treatment. The application is designed to help you track and understand your personal health patterns and is not a substitute for professional medical judgment.

Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition, symptoms, or health objectives. Never disregard professional medical advice or delay in seeking it because of something you have read or observed in Cyra.

Cyra does not recommend or endorse any specific tests, physicians, products, procedures, opinions, or other information that may be referenced within the application. Reliance on any information provided by Cyra is solely at your own risk.

If you think you may have a medical emergency, call your doctor, go to the nearest hospital emergency department, or call emergency services immediately.
''';

  String? getModeDisclaimer(FertilityMode mode) {
    switch (mode) {
      case FertilityMode.avoidPregnancy:
        return 'Cyra provides fertility awareness information for educational '
            'purposes only and is not a birth control method. No app-based '
            'fertility tracking method is 100% effective for preventing '
            'pregnancy. Calendar-based methods alone have a typical-use '
            'failure rate of approximately 24%. For reliable contraception, '
            'consult a healthcare provider about options such as hormonal '
            'contraceptives, IUDs, or barrier methods.';

      case FertilityMode.tryingToConceive:
        return 'Cyra provides fertility information to help you understand '
            'your cycle and identify your fertile window. Regular intercourse '
            'during the fertile window maximizes chances of conception. If you '
            'have been trying to conceive for over 12 months (or 6 months if '
            'over 35), consider consulting a fertility specialist for a '
            'comprehensive evaluation.';

      case FertilityMode.notPlanning:
        return null;
    }
  }
}
