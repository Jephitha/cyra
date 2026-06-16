import 'package:cyra/features/education/models/education_models.dart';

class EducationContent {
  EducationContent._();

  static final List<ArticleCategory> categories = [
    ArticleCategory(
      id: 'menstrual_health',
      name: 'Menstrual Health',
      description: 'Understand your cycle, manage symptoms, and learn what\'s normal.',
      iconName: 'cycle',
      articleCount: articles.where((a) => a.category == 'menstrual_health').length,
    ),
    ArticleCategory(
      id: 'fertility',
      name: 'Fertility',
      description: 'Track ovulation, optimize conception timing, and understand fertility.',
      iconName: 'fertility',
      articleCount: articles.where((a) => a.category == 'fertility').length,
    ),
    ArticleCategory(
      id: 'pregnancy',
      name: 'Pregnancy',
      description: 'Guidance for every trimester, nutrition, and preparation.',
      iconName: 'baby',
      articleCount: articles.where((a) => a.category == 'pregnancy').length,
    ),
    ArticleCategory(
      id: 'nutrition',
      name: 'Nutrition',
      description: 'Eat to support your hormones and overall well-being.',
      iconName: 'food',
      articleCount: articles.where((a) => a.category == 'nutrition').length,
    ),
    ArticleCategory(
      id: 'hormonal_health',
      name: 'Hormonal Health',
      description: 'Learn how your hormones work and what affects them.',
      iconName: 'hormone',
      articleCount: articles.where((a) => a.category == 'hormonal_health').length,
    ),
    ArticleCategory(
      id: 'wellness',
      name: 'Wellness',
      description: 'Sleep, stress, exercise, and lifestyle for hormonal balance.',
      iconName: 'wellbeing',
      articleCount: articles.where((a) => a.category == 'wellness').length,
    ),
  ];

