# Database Schema: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | Data Team | Initial release |

---

## 1. Overview

Cyra uses a dual-database architecture:
- **Drift (SQLite)**: Primary local database on-device
- **Supabase (PostgreSQL)**: Optional cloud sync target

Both schemas are identical in structure. This document describes the PostgreSQL schema (used in Supabase), which is mirrored in Drift for local storage.

---

## 2. Naming Conventions

- Tables: `snake_case`, plural
- Columns: `snake_case`
- Primary keys: `id` (UUID v4 for Supabase, auto-increment integer for local Drift)
- Foreign keys: `{referenced_table}_id`
- Timestamps: `created_at`, `updated_at`
- Soft delete: `deleted_at` (nullable timestamp)
- All tables include: `id`, `created_at`, `updated_at`

---

## 3. Table: `cycles`

Tracks each menstrual cycle for a user.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | Unique identifier |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `start_date` | `date` | NOT NULL | First day of menstruation |
| `end_date` | `date` | NULL | Last day before next period starts |
| `cycle_length` | `smallint` | NULL, CHECK(cycle_length >= 1 AND cycle_length <= 365) | Total days in cycle |
| `period_length` | `smallint` | NULL, CHECK(period_length >= 1 AND period_length <= 30) | Days of menstruation |
| `ovulation_day` | `smallint` | NULL, CHECK(ovulation_day >= 1 AND ovulation_day <= cycle_length) | Detected ovulation day |
| `is_ovulation_confirmed` | `boolean` | DEFAULT false | Whether ovulation confirmed by temp shift |
| `luteal_phase_length` | `smallint` | NULL | Days from ovulation to next period start |
| `notes` | `text` | NULL | User notes for cycle |
| `tags` | `text[]` | DEFAULT '{}' | User-defined tags (e.g., "stressful", "travel") |
| `created_at` | `timestamptz` | DEFAULT now() | Record creation time |
| `updated_at` | `timestamptz` | DEFAULT now() | Last modification time |
| `deleted_at` | `timestamptz` | NULL | Soft delete timestamp |

**Indexes:**
- `idx_cycles_user_id` ON `user_id`
- `idx_cycles_start_date` ON `start_date`
- `idx_cycles_user_start_date` ON `user_id, start_date DESC`
- `idx_cycles_user_status` ON `user_id` WHERE `deleted_at IS NULL`

**RLS Policy:**
```sql
CREATE POLICY cycle_user_isolation ON cycles
  FOR ALL USING (auth.uid() = user_id);
```

**Relationships:**
- One user has many cycles
- One cycle has many cycle_days
- One cycle has potentially one pregnancy

---

## 4. Table: `cycle_days`

