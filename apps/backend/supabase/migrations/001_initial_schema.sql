-- Cyra Initial Schema
-- Privacy-first women's health tracking platform

-- ============================================================
-- EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- UPDATED_AT TRIGGER FUNCTION
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- USERS (managed by Supabase Auth, reference table)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  date_of_birth DATE,
  cycle_length_min INTEGER DEFAULT 21,
  cycle_length_max INTEGER DEFAULT 35,
  period_length_min INTEGER DEFAULT 3,
  period_length_max INTEGER DEFAULT 7,
  luteal_phase_length INTEGER DEFAULT 14,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- CYCLES
-- ============================================================
CREATE TABLE IF NOT EXISTS cycles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  end_date DATE,
  cycle_length INTEGER,
  period_length INTEGER,
  ovulation_day INTEGER,
  luteal_phase_length INTEGER,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cycles_user_id ON cycles(user_id);
CREATE INDEX idx_cycles_start_date ON cycles(start_date);
CREATE INDEX idx_cycles_user_date ON cycles(user_id, start_date DESC);

CREATE TRIGGER update_cycles_updated_at
  BEFORE UPDATE ON cycles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- CYCLE DAYS
-- ============================================================
CREATE TABLE IF NOT EXISTS cycle_days (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cycle_id UUID NOT NULL REFERENCES cycles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  day_number INTEGER NOT NULL,
  flow_level INTEGER CHECK (flow_level >= 0 AND flow_level <= 5),
  bleeding_type TEXT CHECK (bleeding_type IN ('none', 'spotting', 'light', 'medium', 'heavy', 'clots')),
  pain_level INTEGER CHECK (pain_level >= 0 AND pain_level <= 10),
  cervical_position TEXT,
  cervical_os TEXT CHECK (cervical_os IN ('closed', 'partially_open', 'open')),
  cervical_firmness TEXT CHECK (cervical_firmness IN ('firm', 'soft')),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cycle_days_cycle_id ON cycle_days(cycle_id);
CREATE INDEX idx_cycle_days_date ON cycle_days(date);
CREATE INDEX idx_cycle_days_cycle_date ON cycle_days(cycle_id, date);

CREATE TRIGGER update_cycle_days_updated_at
  BEFORE UPDATE ON cycle_days
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- SYMPTOMS (reference/catalog table)
-- ============================================================
CREATE TABLE IF NOT EXISTS symptoms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  category TEXT NOT NULL CHECK (category IN ('physical', 'emotional', 'lifestyle', 'digestive', 'skin', 'other')),
  icon_name TEXT,
  display_order INTEGER DEFAULT 0,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- SYMPTOM LOGS
-- ============================================================
CREATE TABLE IF NOT EXISTS symptom_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  symptom_id UUID NOT NULL REFERENCES symptoms(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  severity INTEGER CHECK (severity >= 1 AND severity <= 5),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_symptom_logs_user_id ON symptom_logs(user_id);
CREATE INDEX idx_symptom_logs_date ON symptom_logs(date);
CREATE INDEX idx_symptom_logs_user_date ON symptom_logs(user_id, date DESC);

CREATE TRIGGER update_symptom_logs_updated_at
  BEFORE UPDATE ON symptom_logs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- BBT RECORDS
-- ============================================================
CREATE TABLE IF NOT EXISTS bbt_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  temperature DECIMAL(4,2) NOT NULL,
  unit TEXT NOT NULL DEFAULT 'C' CHECK (unit IN ('C', 'F')),
  time_taken TIME,
  measurement_location TEXT CHECK (measurement_location IN ('oral', 'vaginal', 'armpit')),
  sleep_hours DECIMAL(3,1),
  disturbances BOOLEAN DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_bbt_records_user_id ON bbt_records(user_id);
CREATE INDEX idx_bbt_records_date ON bbt_records(date);
CREATE INDEX idx_bbt_records_user_date ON bbt_records(user_id, date DESC);

CREATE TRIGGER update_bbt_records_updated_at
  BEFORE UPDATE ON bbt_records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- OVULATION TESTS
-- ============================================================
CREATE TABLE IF NOT EXISTS ovulation_tests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  time_of_day TIME,
  result TEXT NOT NULL CHECK (result IN ('negative', 'positive', 'peak', 'invalid')),
  test_brand TEXT,
  photo_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ovulation_tests_user_id ON ovulation_tests(user_id);
CREATE INDEX idx_ovulation_tests_date ON ovulation_tests(date);
CREATE INDEX idx_ovulation_tests_user_date ON ovulation_tests(user_id, date DESC);

CREATE TRIGGER update_ovulation_tests_updated_at
  BEFORE UPDATE ON ovulation_tests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- CERVICAL MUCUS OBSERVATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS cervical_mucus_observations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  consistency TEXT CHECK (consistency IN ('dry', 'sticky', 'creamy', 'egg_white', 'watery')),
  amount TEXT CHECK (amount IN ('none', 'scant', 'moderate', 'heavy')),
  sensation TEXT CHECK (sensation IN ('dry', 'damp', 'wet', 'slippery')),
  color TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cervical_mucus_user_id ON cervical_mucus_observations(user_id);
CREATE INDEX idx_cervical_mucus_date ON cervical_mucus_observations(date);
CREATE INDEX idx_cervical_mucus_user_date ON cervical_mucus_observations(user_id, date DESC);

CREATE TRIGGER update_cervical_mucus_updated_at
  BEFORE UPDATE ON cervical_mucus_observations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- PREGNANCIES
-- ============================================================
CREATE TABLE IF NOT EXISTS pregnancies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estimated_due_date DATE,
  conception_date DATE,
  positive_test_date DATE,
  gestational_age_days INTEGER,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'ongoing', 'completed', 'loss')),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_pregnancies_user_id ON pregnancies(user_id);
