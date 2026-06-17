-- Cyra Seed Data
-- Default symptoms, educational articles, and demo data

-- ============================================================
-- DEFAULT SYMPTOMS
-- ============================================================
INSERT INTO symptoms (name, category, icon_name, display_order, is_default) VALUES
  -- Physical symptoms
  ('Cramps', 'physical', 'cramps', 1, true),
  ('Bloating', 'physical', 'bloating', 2, true),
  ('Headache', 'physical', 'headache', 3, true),
  ('Fatigue', 'physical', 'fatigue', 4, true),
  ('Back Pain', 'physical', 'back_pain', 5, true),
  ('Breast Tenderness', 'physical', 'breast_tenderness', 6, true),
  ('Nausea', 'physical', 'nausea', 7, true),
  ('Dizziness', 'physical', 'dizziness', 8, true),
  ('Joint Pain', 'physical', 'joint_pain', 9, true),
  ('Muscle Aches', 'physical', 'muscle_aches', 10, true),
  ('Hot Flashes', 'physical', 'hot_flashes', 11, true),
  ('Night Sweats', 'physical', 'night_sweats', 12, true),
  ('Weight Fluctuation', 'physical', 'weight', 13, true),
  ('Appetite Changes', 'physical', 'appetite', 14, true),

  -- Emotional symptoms
  ('Mood Swings', 'emotional', 'mood_swings', 15, true),
  ('Anxiety', 'emotional', 'anxiety', 16, true),
  ('Irritability', 'emotional', 'irritability', 17, true),
  ('Sadness', 'emotional', 'sadness', 18, true),
  ('Brain Fog', 'emotional', 'brain_fog', 19, true),
  ('Low Libido', 'emotional', 'low_libido', 20, true),
  ('Heightened Emotions', 'emotional', 'heightened_emotions', 21, true),
  ('Restlessness', 'emotional', 'restlessness', 22, true),

  -- Lifestyle symptoms
  ('Insomnia', 'lifestyle', 'insomnia', 23, true),
  ('Sleepiness', 'lifestyle', 'sleepiness', 24, true),
  ('Food Cravings', 'lifestyle', 'cravings', 25, true),
  ('Low Energy', 'lifestyle', 'low_energy', 26, true),
  ('Increased Energy', 'lifestyle', 'high_energy', 27, true),
  ('Social Withdrawal', 'lifestyle', 'social', 28, true),
  ('Increased Thirst', 'lifestyle', 'thirst', 29, true),
  ('Frequent Urination', 'lifestyle', 'urination', 30, true),

  -- Digestive symptoms
  ('Constipation', 'digestive', 'constipation', 31, true),
  ('Diarrhea', 'digestive', 'diarrhea', 32, true),
  ('Gas', 'digestive', 'gas', 33, true),
  ('Indigestion', 'digestive', 'indigestion', 34, true),

  -- Skin symptoms
  ('Acne', 'skin', 'acne', 35, true),
  ('Oily Skin', 'skin', 'oily_skin', 36, true),
  ('Dry Skin', 'skin', 'dry_skin', 37, true),
  ('Hair Loss', 'skin', 'hair_loss', 38, true)
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- EDUCATIONAL ARTICLES
-- ============================================================
INSERT INTO education_articles (title, slug, summary, content, category, tags, read_time_minutes, is_published, published_at) VALUES
(
  'Understanding Your Menstrual Cycle',
  'understanding-menstrual-cycle',
  'A complete guide to the four phases of your menstrual cycle and what happens in your body during each phase.',
  '## The Menstrual Cycle Explained\n\nYour menstrual cycle is the monthly series of changes your body goes through to prepare for a possible pregnancy. The average cycle is 28 days, but cycles between 21 and 35 days are considered normal.\n\n### Phase 1: Menstruation (Days 1-5)\nThis is when you have your period. The uterine lining sheds through the vagina. Common symptoms include cramps, fatigue, and mood changes.\n\n### Phase 2: Follicular Phase (Days 1-13)\nOverlapping with menstruation, the pituitary gland releases FSH, stimulating follicles in the ovaries to develop. One follicle becomes dominant and prepares to release an egg.\n\n### Phase 3: Ovulation (Day 14)\nA surge in LH causes the mature egg to be released from the ovary. This is your most fertile window. The egg survives for about 24 hours.\n\n### Phase 4: Luteal Phase (Days 15-28)\nAfter ovulation, the follicle transforms into the corpus luteum, producing progesterone to thicken the uterine lining. If pregnancy does not occur, hormone levels drop and the cycle begins again.\n\n### Tracking Your Cycle\nUsing Cyra, you can log your daily symptoms, track BBT, and record ovulation tests to understand your unique patterns.',
  'menstrual_health',
  ARRAY['menstruation', 'cycle phases', 'ovulation', 'period basics'],
  5,
  true,
  NOW() - INTERVAL '30 days'
),
(
  'Fertility Awareness: Tracking Your Fertile Window',
  'fertility-awareness-tracking',
  'Learn how to identify your fertile window using BBT, cervical mucus, and ovulation tests for natural family planning.',
  '## Fertility Awareness Methods\n\nFertility awareness involves tracking various signs of your body to identify when you are fertile. This can be used both to achieve and to avoid pregnancy.\n\n### Basal Body Temperature (BBT)\nYour BBT is your temperature at rest. After ovulation, progesterone causes a sustained temperature rise of 0.2-0.5°C (0.4-1.0°F). Track this daily before getting out of bed.\n\n### Cervical Mucus\nAs you approach ovulation, cervical mucus becomes abundant, clear, and slippery—similar to raw egg white. This is your most fertile sign.\n\n### Ovulation Predictor Kits (OPKs)\nThese detect the LH surge that occurs 24-48 hours before ovulation. A positive OPK means ovulation is likely imminent.\n\n### Your Fertile Window\nSperm can survive up to 5 days in the reproductive tract, while an egg survives about 24 hours. Your fertile window is approximately 6 days: the 5 days before ovulation and the day of ovulation itself.\n\nCyra combines all these signs to give you a personalized fertility prediction.',
  'fertility',
  ARRAY['fertility', 'BBT', 'cervical mucus', 'ovulation tests', 'fertile window'],
  6,
  true,
  NOW() - INTERVAL '25 days'
),
(
  'PMS vs PMDD: Recognizing the Difference',
  'pms-vs-pmdd',
  'Understand the difference between premenstrual syndrome (PMS) and premenstrual dysphoric disorder (PMDD) and when to seek help.',
  '## PMS vs PMDD\n\nMany people experience physical and emotional changes before their period. But for some, these symptoms can be severe enough to interfere with daily life.\n\n### PMS (Premenstrual Syndrome)\nPMS affects up to 75% of menstruating people. Symptoms can include:\n- Bloating and water retention\n- Breast tenderness\n- Mood swings and irritability\n- Fatigue\n- Food cravings\n- Mild anxiety\n\nSymptoms typically resolve within a few days of your period starting.\n\n### PMDD (Premenstrual Dysphoric Disorder)\nPMDD is a more severe form of PMS, affecting 3-8% of menstruating people. Symptoms include:\n- Severe depression or hopelessness\n- Intense anger or irritability\n- Panic attacks\n- Extreme fatigue\n- Difficulty concentrating\n- Physical symptoms like severe cramps and bloating\n\nPMDD can significantly impact relationships, work, and quality of life.\n\n### When to Seek Help\nIf your premenstrual symptoms regularly interfere with your daily life, speak with a healthcare provider. Treatment options include lifestyle changes, therapy, medication, and hormonal interventions.\n\nTrack your symptoms daily with Cyra to help your provider make an accurate diagnosis.',
  'menstrual_health',
  ARRAY['PMS', 'PMDD', 'premenstrual', 'mental health', 'hormones'],
  4,
  true,
  NOW() - INTERVAL '20 days'
),
(
  'Understanding PCOS: Symptoms and Management',
  'understanding-pcos',
  'An overview of Polycystic Ovary Syndrome, its symptoms, diagnosis, and management strategies for better health outcomes.',
  '## What is PCOS?\n\nPolycystic Ovary Syndrome (PCOS) is a hormonal disorder affecting approximately 1 in 10 people with ovaries. It typically begins during adolescence and can cause a range of symptoms.\n\n### Common Symptoms\n- Irregular or absent periods\n- Excess androgen (male hormone) levels\n- Enlarged ovaries with small cysts\n- Acne and oily skin\n- Excess facial and body hair (hirsutism)\n- Hair thinning on the scalp\n- Weight gain or difficulty losing weight\n- Insulin resistance\n\n### Diagnosis\nThe Rotterdam criteria require at least 2 of 3:\n1. Irregular ovulation (irregular periods)\n2. High androgen levels (blood test or physical signs)\n3. Polycystic ovaries on ultrasound\n\n### Management Strategies\nWhile there is no cure for PCOS, symptoms can be managed:\n- **Lifestyle**: Balanced diet and regular exercise can improve insulin sensitivity\n- **Medication**: Birth control pills, metformin, spironolactone\n- **Fertility**: Letrozole or clomiphene for ovulation induction\n- **Tracking**: Use Cyra to monitor cycles, symptoms, and identify patterns\n\nRegular check-ups are important as PCOS increases risk for type 2 diabetes and cardiovascular disease.',
  'conditions',
  ARRAY['PCOS', 'hormones', 'fertility', 'insulin resistance', 'women health'],
  7,
  true,
  NOW() - INTERVAL '15 days'
),
(
  'Endometriosis: What You Need to Know',
  'endometriosis-guide',
  'Learn about endometriosis, its symptoms, diagnosis journey, and treatment options for managing this chronic condition.',
  '## Understanding Endometriosis\n\nEndometriosis affects approximately 1 in 10 people with ovaries during their reproductive years. It occurs when tissue similar to the uterine lining grows outside the uterus.\n\n### Common Symptoms\n- Severe period pain (dysmenorrhea) that worsens over time\n- Chronic pelvic pain\n- Pain during or after sex\n- Heavy or irregular bleeding\n- Fatigue\n- Painful bowel movements or urination during periods\n- Infertility\n\n### The Diagnosis Journey\nUnfortunately, diagnosis takes an average of 7-10 years. This is because symptoms often overlap with other conditions and a definitive diagnosis requires laparoscopy.\n\n### Treatment Options\n- **Pain management**: NSAIDs, heat therapy, gentle exercise\n- **Hormonal therapy**: Birth control pills, progestins, GnRH agonists\n- **Surgery**: Laparoscopic excision of endometrial tissue\n- **Fertility support**: IVF and other assisted reproductive technologies\n- **Lifestyle**: Anti-inflammatory diet, stress reduction, pelvic floor therapy\n\n### Tracking with Cyra\nLogging your pain levels, symptoms, and cycle data can help your healthcare provider understand your condition better and track treatment effectiveness.\n\nIf you suspect endometriosis, keep a detailed symptom diary and advocate for yourself with your healthcare provider.',
  'conditions',
  ARRAY['endometriosis', 'pelvic pain', 'fertility', 'chronic condition', 'period pain'],
  7,
  true,
  NOW() - INTERVAL '10 days'
);