Daily log entries within a cycle.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | Unique identifier |
| `cycle_id` | `uuid` | NOT NULL, FK → cycles.id ON DELETE CASCADE | Parent cycle |
| `date` | `date` | NOT NULL | Calendar date |
| `day_number` | `smallint` | NOT NULL, CHECK(day_number >= 1) | Day of cycle (1 = first day of period) |
| `cycle_phase` | `text` | NULL, CHECK(cycle_phase IN ('menstrual','follicular','ovulatory','luteal')) | Predicted/observed phase |
| `flow_intensity` | `text` | NULL, CHECK(flow_intensity IN ('none','spotting','light','medium','heavy','very_heavy')) | Menstrual flow |
| `spotting` | `boolean` | DEFAULT false | Any spotting today |
| `clotting` | `text` | NULL, CHECK(clotting IN ('none','small','medium','large')) | Clot presence and size |
| `pain_level` | `smallint` | NULL, CHECK(pain_level >= 0 AND pain_level <= 5) | Cramp/pain severity |
| `intercourse` | `boolean` | DEFAULT false | Intercourse occurred |
| `intercourse_unprotected` | `boolean` | DEFAULT false | Unprotected intercourse |
| `mood` | `text` | NULL, CHECK(mood IN ('very_low','low','neutral','good','very_good','energetic')) | Overall mood |
| `energy_level` | `smallint` | NULL, CHECK(energy_level >= 1 AND energy_level <= 5) | Energy rating |
| `sleep_hours` | `decimal(4,1)` | NULL, CHECK(sleep_hours >= 0 AND sleep_hours <= 24) | Hours slept |
| `stress_level` | `smallint` | NULL, CHECK(stress_level >= 1 AND stress_level <= 5) | Stress rating |
| `symptoms_json` | `jsonb` | DEFAULT '[]' | Quick-logged symptom IDs and severities |
| `temperature` | `decimal(4,2)` | NULL | BBT temperature in Celsius |
| `cervical_mucus_type` | `text` | NULL, CHECK(cervical_mucus_type IN ('dry','sticky','creamy','watery','egg_white')) | CM observation |
| `cervical_position` | `text` | NULL, CHECK(cervical_position IN ('low','medium','high','very_high')) | Cervical position |
| `cervical_os` | `text` | NULL, CHECK(cervical_os IN ('closed','partially','open')) | Cervical opening |
| `opk_result` | `text` | NULL, CHECK(opk_result IN ('negative','positive','fading','not_taken')) | OPK test result |
| `medication_json` | `jsonb` | DEFAULT '[]' | Medications taken: [{name, dose, time}] |
| `supplements_json` | `jsonb` | DEFAULT '[]' | Supplements taken: [{name, dose}] |
| `exercise_minutes` | `smallint` | NULL | Minutes of exercise |
| `notes` | `text` | NULL | Daily notes |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_cycle_days_cycle_id` ON `cycle_id`
- `idx_cycle_days_date` ON `date`
- `idx_cycle_days_user_cycle` ON `cycle_id, day_number` UNIQUE
- `idx_cycle_days_phase` ON `cycle_phase`

**RLS Policy:**
```sql
CREATE POLICY cycle_day_user_isolation ON cycle_days
  FOR ALL USING (
    EXISTS (SELECT 1 FROM cycles WHERE cycles.id = cycle_days.cycle_id AND cycles.user_id = auth.uid())
  );
```

**Relationships:**
- Belongs to one cycle
- Has many symptom_logs
- Has many journal_entries (potentially)
- Has one cervical_mucus_observation (potentially)

---

## 5. Table: `symptoms`

Lookup table of predefined and custom symptoms.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | Unique identifier |
| `user_id` | `uuid` | NULL, FK → auth.users.id | NULL = system predefined, non-NULL = user custom |
| `name` | `text` | NOT NULL | Symptom name (e.g., "Bloating", "Headache") |
| `category` | `text` | NOT NULL, CHECK(category IN ('physical','emotional','lifestyle','digestive','skin','breast','pain','other')) | Category grouping |
| `icon` | `text` | NOT NULL | Icon identifier from design system |
| `predefined_options` | `jsonb` | NULL | [{label: "Mild", value: 1}, ...] severity options |
| `description` | `text` | NULL | Help text for users |
| `related_conditions` | `text[]` | NULL | Condition IDs this symptom relates to |
| `is_active` | `boolean` | DEFAULT true | Whether symptom appears in selector |
| `sort_order` | `smallint` | DEFAULT 0 | Display order within category |
| `created_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_symptoms_category` ON `category`
- `idx_symptoms_user` ON `user_id` WHERE `user_id IS NOT NULL`

**RLS Policy:**
```sql
CREATE POLICY symptom_access ON symptoms
  FOR SELECT USING (user_id IS NULL OR user_id = auth.uid());
CREATE POLICY symptom_insert ON symptoms
  FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY symptom_update ON symptoms
  FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY symptom_delete ON symptoms
  FOR DELETE USING (user_id = auth.uid());
