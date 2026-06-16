abstract final class ConditionConstants {
  static const List<String> conditionTypes = [
    'PCOS',
    'Endometriosis',
    'PMDD',
    'Adenomyosis',
    'Fibroids',
    'Thyroid Disorders',
  ];

  static const List<String> pcosSymptoms = [
    'Irregular periods',
    'Excess hair growth',
    'Acne',
    'Weight gain',
    'Hair thinning',
    'Skin tags',
    'Darkened skin',
    'Oily skin',
    'Mood changes',
    'Fatigue',
  ];

  static const List<String> endometriosisSymptoms = [
    'Severe cramps',
    'Pain during sex',
    'Infertility',
    'Fatigue',
    'Painful bowel movements',
    'Painful urination',
    'Heavy bleeding',
    'Bleeding between periods',
    'Lower back pain',
    'Bloating',
  ];

  static const List<String> pmddSymptoms = [
    'Severe mood swings',
    'Depression',
    'Irritability',
    'Anxiety',
    'Panic attacks',
    'Difficulty concentrating',
    'Fatigue',
    'Insomnia',
    'Food cravings',
    'Breast tenderness',
    'Bloating',
    'Headaches',
  ];

  static const List<String> adenomyosisSymptoms = [
    'Heavy menstrual bleeding',
    'Severe cramping',
    'Chronic pelvic pain',
    'Bloating',
    'Pain during intercourse',
    'Passing blood clots',
    'Prolonged periods',
  ];

  static const List<String> fibroidsSymptoms = [
    'Heavy menstrual bleeding',
    'Long periods',
    'Pelvic pressure',
    'Frequent urination',
    'Back pain',
    'Constipation',
    'Enlarged lower abdomen',
  ];

  static const List<String> thyroidSymptoms = [
    'Fatigue',
    'Weight changes',
    'Temperature sensitivity',
    'Irregular periods',
    'Mood changes',
    'Heart rate changes',
    'Hair changes',
    'Sleep disturbances',
  ];

  static const Map<String, List<String>> conditionSymptoms = {
    'PCOS': pcosSymptoms,
    'Endometriosis': endometriosisSymptoms,
    'PMDD': pmddSymptoms,
    'Adenomyosis': adenomyosisSymptoms,
    'Fibroids': fibroidsSymptoms,
    'Thyroid Disorders': thyroidSymptoms,
  };

  static const Map<String, String> conditionDescriptions = {
    'PCOS': 'Polycystic Ovary Syndrome is a hormonal disorder causing enlarged ovaries with small cysts.',
    'Endometriosis': 'A disorder where tissue similar to the uterine lining grows outside the uterus.',
    'PMDD': 'Premenstrual Dysphoric Disorder is a severe form of premenstrual syndrome.',
    'Adenomyosis': 'A condition where the uterine lining grows into the muscular wall of the uterus.',
    'Fibroids': 'Noncancerous growths in the uterus that can cause heavy bleeding and pain.',
    'Thyroid Disorders': 'Conditions affecting the thyroid gland that can impact menstrual health.',
  };

  static const Map<String, String> conditionIcons = {
    'PCOS': 'pcos',
    'Endometriosis': 'endometriosis',
    'PMDD': 'pmdd',
    'Adenomyosis': 'adenomyosis',
    'Fibroids': 'fibroids',
    'Thyroid Disorders': 'thyroid',
  };
}
