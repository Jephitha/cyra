# Cyra — Implementation Plan

> **Personal Health Companion · Women's Health Operating System**
> Periods · Fertility · Pregnancy · Symptoms · Hormones · Wellness

---

## 1. Executive Summary

Cyra is a production-grade women's health platform for Android (primary) and iOS (simultaneous). It replaces fragmented tools (Clue, Flo, Apple Health, Ovia, Natural Cycles) with a single, explainable, privacy-first operating system for the female body. Cyra tracks cycles, ovulation, pregnancy, symptoms, hormones, and conditions (PCOS, endometriosis, PMDD) while providing on-device AI predictions and personalized wellness insights — all backed by auditable, evidence-based reasoning.

The app follows a **local-first architecture**: all health data resides in an AES-256 encrypted SQLite database on-device. A Supabase backend provides optional encrypted sync, zero-knowledge auth, and community features. Every ML prediction includes a plain-English explanation of *why* the model produced that output (feature importance, cycle context).

Cyra ships as a single codebase (Flutter 3.44 / Dart 3.12) targeting 78 days of phased delivery.

---

## 2. Core Philosophy

| Principle | Implementation |
|---|---|
| **Explainability over black-box** | Every ML prediction surfaces SHAP-style feature contributions. No opaque scores. |
| **Privacy-first** | Local-first storage. Sync is opt-in and zero-knowledge. Biometric & PIN locks. |
| **Local-first** | Full offline capability. Drift + SQLCipher for encrypted SQLite. Supabase is a sync target, not a dependency. |
| **Evidence-based** | Cycle predictions use symptom-thermal-bleeding triangulation, published fertility-awareness methods (Doering, Sensiplan, Marquette). No pseudo-science. |
| **Accessibility** | WCAG AA typography, variable font, screen-reader compatible, reduced-motion support. |
| **User sovereignty** | Full data export (JSON + CSV). Account deletion wipes all remote data irreversibly. |

---

## 3. Target Users

### Primary demographic
- Women and people with cycles, ages 13–45

### Specific cohorts
| Cohort | Needs |
|---|---|
| **TTC (Trying to Conceive)** | Ovulation prediction, fertile window, intercourse logging, pregnancy test tracking |
| **Pregnant** | Trimester tracking, kick counter, contraction timer, appointment log |
| **Postpartum** | Lochia tracking, breastfeeding log, period return prediction |
| **PCOS** | Cycle irregularity markers, symptom clusters (hirsutism, acne, hair loss), insulin-resistance adjacencies |
| **Endometriosis** | Pain mapping, bleeding patterns, treatment efficacy tracking |
| **PMDD** | Symptom severity scoring, luteal-phase tracking, treatment calendar |
| **Perimenopause** | Cycle-length variability, hot-flash logging, hormone trend reports |
| **Contraception users** | Pill/IUD/implant logging, breakthrough bleeding tracking, method reminders |

---

## 4. Technical Stack

### Core Framework
| Technology | Version | Purpose |
|---|---|---|
| Flutter | 3.44 | Cross-platform UI |
| Dart | 3.12 | Application language |
| Riverpod | 3.x (code-gen) | State management + dependency injection |
| Drift | 2.x | Local SQLite ORM |
| SQLCipher | 4.x | AES-256 SQLite encryption |
| Supabase Dart | 2.x | Auth, PostgreSQL, Realtime, Edge Functions |
| TensorFlow Lite | 2.x | On-device ML inference |
| fl_chart | 0.70+ | Cycle/health visualizations |
| health | 11.x | Wearable & Health Connect data |
| go_router | 14.x | Declarative routing |
| freezed | 3.x | Immutable data classes |
| json_serializable | 6.x | JSON serialization |
| flutter_local_notifications | 18.x | Reminders & alerts |
| shared_preferences / secure_storage | — | Key-value + credential storage |

### Backend (Supabase)
| Service | Purpose |
|---|---|
| PostgreSQL (with pgcrypto) | Primary remote database |
| Row-Level Security (RLS) | Per-user data isolation |
| Realtime | Live sync subscriptions |
| Edge Functions (Deno) | Server-side logic (export, anonymized aggregation) |
| Storage | Optional photo/symptom image backup (E2EE) |
| Auth (GoTrue) | Email + OAuth (Google, Apple) |