```

**Relationships:**
- Has many symptom_logs (through pivot)

---

## 6. Table: `symptom_logs`

Records symptom occurrences with severity on cycle days.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `cycle_day_id` | `uuid` | NOT NULL, FK → cycle_days.id ON DELETE CASCADE | Associated cycle day |
| `symptom_id` | `uuid` | NOT NULL, FK → symptoms.id | The symptom logged |
| `severity` | `smallint` | NOT NULL, CHECK(severity >= 1 AND severity <= 5) | 1-5 scale |
| `time_of_day` | `text` | NULL, CHECK(time_of_day IN ('morning','afternoon','evening','night')) | When symptom occurred |
| `duration_minutes` | `smallint` | NULL | How long symptom lasted |
| `notes` | `text` | NULL | User notes |
| `created_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_symptom_logs_cycle_day` ON `cycle_day_id`
- `idx_symptom_logs_symptom` ON `symptom_id`
- `idx_symptom_logs_day_symptom` ON `cycle_day_id, symptom_id` UNIQUE (one severity per symptom per day)
- `idx_symptom_logs_severity` ON `severity`

**RLS Policy:**
```sql
CREATE POLICY symptom_log_user_isolation ON symptom_logs
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM cycle_days
      JOIN cycles ON cycles.id = cycle_days.cycle_id
      WHERE cycle_days.id = symptom_logs.cycle_day_id
      AND cycles.user_id = auth.uid()
    )
  );
```

**Relationships:**
- Belongs to one cycle_day
- References one symptom

---

## 7. Table: `bbt_records`

Basal body temperature readings.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `date` | `date` | NOT NULL | Reading date |
| `temperature` | `decimal(4,2)` | NOT NULL, CHECK(temperature >= 35.0 AND temperature <= 42.0) | Celsius |
| `measurement_method` | `text` | NOT NULL, CHECK(measurement_method IN ('oral','vaginal','armpit','wearable')) | Method used |
| `time` | `time` | NULL | Time of reading |
| `sleep_hours` | `decimal(3,1)` | NULL, CHECK(sleep_hours >= 0 AND sleep_hours <= 24) | Hours slept before reading |
| `disturbances` | `text` | NULL, CHECK(disturbances IN ('none','interrupted','short','alcohol','illness','stress')) | Factors affecting accuracy |
| `is_estimated` | `boolean` | DEFAULT false | Whether estimated from wearable |
| `notes` | `text` | NULL | |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_bbt_user_date` ON `user_id, date` UNIQUE (one reading per day)
- `idx_bbt_temperature` ON `temperature`
- `idx_bbt_method` ON `measurement_method`

**RLS Policy:**
```sql
CREATE POLICY bbt_user_isolation ON bbt_records
  FOR ALL USING (auth.uid() = user_id);
```

**Relationships:**
- One user has many BBT records

---

## 8. Table: `ovulation_tests`

OPK (Ovulation Predictor Kit) test results.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `cycle_id` | `uuid` | NOT NULL, FK → cycles.id ON DELETE CASCADE | Associated cycle |
| `date` | `date` | NOT NULL | Test date |
| `time_of_day` | `text` | NOT NULL, CHECK(time_of_day IN ('morning','afternoon','evening')) | When test taken |
| `result` | `text` | NOT NULL, CHECK(result IN ('negative','positive','fading','invalid')) | Test result |
| `line_intensity` | `smallint` | NULL, CHECK(line_intensity >= 0 AND line_intensity <= 100) | Relative intensity if available |
| `photo_path` | `text` | NULL | Local path to test photo |
| `notes` | `text` | NULL | |
| `created_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_opk_user_date` ON `user_id, date`
- `idx_opk_cycle` ON `cycle_id`
- `idx_opk_result` ON `result`

**RLS Policy:**
```sql
CREATE POLICY opk_user_isolation ON ovulation_tests
  FOR ALL USING (auth.uid() = user_id);
```

**Relationships:**
- One user has many OPK records
- Belongs to one cycle

---

## 9. Table: `cervical_mucus_observations`

Cervical mucus tracking records.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `cycle_day_id` | `uuid` | NOT NULL, FK → cycle_days.id ON DELETE CASCADE | Associated cycle day |
| `type` | `text` | NOT NULL, CHECK(type IN ('dry','sticky','creamy','watery','egg_white')) | Mucus type |
| `consistency` | `text` | NULL, CHECK(consistency IN ('none','scant','light','moderate','heavy')) | Amount |
| `color` | `text` | NULL, CHECK(color IN ('clear','white','yellow','pink','brown','green','gray')) | Color |
| `texture` | `text` | NULL, CHECK(texture IN ('smooth','lumpy','stretchy','thin','thick','sticky')) | Texture |
| `sensation` | `text` | NULL, CHECK(sensation IN ('dry','damp','wet','slippery','lubricative')) | Vaginal sensation |
| `photo_path` | `text` | NULL | Local path to photo |
| `notes` | `text` | NULL | |
| `created_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_cm_cycle_day` ON `cycle_day_id` UNIQUE (one observation per day)
- `idx_cm_type` ON `type`