CREATE INDEX idx_pregnancies_status ON pregnancies(status);

CREATE TRIGGER update_pregnancies_updated_at
  BEFORE UPDATE ON pregnancies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- FETAL MEASUREMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS fetal_measurements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pregnancy_id UUID NOT NULL REFERENCES pregnancies(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  gestational_age_weeks INTEGER,
  gestational_age_days INTEGER,
  weight_grams DECIMAL(7,2),
  length_cm DECIMAL(5,2),
  heart_rate_bpm INTEGER,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_fetal_measurements_pregnancy_id ON fetal_measurements(pregnancy_id);
CREATE INDEX idx_fetal_measurements_date ON fetal_measurements(date);

CREATE TRIGGER update_fetal_measurements_updated_at
  BEFORE UPDATE ON fetal_measurements
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- JOURNAL ENTRIES
-- ============================================================
CREATE TABLE IF NOT EXISTS journal_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  title TEXT,
  content TEXT NOT NULL,
  mood_score INTEGER CHECK (mood_score >= 1 AND mood_score <= 5),
  tags TEXT[],
  is_encrypted BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_journal_entries_user_id ON journal_entries(user_id);
CREATE INDEX idx_journal_entries_date ON journal_entries(date);
CREATE INDEX idx_journal_entries_user_date ON journal_entries(user_id, date DESC);

CREATE TRIGGER update_journal_entries_updated_at
  BEFORE UPDATE ON journal_entries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- USER CONDITIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS user_conditions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  condition_name TEXT NOT NULL,
  diagnosed_date DATE,
  is_active BOOLEAN DEFAULT true,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_conditions_user_id ON user_conditions(user_id);

CREATE TRIGGER update_user_conditions_updated_at
  BEFORE UPDATE ON user_conditions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- WEARABLE SOURCES
-- ============================================================
CREATE TABLE IF NOT EXISTS wearable_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  source_type TEXT NOT NULL CHECK (source_type IN ('apple_health', 'google_fit', 'oura', 'fitbit', 'garmin', 'whoop', 'manual')),
  is_connected BOOLEAN DEFAULT false,
  last_sync_at TIMESTAMPTZ,
  permissions TEXT[],
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_wearable_sources_user_id ON wearable_sources(user_id);

CREATE TRIGGER update_wearable_sources_updated_at
  BEFORE UPDATE ON wearable_sources
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- EDUCATION ARTICLES
-- ============================================================
CREATE TABLE IF NOT EXISTS education_articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  summary TEXT,
  content TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('menstrual_health', 'fertility', 'pregnancy', 'hormones', 'lifestyle', 'conditions')),
  tags TEXT[],
  read_time_minutes INTEGER,
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_education_articles_category ON education_articles(category);
CREATE INDEX idx_education_articles_slug ON education_articles(slug);
CREATE INDEX idx_education_articles_published ON education_articles(is_published, published_at DESC);

CREATE TRIGGER update_education_articles_updated_at
  BEFORE UPDATE ON education_articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- COMMUNITY POSTS
-- ============================================================
CREATE TABLE IF NOT EXISTS community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT,
  content TEXT NOT NULL,
  category TEXT CHECK (category IN ('general', 'symptoms', 'fertility', 'pregnancy', 'tips', 'support')),
  tags TEXT[],
  is_anonymous BOOLEAN DEFAULT false,
  is_moderated BOOLEAN DEFAULT false,
  moderation_status TEXT DEFAULT 'pending' CHECK (moderation_status IN ('pending', 'approved', 'flagged', 'removed')),
  upvotes INTEGER DEFAULT 0,
  reply_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_community_posts_user_id ON community_posts(user_id);
CREATE INDEX idx_community_posts_category ON community_posts(category);
CREATE INDEX idx_community_posts_status ON community_posts(moderation_status);
CREATE INDEX idx_community_posts_created ON community_posts(created_at DESC);