### CI/CD & Quality
- **Testing**: flutter_test, mocktail, drift_test, widget_test
- **Linting**: Dart fix + custom analysis_options.yaml
- **CI**: GitHub Actions (lint → unit → widget → integration)
- **Code generation**: build_runner (riverpod_generator, drift_generator, freezed, json_serializable)

---

## 5. Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        UI LAYER (Widgets)                           │
│  Screens · Dialogs · Bottom Sheets · Custom Painters · Animations  │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ ref.watch / ref.listen
┌───────────────────────────▼─────────────────────────────────────────┐
│                     STATE LAYER (Riverpod)                          │
│  Providers · Notifiers · Streams · Code-gen (riverpod_generator)   │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │              USE CASES / APPLICATION SERVICES                │   │
│  │  PredictionService · SyncService · ExportService · AuthGate │   │
│  └──────────────────────────────────────────────────────────────┘   │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────────┐
│                     DOMAIN LAYER (Pure Dart)                        │
│  Entities · Value Objects · Repository Interfaces · Domain Errors  │
│  Prediction Models · Fertility Algorithms · Cycle Math             │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
        ┌───────────────────┴───────────────────┐
        │                                       │
┌───────▼────────┐                    ┌─────────▼────────┐
│  LOCAL (Drift)   │                    │  REMOTE (Supabase)│
│  SQLCipher       │◄─── optional ───►│  PostgreSQL + RLS │
│  AES-256         │     sync service │  Edge Functions   │
│  Full offline    │                    │  Realtime         │
└──────────────────┘                    └──────────────────┘
```

### Data flow
1. All writes go to **local Drift DB first** (encrypted SQLite)
2. Sync service observes local changes and pushes to Supabase (device-side encryption for sensitive fields)
3. Remote changes via Realtime are applied locally (CRDT-inspired merge: last-write-wins with timestamp vector)
4. Reads always resolve from local DB (instant, offline-capable)
5. ML inference runs on-device via TFLite; models are downloaded and cached on first sync

---

## 6. Design System

### Color Palette
| Token | Hex | Usage |
|---|---|---|
| `--color-primary` | `#2D5A27` | Forest Green — primary actions, active states |
| `--color-secondary` | `#F5F0E8` | Warm Ivory — backgrounds, cards |
| `--color-accent` | `#C9A84C` | Soft Gold — highlights, premium features |
| `--color-sage` | `#8A9A7D` | Sage — secondary text, decorative elements |
| `--color-charcoal` | `#2C2C2C` | Charcoal — body text |
| `--color-slate` | `#6B7280` | Slate — caption, metadata |
| `--color-mist` | `#F9FAFB` | Mist White — screen backgrounds |
| `--color-error` | `#B91C1C` | Red — errors, alerts |
| `--color-success` | `#166534` | Green — confirmations |

### Typography
- **Font**: Variable font (Inter var or Recursive), weight range 300–700
- **Scale**: 12 / 14 / 16 / 18 / 20 / 24 / 30 / 36 / 48 / 60
- **Line height**: 1.4 (body), 1.2 (headings)
- **Contrast**: All text passes WCAG AA (4.5:1 body, 3:1 large)

### Component Library
All components live in `lib/design/`:
- `CyraButton`, `CyraTextButton`, `CyraIconButton`
- `CyraCard` (elevated, outlined, muted)
- `CyraInput`, `CyraDropdown`, `CyraDatePicker`
- `CyraBottomSheet`, `CyraModal`
- `CyraChip`, `CyraBadge`
- `CyraProgressIndicator` (linear + circular)
- `CyraToggle`, `CyraCheckbox`, `CyraRadio`
- `CyraAppBar`, `CyraTabBar`
- `CyraCalendar` (cycle-aware calendar widget)
- `CyraChart` (wraps fl_chart with theme tokens)

### Theme
- `CyraThemeData` extends `ThemeExtension` — all tokens are typed and hot-reloadable
- Light + Dark mode (dark mode uses inverted primary/surface)
- `CyraTextTheme` with all 10 size variants
- Motion tokens: 200ms standard, 300ms emphasis, 500ms expressive

---

## 7. Implementation Roadmap

### Phase 0 — Foundation & Scaffolding (Days 1–3)

**Deliverables**
- Flutter project scaffolded with all dependencies
- `analysis_options.yaml` with strict lint rules
- Folder structure (feature-first + clean architecture)
- Build configuration (debug/release flavors, app icons, splash screen)
- GitHub Actions CI: lint → test (unit + widget)
- Code generation pipeline (build_runner watch mode)