**RLS Policy:**
```sql
CREATE POLICY cm_user_isolation ON cervical_mucus_observations
  FOR ALL USING (
    EXISTS (SELECT 1 FROM cycle_days JOIN cycles ON cycles.id = cycle_days.cycle_id WHERE cycle_days.id = cervical_mucus_observations.cycle_day_id AND cycles.user_id = auth.uid())
  );
```

---

## 10. Table: `pregnancies`

Pregnancy tracking records.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `conception_date` | `date` | NULL | Estimated conception |
| `estimated_due_date` | `date` | NOT NULL | EDD from LMP or ultrasound |
| `lmp_date` | `date` | NOT NULL | Last menstrual period start |
| `current_week` | `smallint` | NULL, CHECK(current_week >= 1 AND current_week <= 42) | Current pregnancy week |
| `current_trimester` | `smallint` | NULL, CHECK(current_trimester IN (1, 2, 3)) | 1st, 2nd, 3rd |
| `ultrasound_dates` | `jsonb` | DEFAULT '[]' | [{date, weeks, days, crl_mm}] |
| `baby_count` | `smallint` | DEFAULT 1, CHECK(baby_count >= 1 AND baby_count <= 4) | Singleton, twins, etc. |
| `due_date_adjusted` | `boolean` | DEFAULT false | Whether adjusted from ultrasound |
| `status` | `text` | DEFAULT 'active', CHECK(status IN ('active','completed','miscarriage','stillbirth')) | Pregnancy outcome |
| `notes` | `text` | NULL | |
| `is_active` | `boolean` | DEFAULT true | Current active pregnancy |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_pregnancy_user` ON `user_id` WHERE `is_active = true`
- `idx_pregnancy_due_date` ON `estimated_due_date`

**RLS Policy:**
```sql
CREATE POLICY pregnancy_user_isolation ON pregnancies
  FOR ALL USING (auth.uid() = user_id);
```

**Relationships:**
- One user has many pregnancies (over time)
- Has many fetal_measurements

---

## 11. Table: `fetal_measurements`

Vitals and measurements logged during pregnancy.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `pregnancy_id` | `uuid` | NOT NULL, FK → pregnancies.id ON DELETE CASCADE | Parent pregnancy |
| `date` | `date` | NOT NULL | Measurement date |
| `pregnancy_week` | `smallint` | NOT NULL | Week at measurement |
| `weight_kg` | `decimal(5,2)` | NULL | Maternal weight |
| `blood_pressure_systolic` | `smallint` | NULL, CHECK(blood_pressure_systolic >= 60 AND blood_pressure_systolic <= 250) | Systolic BP |
| `blood_pressure_diastolic` | `smallint` | NULL, CHECK(blood_pressure_diastolic >= 30 AND blood_pressure_diastolic <= 150) | Diastolic BP |
| `glucose_level_mgdl` | `smallint` | NULL | Blood glucose |
| `kicks_count` | `smallint` | NULL | Daily kick count |
| `kicks_duration_minutes` | `smallint` | NULL | Time to reach kick count |
| `contractions_data` | `jsonb` | NULL | [{start_time, duration_seconds, intensity}] |
| `fundal_height_cm` | `decimal(4,1)` | NULL | Fundal height |
| `fetal_heart_rate` | `smallint` | NULL, CHECK(fetal_heart_rate >= 60 AND fetal_heart_rate <= 220) | FHR bpm |
| `ultrasound_weight_g` | `smallint` | NULL, CHECK(ultrasound_weight_g >= 0) | Estimated fetal weight |
| `notes` | `text` | NULL | |
| `created_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_fetal_meas_pregnancy` ON `pregnancy_id`
- `idx_fetal_meas_week` ON `pregnancy_week`

**RLS Policy:**
```sql
CREATE POLICY fetal_meas_user_isolation ON fetal_measurements
  FOR ALL USING (
    EXISTS (SELECT 1 FROM pregnancies WHERE pregnancies.id = fetal_measurements.pregnancy_id AND pregnancies.user_id = auth.uid())
  );