CREATE TRIGGER update_community_posts_updated_at
  BEFORE UPDATE ON community_posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- HEALTH REPORTS
-- ============================================================
CREATE TABLE IF NOT EXISTS health_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  report_type TEXT NOT NULL CHECK (report_type IN ('cycle_summary', 'fertility_report', 'symptoms_report', 'full_health_report')),
  date_range_start DATE NOT NULL,
  date_range_end DATE NOT NULL,
  report_data JSONB,
  pdf_url TEXT,
  is_encrypted BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_health_reports_user_id ON health_reports(user_id);
CREATE INDEX idx_health_reports_created ON health_reports(user_id, created_at DESC);

-- ============================================================
-- APP SETTINGS
-- ============================================================
CREATE TABLE IF NOT EXISTS app_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  settings JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE TRIGGER update_app_settings_updated_at
  BEFORE UPDATE ON app_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- AUDIT LOGS (privacy-preserving)
-- ============================================================
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  resource_type TEXT,
  resource_id TEXT,
  metadata JSONB,
  ip_address INET,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- User Profiles
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_profiles_select ON user_profiles FOR SELECT USING (id = auth.uid());
CREATE POLICY user_profiles_insert ON user_profiles FOR INSERT WITH CHECK (id = auth.uid());
CREATE POLICY user_profiles_update ON user_profiles FOR UPDATE USING (id = auth.uid());

-- Cycles
ALTER TABLE cycles ENABLE ROW LEVEL SECURITY;
CREATE POLICY cycles_select ON cycles FOR SELECT USING (user_id = auth.uid());
CREATE POLICY cycles_insert ON cycles FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY cycles_update ON cycles FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY cycles_delete ON cycles FOR DELETE USING (user_id = auth.uid());

-- Cycle Days
ALTER TABLE cycle_days ENABLE ROW LEVEL SECURITY;
CREATE POLICY cycle_days_select ON cycle_days FOR SELECT USING (
  cycle_id IN (SELECT id FROM cycles WHERE user_id = auth.uid())
);
CREATE POLICY cycle_days_insert ON cycle_days FOR INSERT WITH CHECK (
  cycle_id IN (SELECT id FROM cycles WHERE user_id = auth.uid())
);
CREATE POLICY cycle_days_update ON cycle_days FOR UPDATE USING (
  cycle_id IN (SELECT id FROM cycles WHERE user_id = auth.uid())
);
CREATE POLICY cycle_days_delete ON cycle_days FOR DELETE USING (
  cycle_id IN (SELECT id FROM cycles WHERE user_id = auth.uid())
);

-- Symptoms (reference table - readable by all authenticated users)
ALTER TABLE symptoms ENABLE ROW LEVEL SECURITY;
CREATE POLICY symptoms_select ON symptoms FOR SELECT USING (true);

-- Symptom Logs
ALTER TABLE symptom_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY symptom_logs_select ON symptom_logs FOR SELECT USING (user_id = auth.uid());
CREATE POLICY symptom_logs_insert ON symptom_logs FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY symptom_logs_update ON symptom_logs FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY symptom_logs_delete ON symptom_logs FOR DELETE USING (user_id = auth.uid());

-- BBT Records
ALTER TABLE bbt_records ENABLE ROW LEVEL SECURITY;
CREATE POLICY bbt_records_select ON bbt_records FOR SELECT USING (user_id = auth.uid());
CREATE POLICY bbt_records_insert ON bbt_records FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY bbt_records_update ON bbt_records FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY bbt_records_delete ON bbt_records FOR DELETE USING (user_id = auth.uid());

-- Ovulation Tests
ALTER TABLE ovulation_tests ENABLE ROW LEVEL SECURITY;
CREATE POLICY ovulation_tests_select ON ovulation_tests FOR SELECT USING (user_id = auth.uid());
CREATE POLICY ovulation_tests_insert ON ovulation_tests FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY ovulation_tests_update ON ovulation_tests FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY ovulation_tests_delete ON ovulation_tests FOR DELETE USING (user_id = auth.uid());

-- Cervical Mucus Observations
ALTER TABLE cervical_mucus_observations ENABLE ROW LEVEL SECURITY;
CREATE POLICY cervical_mucus_select ON cervical_mucus_observations FOR SELECT USING (user_id = auth.uid());
CREATE POLICY cervical_mucus_insert ON cervical_mucus_observations FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY cervical_mucus_update ON cervical_mucus_observations FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY cervical_mucus_delete ON cervical_mucus_observations FOR DELETE USING (user_id = auth.uid());

