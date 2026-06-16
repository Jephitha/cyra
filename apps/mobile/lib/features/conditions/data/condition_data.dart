import 'package:cyra/features/conditions/models/condition_models.dart';

class ConditionData {
  static const Map<String, ConditionInfo> conditions = {
    'pcos': ConditionInfo(
      id: 'pcos',
      name: 'PCOS',
      description: 'Polycystic Ovary Syndrome is a hormonal disorder causing enlarged ovaries with small cysts. It affects 1 in 10 women of childbearing age.',
      commonSymptoms: ['Irregular or absent periods', 'Excess hair growth (hirsutism)', 'Acne', 'Weight gain or difficulty losing weight', 'Hair thinning on scalp', 'Difficulty conceiving'],
      trackingRecommendations: ['Track cycle length and regularity', 'Log weight changes', 'Monitor acne and hair growth', 'Track insulin-related symptoms', 'Note any ovulation signs'],
      managementTips: 'Regular exercise (150 min/week moderate activity), balanced diet with low glycemic index foods, stress management, and adequate sleep can help manage PCOS symptoms.',
      whenToSeeDoctor: 'If you have irregular periods, difficulty conceiving, or signs of excess androgen (facial hair, severe acne, hair thinning).',
      prevalenceInfo: 'Affects 6-12% of women of reproductive age worldwide.',
      isVisible: true,
    ),
    'endometriosis': ConditionInfo(
      id: 'endometriosis',
      name: 'Endometriosis',
      description: 'A condition where tissue similar to the uterine lining grows outside the uterus, causing pain and potential fertility issues. Affects approximately 1 in 10 women.',
      commonSymptoms: ['Severe menstrual cramps', 'Chronic pelvic pain', 'Pain during or after sex', 'Painful bowel movements or urination', 'Heavy menstrual bleeding', 'Fatigue', 'Infertility'],
      trackingRecommendations: ['Track pain levels daily (0-10 scale)', 'Log pain location and type', 'Monitor menstrual flow intensity', 'Track GI symptoms', 'Note fatigue levels'],
      managementTips: 'Heat therapy, gentle exercise like walking or yoga, anti-inflammatory diet, and adequate rest during flare-ups. Keep a symptom diary to identify triggers.',
      whenToSeeDoctor: 'If you experience severe pain that interferes with daily life, pain during sex, or difficulty conceiving.',
      prevalenceInfo: 'Affects about 1 in 10 women of reproductive age globally.',
      isVisible: true,
    ),
    'pmdd': ConditionInfo(
      id: 'pmdd',
      name: 'PMDD',
      description: 'Premenstrual Dysphoric Disorder is a severe form of PMS causing significant emotional and physical symptoms in the luteal phase of the menstrual cycle.',
      commonSymptoms: ['Severe mood swings', 'Irritability or anger', 'Depression or hopelessness', 'Anxiety or tension', 'Fatigue and low energy', 'Sleep disturbances', 'Physical symptoms: bloating, breast tenderness'],
      trackingRecommendations: ['Track mood daily (1-5 scale)', 'Log emotional symptoms in luteal phase', 'Monitor sleep quality', 'Note physical symptoms', 'Track symptom onset and resolution relative to period'],
      managementTips: 'Track symptoms for at least 2-3 cycles to confirm pattern. SSRI medications can be effective. Cognitive behavioral therapy, regular exercise, and stress reduction techniques may help.',
      whenToSeeDoctor: 'If you experience severe mood symptoms that interfere with relationships, work, or daily functioning in the week before your period.',
      prevalenceInfo: 'Affects 3-8% of women of reproductive age.',
      isVisible: true,
    ),
    'adenomyosis': ConditionInfo(
      id: 'adenomyosis',
      name: 'Adenomyosis',
      description: 'A condition where the endometrial tissue grows into the muscular wall of the uterus, causing an enlarged uterus and heavy, painful periods.',
      commonSymptoms: ['Heavy or prolonged menstrual bleeding', 'Severe cramping or sharp pelvic pain', 'Chronic pelvic pain', 'Pain during sex', 'Enlarged uterus', 'Bloating or abdominal pressure'],
      trackingRecommendations: ['Track menstrual flow intensity and duration', 'Log pain levels', 'Monitor bleeding pattern changes', 'Note any new symptoms'],
      managementTips: 'Anti-inflammatory medications, heat therapy, gentle exercise. Treatment options include hormonal therapies and in severe cases, surgery.',
      whenToSeeDoctor: 'If you have increasingly heavy or painful periods that affect your quality of life.',
      isVisible: true,
    ),
    'fibroids': ConditionInfo(
      id: 'fibroids',
      name: 'Uterine Fibroids',
      description: 'Non-cancerous growths in the uterus that often appear during childbearing years. They vary in size and can cause symptoms depending on their location and size.',
      commonSymptoms: ['Heavy menstrual bleeding', 'Long periods (7+ days)', 'Pelvic pressure or pain', 'Frequent urination', 'Difficulty emptying bladder', 'Constipation', 'Back or leg pain'],
      trackingRecommendations: ['Track period length and flow intensity', 'Monitor pain and pressure symptoms', 'Log urinary and GI symptoms', 'Note any changes over time'],
      managementTips: 'Monitor symptoms over time. Treatment options include medications to manage symptoms and procedures to remove fibroids. Fibroids often shrink after menopause.',
      whenToSeeDoctor: 'If you have heavy bleeding, severe pain, anemia symptoms (fatigue, weakness), or if fibroids affect your quality of life.',
      isVisible: true,
    ),
    'thyroid': ConditionInfo(
      id: 'thyroid',
      name: 'Thyroid Disorders',
      description: 'Thyroid disorders (hypothyroidism or hyperthyroidism) affect the thyroid gland and can significantly impact menstrual cycles, fertility, and overall health.',
      commonSymptoms: ['Hypothyroidism: fatigue, weight gain, cold sensitivity, heavy periods', 'Hyperthyroidism: weight loss, rapid heartbeat, heat sensitivity, light or missed periods', 'Both: menstrual irregularities, fertility issues', 'Mood changes', 'Energy fluctuations'],
      trackingRecommendations: ['Track cycle regularity and flow', 'Monitor energy levels', 'Log weight changes', 'Track mood and anxiety', 'Note any medication changes'],
      managementTips: 'Work with your doctor to maintain optimal thyroid levels. Take medication as prescribed. Regular blood tests to monitor TSH levels are important.',
      whenToSeeDoctor: 'If you have unexplained fatigue, weight changes, menstrual irregularities, or a family history of thyroid disorders.',
      prevalenceInfo: 'Affects approximately 5% of the population, with higher prevalence in women.',
      isVisible: true,
    ),
  };

  static ConditionInfo getCondition(String id) => conditions[id]!;
  static List<ConditionInfo> get allConditions => conditions.values.toList();
}