```

---

## 12. Table: `journal_entries`

Personal journal entries linked to cycle days.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `cycle_day_id` | `uuid` | NULL, FK → cycle_days.id ON DELETE SET NULL | Optional link to cycle day |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `title` | `text` | NULL | Entry title |
| `content` | `text` | NOT NULL | Journal body |
| `mood` | `text` | NULL, CHECK(mood IN ('very_sad','sad','neutral','happy','very_happy','anxious','angry','calm')) | Mood emoji/indicator |
| `tags` | `text[]` | DEFAULT '{}' | Searchable tags |
| `photo_paths` | `jsonb` | DEFAULT '[]' | Local paths to attached photos |
| `voice_note_path` | `text` | NULL | Local path to voice recording |
| `voice_note_duration` | `smallint` | NULL | Duration in seconds |
| `is_favorite` | `boolean` | DEFAULT false | Bookmarked entry |
| `created_at` | `timestamptz` | NOT NULL DEFAULT now() | Entry timestamp |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_journal_user_date` ON `user_id, created_at DESC`
- `idx_journal_cycle_day` ON `cycle_day_id`
- `idx_journal_mood` ON `mood`
- `idx_journal_tags` USING GIN ON `tags`
- `idx_journal_favorite` ON `is_favorite` WHERE `is_favorite = true`

**RLS Policy:**
```sql
CREATE POLICY journal_user_isolation ON journal_entries
  FOR ALL USING (auth.uid() = user_id);
```

---

## 13. Table: `user_conditions`

Tracked health conditions for condition-specific features.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `condition_type` | `text` | NOT NULL, CHECK(condition_type IN ('pcos','endometriosis','pmdd','adenomyosis','fibroids','thyroid','menopause','other')) | Condition identifier |
| `custom_condition_name` | `text` | NULL, | If condition_type = 'other' |
| `diagnosis_date` | `date` | NULL | When diagnosed |
| `is_self_diagnosed` | `boolean` | DEFAULT false | Self-reported vs. clinical |
| `severity` | `text` | NULL, CHECK(severity IN ('mild','moderate','severe')) | Self-reported severity |
| `treatments` | `jsonb` | DEFAULT '[]' | [{name, type, start_date, end_date, notes}] |
| `notes` | `text` | NULL | |
| `is_active` | `boolean` | DEFAULT true | |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_conditions_user` ON `user_id`
- `idx_conditions_type` ON `condition_type`

**RLS Policy:**
```sql
CREATE POLICY conditions_user_isolation ON user_conditions
  FOR ALL USING (auth.uid() = user_id);
```

---

## 14. Table: `wearable_sources`

Connected wearable device metadata.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `source_type` | `text` | NOT NULL, CHECK(source_type IN ('apple_watch','fitbit','garmin','oura','oneplus','oppo','redmi','google_fit','samsung_health','other')) | Device type |
| `device_name` | `text` | NULL | User-facing device name |
| `is_connected` | `boolean` | DEFAULT false | Connection status |
| `last_sync_at` | `timestamptz` | NULL | Last successful sync |
| `last_sync_status` | `text` | NULL, CHECK(last_sync_status IN ('success','failed','in_progress','pending')) | Sync status |
| `scopes_granted` | `text[]` | DEFAULT '{}' | Data permissions granted |
| `error_message` | `text` | NULL | Last error message |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_wearable_user` ON `user_id`

**RLS Policy:**
```sql
CREATE POLICY wearable_user_isolation ON wearable_sources
  FOR ALL USING (auth.uid() = user_id);
```

---

## 15. Table: `education_articles`