-- Pregnancies
ALTER TABLE pregnancies ENABLE ROW LEVEL SECURITY;
CREATE POLICY pregnancies_select ON pregnancies FOR SELECT USING (user_id = auth.uid());
CREATE POLICY pregnancies_insert ON pregnancies FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY pregnancies_update ON pregnancies FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY pregnancies_delete ON pregnancies FOR DELETE USING (user_id = auth.uid());

-- Fetal Measurements (via pregnancy)
ALTER TABLE fetal_measurements ENABLE ROW LEVEL SECURITY;
CREATE POLICY fetal_measurements_select ON fetal_measurements FOR SELECT USING (
  pregnancy_id IN (SELECT id FROM pregnancies WHERE user_id = auth.uid())
);
CREATE POLICY fetal_measurements_insert ON fetal_measurements FOR INSERT WITH CHECK (
  pregnancy_id IN (SELECT id FROM pregnancies WHERE user_id = auth.uid())
);
CREATE POLICY fetal_measurements_update ON fetal_measurements FOR UPDATE USING (
  pregnancy_id IN (SELECT id FROM pregnancies WHERE user_id = auth.uid())
);
CREATE POLICY fetal_measurements_delete ON fetal_measurements FOR DELETE USING (
  pregnancy_id IN (SELECT id FROM pregnancies WHERE user_id = auth.uid())
);

-- Journal Entries
ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY journal_entries_select ON journal_entries FOR SELECT USING (user_id = auth.uid());
CREATE POLICY journal_entries_insert ON journal_entries FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY journal_entries_update ON journal_entries FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY journal_entries_delete ON journal_entries FOR DELETE USING (user_id = auth.uid());

-- User Conditions
ALTER TABLE user_conditions ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_conditions_select ON user_conditions FOR SELECT USING (user_id = auth.uid());
CREATE POLICY user_conditions_insert ON user_conditions FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY user_conditions_update ON user_conditions FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY user_conditions_delete ON user_conditions FOR DELETE USING (user_id = auth.uid());

-- Wearable Sources
ALTER TABLE wearable_sources ENABLE ROW LEVEL SECURITY;
CREATE POLICY wearable_sources_select ON wearable_sources FOR SELECT USING (user_id = auth.uid());
CREATE POLICY wearable_sources_insert ON wearable_sources FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY wearable_sources_update ON wearable_sources FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY wearable_sources_delete ON wearable_sources FOR DELETE USING (user_id = auth.uid());

-- Education Articles (public read)
ALTER TABLE education_articles ENABLE ROW LEVEL SECURITY;
CREATE POLICY education_articles_select ON education_articles FOR SELECT USING (is_published = true);

-- Community Posts
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY community_posts_select ON community_posts FOR SELECT USING (
  moderation_status = 'approved' OR user_id = auth.uid()
);
CREATE POLICY community_posts_insert ON community_posts FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY community_posts_update ON community_posts FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY community_posts_delete ON community_posts FOR DELETE USING (user_id = auth.uid());

-- Health Reports
ALTER TABLE health_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY health_reports_select ON health_reports FOR SELECT USING (user_id = auth.uid());
CREATE POLICY health_reports_insert ON health_reports FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY health_reports_delete ON health_reports FOR DELETE USING (user_id = auth.uid());

-- App Settings
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY app_settings_select ON app_settings FOR SELECT USING (user_id = auth.uid());
CREATE POLICY app_settings_insert ON app_settings FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY app_settings_update ON app_settings FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY app_settings_delete ON app_settings FOR DELETE USING (user_id = auth.uid());

-- Audit Logs (insert only, no read by regular users)
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY audit_logs_insert ON audit_logs FOR INSERT WITH CHECK (user_id = auth.uid());

-- ============================================================
-- STORAGE BUCKETS
-- ============================================================
INSERT INTO storage.buckets (id, name, public) VALUES
  ('user_photos', 'user_photos', false),
  ('health_reports', 'health_reports', false),
  ('avatar_images', 'avatar_images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage RLS: users can only access their own folder
CREATE POLICY storage_user_photos_select ON storage.objects FOR SELECT USING (
  bucket_id = 'user_photos' AND (storage.foldername(name))[1] = auth.uid()::text
);
CREATE POLICY storage_user_photos_insert ON storage.objects FOR INSERT WITH CHECK (
  bucket_id = 'user_photos' AND (storage.foldername(name))[1] = auth.uid()::text
);
CREATE POLICY storage_user_photos_delete ON storage.objects FOR DELETE USING (
  bucket_id = 'user_photos' AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY storage_health_reports_select ON storage.objects FOR SELECT USING (
  bucket_id = 'health_reports' AND (storage.foldername(name))[1] = auth.uid()::text
);
CREATE POLICY storage_health_reports_insert ON storage.objects FOR INSERT WITH CHECK (
  bucket_id = 'health_reports' AND (storage.foldername(name))[1] = auth.uid()::text
);