-- ============================================================
-- DEMO CYCLE DATA (for testing/development)
-- ============================================================
-- Insert demo user cycles (assumes a test user exists in auth with known UUID)
-- Replace the user_id with an actual test user UUID for development
DO $$
DECLARE
  demo_user_id UUID := '00000000-0000-0000-0000-000000000000';
  cycle1_id UUID;
  cycle2_id UUID;
  cycle3_id UUID;
  cycle4_id UUID;
  cycle5_id UUID;
  cycle6_id UUID;
  symptom_cramps UUID;
  symptom_bloating UUID;
  symptom_headache UUID;
  symptom_fatigue UUID;
  symptom_mood UUID;
  symptom_anxiety UUID;
  symptom_acne UUID;
  symptom_cravings UUID;
  symptom_back_pain UUID;
  symptom_insomnia UUID;
BEGIN
  -- Only seed if demo user profile exists
  IF EXISTS (SELECT 1 FROM auth.users WHERE id = demo_user_id) THEN

    -- Get symptom IDs
    SELECT id INTO symptom_cramps FROM symptoms WHERE name = 'Cramps';
    SELECT id INTO symptom_bloating FROM symptoms WHERE name = 'Bloating';
    SELECT id INTO symptom_headache FROM symptoms WHERE name = 'Headache';
    SELECT id INTO symptom_fatigue FROM symptoms WHERE name = 'Fatigue';
    SELECT id INTO symptom_mood FROM symptoms WHERE name = 'Mood Swings';
    SELECT id INTO symptom_anxiety FROM symptoms WHERE name = 'Anxiety';
    SELECT id INTO symptom_acne FROM symptoms WHERE name = 'Acne';
    SELECT id INTO symptom_cravings FROM symptoms WHERE name = 'Food Cravings';
    SELECT id INTO symptom_back_pain FROM symptoms WHERE name = 'Back Pain';
    SELECT id INTO symptom_insomnia FROM symptoms WHERE name = 'Insomnia';

    -- Cycle 1: 28 days
    INSERT INTO cycles (id, user_id, start_date, end_date, cycle_length, period_length, ovulation_day, luteal_phase_length)
    VALUES (gen_random_uuid(), demo_user_id, '2025-01-01', '2025-01-28', 28, 5, 14, 14)
    RETURNING id INTO cycle1_id;

    -- Cycle 1 days (period days 1-5)
    INSERT INTO cycle_days (cycle_id, date, day_number, flow_level, bleeding_type, pain_level) VALUES
      (cycle1_id, '2025-01-01', 1, 3, 'medium', 5),
      (cycle1_id, '2025-01-02', 2, 4, 'heavy', 6),
      (cycle1_id, '2025-01-03', 3, 4, 'heavy', 7),
      (cycle1_id, '2025-01-04', 4, 2, 'light', 4),
      (cycle1_id, '2025-01-05', 5, 1, 'spotting', 2),
      (cycle1_id, '2025-01-06', 6, 0, 'none', 0),
      (cycle1_id, '2025-01-07', 7, 0, 'none', 0),
      (cycle1_id, '2025-01-08', 8, 0, 'none', 0),
      (cycle1_id, '2025-01-09', 9, 0, 'none', 0),
      (cycle1_id, '2025-01-10', 10, 0, 'none', 0),
      (cycle1_id, '2025-01-11', 11, 0, 'none', 0),
      (cycle1_id, '2025-01-12', 12, 0, 'none', 0),
      (cycle1_id, '2025-01-13', 13, 0, 'none', 0),
      (cycle1_id, '2025-01-14', 14, 0, 'none', 0),
      (cycle1_id, '2025-01-15', 15, 0, 'none', 0),
      (cycle1_id, '2025-01-16', 16, 0, 'none', 0),
      (cycle1_id, '2025-01-17', 17, 0, 'none', 0),
      (cycle1_id, '2025-01-18', 18, 0, 'none', 0),
      (cycle1_id, '2025-01-19', 19, 0, 'none', 0),
      (cycle1_id, '2025-01-20', 20, 0, 'none', 0),
      (cycle1_id, '2025-01-21', 21, 0, 'none', 0),
      (cycle1_id, '2025-01-22', 22, 0, 'none', 0),
      (cycle1_id, '2025-01-23', 23, 0, 'none', 0),
      (cycle1_id, '2025-01-24', 24, 0, 'none', 0),
      (cycle1_id, '2025-01-25', 25, 0, 'none', 0),
      (cycle1_id, '2025-01-26', 26, 0, 'none', 0),
      (cycle1_id, '2025-01-27', 27, 0, 'none', 0),
      (cycle1_id, '2025-01-28', 28, 0, 'none', 0);

    -- Symptoms for cycle 1
    INSERT INTO symptom_logs (user_id, symptom_id, date, severity) VALUES
      (demo_user_id, symptom_cramps, '2025-01-01', 4),
      (demo_user_id, symptom_fatigue, '2025-01-01', 3),
      (demo_user_id, symptom_bloating, '2025-01-01', 3),
      (demo_user_id, symptom_cramps, '2025-01-02', 5),
      (demo_user_id, symptom_fatigue, '2025-01-02', 4),
      (demo_user_id, symptom_back_pain, '2025-01-02', 3),
      (demo_user_id, symptom_cramps, '2025-01-03', 4),
      (demo_user_id, symptom_back_pain, '2025-01-03', 4),
      (demo_user_id, symptom_bloating, '2025-01-03', 2),
      (demo_user_id, symptom_cramps, '2025-01-04', 2),
      (demo_user_id, symptom_headache, '2025-01-04', 3),
      (demo_user_id, symptom_bloating, '2025-01-05', 1),
      (demo_user_id, symptom_mood, '2025-01-12', 3),
      (demo_user_id, symptom_anxiety, '2025-01-13', 2),
      (demo_user_id, symptom_mood, '2025-01-14', 3),
      (demo_user_id, symptom_acne, '2025-01-15', 2),
      (demo_user_id, symptom_bloating, '2025-01-16', 2),
      (demo_user_id, symptom_mood, '2025-01-24', 4),
      (demo_user_id, symptom_anxiety, '2025-01-25', 3),
      (demo_user_id, symptom_cravings, '2025-01-25', 4),
      (demo_user_id, symptom_fatigue, '2025-01-26', 3),
      (demo_user_id, symptom_insomnia, '2025-01-26', 3),
      (demo_user_id, symptom_bloating, '2025-01-27', 3),
      (demo_user_id, symptom_mood, '2025-01-27', 4),
      (demo_user_id, symptom_cramps, '2025-01-28', 2),
      (demo_user_id, symptom_headache, '2025-01-28', 2);

    -- BBT records for cycle 1
    INSERT INTO bbt_records (user_id, date, temperature, unit, measurement_location, sleep_hours) VALUES
      (demo_user_id, '2025-01-01', 36.5, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-02', 36.4, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-03', 36.5, 'C', 'oral', 6.5),
      (demo_user_id, '2025-01-04', 36.4, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-05', 36.3, 'C', 'oral', 8.5),
      (demo_user_id, '2025-01-06', 36.4, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-07', 36.3, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-08', 36.4, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-09', 36.3, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-10', 36.4, 'C', 'oral', 6.5),
      (demo_user_id, '2025-01-11', 36.3, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-12', 36.4, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-13', 36.3, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-14', 36.2, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-15', 36.6, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-16', 36.7, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-17', 36.7, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-18', 36.8, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-19', 36.7, 'C', 'oral', 6.5),
      (demo_user_id, '2025-01-20', 36.8, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-21', 36.8, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-22', 36.7, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-23', 36.8, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-24', 36.7, 'C', 'oral', 7.5),
      (demo_user_id, '2025-01-25', 36.6, 'C', 'oral', 6.5),
      (demo_user_id, '2025-01-26', 36.5, 'C', 'oral', 7.0),
      (demo_user_id, '2025-01-27', 36.4, 'C', 'oral', 8.0),
      (demo_user_id, '2025-01-28', 36.3, 'C', 'oral', 7.5);

    -- Ovulation tests for cycle 1
    INSERT INTO ovulation_tests (user_id, date, result, time_of_day) VALUES
      (demo_user_id, '2025-01-11', 'negative', '14:00'),
      (demo_user_id, '2025-01-12', 'negative', '14:00'),
      (demo_user_id, '2025-01-13', 'positive', '16:00'),
      (demo_user_id, '2025-01-14', 'peak', '12:00'),
      (demo_user_id, '2025-01-15', 'negative', '14:00');

    -- Cycle 2: 27 days
    INSERT INTO cycles (id, user_id, start_date, end_date, cycle_length, period_length, ovulation_day, luteal_phase_length)
    VALUES (gen_random_uuid(), demo_user_id, '2025-01-29', '2025-02-24', 27, 4, 13, 14)
    RETURNING id INTO cycle2_id;

    INSERT INTO cycle_days (cycle_id, date, day_number, flow_level, bleeding_type, pain_level) VALUES
      (cycle2_id, '2025-01-29', 1, 3, 'medium', 4),
      (cycle2_id, '2025-01-30', 2, 4, 'heavy', 5),
      (cycle2_id, '2025-01-31', 3, 3, 'medium', 4),
      (cycle2_id, '2025-02-01', 4, 1, 'spotting', 1),
      (cycle2_id, '2025-02-02', 5, 0, 'none', 0),
      (cycle2_id, '2025-02-03', 6, 0, 'none', 0),
      (cycle2_id, '2025-02-04', 7, 0, 'none', 0),
      (cycle2_id, '2025-02-05', 8, 0, 'none', 0),
      (cycle2_id, '2025-02-06', 9, 0, 'none', 0),
      (cycle2_id, '2025-02-07', 10, 0, 'none', 0),
      (cycle2_id, '2025-02-08', 11, 0, 'none', 0),
      (cycle2_id, '2025-02-09', 12, 0, 'none', 0),
      (cycle2_id, '2025-02-10', 13, 0, 'none', 0),
      (cycle2_id, '2025-02-11', 14, 0, 'none', 0),
      (cycle2_id, '2025-02-12', 15, 0, 'none', 0),
      (cycle2_id, '2025-02-13', 16, 0, 'none', 0),
      (cycle2_id, '2025-02-14', 17, 0, 'none', 0),
      (cycle2_id, '2025-02-15', 18, 0, 'none', 0),
      (cycle2_id, '2025-02-16', 19, 0, 'none', 0),
      (cycle2_id, '2025-02-17', 20, 0, 'none', 0),
      (cycle2_id, '2025-02-18', 21, 0, 'none', 0),
      (cycle2_id, '2025-02-19', 22, 0, 'none', 0),
      (cycle2_id, '2025-02-20', 23, 0, 'none', 0),
      (cycle2_id, '2025-02-21', 24, 0, 'none', 0),
      (cycle2_id, '2025-02-22', 25, 0, 'none', 0),
      (cycle2_id, '2025-02-23', 26, 0, 'none', 0),
      (cycle2_id, '2025-02-24', 27, 0, 'none', 0);

    -- Cycle 3: 30 days
    INSERT INTO cycles (id, user_id, start_date, end_date, cycle_length, period_length, ovulation_day, luteal_phase_length)
    VALUES (gen_random_uuid(), demo_user_id, '2025-02-25', '2025-03-26', 30, 6, 16, 14)
    RETURNING id INTO cycle3_id;

    -- Cycle 4: 26 days
    INSERT INTO cycles (id, user_id, start_date, end_date, cycle_length, period_length, ovulation_day, luteal_phase_length)
    VALUES (gen_random_uuid(), demo_user_id, '2025-03-27', '2025-04-21', 26, 4, 12, 14)
    RETURNING id INTO cycle4_id;

    -- Cycle 5: 29 days
    INSERT INTO cycles (id, user_id, start_date, end_date, cycle_length, period_length, ovulation_day, luteal_phase_length)
    VALUES (gen_random_uuid(), demo_user_id, '2025-04-22', '2025-05-20', 29, 5, 15, 14)
    RETURNING id INTO cycle5_id;

    -- Cycle 6: ongoing
    INSERT INTO cycles (id, user_id, start_date, cycle_length, period_length)
    VALUES (gen_random_uuid(), demo_user_id, '2025-05-21', 28, 5)
    RETURNING id INTO cycle6_id;

    -- Journal entries for demo
    INSERT INTO journal_entries (user_id, date, title, content, mood_score, tags) VALUES
      (demo_user_id, '2025-01-01', 'First day', 'Started my period today. Cramps are pretty bad but manageable with a heating pad.', 3, ARRAY['period', 'cramps']),
      (demo_user_id, '2025-01-14', 'Feeling good', 'Ovulation day! Feeling energetic and in a great mood.', 5, ARRAY['ovulation', 'energy']),
      (demo_user_id, '2025-01-25', 'PMS is real', 'Feeling irritable and tired. Just want to rest and eat chocolate.', 2, ARRAY['PMS', 'fatigue']),
      (demo_user_id, '2025-02-10', 'Mid-cycle', 'Noticing increased energy and clear skin this week.', 4, ARRAY['energy', 'skin']),
      (demo_user_id, '2025-03-15', 'Stressful week', 'Work has been intense. Noticing more tension in my body than usual.', 2, ARRAY['stress', 'work']);

  END IF;
END $$;

-- ============================================================
-- SAMPLE MODERATION NOTIFICATIONS
-- ============================================================
-- These serve as examples for testing; the test anonymous_user_id
-- should match a real anonymous user in the system when running locally.
-- Insert only if the table exists and is empty.
INSERT INTO community_moderation_notifications (anonymous_user_id, content_type, content_id, action, reason, is_read, created_at)
SELECT * FROM (VALUES
  ('test_anon_user_1', 'post', 'post_seed_demo_1', 'approved', 'No harmful content detected', false, NOW() - INTERVAL '2 days'),
  ('test_anon_user_1', 'reply', 'reply_seed_demo_1', 'flagged', 'Content flagged for review: spam', false, NOW() - INTERVAL '1 day'),
  ('test_anon_user_2', 'post', 'post_seed_demo_2', 'removed', 'Content violates community guidelines: harassment', true, NOW() - INTERVAL '3 days')
) AS v(anonymous_user_id, content_type, content_id, action, reason, is_read, created_at)
WHERE EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'community_moderation_notifications')
  AND (SELECT COUNT(*) FROM community_moderation_notifications) = 0;