Content for the Education Hub.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `title` | `text` | NOT NULL | Article title |
| `slug` | `text` | NOT NULL UNIQUE | URL-friendly identifier |
| `content` | `text` | NOT NULL | Full article content (Markdown) |
| `excerpt` | `text` | NOT NULL | Short summary (~150 chars) |
| `category` | `text` | NOT NULL, CHECK(category IN ('cycle_basics','fertility','pregnancy','conditions','nutrition','exercise','mental_health','general')) | Topic category |
| `subcategory` | `text` | NULL | Further categorization |
| `tags` | `text[]` | DEFAULT '{}' | Search tags |
| `related_condition` | `text` | NULL | Condition this article relates to |
| `read_time_minutes` | `smallint` | NOT NULL | Estimated reading time |
| `is_offline_available` | `boolean` | DEFAULT false | Available for offline download |
| `is_featured` | `boolean` | DEFAULT false | Featured on home screen |
| `icon` | `text` | NULL | Category icon |
| `cover_image_url` | `text` | NULL | Hero image |
| `medical_review_date` | `date` | NULL | Last medical review |
| `medical_reviewer_name` | `text` | NULL | Reviewer credentials |
| `sources` | `jsonb` | DEFAULT '[]' | [{title, url, author}] |
| `difficulty_level` | `text` | DEFAULT 'beginner', CHECK(difficulty_level IN ('beginner','intermediate','advanced')) | Reading difficulty |
| `is_published` | `boolean` | DEFAULT false | Published status |
| `sort_order` | `smallint` | DEFAULT 0 | Display order |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_articles_category` ON `category`
- `idx_articles_condition` ON `related_condition`
- `idx_articles_featured` ON `is_featured` WHERE `is_published = true`
- `idx_articles_tags` USING GIN ON `tags`
- `idx_articles_offline` ON `is_offline_available`

**RLS Policy:**
```sql
CREATE POLICY articles_read ON education_articles
  FOR SELECT USING (is_published = true);
CREATE POLICY articles_admin ON education_articles
  FOR ALL USING (auth.role() = 'service_role');
```

---

## 16. Table: `community_posts`

Anonymous community discussion posts.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Author |
| `topic_id` | `text` | NOT NULL, CHECK(topic_id IN ('general','ttc','pregnancy','pcos','endometriosis','pmdd','teens','new_moms')) | Topic group |
| `title` | `text` | NOT NULL | Post title |
| `content` | `text` | NOT NULL | Post body |
| `is_anonymous` | `boolean` | DEFAULT true | Whether author name hidden |
| `is_moderated` | `boolean` | DEFAULT false | Flags for moderation review |
| `moderation_status` | `text` | DEFAULT 'pending', CHECK(moderation_status IN ('pending','approved','rejected','flagged')) | Moderation state |
| `moderation_reason` | `text` | NULL | Reason if rejected/flagged |
| `upvote_count` | `integer` | DEFAULT 0, CHECK(upvote_count >= 0) | Upvote tally |
| `reply_count` | `integer` | DEFAULT 0, CHECK(reply_count >= 0) | Reply tally |
| `is_pinned` | `boolean` | DEFAULT false | Pinned by moderators |
| `is_locked` | `boolean` | DEFAULT false | Locked from further replies |
| `created_at` | `timestamptz` | DEFAULT now() | |
| `updated_at` | `timestamptz` | DEFAULT now() | |
| `deleted_at` | `timestamptz` | NULL | Soft delete |

**Indexes:**
- `idx_posts_topic` ON `topic_id`
- `idx_posts_created` ON `created_at DESC`
- `idx_posts_moderation` ON `moderation_status` WHERE `moderation_status != 'approved'`
- `idx_posts_hot` ON `upvote_count DESC, created_at DESC`

**RLS Policy:**
```sql
CREATE POLICY posts_select ON community_posts
  FOR SELECT USING (moderation_status = 'approved' OR user_id = auth.uid());
CREATE POLICY posts_insert ON community_posts
  FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY posts_update ON community_posts
  FOR UPDATE USING (user_id = auth.uid() OR auth.role() = 'service_role');
CREATE POLICY posts_delete ON community_posts
  FOR DELETE USING (user_id = auth.uid());