**Key files**
```
lib/
  main.dart
  app.dart
  bootstrap.dart
  core/
    constants.dart
    error.dart
    logger.dart
    extensions/
  features/
  l10n/ (ARB files for i18n)
test/
  helpers/
  mocks/
```

**Dependencies:** None (greenfield)

**Testing**
- CI pipeline validates: `dart analyze` passes, skeleton app renders
- Smoke test: app launches, shows splash, navigates to error screen if no DB

### Phase 1 — Design System & Theme (Days 4–6)

**Deliverables**
- Full `CyraThemeData` implementation (light + dark)
- All 15+ design components implemented
- Typography system with variable font
- Color tokens as const objects
- `CyraCalendar` widget (base version)
- Storybook-style demo screen (dev-only)

**Key files**
```
lib/design/
  theme/
    cyra_theme.dart
    cyra_colors.dart
    cyra_text_theme.dart
    dark_theme.dart
    light_theme.dart
  components/
    cyra_button.dart
    cyra_card.dart
    cyra_input.dart
    cyra_calendar.dart
    ...
  tokens/
    motion.dart
    spacing.dart
    radius.dart
```

**Dependencies:** Phase 0

**Testing**
- Widget tests for every component (variants + states)
- Golden tests for key screens (light + dark)
- Accessibility tests (contrast ratio, touch targets, label presence)

### Phase 2 — Core Data Layer (Days 7–10)

**Deliverables**
- Drift database schema with all core tables
- SQLCipher encryption layer (AES-256, key derived from device + user PIN)
- Migration system (versioned, with rollback support)
- Repository interfaces and implementations (local only)
- `DatabaseService` singleton with lifecycle management
- All entities as freezed classes

**Database tables (Phase 2 scope)**
```
users
cycles (menstrual cycles)
period_days (daily bleeding intensity)
symptoms (symptom type, severity, timestamp)
tags (user-defined labels)
pregnancy_tests (test date, result, HCG sensitivity)
intercourse (timestamp, protected/unprotected)
medications (med name, dose, schedule)
devices (paired wearable info)
sync_log (sync audit trail)
```

**Key files**
```
lib/core/database/
  database.dart (Drift Database class)
  database_config.dart (encryption setup)
  migrations/
  dao/ (CRUD for each table)
lib/features/cycle/data/
  models/
  repositories/
```

**Dependencies:** Phase 1 (components for debug DB viewer)

**Testing**
- Unit tests for all DAOs (CRUD operations)
- Migration test (v1 → v2 → rollback)
- Encryption test (verify DB is unreadable without key)
- Performance test (100k rows, query latency)

### Phase 3 — Auth & Privacy Layer (Days 11–14)

**Deliverables**
- Supabase Auth integration (email + magic link, Google, Apple)
- Biometric lock (local_auth) + PIN fallback
- Emergency privacy lock (single button → blank screen + app switcher blur)
- Hidden mode (app icon disguises as "Calculator" on Android)
- Zero-knowledge sync: device key encrypts sensitive fields before upload
- RLS policies for all Supabase tables
- Account creation, deletion, session management
- Onboarding flow (welcome → auth → permissions → privacy disclaimer)

**Key files**
```
lib/features/auth/
  data/
    supabase_auth_repository.dart
  domain/
    auth_repository_interface.dart
  presentation/
    screens/
      login_screen.dart
      signup_screen.dart
    providers/
      auth_provider.dart
lib/features/privacy/
  biometric_lock.dart
  emergency_lock.dart
  hidden_mode.dart
  sync_encryption.dart
lib/core/security/
  key_derivation.dart
  secure_storage_helper.dart
```

**Dependencies:** Phase 2 (user table, DB encryption key from auth)