  static final List<Article> articles = [
    // ── Menstrual Health ────────────────────────────────────────────
    Article(
      id: 'menstrual_cycle_phases',
      title: 'Understanding Your Menstrual Cycle',
      category: 'menstrual_health',
      summary: 'Learn about the four phases of your menstrual cycle and the hormones that drive each one.',
      content: '''Your menstrual cycle is a carefully orchestrated series of hormonal events that prepares your body for pregnancy each month. While the average cycle is 28 days, cycles ranging from 21 to 35 days are considered normal.

The Menstrual Phase (Days 1-5)
This phase begins on the first day of bleeding. The uterine lining (endometrium) sheds because pregnancy did not occur in the previous cycle. Estrogen and progesterone levels are at their lowest. Prostaglandins, hormone-like compounds, trigger uterine contractions that help expel the lining — these same contractions can cause cramping.

The Follicular Phase (Days 1-13)
Overlapping with the menstrual phase, the follicular phase begins when the pituitary gland releases follicle-stimulating hormone (FSH). FSH stimulates several ovarian follicles to begin maturing. As follicles grow, they produce increasing amounts of estrogen, which signals the uterine lining to thicken in preparation for a potential pregnancy. Around day 10, estrogen levels surge, causing cervical mucus to become more abundant and elastic.

Ovulation (Around Day 14)
The estrogen surge triggers a rapid rise in luteinizing hormone (LH) — the LH surge. This surge causes the dominant follicle to release a mature egg approximately 36 hours later. Ovulation is the brief window when pregnancy is possible. The egg travels into the fallopian tube, where it can be fertilized for about 12-24 hours.

The Luteal Phase (Days 15-28)
After ovulation, the ruptured follicle transforms into the corpus luteum, which produces progesterone. Progesterone thickens the uterine lining further and maintains it for potential implantation. If fertilization does not occur, the corpus luteum breaks down after about 10-14 days, progesterone drops, and the cycle begins anew.

Tracking your cycle phases can help you understand your body's patterns, predict ovulation, and identify when something may be off. Variations in cycle length from month to month are common, especially during adolescence, perimenopause, or times of significant stress.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 3, 15),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 5,
      tags: ['cycle basics', 'hormones', 'ovulation', 'phases'],
      createdAt: DateTime(2026, 1, 10),
      updatedAt: DateTime(2026, 3, 15),
    ),
    Article(
      id: 'period_blood_color',
      title: 'What Your Period Blood Color Means',
      category: 'menstrual_health',
      summary: 'A clinical guide to understanding what different period blood colors indicate about your health.',
      content: '''Period blood can vary in color from bright red to dark brown, and sometimes even black, pink, or orange. These variations are typically normal and relate to how quickly blood is leaving your body and how long it has been exposed to oxygen.

Bright Red Blood
Fresh, bright red blood typically appears at the beginning or height of your period. It indicates active, steady flow leaving the body quickly before oxidation occurs. This is a sign of a healthy, normal period.

Dark Red or Brown Blood
Darker blood, often appearing at the end of your period or during lighter flow days, is older blood that has had more time to oxidize. The hemoglobin in the blood darkens as it reacts with oxygen. This is normal and common.

Black Blood
Blood that appears black is simply very old blood that has been in the uterus for an extended period. It may appear at the very beginning or end of your period. If accompanied by other symptoms like itching, odor, or discomfort, it is worth discussing with a healthcare provider to rule out infection.

Pink Blood
Pinkish blood can indicate lower estrogen levels or may appear when your blood mixes with cervical fluid, diluting the color. It can occur at the beginning or end of your period or in women using hormonal contraception.

Orange or Grey Blood
Orange blood or grey discharge warrants medical attention. Orange blood mixed with cervical fluid can suggest an infection, while grey discharge is often associated with bacterial vaginosis or other infections requiring treatment.

Clots
Small blood clots (smaller than a grape) are normal, especially on heavier flow days. The body produces anticoagulants to prevent clotting during menstruation, but on heavy days these may be overwhelmed. Clots larger than a grape should be discussed with a healthcare provider.

When to Consult a Healthcare Provider
While most color variations are normal, consult your provider if you experience: consistently grey or orange discharge, extremely heavy bleeding (soaking through a pad or tampon every 1-2 hours), clots larger than 2.5 cm, periods lasting more than 7 days, or severe pain that interferes with daily activities.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 2, 20),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 4,
      tags: ['period health', 'symptoms', 'what to watch for'],
      createdAt: DateTime(2026, 1, 15),
      updatedAt: DateTime(2026, 2, 20),
    ),
    Article(
      id: 'managing_period_pain',
      title: 'Managing Period Pain Naturally',
      category: 'menstrual_health',
      summary: 'Evidence-based approaches to managing menstrual cramps without medication.',
      content: '''Dysmenorrhea — the medical term for painful periods — affects up to 90% of menstruating women at some point in their lives. The pain is caused by prostaglandins, hormone-like compounds that trigger uterine contractions to shed the uterine lining.

Heat Therapy
Applying heat to the lower abdomen is one of the most effective non-pharmaceutical interventions. A 2018 Cochrane review found that heat therapy is comparable to ibuprofen for pain relief. Use a heating pad, hot water bottle, or warm bath for 15-20 minutes as needed.

Exercise
Moderate exercise increases blood flow and releases endorphins, which are natural pain relievers. A 2019 systematic review in BMC Women's Health found that aerobic exercise performed 3 times per week significantly reduced menstrual pain severity. Gentle yoga poses — particularly child's pose, cat-cow, and reclining bound angle — can be especially helpful.

Dietary Adjustments
Anti-inflammatory dietary choices may reduce cramping. Omega-3 fatty acids (found in fish, flaxseeds, and walnuts) have been shown to reduce prostaglandin production. Magnesium supplementation (200-400 mg daily) may help reduce muscle contraction intensity. Reducing salt intake can minimize water retention and bloating.

Acupuncture and Acupressure
A 2017 meta-analysis in PLoS One examined 42 studies and found that acupuncture significantly reduced menstrual pain compared to no treatment. Acupressure at the SP6 point (four finger-widths above the inner ankle) showed particular promise.

Essential Oils
Abdominal massage with essential oils may provide relief. A randomized controlled trial found that a blend of lavender, clary sage, and marjoram in almond oil reduced pain scores more than massage with almond oil alone. Always dilute essential oils in a carrier oil before applying to skin.

When Medical Treatment Is Needed
If natural approaches are insufficient, over-the-counter non-steroidal anti-inflammatory drugs (NSAIDs) like ibuprofen or naproxen are effective. These work by reducing prostaglandin production. For severe, persistent pain that does not respond to treatment, consult a healthcare provider to evaluate for underlying conditions such as endometriosis or fibroids.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 1),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 5,
      tags: ['pain management', 'cramps', 'natural remedies', 'dysmenorrhea'],
      createdAt: DateTime(2026, 2, 1),
      updatedAt: DateTime(2026, 4, 1),
    ),
    Article(
      id: 'irregular_periods',
      title: 'When Periods Are Irregular: Causes and When to Seek Help',
      category: 'menstrual_health',
      summary: 'Understand the common causes of irregular periods and learn when to consult a healthcare provider.',
      content: '''A normal menstrual cycle ranges from 21 to 35 days. Variations of a few days from month to month are common, but consistently irregular cycles — those that vary by more than 7-9 days — may signal an underlying condition.

Common Causes of Irregular Periods

Stress: Chronic stress elevates cortisol levels, which can suppress the hormones that regulate ovulation. This may delay or skip periods entirely.

Weight Changes: Significant weight loss (below 85% of ideal body weight) or rapid weight gain can disrupt hormone production. Fat cells produce estrogen, and dramatic changes in body fat percentage can alter the menstrual cycle.

Polycystic Ovary Syndrome (PCOS): PCOS affects 6-12% of women of reproductive age. It causes hormonal imbalances that lead to infrequent or absent ovulation, resulting in irregular or missed periods. Other symptoms may include acne, excess facial or body hair, and difficulty conceiving.

Thyroid Disorders: Both hyperthyroidism and hypothyroidism can affect menstrual regularity. Thyroid hormones interact with reproductive hormones, and even mild thyroid dysfunction can disrupt cycles.

Perimenopause: The transition to menopause, which typically begins in the mid-40s, can cause cycles to become shorter, longer, heavier, or lighter. This phase lasts an average of 4 years.

Exercise and Eating Disorders: Excessive exercise combined with inadequate caloric intake can lead to hypothalamic amenorrhea — the suppression of menstrual cycles. This is common among endurance athletes and those with restrictive eating patterns.

When to Seek Help

Consult a healthcare provider if you experience: no period for 3 months or more (amenorrhea), cycles consistently shorter than 21 days or longer than 35 days, sudden changes in cycle pattern, bleeding between periods, periods lasting more than 7 days, or severe pain that does not respond to over-the-counter treatment.

A healthcare provider may perform blood tests to check hormone levels, thyroid function, and prolactin, along with an ultrasound to evaluate the ovaries and uterus. Treatment depends on the underlying cause and may include lifestyle modifications, hormonal therapy, or treatment of the underlying condition.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 3, 10),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 5,
      tags: ['irregular cycles', 'PCOS', 'thyroid', 'when to see a doctor'],
      createdAt: DateTime(2026, 2, 15),
      updatedAt: DateTime(2026, 3, 10),
    ),

    // ── Fertility ───────────────────────────────────────────────────
    Article(
      id: 'fertile_window',
      title: 'Understanding Your Fertile Window',
      category: 'fertility',
      summary: 'Learn how to identify your fertile window using cycle tracking, cervical mucus, and other fertility signs.',
      content: '''The fertile window is the six-day span during each menstrual cycle when pregnancy is possible. It includes the five days before ovulation and the day of ovulation itself. Sperm can survive in the female reproductive tract for up to five days, but the egg remains viable for only 12-24 hours after release.

Timing Your Fertile Window

For someone with a regular 28-day cycle, ovulation typically occurs around day 14, making the fertile window approximately days 10-15. However, cycle lengths vary, and relying solely on calendar calculations can be imprecise.

Cervical Mucus Method

Cervical mucus changes predictably throughout the menstrual cycle. After menstruation, mucus is scant or absent. As estrogen rises during the follicular phase, mucus becomes increasingly abundant, clear, slippery, and stretchy — similar to raw egg whites. This "egg white" mucus appears 1-2 days before ovulation and is the most fertile-quality mucus. After ovulation, progesterone causes mucus to become thick, cloudy, and sticky again.

Basal Body Temperature (BBT)

Your basal body temperature rises 0.2-0.5°C (0.4-0.9°F) after ovulation due to increased progesterone. BBT charting involves taking your temperature at the same time each morning before getting out of bed. A sustained temperature shift confirms that ovulation has occurred, but BBT alone cannot predict ovulation in advance.

Ovulation Predictor Kits (OPKs)

OPKs detect the luteinizing hormone (LH) surge that occurs 24-36 hours before ovulation. Testing once daily in the afternoon or early evening is most effective. A positive OPK indicates that ovulation is likely to occur within the next day or two.

Combining Methods

Using multiple fertility awareness methods together — calendar tracking, cervical mucus observation, and BBT charting — provides the most accurate picture. Studies show that when used correctly, fertility awareness methods can be up to 98% effective for identifying the fertile window.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 3, 20),
      reviewAuthor: 'Dr. Elena Torres, MD, Reproductive Endocrinologist',
      readTimeMinutes: 5,
      tags: ['fertile window', 'ovulation', 'cervical mucus', 'fertility awareness'],
      createdAt: DateTime(2026, 1, 20),
      updatedAt: DateTime(2026, 3, 20),
    ),
    Article(
      id: 'basal_body_temperature',
      title: 'Basal Body Temperature: A Complete Guide',
      category: 'fertility',
      summary: 'Everything you need to know about tracking BBT accurately for fertility awareness.',
      content: '''Basal body temperature (BBT) charting is a powerful fertility awareness method that helps you confirm ovulation and understand your cycle patterns. BBT is your body's temperature at complete rest, measured immediately upon waking before any activity.

How BBT Works

During the follicular phase (before ovulation), estrogen keeps temperatures relatively low, typically between 36.1-36.5°C (97.0-97.8°F). After ovulation, progesterone causes a sustained temperature rise of 0.2-0.5°C (0.4-0.9°F). This shift usually lasts until the next period begins. Three consecutive temperatures higher than the previous six establish a "thermal shift," confirming ovulation has occurred.

Choosing a Thermometer

A basal body thermometer — which displays to two decimal places — is essential for accurate tracking. Digital thermometers are preferred over mercury thermometers for safety and precision. Specialized fertility trackers that use oral, vaginal, or wearable sensors are also available.

Tracking Guidelines

Take your temperature at the same time every morning, within 30 minutes of your usual time. Take it before sitting up, eating, drinking, or using your phone. Keep the thermometer on your bedside table for easy access. Record the reading immediately in your tracking app or chart.

Factors That Affect Accuracy

Several factors can elevate temperature and obscure the ovulatory shift: alcohol consumption the night before, fewer than 3 hours of uninterrupted sleep, illness or fever, stress, jet lag, and certain medications including NSAIDs. Note these factors on your chart so you can interpret readings accurately.

Interpreting Your Chart

A biphasic pattern — lower temperatures followed by a sustained rise — confirms ovulation. The exact day of ovulation is typically the day before the temperature rise. Monophasic charts (no sustained rise) may indicate anovulatory cycles, which are common occasionally and not necessarily a cause for concern.

When BBT Is Most Useful

BBT charting is particularly valuable for confirming that ovulation is occurring, timing intercourse effectively, identifying cycle irregularities, and working with fertility specialists. For those trying to avoid pregnancy, BBT should be combined with other fertility awareness methods for greater accuracy.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 5),
      reviewAuthor: 'Dr. Elena Torres, MD, Reproductive Endocrinologist',
      readTimeMinutes: 6,
      tags: ['BBT', 'temperature tracking', 'ovulation confirmation', 'fertility awareness'],
      createdAt: DateTime(2026, 2, 5),
      updatedAt: DateTime(2026, 4, 5),
    ),
    Article(
      id: 'ovulation_predictor_kits',
      title: 'Ovulation Predictor Kits: How to Use Them',
      category: 'fertility',
      summary: 'A complete guide to using OPKs accurately for timing intercourse and understanding your fertility.',
      content: '''Ovulation predictor kits (OPKs) are urine-based tests that detect the surge in luteinizing hormone (LH) that occurs 24-36 hours before ovulation. When used correctly, OPKs are approximately 99% accurate at detecting the LH surge.

How LH Surge Works

In the days leading up to ovulation, estrogen levels rise, stimulating the pituitary gland to release increasing amounts of LH. The LH surge triggers the dominant ovarian follicle to release a mature egg — typically within 36 hours. OPKs detect this surge, giving you advance notice of ovulation.

Types of OPKs

Standard test strips are the most economical option. They show a control line and a test line; the result is positive when the test line is as dark as or darker than the control line. Digital readers offer clear "smiley face" or "peak" results, eliminating interpretation uncertainty. Some advanced monitors track both estrogen and LH to identify a broader fertile window.

When and How to Test

Begin testing several days before expected ovulation. For a 28-day cycle, start around day 10. Test once daily, preferably between 2 PM and 6 PM, as LH surges often begin in the morning but may not reach detectable levels in urine until later in the day. Avoid excessive fluid intake 2 hours before testing, as diluted urine can produce false negatives.

Interpreting Results

A negative result shows a faint or absent test line. A positive result indicates the LH surge has been detected — ovulation is likely within the next 24-36 hours. Continue testing until you get a positive result, as the surge can be brief and may be missed if testing intervals are too far apart.

Common Mistakes to Avoid

Testing too early or too late in the cycle is the most common error. Using first morning urine is not recommended because the LH surge may not be detectable yet. Testing only once daily can miss a brief surge. Some women with polycystic ovary syndrome (PCOS) may have chronically elevated LH levels, causing persistently positive OPK results — in this case, OPKs may not be reliable.

When to Use OPKs

OPKs are most helpful for timing intercourse when trying to conceive. Having intercourse on the day of the positive OPK and the following 1-2 days maximizes the chance of conception. OPKs are also useful for timing intrauterine insemination (IUI) procedures when working with a fertility specialist.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 3, 25),
      reviewAuthor: 'Dr. Elena Torres, MD, Reproductive Endocrinologist',
      readTimeMinutes: 5,
      tags: ['OPK', 'LH surge', 'ovulation testing', 'fertility tracking'],
      createdAt: DateTime(2026, 2, 10),
      updatedAt: DateTime(2026, 3, 25),
    ),
    Article(
      id: 'fertility_specialist',
      title: 'When to See a Fertility Specialist',
      category: 'fertility',
      summary: 'Evidence-based guidelines on when to seek help from a reproductive specialist.',
      content: '''Deciding when to seek fertility care can feel overwhelming. Understanding the standard guidelines can help you make an informed decision about when to consult a specialist.

General Guidelines

The American Society for Reproductive Medicine recommends seeking evaluation after:
- 12 months of regular, unprotected intercourse if under age 35
- 6 months of regular, unprotected intercourse if age 35 or older
- 3 months if age 40 or older

Earlier evaluation is warranted if you have known risk factors.

Medical Conditions Requiring Earlier Evaluation

Certain conditions warrant immediate consultation regardless of how long you have been trying: irregular or absent menstrual cycles, known or suspected endometriosis, history of pelvic inflammatory disease, previous ovarian surgery, prior chemotherapy or radiation therapy, history of recurrent pregnancy loss (two or more miscarriages), known male factor infertility in your partner, or a family history of early menopause.

What to Expect at a Fertility Evaluation

The initial consultation typically includes a thorough medical history, discussion of your cycle patterns and prior pregnancy history, and recommendations for initial testing. For women, testing may include blood work to assess ovarian reserve (AMH, FSH, estradiol), thyroid function, and prolactin levels. An ultrasound may evaluate ovarian appearance, uterine structure, and follicle count. For men, a semen analysis is typically the first step.

Common Fertility Treatments

Depending on the underlying cause, treatments range from least to most invasive. Ovulation induction uses medications like clomiphene citrate or letrozole to stimulate egg development. Intrauterine insemination (IUI) places processed sperm directly into the uterus at the time of ovulation. In vitro fertilization (IVF) involves retrieving eggs, fertilizing them in a laboratory, and transferring resulting embryos into the uterus.

Lifestyle Factors

Before or alongside medical treatment, optimizing lifestyle factors can improve outcomes. Achieving a healthy BMI (19-25) is associated with better fertility outcomes. Moderate exercise (150 minutes per week) supports reproductive health. Reducing alcohol intake, avoiding smoking, and managing stress through evidence-based approaches like cognitive behavioral therapy can also be beneficial.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 10),
      reviewAuthor: 'Dr. Elena Torres, MD, Reproductive Endocrinologist',
      readTimeMinutes: 6,
      tags: ['fertility specialist', 'when to seek help', 'fertility testing', 'treatment options'],
      createdAt: DateTime(2026, 3, 1),
      updatedAt: DateTime(2026, 4, 10),
    ),

    // ── Pregnancy ───────────────────────────────────────────────────
    Article(
      id: 'first_trimester',
      title: 'Your First Trimester: What to Expect',
      category: 'pregnancy',
      summary: 'A comprehensive week-by-week overview of the first trimester of pregnancy.',
      content: '''The first trimester spans weeks 1 through 12 of pregnancy and is a period of rapid development for the embryo and significant change for the pregnant person. Understanding what to expect can help you navigate this transformative time with confidence.

Weeks 1-4: Conception and Implantation

Pregnancy is dated from the first day of your last menstrual period. Conception occurs around week 2, followed by the fertilized egg traveling to the uterus. Implantation typically occurs 6-12 days after ovulation. Around week 4, home pregnancy tests can detect human chorionic gonadotropin (hCG), the hormone that confirms pregnancy.

Weeks 5-8: Embryonic Development

This is a critical period of organ development. The neural tube (which becomes the brain and spinal cord) forms by week 6. The heart begins beating around week 6 and can be detected on an ultrasound. Limb buds appear, and facial features begin to develop. Common symptoms during these weeks include fatigue, breast tenderness, nausea, and food aversions — largely driven by rising hCG and progesterone levels.

Weeks 9-12: Transition to Fetus

By week 9, the embryo officially becomes a fetus. Major organs have formed and begin to function. The fetus can make small movements, though these are not yet felt. The risk of miscarriage decreases significantly after week 12. Nausea and fatigue may begin to improve for many women as hCG levels plateau.

Common First Trimester Symptoms

Nausea and vomiting (morning sickness) affects 70-80% of pregnancies and can occur at any time of day. Eating small, frequent meals and avoiding triggers can help. Fatigue is nearly universal due to increased progesterone. Breast tenderness, frequent urination, constipation, and mood changes are also common. Most symptoms are normal, but severe vomiting (hyperemesis gravidarum) requires medical attention.

Prenatal Care

The first prenatal visit typically occurs between weeks 6-10. Your provider will confirm the pregnancy, estimate the due date, perform blood work, and discuss prenatal screening options. Taking a prenatal vitamin with at least 400 mcg of folic acid is recommended before conception and throughout the first trimester to reduce the risk of neural tube defects.

When to Call Your Provider

Contact your healthcare provider if you experience heavy bleeding (soaking through a pad in an hour), severe abdominal or pelvic pain, fever above 100.4°F (38°C), severe vomiting with inability to keep fluids down, or painful or burning urination.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 5, 1),
      reviewAuthor: 'Dr. Rachel Chen, MD, OB-GYN',
      readTimeMinutes: 6,
      tags: ['first trimester', 'pregnancy', 'prenatal care', 'embryonic development'],
      createdAt: DateTime(2026, 3, 10),
      updatedAt: DateTime(2026, 5, 1),
    ),
    Article(
      id: 'nutrition_during_pregnancy',
      title: 'Nutrition During Pregnancy',
      category: 'pregnancy',
      summary: 'Evidence-based nutritional guidelines to support a healthy pregnancy.',
      content: '''Proper nutrition during pregnancy supports fetal development, maintains maternal health, and reduces the risk of complications. The principle "eating for two" is outdated — what matters most is the quality, not the quantity, of what you eat.

Caloric Needs

In the first trimester, caloric needs are similar to pre-pregnancy levels (approximately 1,800-2,000 calories per day, depending on activity level). In the second trimester, an additional 340 calories per day is recommended. In the third trimester, an additional 450 calories per day. These extra calories should come from nutrient-dense foods rather than empty calories.

Key Nutrients

Folic acid (400-800 mcg daily) is critical before conception and in early pregnancy to prevent neural tube defects. Food sources include leafy greens, legumes, and fortified cereals. Iron requirements double during pregnancy to support increased blood volume. Aim for 27 mg daily from sources like lean red meat, poultry, fish, beans, and fortified grains. Pair iron-rich foods with vitamin C (citrus, bell peppers) to enhance absorption.

Calcium (1,000 mg daily) supports fetal bone development while preserving maternal bone density. Dairy products, fortified plant milk, and leafy greens are excellent sources. Vitamin D (600 IU daily) works with calcium and supports immune function. Omega-3 fatty acids (specifically DHA) support fetal brain and eye development — aim for 200-300 mg DHA daily from low-mercury fish or supplements.

Foods to Limit or Avoid

Avoid alcohol completely during pregnancy — no safe level has been established. Limit caffeine to 200 mg daily (approximately one 12-ounce coffee). Avoid raw or undercooked meats, unpasteurized dairy products, and deli meats unless heated to steaming to reduce the risk of foodborne illness. Limit high-mercury fish including shark, swordfish, king mackerel, and tilefish.

Managing Common Digestive Issues

Nausea may improve with small, frequent meals, avoiding strong odors, and eating bland foods like crackers before getting out of bed. Constipation, common due to progesterone slowing digestion, can be managed with adequate fiber (25-30 grams daily), hydration, and regular physical activity.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 20),
      reviewAuthor: 'Dr. Maya Patel, RD, PhD',
      readTimeMinutes: 5,
      tags: ['pregnancy nutrition', 'prenatal vitamins', 'healthy eating', 'folic acid'],
      createdAt: DateTime(2026, 3, 15),
      updatedAt: DateTime(2026, 4, 20),
    ),
    Article(
      id: 'exercise_during_pregnancy',
      title: 'Exercise During Pregnancy',
      category: 'pregnancy',
      summary: 'Safe exercise guidelines for each trimester of pregnancy.',
      content: '''Regular physical activity during pregnancy is safe for most women and offers numerous benefits, including reduced back pain, decreased risk of gestational diabetes, improved mood, better sleep, and easier postpartum recovery. The American College of Obstetricians and Gynecologists (ACOG) recommends 150 minutes of moderate-intensity aerobic activity per week for pregnant women without contraindications.

Safe Exercises During Pregnancy

Brisk walking is an excellent low-impact activity that can be maintained throughout pregnancy. Swimming and water aerobics provide buoyancy that reduces joint stress while offering resistance for muscle conditioning. Stationary cycling eliminates fall risk while providing cardiovascular benefits. Prenatal yoga improves flexibility, reduces stress, and helps maintain core strength. Modified strength training using lighter weights with higher repetitions helps maintain muscle tone.

First Trimester Guidelines

In the first trimester, exercise can continue at pre-pregnancy intensity as long as you feel well. Pay attention to fatigue and nausea, which may affect energy levels. Avoid overheating — stay hydrated, exercise in a well-ventilated space, and avoid hot yoga or intense exercise in hot, humid conditions.

Second Trimester Guidelines

As your belly grows, the center of gravity shifts. Avoid exercises that require lying flat on your back after 16 weeks, as this can compress the vena cava and reduce blood flow. Balance exercises may become more challenging. The hormone relaxin increases joint laxity, so avoid deep stretches and high-impact movements.

Third Trimester Guidelines

Focus on maintaining activity rather than improving fitness. Listen to your body and reduce intensity as needed. Kegel exercises can be continued throughout pregnancy to strengthen pelvic floor muscles. Pelvic tilts, cat-cow stretches, and seated exercises remain comfortable options.

Exercises to Avoid

Avoid contact sports, activities with fall risk (skiing, horseback riding, gymnastics), scuba diving (risk of decompression sickness to the fetus), and any exercise causing abdominal pain, vaginal bleeding, or leakage of amniotic fluid.

When to Stop and Consult Your Provider

Stop exercising and contact your healthcare provider if you experience vaginal bleeding, chest pain, difficulty breathing, dizziness or fainting, regular painful contractions, fluid leaking, or calf pain or swelling.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 5, 5),
      reviewAuthor: 'Dr. Rachel Chen, MD, OB-GYN',
      readTimeMinutes: 5,
      tags: ['exercise', 'pregnancy fitness', 'prenatal exercise', 'safe exercise'],
      createdAt: DateTime(2026, 4, 1),
      updatedAt: DateTime(2026, 5, 5),
    ),
    Article(
      id: 'preparing_for_labor',
      title: 'Preparing for Labor and Delivery',
      category: 'pregnancy',
      summary: 'An educational overview of labor stages, pain management options, and birth planning.',
      content: '''Understanding the process of labor and delivery can reduce anxiety and help you make informed decisions about your birth experience. While every birth is unique, knowing what to expect provides a foundation for confidence and preparation.

Stages of Labor

The first stage begins with regular contractions that cause the cervix to dilate and efface. The early phase (latent labor) may last hours or days with mild, irregular contractions. Active labor begins around 6 centimeters of dilation with stronger, regular contractions. The transition phase (8-10 centimeters) is the most intense part of labor. The second stage begins when the cervix is fully dilated and involves pushing as the baby descends through the birth canal. The third stage involves delivery of the placenta, typically within 30 minutes after birth.

Pain Management Options

Non-pharmacological approaches include breathing techniques, hydrotherapy (shower or bath), massage, acupressure, movement and position changes, and continuous labor support from a doula or partner. Pharmacological options include nitrous oxide (laughing gas), which provides mild pain relief while allowing you to remain alert. Epidural anesthesia provides significant pain relief by blocking nerve signals from the lower spine. Opioid medications may be offered at some hospitals but cross the placenta and can affect the baby's breathing.

Birth Planning

A birth plan communicates your preferences to your healthcare team. Consider your preferences for pain management, labor positions, who you want present, interventions like continuous fetal monitoring or episiotomy, immediate postpartum care including skin-to-skin contact and delayed cord clamping, and newborn feeding preferences. Remember that birth plans are flexible — having preferences while remaining open to change is a healthy approach.

Signs That Labor Is Beginning

Common signs include regular, increasingly strong contractions that do not subside with rest, a "bloody show" (mucus tinged with blood as the cervical plug is released), water breaking (amniotic fluid leakage), and lower back pain or pressure. Call your healthcare provider when contractions are 5 minutes apart for 1 hour (first-time parents) or when you suspect your water has broken.

When to Go to the Hospital

Most providers recommend going to the hospital or birth center when contractions are regular and strong — typically 4-1-1 (every 4 minutes, lasting 1 minute, for 1 hour) for first-time parents. Go immediately if your water breaks with green or brown fluid, you have heavy bleeding, or you notice decreased fetal movement.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 5, 10),
      reviewAuthor: 'Dr. Rachel Chen, MD, OB-GYN',
      readTimeMinutes: 6,
      tags: ['labor', 'delivery', 'birth plan', 'pain management'],
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 5, 10),
    ),

    // ── Nutrition ───────────────────────────────────────────────────
    Article(
      id: 'cycle_syncing_nutrition',
      title: 'Cycle-Syncing Nutrition',
      category: 'nutrition',
      summary: 'How to adjust your diet to support the hormonal needs of each menstrual cycle phase.',
      content: '''Cycle-syncing nutrition is the practice of adjusting your food choices to align with the changing hormonal needs of each menstrual cycle phase. While research in this area is still emerging, the principles align with general nutritional science and may help manage cycle-related symptoms.

Menstrual Phase (Days 1-5)

During menstruation, estrogen and progesterone are at their lowest. Iron levels may be depleted due to blood loss. Focus on iron-rich foods: lean red meat, spinach, lentils, and fortified cereals. Pair with vitamin C sources like citrus or bell peppers to enhance absorption. Warming, anti-inflammatory foods like ginger and turmeric may help with cramping. Magnesium-rich foods such as dark chocolate, almonds, and leafy greens can help reduce muscle tension.

Follicular Phase (Days 6-13)

As estrogen rises, your body becomes more insulin-sensitive and may handle carbohydrates more efficiently. This is a good time for complex carbohydrates like quinoa, oats, and sweet potatoes, along with fermented foods that support gut health. Increasing fiber from vegetables, fruits, and legumes supports estrogen metabolism and elimination.

Ovulation (Around Day 14)

Estrogen peaks just before ovulation, and inflammation may increase. Anti-inflammatory foods are especially beneficial: fatty fish (salmon, sardines), walnuts, flaxseeds, berries, and leafy greens. Antioxidant-rich foods help counteract estrogen-related oxidative stress. Supporting liver function with cruciferous vegetables like broccoli, cauliflower, and Brussels sprouts aids estrogen clearance.

Luteal Phase (Days 15-28)

Progesterone dominates the luteal phase, which can increase appetite and potentially contribute to bloating, mood changes, and sugar cravings. Focus on complex carbohydrates to support serotonin production and stabilize blood sugar. Increase magnesium-rich foods to help with mood regulation and sleep. Limit sodium to reduce bloating. Include tryptophan-rich foods like turkey, eggs, and pumpkin seeds to support serotonin synthesis.

Practical Tips

You do not need to overhaul your diet completely. Start by adding one or two phase-specific foods each cycle. Drink plenty of water throughout your cycle, as hydration affects hormone transport and elimination. Limit caffeine and alcohol, which can disrupt sleep and hormone balance, especially in the luteal phase.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 3, 30),
      reviewAuthor: 'Dr. Maya Patel, RD, PhD',
      readTimeMinutes: 5,
      tags: ['cycle syncing', 'nutrition', 'diet', 'hormone health'],
      createdAt: DateTime(2026, 2, 20),
      updatedAt: DateTime(2026, 3, 30),
    ),
    Article(
      id: 'exercise_and_cycle',
      title: 'Exercise and Your Menstrual Cycle',
      category: 'nutrition',
      summary: 'How to adjust your workout routine across your menstrual cycle for optimal performance and recovery.',
      content: '''Hormonal fluctuations across the menstrual cycle influence energy levels, muscle recovery, and exercise performance. Adapting your workout intensity to these changes can enhance results and reduce injury risk.

Menstrual Phase (Days 1-5)

Energy and stamina may be lower as estrogen and progesterone are at their baseline. This is an ideal time for gentle movement: walking, light yoga, stretching, and meditation. Listen to your body and allow for rest if fatigue is significant. Light exercise may actually help reduce cramping by increasing blood flow.

Follicular Phase (Days 6-13)

As estrogen rises, energy and endurance increase. Studies suggest that during the follicular phase, women may have improved strength gains and faster muscle recovery. This is an excellent time for higher-intensity workouts: running, HIIT, heavy strength training, and group fitness classes. Estrogen may have a protective effect on muscles, reducing soreness.

Ovulation (Days 14-16)

Estrogen peaks around ovulation, which may coincide with peak physical performance. Some research suggests increased ligament laxity due to the hormone relaxin, so focus on proper form and avoid overstretching. This is a good time for PR attempts, intense cardio, or challenging workouts.

Luteal Phase (Days 17-28)

Progesterone rises after ovulation, which can increase body temperature, heart rate, and perceived exertion. Many women experience decreased endurance and increased fatigue. Water retention may make movement feel heavier. Focus on moderate-intensity exercise: moderate weight training, swimming, cycling, and Pilates. Reduce high-impact activities if joints feel loose or uncomfortable.

Core Strength and Pelvic Floor

Building core and pelvic floor strength throughout the cycle supports overall fitness and may help with menstrual pain. Incorporate exercises like pelvic tilts, bridges, and diaphragmatic breathing. Avoid excessive crunches or high-impact exercises during the menstrual phase if cramping is present.

General Guidelines

Stay hydrated throughout your cycle, as dehydration affects performance and can worsen cramps. Fuel properly before and after workouts, especially during the luteal phase when metabolism may be slightly elevated. Track how you feel across your cycle to identify your personal patterns.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 15),
      reviewAuthor: 'Dr. James Wright, PT, DPT',
      readTimeMinutes: 5,
      tags: ['exercise', 'cycle phases', 'workout', 'fitness'],
      createdAt: DateTime(2026, 3, 5),
      updatedAt: DateTime(2026, 4, 15),
    ),

    // ── Wellness ────────────────────────────────────────────────────
    Article(
      id: 'sleep_and_hormones',
      title: 'Sleep and Hormones',
      category: 'wellness',
      summary: 'Learn how sleep quality affects your hormonal health and what you can do to improve both.',
      content: '''Sleep and hormones share a bidirectional relationship: hormones influence sleep quality, and sleep quality affects hormone production. Understanding this connection can help you optimize both for better overall health.

How Hormones Affect Sleep

Progesterone has mild sedative effects and can promote sleep, which is why many women sleep well during the luteal phase. However, as progesterone rises, so does body temperature, which can disrupt deep sleep for some women. Estrogen enhances REM sleep and helps regulate body temperature. The sharp drop in both hormones before menstruation can lead to sleep disturbances — a common premenstrual complaint.

The Menstrual Cycle and Sleep Architecture

Studies using polysomnography (sleep studies) have found that during the luteal phase, women spend less time in REM sleep and more time in stage 2 sleep. Sleep latency — the time it takes to fall asleep — may increase. Women are also more likely to report insomnia symptoms in the days leading up to menstruation.

How Sleep Affects Hormones

Chronic sleep deprivation disrupts the hypothalamic-pituitary-adrenal (HPA) axis, leading to elevated cortisol levels. High cortisol can suppress reproductive hormone production, potentially causing irregular cycles or anovulation. Inadequate sleep also affects glucose metabolism and insulin sensitivity, which can influence hormone balance.

Sleep and Melatonin

Melatonin, the sleep hormone, is produced by the pineal gland in response to darkness. Beyond sleep regulation, melatonin acts as a powerful antioxidant that may support ovarian health. Studies suggest melatonin plays a role in follicle development and oocyte quality. Maintaining a consistent sleep-wake schedule supports healthy melatonin production.

Practical Sleep Hygiene

Aim for 7-9 hours of sleep per night. Maintain a consistent sleep schedule even on weekends. Create a cool (65-68°F or 18-20°C), dark, and quiet sleeping environment. Limit blue light exposure from screens 1-2 hours before bed. Avoid caffeine after 2 PM and limit alcohol, which disrupts REM sleep. Establish a relaxing bedtime routine — reading, gentle stretching, or meditation can signal your body to wind down.

When Sleep Problems Persist

If you regularly struggle with sleep despite good sleep hygiene, consider keeping a sleep diary to identify patterns. Discuss persistent insomnia or excessive daytime sleepiness with a healthcare provider, as these may indicate sleep disorders or underlying hormonal issues.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 12),
      reviewAuthor: 'Dr. Maya Patel, RD, PhD',
      readTimeMinutes: 5,
      tags: ['sleep', 'hormones', 'melatonin', 'sleep hygiene'],
      createdAt: DateTime(2026, 3, 20),
      updatedAt: DateTime(2026, 4, 12),
    ),
    Article(
      id: 'stress_management_hormonal_health',
      title: 'Stress Management for Hormonal Health',
      category: 'wellness',
      summary: 'Evidence-based stress reduction techniques to support hormonal balance and overall well-being.',
      content: '''Chronic stress is one of the most significant disruptors of hormonal health. When you experience stress, your body activates the hypothalamic-pituitary-adrenal (HPA) axis, releasing cortisol and other stress hormones. While this response is essential for survival, chronic activation can interfere with reproductive hormones, thyroid function, and metabolic health.

The Stress-Hormone Connection

Elevated cortisol can suppress gonadotropin-releasing hormone (GnRH), which in turn reduces luteinizing hormone (LH) and follicle-stimulating hormone (FSH). This can lead to delayed or absent ovulation, irregular cycles, and reduced fertility. Chronically high cortisol also affects thyroid function by inhibiting TSH production and converting T4 to the active T3 form. Additionally, cortisol stimulates gluconeogenesis, which can raise blood sugar and affect insulin sensitivity over time.

Mindfulness and Meditation

A 2019 meta-analysis of 47 studies found that mindfulness-based interventions significantly reduced cortisol levels. Even 10 minutes of daily meditation can make a difference. Body scan meditation, loving-kindness meditation, and breath-focused awareness are effective starting points. Apps and guided recordings can help establish a consistent practice.

Cognitive Behavioral Therapy (CBT)

CBT is one of the most evidence-based approaches for managing stress and anxiety. It helps identify and reframe stress-inducing thought patterns. A 2020 study found that CBT for insomnia improved not only sleep but also cortisol profiles and inflammatory markers. Working with a trained therapist, even for a limited number of sessions, can provide lasting benefits.

Physical Activity

Exercise is a powerful stress reducer. Aerobic exercise (walking, running, swimming) reduces cortisol and increases endorphins. Yoga, in particular, has been shown in multiple studies to lower cortisol levels and improve perceived stress. The key is consistency — 30 minutes of moderate activity most days of the week is more effective than occasional intense workouts.

Lifestyle Foundations

Sleep is foundational for stress management and hormone regulation. Aim for 7-9 hours of quality sleep. Nutrition also plays a role — blood sugar swings can activate the stress response, so eating balanced meals with protein, fiber, and healthy fats at regular intervals supports stable cortisol. Social connection is another powerful buffer against stress; maintaining supportive relationships reduces the physiological impact of stressors.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 5, 8),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 5,
      tags: ['stress', 'cortisol', 'mindfulness', 'mental health'],
      createdAt: DateTime(2026, 4, 5),
      updatedAt: DateTime(2026, 5, 8),
    ),

    // ── Hormonal Health ─────────────────────────────────────────────
    Article(
      id: 'estrogen_and_progesterone',
      title: 'Understanding Estrogen and Progesterone',
      category: 'hormonal_health',
      summary: 'A comprehensive guide to the two primary female sex hormones and their roles in the body.',
      content: '''Estrogen and progesterone are the two primary female sex hormones, each playing distinct but interconnected roles throughout the menstrual cycle and beyond. Understanding their functions helps demystify how your body works.

Estrogen

Estrogen is not a single hormone but a group of three related hormones: estradiol (the dominant form in reproductive years), estrone (dominant after menopause), and estriol (primarily produced during pregnancy). Estrogen is produced mainly by the ovaries, with smaller amounts from fat tissue and the adrenal glands.

Estrogen is responsible for the development of secondary sexual characteristics during puberty, thickening of the uterine lining during the follicular phase, cervical mucus production conducive to sperm survival, bone density maintenance, and cognitive function and mood regulation through its effects on neurotransmitters like serotonin.

Estrogen levels rise during the follicular phase, peak just before ovulation, drop briefly after ovulation, and then rise moderately during the luteal phase before falling again before menstruation.

Progesterone

Progesterone is produced primarily by the corpus luteum after ovulation. Its main roles include stabilizing the uterine lining for potential implantation, preventing further ovulation during pregnancy, supporting early pregnancy by maintaining the uterine lining, promoting breast tissue development, and increasing body temperature (which is why BBT rises after ovulation).

Progesterone has a calming, sometimes sedating effect. It also stimulates appetite in some women, which may contribute to luteal phase cravings. Progesterone levels are low during the follicular phase, rise after ovulation, peak in the mid-luteal phase, and fall sharply if pregnancy does not occur.

The Estrogen-Progesterone Balance

The ratio of estrogen to progesterone matters as much as the absolute levels of each. When estrogen is high relative to progesterone — a condition called "estrogen dominance" — symptoms may include heavy periods, breast tenderness, mood swings, bloating, and fibroid growth. Factors contributing to estrogen dominance include chronic stress (which raises cortisol and can lower progesterone), environmental xenoestrogens (chemicals that mimic estrogen), and inadequate fiber intake (which impairs estrogen elimination).

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 3, 18),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 6,
      tags: ['estrogen', 'progesterone', 'hormone balance', 'reproductive health'],
      createdAt: DateTime(2026, 2, 25),
      updatedAt: DateTime(2026, 3, 18),
    ),
    Article(
      id: 'lh_and_fsh',
      title: 'What Are LH and FSH?',
      category: 'hormonal_health',
      summary: 'Learn about the pituitary hormones that control your menstrual cycle and fertility.',
      content: '''Luteinizing hormone (LH) and follicle-stimulating hormone (FSH) are produced by the pituitary gland and serve as the master controllers of the menstrual cycle. Understanding these hormones is key to fertility awareness and diagnosing reproductive health conditions.

FSH: Follicle-Stimulating Hormone

FSH is released by the pituitary gland at the beginning of each menstrual cycle. Its primary job is to stimulate the growth of ovarian follicles — fluid-filled sacs that contain immature eggs. Each cycle, several follicles begin to develop under FSH influence, but typically only one becomes dominant and releases a mature egg.

FSH levels are highest at the start of the cycle (days 1-4) and gradually decline as estrogen rises. Elevated FSH levels (above 10-15 mIU/mL on day 3 of the cycle) may indicate diminished ovarian reserve, meaning fewer eggs remain in the ovaries. This is why FSH testing is part of fertility evaluations.

LH: Luteinizing Hormone

LH remains relatively low during most of the follicular phase. When estrogen reaches a critical threshold, the brain signals the pituitary to release a massive surge of LH. This LH surge triggers the final maturation of the egg and its release from the follicle — ovulation. The surge typically lasts 24-36 hours and is what ovulation predictor kits detect.

After ovulation, LH stimulates the ruptured follicle to transform into the corpus luteum, which produces progesterone. LH levels remain low during the luteal phase unless pregnancy occurs.

The LH-to-FSH Ratio

The ratio of LH to FSH is clinically significant. In polycystic ovary syndrome (PCOS), the LH-to-FSH ratio is often elevated (greater than 2:1 or 3:1). This reflects the disrupted GnRH signaling characteristic of PCOS. Healthcare providers may check this ratio along with other hormone levels when evaluating irregular cycles or infertility.

When Testing Is Done

FSH and LH are typically measured on day 2, 3, or 4 of the menstrual cycle for baseline assessment. LH may also be measured around mid-cycle to confirm ovulation. These tests are often combined with estradiol, AMH (anti-Müllerian hormone), and inhibin B for a comprehensive ovarian reserve assessment.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 4, 8),
      reviewAuthor: 'Dr. Elena Torres, MD, Reproductive Endocrinologist',
      readTimeMinutes: 5,
      tags: ['LH', 'FSH', 'pituitary hormones', 'fertility testing'],
      createdAt: DateTime(2026, 3, 25),
      updatedAt: DateTime(2026, 4, 8),
    ),
    Article(
      id: 'hormonal_birth_control',
      title: 'Hormonal Birth Control: Types and How They Work',
      category: 'hormonal_health',
      summary: 'An educational overview of hormonal contraception methods and their mechanisms of action.',
      content: '''Hormonal birth control prevents pregnancy primarily by suppressing ovulation, but different methods work through additional mechanisms. Understanding how each type works can help you make an informed choice about contraception.

Combined Hormonal Contraceptives

Combined methods contain both estrogen (typically ethinyl estradiol) and a progestin. Combined oral contraceptives (the pill) are taken daily for 21 days followed by 7 placebo pills. The vaginal ring is inserted into the vagina for 3 weeks and removed for 1 week. The contraceptive patch is worn on the skin for 3 weeks with a patch-free week.

These methods work primarily by suppressing FSH and LH, preventing follicle development and ovulation. They also thicken cervical mucus to impede sperm passage and thin the uterine lining. Typical use effectiveness is approximately 91%, while perfect use exceeds 99%.

Progestin-Only Methods

The progestin-only pill (mini-pill) is taken daily without a break. The hormonal intrauterine device (IUD) releases levonorgestrel and is effective for 3-8 years depending on the brand. The contraceptive implant (Nexplanon) is placed under the skin of the upper arm and is effective for 3 years. The injection (Depo-Provera) is given every 3 months.

Progestin-only methods work primarily by thickening cervical mucus to prevent sperm from reaching the egg. Some methods also suppress ovulation (the implant and injection are more reliable at ovulation suppression than the mini-pill). The hormonal IUD also thins the uterine lining, reducing menstrual bleeding. Effectiveness varies by method but ranges from 91% (mini-pill, typical use) to over 99% (IUD, implant).

Emergency Contraception

Emergency contraceptive pills (plan B, ella) can prevent pregnancy when taken within 3-5 days after unprotected intercourse. Plan B (levonorgestrel) works primarily by delaying ovulation. Ella (ulipristal acetate) can delay ovulation even when LH has begun to rise. The copper IUD is the most effective emergency contraception when inserted within 5 days.

Considerations and Side Effects

Common side effects include irregular bleeding, nausea, breast tenderness, and mood changes. Hormonal contraception does not protect against sexually transmitted infections. Certain medical conditions — including a history of blood clots, migraine with aura, and uncontrolled hypertension — may contraindicate estrogen-containing methods.

This article is for educational purposes and does not constitute medical advice.''',
      medicalReviewDate: DateTime(2026, 5, 12),
      reviewAuthor: 'Dr. Sarah Mitchell, MD, OB-GYN',
      readTimeMinutes: 6,
      tags: ['birth control', 'contraception', 'hormonal contraception', 'IUD', 'the pill'],
      createdAt: DateTime(2026, 4, 15),
      updatedAt: DateTime(2026, 5, 12),
    ),
  ];

  static List<Article> getByCategory(String category) =>
      articles.where((a) => a.category == category).toList();

  static List<Article> search(String query) {
    final lower = query.toLowerCase();
    return articles.where((a) =>
      a.title.toLowerCase().contains(lower) ||
      (a.summary?.toLowerCase().contains(lower) ?? false) ||
      a.content.toLowerCase().contains(lower) ||
      a.tags.any((t) => t.toLowerCase().contains(lower)),
    ).toList();
  }

  static List<Article> getByTag(String tag) =>
      articles.where((a) => a.tags.contains(tag)).toList();

  static Article? getById(String id) {
    try {
      return articles.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Article> get featured => articles.take(4).toList();

  static List<Article> getRelated(Article article) {
    return articles.where((a) =>
      a.id != article.id &&
      (a.category == article.category || a.tags.any((t) => article.tags.contains(t)))
    ).take(3).toList();
  }
}