```

**Relationships:**
- Has many replies (in replies table, not detailed here)

---

## 17. Table: `health_reports`

Generated PDF health reports.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `report_type` | `text` | NOT NULL, CHECK(report_type IN ('cycle_history','symptom_summary','fertility_analysis','pregnancy_progress','full_health')) | Report kind |
| `title` | `text` | NULL | Report title |
| `date_range_start` | `date` | NOT NULL | Report start date |
| `date_range_end` | `date` | NOT NULL | Report end date |
| `parameters` | `jsonb` | NULL | Report generation parameters |
| `file_path` | `text` | NULL | Path to generated PDF |
| `file_size_bytes` | `integer` | NULL | PDF file size |
| `is_encrypted` | `boolean` | DEFAULT true | Whether PDF is encrypted |
| `share_count` | `smallint` | DEFAULT 0 | Number of times shared |
| `generation_status` | `text` | DEFAULT 'pending', CHECK(generation_status IN ('pending','generating','completed','failed')) | Generation state |
| `error_message` | `text` | NULL | Error if failed |
| `created_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_reports_user` ON `user_id`
- `idx_reports_type` ON `report_type`

**RLS Policy:**
```sql
CREATE POLICY reports_user_isolation ON health_reports
  FOR ALL USING (auth.uid() = user_id);
```

---

## 18. Table: `app_settings`

User preferences and app configuration.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `uuid` | PK, DEFAULT uuid_generate_v4() | |
| `user_id` | `uuid` | NOT NULL, FK → auth.users.id | Owner |
| `key` | `text` | NOT NULL | Setting key |
| `value` | `jsonb` | NOT NULL | Setting value |
| `updated_at` | `timestamptz` | DEFAULT now() | |

**Indexes:**
- `idx_settings_user_key` ON `user_id, key` UNIQUE

**RLS Policy:**
```sql
CREATE POLICY settings_user_isolation ON app_settings
  FOR ALL USING (auth.uid() = user_id);
```

---

## 19. Drift (Local) Schema Notes

The local Drift schema mirrors this PostgreSQL schema with the following adjustments:

| Aspect | PostgreSQL | Drift (SQLite) |
|--------|-----------|----------------|
| Primary Key | UUID v4 | `INTEGER AUTOINCREMENT` for efficiency |
| User ID | UUID, FK to auth.users | `TEXT` (stored after auth) |
| `jsonb` columns | Native JSON support | `String` stored as JSON text, parsed with converters |
| `text[]` arrays | Native array support | `String` stored as comma-separated or JSON |
| Timestamps | `timestamptz` | `DateTime` |
| RLS | PostgreSQL RLS policies | Not applicable (single-user local DB) |
| Foreign Keys | Explicit FK constraints | Drift managed by reference annotations |
| Migrations | Supabase migration SQL | Drift `MigrationStrategy` with `schemaVersion` |

### 19.1 Drift Table Generation Pattern

```dart
// Example Drift table definition (conceptual)
class Cycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()(); // Maps to Supabase UUID
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn? get endDate => dateTime().nullable()();
  IntColumn get cycleLength => integer().nullable()();
  // ... other columns
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

## 20. Migration Strategy

### 20.1 Supabase Migrations

```sql
-- Example: 001_create_cycles_table.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE cycles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  -- ... other columns
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_cycles_user_id ON cycles(user_id);
CREATE POLICY cycle_user_isolation ON cycles FOR ALL USING (auth.uid() = user_id);
```

### 20.2 Drift Migrations

```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: stepByStep(
      from1To2: (Migrator m, SchemaVerifier v) async {
        await m.addColumn(cycles, cycles.ovulationDay);
      },
      // future migrations...
    ),
  );
}
```

---

## 21. Data Archival & Purging

| Data Type | Retention | Action |
|-----------|-----------|--------|
| Active cycles | Until user deletes | Keep |
| Past cycles | Forever | Keep for analysis |
| Deleted cycles | 30 days | Soft delete, then hard delete |
| Journal entries | Forever | Kept until user deletes |
| Photos | Forever | Local only, deleted with journal |
| Community posts | Forever | Soft delete on user account deletion |
| Health reports | Forever | Kept until user deletes |
| Education articles | As published | Updated with new versions |
| App settings | Forever | Keep |
| Analytics | 12 months | Anonymized, then deleted |
| Sync queue | Until synced | Deleted after successful sync |
| Audit logs | 90 days | Rotated |
