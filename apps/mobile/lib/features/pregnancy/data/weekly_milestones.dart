import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';

class PregnancyData {
  PregnancyData._();

  static const List<WeeklyMilestone> milestones = [
    WeeklyMilestone(
      week: 1,
      babySizeComparison: 'No baby yet',
      babyLengthCm: 0,
      babyWeightG: 0,
      developmentSummary:
          'Your body is preparing to ovulate. The uterine lining is building up in preparation for a potential pregnancy.',
      maternalChanges:
          'This week is counted from the first day of your last menstrual period. You are not actually pregnant yet.',
      symptoms: ['Light bleeding or spotting', 'Mild cramping'],
      tips: [
        'Start taking prenatal vitamins with at least 400 mcg of folic acid',
        'Track your ovulation signs to understand your cycle',
        'Maintain a healthy balanced diet',
      ],
    ),
    WeeklyMilestone(
      week: 2,
      babySizeComparison: 'Fertilized egg',
      babyLengthCm: 0.01,
      babyWeightG: 0,
      developmentSummary:
          'Conception occurs around ovulation. The fertilized egg, now a zygote, begins its journey toward the uterus while undergoing rapid cell division.',
      maternalChanges:
          'You may notice increased cervical mucus and a slight rise in basal body temperature.',
      symptoms: ['No noticeable symptoms', 'Possible mild cramping'],
      tips: [
        'Continue prenatal vitamins with folic acid',
        'Avoid alcohol, smoking, and recreational drugs',
        'Stay hydrated and manage stress',
      ],
    ),
    WeeklyMilestone(
      week: 3,
      babySizeComparison: 'Tiny embryo',
      babyLengthCm: 0.04,
      babyWeightG: 0,
      developmentSummary:
          'The blastocyst implants into the uterine lining. Cells begin to differentiate into the embryo and placenta. The amniotic cavity starts to form.',
      maternalChanges:
          'Implantation may cause very light spotting. Hormonal shifts begin as hCG levels rise.',
      symptoms: [
        'Very light implantation spotting (possible)',
        'Mild breast tenderness',
        'Fatigue',
      ],
      tips: [
        'Avoid vigorous exercise during implantation',
        'Eat folate-rich foods like leafy greens and legumes',
        'Get adequate rest and sleep',
      ],
    ),
    WeeklyMilestone(
      week: 4,
      babySizeComparison: 'Poppy seed',
      babyLengthCm: 0.1,
      babyWeightG: 0,
      developmentSummary:
          'The neural tube, which will become the brain and spinal cord, begins to form. The heart starts to develop as a simple tube. The placenta begins producing hCG.',
      maternalChanges:
          'You may miss your period around this week. hCG levels are now detectable on a pregnancy test.',
      symptoms: [
        'Missed period',
        'Breast tenderness',
        'Nausea',
        'Fatigue',
        'Mood swings',
      ],
      tips: [
        'Take a home pregnancy test if you haven\'t already',
        'Schedule your first prenatal appointment',
        'Confirm pregnancy with a healthcare provider',
      ],
    ),
    WeeklyMilestone(
      week: 5,
      babySizeComparison: 'Sesame seed',
      babyLengthCm: 0.2,
      babyWeightG: 0,
      developmentSummary:
          'The heart begins to beat and divide into chambers. The neural tube continues developing. The embryo is now made of three layers that will form all organs and tissues.',
      maternalChanges:
          'Morning sickness may begin. Your uterus is starting to enlarge, though it\'s still very small.',
      symptoms: [
        'Morning sickness (nausea with or without vomiting)',
        'Breast tenderness',
        'Frequent urination',
        'Food aversions or cravings',
        'Fatigue',
      ],
      tips: [
        'Eat small, frequent meals to manage nausea',
        'Stay hydrated — aim for 8-10 glasses of water daily',
        'Avoid raw fish, undercooked meat, and unpasteurized dairy',
      ],
    ),
    WeeklyMilestone(
      week: 6,
      babySizeComparison: 'Lentil',
      babyLengthCm: 0.4,
      babyWeightG: 0,
      developmentSummary:
          'The heart is now beating about 110 times per minute. The neural tube begins closing. Arm and leg buds appear. The pituitary gland starts forming.',
      maternalChanges:
          'Nausea may intensify. Your blood volume is increasing, which may cause fatigue and dizziness.',
      symptoms: [
        'Worsening morning sickness',
        'Breast changes (darker areolas, visible veins)',
        'Bloating and gas',
        'Mood swings',
        'Dizziness',
      ],
      tips: [
        'Keep crackers by your bed to eat before getting up',
        'Wear a supportive bra as your breasts change',
        'Ginger tea or ginger candies may help nausea',
      ],
    ),
    WeeklyMilestone(
      week: 7,
      babySizeComparison: 'Blueberry',
      babyLengthCm: 1.0,
      babyWeightG: 0,
      developmentSummary:
          'Facial features begin forming — eyes, nostrils, and ears are developing. The mouth and tongue are forming. The brain continues rapid growth. Arms and legs are elongating.',
      maternalChanges:
          'Your uterus is about the size of a lemon. You may still experience significant fatigue and nausea.',
      symptoms: [
        'Nausea and vomiting',
        'Frequent urination',
        'Increased saliva production',
        'Constipation',
        'Mood swings',
      ],
      tips: [
        'Increase fiber intake to combat constipation',
        'Practice pelvic floor exercises (Kegels)',
        'Start thinking about prenatal testing options',
      ],
    ),
    WeeklyMilestone(
      week: 8,
      babySizeComparison: 'Raspberry',
      babyLengthCm: 1.6,
      babyWeightG: 0.02,
      developmentSummary:
          'Major organs including the heart, brain, lungs, and kidneys are forming. Fingers and toes begin to appear but are still webbed. The embryo is now about the size of a raspberry.',
      maternalChanges:
          'Your uterus is growing, though you may not show yet. Fatigue is often at its peak during this time.',
      symptoms: [
        'Peak nausea and morning sickness',
        'Extreme fatigue',
        'Bloating',
        'Mood swings',
        'Breast tenderness',
      ],
      tips: [
        'Rest when you need to — your body is working hard',
        'Avoid harsh chemicals and cleaning products',
        'Continue prenatal vitamins and attend first ultrasound',
      ],
    ),
    WeeklyMilestone(
      week: 9,
      babySizeComparison: 'Grape',
      babyLengthCm: 2.3,
      babyWeightG: 0.1,
      developmentSummary:
          'The embryo is now officially a fetus. The tailbone is disappearing. Fingers and toes are no longer webbed. The eyelids are forming but remain fused shut.',
      maternalChanges:
          'Your uterus is expanding. You may notice your waistline thickening. Breasts continue to grow.',
      symptoms: [
        'Nausea (may start to improve)',
        'Visible veins on breasts',
        'Increased vaginal discharge',
        'Mood swings',
        'Food aversions',
      ],
      tips: [
        'Switch to comfortable, loose-fitting clothing',
        'Use a gentle, fragrance-free soap for intimate hygiene',
        'Discuss exercise guidelines with your provider',
      ],
    ),
    WeeklyMilestone(
      week: 10,
      babySizeComparison: 'Kumquat',
      babyLengthCm: 3.1,
      babyWeightG: 4.0,
      developmentSummary:
          'Vital organs are now fully formed and functional. The stomach begins producing digestive juices. The kidneys start producing urine. The heart has four distinct chambers.',
      maternalChanges:
          'Your energy levels may begin improving. Your uterus is now the size of a small grapefruit.',
      symptoms: [
        'Nausea may begin to subside',
        'Increased energy',
        'Visible veins (especially on abdomen)',
        'Mood swings',
        'Heartburn',
      ],
      tips: [
        'Moisturize growing belly skin to prevent stretch marks',
        'Eat smaller meals to reduce heartburn',
        'Schedule your first trimester screening if desired',
      ],
    ),
    WeeklyMilestone(
      week: 11,
      babySizeComparison: 'Fig',
      babyLengthCm: 4.1,
      babyWeightG: 7.0,
      developmentSummary:
          'The head is about half the length of the body. External genitalia are beginning to develop, but it\'s too early to determine sex. The fetus can now yawn and stretch.',
      maternalChanges:
          'Your energy is likely returning. The risk of miscarriage drops significantly after this week.',
      symptoms: [
        'Nausea improving or gone',
        'Increased energy',
        'Visible linea nigra (dark line on belly)',
        'Dizziness',
        'Nasal congestion',
      ],
      tips: [
        'Start looking into maternity wear',
        'Begin gentle prenatal exercise like walking or swimming',
        'Share your pregnancy news when you feel ready',
      ],
    ),
    WeeklyMilestone(
      week: 12,
      babySizeComparison: 'Lime',
      babyLengthCm: 5.4,
      babyWeightG: 14.0,
      developmentSummary:
          'Reflexes begin — the fetus can now make sucking motions. The fingers and toes are fully separated. Bones are beginning to harden. The intestines are forming.',
      maternalChanges:
          'Your uterus is above the pubic bone. You may have a small baby bump. Many women feel their best during the second trimester.',
      symptoms: [
        'Nausea mostly resolved',
        'Visible baby bump beginning',
        'Mild headaches',
        'Nasal congestion',
        'Skin changes (mask of pregnancy)',
      ],
      tips: [
        'Schedule your nuchal translucency screening',
        'Take belly photos to track your progress',
        'Start planning your maternity leave',
      ],
    ),
    WeeklyMilestone(
      week: 13,
      babySizeComparison: 'Pea pod',
      babyLengthCm: 7.4,
      babyWeightG: 23.0,
      developmentSummary:
          'The intestines move from the umbilical cord into the abdomen. The vocal cords begin forming. The fetus can now move its limbs, though movements are too subtle to feel.',
      maternalChanges:
          'The first trimester is ending. Your energy is restored and nausea has likely resolved. You may feel more emotionally stable.',
      symptoms: [
        'Increased energy',
        'Visible belly',
        'Improved mood',
        'Round ligament pain (mild)',
        'Increased appetite',
      ],
      tips: [
        'Begin wearing maternity pants for comfort',
        'Strengthen your core to support growing belly',
        'Celebrate entering the second trimester!',
      ],
    ),
    WeeklyMilestone(
      week: 14,
      babySizeComparison: 'Lemon',
      babyLengthCm: 8.7,
      babyWeightG: 43.0,
      developmentSummary:
          'The fetus is growing rapidly. The thyroid gland begins producing hormones. The spleen starts producing red blood cells. Fine hair (lanugo) begins covering the body.',
      maternalChanges:
          'Your belly is more noticeable. Your uterus is about the size of a large grapefruit. Many women experience a surge in energy and well-being.',
      symptoms: [
        'Increased energy',
        'Libido may return or increase',
        'Appetite increase',
        'Round ligament pain',
        'Nasal congestion',
      ],
      tips: [
        'Stay active with low-impact prenatal exercise',
        'Drink plenty of water to stay hydrated',
        'Discuss prenatal testing options with your provider',
      ],
    ),
    WeeklyMilestone(
      week: 15,
      babySizeComparison: 'Apple',
      babyLengthCm: 10.1,
      babyWeightG: 70.0,
      developmentSummary:
          'The fetus is becoming more active, though you may not feel movements yet. Bone marrow begins forming. The skin is thin and transparent. Taste buds are developing.',
      maternalChanges:
          'Your appetite is returning. You may feel more energetic. The top of your uterus is halfway between your pubic bone and belly button.',
      symptoms: [
        'Increased energy',
        'Appetite increase',
        'Mild forgetfulness (pregnancy brain)',
        'Possible dizziness',
        'Round ligament pain',
      ],
      tips: [
        'Stay organized with lists and reminders',
        'Eat iron-rich foods to prevent anemia',
        'Consider a pregnancy journal or app',
      ],
    ),
    WeeklyMilestone(
      week: 16,
      babySizeComparison: 'Avocado',
      babyLengthCm: 11.6,
      babyWeightG: 100.0,
      developmentSummary:
          'The fetus develops a pattern of movement and rest. The head is more erect. Legs are longer than arms. The heart pumps about 25 quarts of blood per day.',
      maternalChanges:
          'You may feel your baby move for the first time (quickening). Your uterus is now below your belly button.',
      symptoms: [
        'Baby movements (flutters or gas-like sensations)',
        'Increased appetite',
        'Round ligament pain',
        'Mild backache',
        'Mood swings (less frequent)',
      ],
      tips: [
        'Pay attention to fetal movement patterns',
        'Support your back with good posture and pillows',
        'Sign up for prenatal classes',
      ],
    ),
    WeeklyMilestone(
      week: 17,
      babySizeComparison: 'Pear',
      babyLengthCm: 13.0,
      babyWeightG: 140.0,
      developmentSummary:
          'Fat begins to form under the skin for insulation. The umbilical cord becomes thicker and stronger. The fetus can now hiccup. Sweat glands begin developing.',
      maternalChanges:
          'Your uterus is about 2 inches below your belly button. Your breasts may begin producing colostrum.',
      symptoms: [
        'Noticeable baby bump',
        'Increased vaginal discharge (leukorrhea)',
        'Ligament pain',
        'Occasional headaches',
        'Dizziness',
      ],
      tips: [
        'Wear supportive footwear to prevent balance issues',
        'Sleep on your side with pillows between your knees',
        'Expect leaking colostrum — use breast pads if needed',
      ],
    ),
    WeeklyMilestone(
      week: 18,
      babySizeComparison: 'Bell pepper',
      babyLengthCm: 14.2,
      babyWeightG: 190.0,
      developmentSummary:
          'The fetus can hear sounds from outside the womb. The nervous system is developing rapidly. Meconium (first stool) is forming in the intestines. Bones continue hardening.',
      maternalChanges:
          'You may feel stronger movements. Your appetite continues to increase. You should have your anatomy scan scheduled soon.',
      symptoms: [
        'Stronger fetal movements',
        'Increased appetite',
        'Backaches',
        'Leg cramps',
        'Skin changes (darker skin patches)',
      ],
      tips: [
        'Play soothing music or talk to your baby',
        'Elevate your feet to reduce swelling',
        'Prepare questions for your anatomy scan',
      ],
    ),
    WeeklyMilestone(
      week: 19,
      babySizeComparison: 'Mango',
      babyLengthCm: 15.3,
      babyWeightG: 240.0,
      developmentSummary:
          'Vernix caseosa, a waxy protective coating, covers the skin. The kidneys are producing urine which is released into the amniotic fluid. All senses are developing.',
      maternalChanges:
          'Your belly is growing steadily. You may experience round ligament pain as your uterus stretches.',
      symptoms: [
        'Round ligament pain',
        'Backaches',
        'Leg cramps',
        'Swollen ankles or feet',
        'Dizziness',
      ],
      tips: [
        'Stretch gently to relieve round ligament pain',
        'Elevate legs when resting to reduce swelling',
        'Begin sleeping on your side (left side preferred)',
      ],
    ),
    WeeklyMilestone(
      week: 20,
      babySizeComparison: 'Banana',
      babyLengthCm: 16.4,
      babyWeightG: 300.0,
      developmentSummary:
          'You\'re halfway through your pregnancy! The fetus is swallowing more amniotic fluid. Toenails are forming. The heart can now be heard clearly with a stethoscope.',
      maternalChanges:
          'Your uterus is at your belly button. Your anatomy scan is typically done between 18-22 weeks. Fetal movements may feel like kicks or rolls.',
      symptoms: [
        'Halfway milestone!',
        'Baby kicks and rolls',
        'Heartburn',
        'Leg cramps',
        'Varicose veins may appear',
      ],
      tips: [
        'Schedule your anatomy scan (18-22 weeks)',
        'Wear compression stockings if needed',
        'Take a belly photo at the halfway point',
      ],
    ),
    WeeklyMilestone(
      week: 21,
      babySizeComparison: 'Carrot',
      babyLengthCm: 26.7,
      babyWeightG: 360.0,
      developmentSummary:
          'The fetus swallows more amniotic fluid, which helps the digestive system mature. White blood cells form to fight infection. The tongue is fully formed.',
      maternalChanges:
          'Your uterus is about 1 cm above your belly button. You may feel Braxton Hicks contractions (practice contractions).',
      symptoms: [
        'Braxton Hicks contractions (irregular, painless)',
        'Heartburn',
        'Leg cramps',
        'Stretch marks',
        'Increased appetite',
      ],
      tips: [
        'Stay hydrated to reduce Braxton Hicks frequency',
        'Apply belly oil or lotion for stretched skin',
        'Eat smaller, more frequent meals for heartburn relief',
      ],
    ),
    WeeklyMilestone(
      week: 22,
      babySizeComparison: 'Papaya',
      babyLengthCm: 27.8,
      babyWeightG: 430.0,
      developmentSummary:
          'The fetus now has eyebrows and eyelashes. The lips are more distinct. The pancreas is developing properly. The fetus has a distinct sleep-wake cycle.',
      maternalChanges:
          'Your center of gravity is shifting. You may notice changes in your balance. Your belly is becoming more prominent.',
      symptoms: [
        'Braxton Hicks contractions',
        'Back pain',
        'Swollen feet and ankles',
        'Itchy belly skin',
        'Occasional shortness of breath',
      ],
      tips: [
        'Practice good posture to reduce back strain',
        'Moisturize belly skin to reduce itching',
        'Start your baby registry and nursery plans',
      ],
    ),
    WeeklyMilestone(
      week: 23,
      babySizeComparison: 'Grapefruit',
      babyLengthCm: 28.9,
      babyWeightG: 500.0,
      developmentSummary:
          'The lungs are developing surfactant, which helps them inflate after birth. The skin is becoming less transparent as fat accumulates. The fetus can blink.',
      maternalChanges:
          'Your belly button may pop out. The growing uterus puts pressure on your lungs and stomach.',
      symptoms: [
        'Shortness of breath',
        'Heartburn',
        'Swelling in hands and feet',
        'Backache',
        'Difficulty sleeping',
      ],
      tips: [
        'Sleep with extra pillows for comfort',
        'Elevate your legs when sitting',
        'Keep your prenatal appointment for glucose screening',
      ],
    ),
    WeeklyMilestone(
      week: 24,
      babySizeComparison: 'Ear of corn',
      babyLengthCm: 30.0,
      babyWeightG: 600.0,
      developmentSummary:
          'The fetus\'s hearing is fully developed. The lungs continue maturing. The body is beginning to produce white blood cells. The sense of balance is developing.',
      maternalChanges:
          'Your uterus is about 5 cm above your belly button. A glucose screening test is usually performed this week.',
      symptoms: [
        'Shortness of breath',
        'Back pain',
        'Swelling',
        'Braxton Hicks contractions',
        'Insomnia',
      ],
      tips: [
        'Complete your glucose tolerance test',
        'Sleep on your left side for optimal circulation',
        'Stay hydrated and eat iron-rich foods',
      ],
    ),
    WeeklyMilestone(
      week: 25,
      babySizeComparison: 'Rutabaga',
      babyLengthCm: 34.6,
      babyWeightG: 660.0,
      developmentSummary:
          'The fetus starts to put on more fat for warmth and energy after birth. The hands are fully developed with fingerprints. Capillaries form under the skin.',
      maternalChanges:
          'Your growing uterus is pushing upward toward your rib cage. You may feel more uncomfortable as space decreases.',
      symptoms: [
        'Shortness of breath',
        'Hemorrhoids',
        'Leg cramps',
        'Restless legs',
        'Difficulty sleeping',
      ],
      tips: [
        'Eat high-fiber foods to prevent hemorrhoids',
        'Stretch your calves before bed to prevent cramps',
        'Use a pregnancy pillow for better sleep',
      ],
    ),
    WeeklyMilestone(
      week: 26,
      babySizeComparison: 'Zucchini',
      babyLengthCm: 35.6,
      babyWeightG: 760.0,
      developmentSummary:
          'The fetus makes breathing movements to practice for life outside the womb. The eyes begin opening and closing. The brain is developing rapidly with increased connectivity.',
      maternalChanges:
          'Your uterus is now about 6 cm above your belly button. You may feel more tired as your body works harder.',
      symptoms: [
        'Fatigue',
        'Shortness of breath',
        'Back pain',
        'Swelling',
        'Braxton Hicks contractions',
      ],
      tips: [
        'Rest when possible and listen to your body',
        'Avoid standing for long periods',
        'Continue moderate exercise if comfortable',
      ],
    ),
    WeeklyMilestone(
      week: 27,
      babySizeComparison: 'Cauliflower',
      babyLengthCm: 36.6,
      babyWeightG: 875.0,
      developmentSummary:
          'The fetus can open and close their eyes. The brain is very active. The lungs are not yet fully mature but continue developing. Regular sleep-wake cycles are established.',
      maternalChanges:
          'You are entering the third trimester. Your energy may dip as your body prepares for birth. The top of your uterus is above your belly button.',
      symptoms: [
        'Fatigue',
        'Shortness of breath',
        'Frequent urination',
        'Pelvic pressure',
        'Mild contractions (Braxton Hicks)',
      ],
      tips: [
        'Prepare for the third trimester — rest when needed',
        'Sleep on your left side with pillows for support',
        'Start your birth plan and discuss with your provider',
      ],
    ),
    WeeklyMilestone(
      week: 28,
      babySizeComparison: 'Eggplant',
      babyLengthCm: 37.6,
      babyWeightG: 1000.0,
      developmentSummary:
          'The brain continues rapid growth with billions of neurons forming. The lungs can now breathe amniotic fluid. The eyes can produce tears. The immune system strengthens.',
      maternalChanges:
          'You are now in the third trimester. Your baby is about 2.5 pounds. You may feel more pressure on your bladder and lungs.',
      symptoms: [
        'Frequent urination',
        'Shortness of breath',
        'Back pain',
        'Leg cramps',
        'Restless sleep',
      ],
      tips: [
        'Monitor fetal kicks daily (kick counts)',
        'Stay hydrated to prevent preterm contractions',
        'Pack your hospital bag',
      ],
    ),
    WeeklyMilestone(
      week: 29,
      babySizeComparison: 'Butternut squash',
      babyLengthCm: 38.6,
      babyWeightG: 1150.0,
      developmentSummary:
          'The fetus experiences hiccups frequently. The bone marrow is now producing red blood cells. The muscles and lungs continue maturing. The head grows to accommodate the developing brain.',
      maternalChanges:
          'Your uterus is about 7-8 cm above your belly button. You may feel Braxton Hicks more frequently.',
      symptoms: [
        'Fetal hiccups (rhythmic movements)',
        'Shortness of breath',
        'Heartburn',
        'Pelvic pressure',
        'Fatigue',
      ],
      tips: [
        'Rest when you feel hiccups or intense movement',
        'Elevate your upper body to reduce heartburn at night',
        'Begin perineal massage to prepare for birth',
      ],
    ),
    WeeklyMilestone(
      week: 30,
      babySizeComparison: 'Cabbage',
      babyLengthCm: 39.9,
      babyWeightG: 1310.0,
      developmentSummary:
          'The fetus is rapidly gaining brain tissue. The skin is smoother as fat accumulates underneath. The eyes are fully developed though vision is still blurry.',
      maternalChanges:
          'Your belly is continuing to grow outward. You may feel increasingly tired and uncomfortable.',
      symptoms: [
        'Increasing fatigue',
        'Shortness of breath',
        'Swollen ankles and feet',
        'Braxton Hicks contractions',
        'Difficulty finding comfortable position',
      ],
      tips: [
        'Take frequent rest breaks throughout the day',
        'Elevate feet when sitting to reduce swelling',
        'Continue kick counts daily',
      ],
    ),
    WeeklyMilestone(
      week: 31,
      babySizeComparison: 'Coconut',
      babyLengthCm: 41.1,
      babyWeightG: 1500.0,
      developmentSummary:
          'The fetus can now turn their head from side to side. The lungs are maturing but are not fully ready. The body is accumulating more fat for temperature regulation.',
      maternalChanges:
          'Your uterus is pushing against your diaphragm, making breathing harder. You may feel pressure in your pelvis.',
      symptoms: [
        'Shortness of breath',
        'Pelvic pressure',
        'Lower back pain',
        'Difficulty sleeping',
        'Swelling',
      ],
      tips: [
        'Practice breathing techniques for labor',
        'Sleep with extra pillows to prop yourself up',
        'Decrease salt intake to manage swelling',
      ],
    ),
    WeeklyMilestone(
      week: 32,
      babySizeComparison: 'Jicama',
      babyLengthCm: 42.4,
      babyWeightG: 1700.0,
      developmentSummary:
          'The fetus practices breathing by inhaling amniotic fluid. Toenails are fully formed. The skin is becoming pink and opaque. All five senses are functioning.',
      maternalChanges:
          'Your baby is getting into position for birth (head-down position ideally). Your belly is large and prominent.',
      symptoms: [
        'Significant shortness of breath',
        'Frequent urination',
        'Pelvic pressure',
        'Hemorrhoids',
        'Varicose veins',
      ],
      tips: [
        'Attend childbirth education classes',
        'Discuss pain management options for labor',
        'Consider pre-registering at the hospital',
      ],
    ),
    WeeklyMilestone(
      week: 33,
      babySizeComparison: 'Pineapple',
      babyLengthCm: 43.7,
      babyWeightG: 1900.0,
      developmentSummary:
          'The immune system continues developing with antibodies passing from you to the fetus. The bones are hardening but the skull remains flexible for birth. The pupils constrict in response to light.',
      maternalChanges:
          'You may notice your baby dropping lower into your pelvis (lightening). This can make breathing easier but increases pelvic pressure.',
      symptoms: [
        'Baby dropping (lightening)',
        'Improved breathing',
        'Increased pelvic pressure',
        'Frequent urination',
        'Braxton Hicks contractions',
      ],
      tips: [
        'Notice if lightening occurs — it may ease breathing',
        'Continue kick counts and report changes to provider',
        'Finalize your birth plan and hospital bag',
      ],
    ),
    WeeklyMilestone(
      week: 34,
      babySizeComparison: 'Cantaloupe',
      babyLengthCm: 45.0,
      babyWeightG: 2100.0,
      developmentSummary:
          'Fingernails have grown to the tips of the fingers. The central nervous system and lungs are still maturing. The fetus is storing iron, calcium, and phosphorus.',
      maternalChanges:
          'Your body is preparing for birth. You may feel increased pressure as the baby engages in the pelvis.',
      symptoms: [
        'Pelvic pressure and discomfort',
        'Frequent urination',
        'Back pain',
        'Swelling',
        'Fatigue',
      ],
      tips: [
        'Rest when you can and pace yourself',
        'Avoid lying flat on your back',
        'Discuss signs of labor with your provider',
      ],
    ),
    WeeklyMilestone(
      week: 35,
      babySizeComparison: 'Honeydew',
      babyLengthCm: 46.2,
      babyWeightG: 2300.0,
      developmentSummary:
          'The kidneys are fully developed and the liver processes waste. Most of the fat stores are laid down. The fetus is running out of room and movements feel more like stretching.',
      maternalChanges:
          'Your baby is likely head-down now. Your cervix may begin dilating or effacing in preparation for labor.',
      symptoms: [
        'Intense pelvic pressure',
        'Braxton Hicks contractions',
        'Difficulty sleeping',
        'Swelling increases',
        'Increased vaginal discharge',
      ],
      tips: [
        'Watch for signs of preterm labor',
        'Have your support person ready',
        'Keep your hospital bag in the car',
      ],
    ),
    WeeklyMilestone(
      week: 36,
      babySizeComparison: 'Romaine lettuce',
      babyLengthCm: 47.4,
      babyWeightG: 2500.0,
      developmentSummary:
          'The fetus is considered late preterm. The lungs are nearly fully mature. The sucking and swallowing reflexes are well developed. The baby may engage in the pelvis (drop).',
      maternalChanges:
          'Your baby may drop into the birth canal. You may find breathing easier but walking more uncomfortable.',
      symptoms: [
        'Baby dropping (lightening)',
        'Easier breathing',
        'Increased pelvic pressure',
        'More frequent Braxton Hicks',
        'Loss of mucus plug (possible)',
      ],
      tips: [
        'Attend weekly prenatal appointments from now on',
        'Track contractions (timing and intensity)',
        'Confirm your birth preferences with your provider',
      ],
    ),
    WeeklyMilestone(
      week: 37,
      babySizeComparison: 'Swiss chard',
      babyLengthCm: 48.6,
      babyWeightG: 2800.0,
      developmentSummary:
          'The baby is considered early term. The lungs should be fully mature. The baby continues to gain about half a pound per week. The head is likely engaged in the pelvis.',
      maternalChanges:
          'Your cervix may begin dilating. You may lose your mucus plug (bloody show). Contractions may become more regular.',
      symptoms: [
        'Bloody show (mucus plug discharge)',
        'Strong Braxton Hicks contractions',
        'Pelvic pressure and aching',
        'Diarrhea',
        'Nesting urge',
      ],
      tips: [
        'Rest when you feel the nesting urge',
        'Stay hydrated and eat light, energy-rich meals',
        'Keep your phone charged and hospital bag ready',
      ],
    ),
    WeeklyMilestone(
      week: 38,
      babySizeComparison: 'Rhubarb',
      babyLengthCm: 49.8,
      babyWeightG: 3000.0,
      developmentSummary:
          'The baby is shedding vernix caseosa and lanugo. The skin is smooth and pink. The brain and nervous system are ready for life outside the womb. The baby is fully developed.',
      maternalChanges:
          'Your body is in full preparation mode. Any day now! Your labor could start at any time.',
      symptoms: [
        'Prodromal labor (irregular contractions)',
        'Water breaking (possible)',
        'Bloody show',
        'Intense pelvic pressure',
        'Nesting instinct',
      ],
      tips: [
        'Rest as much as possible before labor begins',
        'Time any contractions you notice',
        'Call your provider if your water breaks',
      ],
    ),
    WeeklyMilestone(
      week: 39,
      babySizeComparison: 'Mini watermelon',
      babyLengthCm: 50.7,
      babyWeightG: 3200.0,
      developmentSummary:
          'The baby is fully developed and ready to be born. The lungs produce surfactant. The immune system is strong. The baby is gaining about 1-2 ounces per day.',
      maternalChanges:
          'You may feel anxious and eager. This is normal. Your body knows what to do. Your baby is just waiting for the right time.',
      symptoms: [
        'Contractions (may increase in intensity)',
        'Lower back pain',
        'Pelvic pressure',
        'Anxiety and excitement',
        'Fatigue',
      ],
      tips: [
        'Trust your body and your baby\'s timing',
        'Practice relaxation and breathing techniques',
        'Call your provider with any concerns',
      ],
    ),
    WeeklyMilestone(
      week: 40,
      babySizeComparison: 'Watermelon',
      babyLengthCm: 51.2,
      babyWeightG: 3400.0,
      developmentSummary:
          'Your baby is full term and ready for birth. All organs are mature. The baby has a strong grasp reflex. The skull bones are still soft and movable for passage through the birth canal.',
      maternalChanges:
          'This is your due date, but only about 5% of babies arrive on their exact due date. Most babies arrive between 39 and 41 weeks.',
      symptoms: [
        'Strong, regular contractions',
        'Lower back pressure',
        'Water breaking (possible)',
        'Bloody show',
        'Excitement and nervousness',
      ],
      tips: [
        'Trust your body — you are ready',
        'Go to the hospital when contractions are 5-1-1 (5 min apart, 1 min long, 1 hour)',
        'Stay calm and positive — you\'re about to meet your baby!',
      ],
    ),
  ];

  static WeeklyMilestone getMilestone(int week) {
    if (week <= milestones.first.week) {
      return milestones.first;
    }
    if (week >= milestones.last.week) {
      return milestones.last.copyWith(
        week: week,
        babySizeComparison: 'Full-term baby',
        developmentSummary:
            'Your baby is full term. Some pregnancies go beyond 40 weeks, and your care team can guide monitoring and next steps.',
        maternalChanges:
            'It is understandable to feel ready and watchful. Keep tracking movement, contractions, and any guidance from your care team.',
        tips: [
          'Keep all late-pregnancy appointments and monitoring visits',
          'Call your care team about decreased movement, bleeding, water breaking, or concerning symptoms',
          'Rest, hydrate, and keep your hospital bag and support plan ready',
        ],
      );
    }
    return milestones.firstWhere(
      (m) => m.week == week,
      orElse: () => milestones.last,
    );
  }

  static List<WeeklyMilestone> getTrimesterMilestones(int trimester) {
    final (int start, int end) = switch (trimester) {
      1 => (1, 13),
      2 => (14, 27),
      3 => (28, 40),
      _ => (1, 40),
    };
    return milestones.where((m) => m.week >= start && m.week <= end).toList();
  }
}