**Testing**
- Auth flow tests (signup, login, logout, token refresh, session persistence)
- Biometric failure → PIN fallback → account lockout
- Emergency lock activates in <200ms
- Hidden mode icon verified on Android
- RLS policy audit (verify user cannot read another user's rows)
- Security: attempt SQL injection on auth endpoints

### Phase 4 — Period Tracker (Days 15–25)

**Deliverables**
- Period logging screen (flow intensity selector: spotting/light/medium/heavy/clot)
- Cycle calendar view (cycle day highlighting, period prediction shading)
- Customizable cycle length (27-day default, per-user adaptive)
- Period prediction algorithm (Doering + Bayesian update on last 6 cycles)
- Cycle history list with edit/delete
- Quick-log widget (Android homescreen)
- Push notification: "Period predicted in 2 days"
- Flow chart (cycle length trend, period duration trend)

**Key files**
```
lib/features/period_tracker/
  presentation/
    screens/
      period_log_screen.dart
      cycle_calendar_screen.dart
      cycle_detail_screen.dart
      cycle_history_screen.dart
    widgets/
      flow_selector.dart
      cycle_day_tile.dart
      prediction_banner.dart
    providers/
      cycle_provider.dart
      prediction_provider.dart
  domain/
    cycle_entity.dart
    period_day_entity.dart
    cycle_predictor.dart
  data/
    cycle_repository.dart
    cycle_dao.dart
```

**Dependencies:** Phase 2 (database), Phase 3 (auth for sync)

**Testing**
- Cycle prediction accuracy against synthetic data (100+ simulated cycles)
- Flow selector: all intensity levels selectable, haptic feedback on long press
- Calendar: correct cycle day numbering, prediction shading accuracy
- Log period → verify DB write → verify calendar update
- Edit logged period → verify recalculation
- Delete cycle → verify cascade to period_days
- Notifications fire at correct cycle day

### Phase 5 — Ovulation & Fertility (Days 26–35)

**Deliverables**
- BBT (basal body temperature) logging with chart
- Cervical mucus logging (types: dry/sticky/creamy/egg-white/watery)
- Ovulation prediction using symptothermal method (Sensiplan rules)
- Fertile window calculation (5 days before ovulation + 1 day after)
- Intercourse logging (with protection status)
- Ovulation test (LH strip) logging + photo capture
- Daily fertile status indicator (low/high/peak)
- Prediction explanation panel (why today is predicted as fertile)
- Calendar overlay: fertile window, ovulation day, intercourse markers

**Key files**
```
lib/features/ovulation/
  presentation/
    screens/
      bbt_log_screen.dart
      mucus_log_screen.dart
      fertile_window_screen.dart
    widgets/
      bbt_chart.dart (coverline, thermal shift)
      mucus_selector.dart
      fertile_status_badge.dart
    providers/
      ovulation_provider.dart
      fertile_window_provider.dart
  domain/
    bbt_entity.dart
    mucus_entity.dart
    fertile_window_calculator.dart
    symptothermal_algorithm.dart
  data/
    bbt_repository.dart
    mucus_repository.dart
```

**Dependencies:** Phase 4 (cycle data feeds ovulation algorithm)

**Testing**
- Symptothermal algorithm validated against published Sensiplan reference data
- BBT chart renders coverline correctly at 0.05°F above previous 6 temperatures
- Fertile window matches expected output for 50 synthetic cycles
- LH surge detection from log entries
- Mucus type selection → correct fertile classification
- Explanation panel shows correct rule that triggered (temperature shift / mucus peak / LH surge)

### Phase 6 — Pregnancy Tracker (Days 36–42)

**Deliverables**
- Pregnancy mode activation (positive test → pregnancy timeline)
- Trimester overview dashboard
- Week-by-week tracker (gestational age, fetal development milestones)
- Due date calculator (LMP + EDD, adjustable)
- Kick counter (tap-to-count with timer)
- Contraction timer (frequency + duration logging)
- Appointment log (OB visits, test results, notes)
- Weight tracking (with recommended range chart)
- Pregnancy symptom logging (nausea, fatigue, cravings, etc.)
- Nutrition & supplement reminders (prenatal vitamins, folate, iron)
- Privacy toggle: hide pregnancy from community profile

**Key files**
```
lib/features/pregnancy/
  presentation/
    screens/
      pregnancy_dashboard.dart
      week_by_week_screen.dart
      kick_counter_screen.dart
      contraction_timer_screen.dart
      appointment_log_screen.dart
      weight_tracker_screen.dart
    widgets/
      due_date_banner.dart
      trimester_progress.dart
      kick_chart.dart
    providers/
      pregnancy_provider.dart
      kick_counter_provider.dart
      contraction_timer_provider.dart
  domain/
    pregnancy_entity.dart
    due_date_calculator.dart
    gestational_age_calculator.dart
  data/
    pregnancy_repository.dart
```

**Dependencies:** Phase 4–5 (pregnancy triggered from cycle data / test result)

**Testing**
- Due date calculation matches Naegele's rule (±1 day)
- Kick counter: timer accuracy, count persistence across app restart
- Contraction timer: start/stop, duration calculation, log export
- Week-by-week: correct week for given gestational age
- Weight chart: correct percentile rendering against WHO reference data
- Pregnancy mode disables period/ovulation tracking (temporarily)

### Phase 7 — Symptoms, Journal & Reports (Days 42–48)

**Deliverables**
- Symptom logging dashboard (pain, mood, digestive, skin, energy, etc.)
- Custom symptom creation (name, scale type, icons)
- Symptom severity scale (1–5 visual slider + emoji)
- Symptom → cycle day correlation charts
- Freeform journal entries (Markdown-capable, with mood tag)
- Journal → cycle day linking (see journal entry for specific cycle day)
- PDF report generation (monthly summary: cycle stats, symptoms, moods)
- CSV/JSON export (full data or date range)
- Report sharing (airdrop, email, print)

**Key files**
```
lib/features/symptoms/
  presentation/
    screens/
      symptom_log_screen.dart
      symptom_detail_screen.dart
      symptom_trend_chart.dart
    widgets/
      symptom_selector.dart
      severity_slider.dart
    providers/
      symptom_provider.dart
      symptom_insight_provider.dart
  domain/
    symptom_entity.dart
    symptom_aggregator.dart
  data/
    symptom_repository.dart
lib/features/journal/
  ... (similar structure)
lib/features/reports/
  ... (export/report generation)
```

**Dependencies:** Phases 4–5 (cycle data for correlation)

**Testing**
- Log 50 symptoms → verify trend chart renders
- Custom symptom created → persisted → appears in selector
- Journal entry links to correct cycle day
- PDF report generated from 3-month synthetic data → verify all sections present
- CSV export → import to Google Sheets → verify columns match schema
- Symptom → cycle correlation chart shows correct aggregation

### Phase 8 — AI Insights & Smart Prediction (Days 49–58)

**Deliverables**
- On-device TFLite model for cycle prediction (input: last 6 cycles, BBT, symptoms, LH)
- Prediction explanation engine (SHAP-inspired feature contribution)
- Personalized cycle-length prediction (adaptive Bayesian)
- Ovulation day confidence score (high/medium/low + reasoning)
- Anomaly detection (unusual bleeding, cycle length outliers, symptom clusters)
- Natural language insights ("Your luteal phase was 3 days shorter than usual this cycle")
- Model update mechanism (download new TFLite models from Supabase)
- A/B test framework for prediction model versions
- Insight card widget on home screen

**Key files**
```
lib/features/ai/
  presentation/
    widgets/
      insight_card.dart
      prediction_explanation_sheet.dart
    providers/
      insight_provider.dart
      prediction_model_provider.dart
  domain/
    cycle_predictor.dart
    insight_generator.dart
    anomaly_detector.dart
    explanation_engine.dart
  data/
    tflite_model_manager.dart
    model_downloader.dart
    feature_extractor.dart
lib/ml/
  models/
    cycle_predictor.tflite
    anomaly_detector.tflite
  training/
    (Jupyter notebooks for model training — not shipped in app)
```

**Dependencies:** Phases 4–5 (training data from cycle + ovulation), Phase 7 (symptom data)

**Testing**
- Prediction accuracy: mean absolute error ≤ 1.5 days for next period start
- Explanation engine: verify each output includes ≥3 contributing features
- Anomaly detection: known outlier cycles flagged correctly (95%+ recall)
- Model download → fallback to bundled model on network failure
- A/B test: identical predictions from both model versions
- Cold start: no prior data → evidence-based defaults, not random guesses

### Phase 9 — Conditions, Education, Community (Days 59–68)

**Deliverables**
- Condition-specific tracking modes (PCOS, Endo, PMDD, fibroids, etc.)
- Condition onboarding questionnaire (diagnosis confirmation, symptom presets)
- PCOS: cycle irregularity markers, hirsutism logging, insulin-resistance proxy tracking
- Endometriosis: pain mapping (body diagram), bleeding severity, treatment log
- PMDD: daily symptom severity scoring (DSM-5 aligned), luteal-phase tracking
- Treatment efficacy reports (symptom score before/after intervention)
- Education hub (articles organized by condition + cycle phase)
- Evidence-based content updated via Supabase CMS
- Community (anonymous optional): topic-based discussion, upvoted Q&A
- Expert Q&A (moderated, verified professionals)
- Privacy: anonymous posting, block/report, content warnings

**Key files**
```
lib/features/conditions/
  presentation/
    screens/
      condition_hub_screen.dart
      pcos_dashboard.dart
      endo_dashboard.dart
      pmdd_dashboard.dart
      pain_map_widget.dart
    providers/
      condition_provider.dart
  domain/
    condition_entity.dart
    condition_protocols.dart
    pcos_markers.dart
    endo_pain_score.dart
  data/
    condition_repository.dart
lib/features/education/
  ...
lib/features/community/
  ...
```

**Dependencies:** Phases 4–7 (condition tracking builds on symptom/cycle data)

**Testing**
- PCOS dashboard: irregular cycle markers match stored cycle data
- Endo pain map: tap on body region → logs correct anatomical location
- PMDD score threshold (≥20 on Daily Record of Severity of Problems) triggers insight card
- Treatment report: pre/post symptom comparison calculates correct delta
- Education articles render from CMS (offline cache on first load)
- Community: post created → visible to self → visible to others (with RLS)

### Phase 10 — Wearables, App Store & Polish (Days 69–78)

**Deliverables**
- Health Connect (Android) integration: read steps, HRV, sleep, resting HR
- Apple Health (iOS) integration: identical data reads
- Wear OS companion app (basic: cycle day glance, quick-log period)
- Oura ring integration (via Oura Cloud API, user-authorised)
- Fitbit integration (via Fitbit Web API)
- Data import (Clue, Flo, Apple Health export CSV)
- App store assets: screenshots (6.7" + 5.5" + iPad), preview video, description
- Landing page / marketing site
- Privacy policy + terms of service (lawyer-reviewed)
- Beta testing (TestFlight + Firebase App Distribution)
- Performance audit (GPU rasterizer, shader warmup, app size)
- Crash reporting + analytics (optional, opt-in, privacy-first)
- Final accessibility audit (VoiceOver + TalkBack)

**Key files**
```
lib/features/wearables/
  data/
    health_connect_bridge.dart
    apple_health_bridge.dart
    oura_bridge.dart
    fitbit_bridge.dart
  domain/
    wearable_data_entity.dart
    wearable_sync_service.dart
lib/features/import/
  ...
assets/store/
  screenshots/
  preview.mp4
```

**Dependencies:** All prior phases (wearable data enhances predictions)

**Testing**
- Health Connect: read steps, verify against phone pedometer
- Oura API: OAuth flow, read sleep/HRV, map to cycle day
- CSV import: 12 months of Clue export → verify all periods transferred
- App size ≤ 150 MB (AAB)
- Cold start time ≤ 2s on Pixel 7 / iPhone 14
- GPU frame rate: 60fps on cycle calendar (scroll test)

---

## 8. Testing Strategy (Cross-Phase)

| Level | Tool | Scope |
|---|---|---|
| Unit | `flutter_test` + `mocktail` | Domain logic, calculators, algorithms, repositories |
| Widget | `flutter_test` | Component rendering, interaction, states |
| Golden | `alchemist` / `golden_toolkit` | Visual regression for every component |
| Integration | `integration_test` | Full flows: log period → see prediction → sync to cloud |
| Security | Manual + automated (OWASP ZAP) | RLS audit, encryption verification, MITM testing |
| Performance | Flutter DevTools + baseline | Frame rate, memory, startup time, DB query latency |
| Accessibility | `flutter_test` (semantics) + manual | WCAG AA: contrast, labels, touch targets |

---

## 9. Application Modules (14 Modules)

| # | Module | Description |
|---|---|---|
| 1 | **Period Tracker** | Log flow intensity, track cycle length, predict next period. Adaptive algorithm. Phase 4. |
| 2 | **Ovulation Tracker** | BBT, cervical mucus, LH strips. Sensiplan symptothermal rules. Phase 5. |
| 3 | **Fertility Planning** | Fertile window, intercourse timing, TTC dashboard. Phase 5. |
| 4 | **Pregnancy Tracker** | Week-by-week, kick counter, contraction timer, due date. Phase 6. |
| 5 | **Symptom Tracker** | Log 50+ symptoms, custom symptoms, severity scale, cycle correlation. Phase 7. |
| 6 | **Hormone Insights** | Estrogen/progesterone proxy from BBT + mucus patterns. Cycle-phase hormone education. Phase 8. |
| 7 | **Conditions Support** | PCOS, Endo, PMDD, fibroids, perimenopause. Condition-specific dashboards + treatments. Phase 9. |
| 8 | **AI Health Insights** | On-device ML: personalized predictions, anomaly detection, natural-language summaries. Phase 8. |
| 9 | **Smart Prediction Engine** | Bayesian period predictor, ovulation confidence, luteal phase estimate. Phase 8. |
| 10 | **Journal** | Markdown journal, mood tags, cycle-day linking. Phase 7. |
| 11 | **Health Reports** | PDF + CSV export, monthly summary, provider-ready report. Phase 7. |
| 12 | **Wearable Integrations** | Health Connect, Apple Health, Oura, Fitbit, Wear OS glance. Phase 10. |
| 13 | **Community** | Anonymous discussion, topic groups, expert Q&A, content warnings. Phase 9. |
| 14 | **Education Hub** | Evidence-based articles, condition-specific content, CMS-backed. Phase 9. |

---

## 10. Privacy & Security

| Feature | Implementation |
|---|---|
| **Local-first** | All health data stored in encrypted SQLite (SQLCipher). No remote dependency for core function. |
| **AES-256 encryption** | SQLCipher encrypts the entire SQLite file. Key derived from user PIN + device UID (PBKDF2, 100k iterations). |
| **E2EE sync** | Sensitive fields (symptoms, journal entries) encrypted with device-derived key before upload. Supabase sees only opaque blobs. |
| **Biometric lock** | `local_auth`: fingerprint / Face ID gate the app. Fallback to 6-digit PIN. |
| **PIN lock** | 6-digit minimum. Enforced before biometric fallback. Rate-limited (10 attempts → 5-min lockout). |
| **Emergency privacy lock** | Triple-tap status bar → app switches to blank screen + app switcher shows blurred preview. Triggers in <200ms. |
| **Hidden mode** | Android: app icon + name change to "Calculator". iOS: hide from App Library + require Face ID. |
| **Zero-knowledge architecture** | Server never sees plaintext health data. Search indexes are on-device only. |
| **OWASP Top 10 compliance** | M1–M10: insecure data storage (encrypted), insecure comms (HTTPS + certificate pinning), insecure auth (biometric + 2FA-ready), etc. |
| **Data sovereignty** | Export (JSON + CSV) and full account deletion available in-app. Deletion triggers Supabase RPC that cascades all user data within 24h. |
| **Analytics** | Opt-in only. Aggregated + anonymized. No health data sent. Firebase Analytics configured with `isAnalyticsCollectionEnabled = false` by default. |
| **Audit log** | Local sync_log table records every sync operation. No remote audit trail (privacy). |

---

## 11. Success Criteria

Cyra ships when the following are true:

1. **Period prediction**: MAE ≤ 1.5 days after 3 logged cycles
2. **Ovulation detection**: Correct fertile window identification in ≥90% of cycles with BBT + mucus data
3. **Privacy**: Zero plaintext health data ever transmitted to Supabase (verified by MITM proxy test)
4. **Performance**: Cold start ≤2s, 60fps scroll on cycle calendar, DB queries ≤50ms for 100k rows
5. **Offline**: 100% of core features work without internet (period/ovulation logging, predictions, journal)
6. **Accessibility**: WCAG AA on all screens, VoiceOver + TalkBack full navigation
7. **App Store**: Approved on Google Play + Apple App Store (no rejections for misleading health claims)
8. **User experience**: App feels like *"Apple + Oura + fertility clinic + privacy company collaboration"*

### Quality gates per phase
| Gate | Criteria |
|---|---|
| PR merge | `dart analyze` clean, all tests pass, coverage ≥80% for new code |
| Phase sign-off | All phase deliverables accepted, no P0/P1 bugs, golden tests match |
| Release candidate | Full integration test suite passes, security audit clean, privacy verified |
| Production release | App Store approval, crash-free rate ≥99.5%, ≤1% ANR rate (Android) |

---

*This plan is a living document. Update with each phase retrospective. Adjust phase boundaries as technical discoveries warrant — but never compromise on privacy, data integrity, or explainability.*
