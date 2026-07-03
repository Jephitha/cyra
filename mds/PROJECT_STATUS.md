# Cyra — Project Status

_Compiled by reverse-engineering `app-debug.apk` (Flutter debug build) — no access to the actual
git repo, so file line numbers are approximate and some claims below are marked "needs verification"
where the decompiled kernel blob didn't give full certainty. Re-verify against source before trusting
blindly._

Package: `com.getmycyra.app` · App name: **Cyra** · Repo root (from embedded paths):
`~/Documents/Cyra/apps/mobile` (Flutter app) + `apps/backend/supabase` (Supabase project, local dev).

Stack: Flutter, Riverpod (`flutter_riverpod` + `riverpod_annotation` codegen), `go_router`,
Drift (SQLite ORM) for local-first storage, Supabase (`supabase_flutter`) for optional
auth/sync, `flutter_secure_storage` + `local_auth` + `encrypt`/`pointycastle` for security,
`fl_chart` for charts, `freezed`/`json_serializable` for models.

---

## 1. What is real and working

These have actual logic, not placeholders — verified by reading the decompiled source:

- **Cycle prediction** — `core/prediction/cycle_predictor.dart`
  Weighted moving average over completed cycles (most recent 3 weighted 2x), variance/std-dev
  based variability score, confidence score, prediction range (±7 days when <3 cycles tracked).
- **Ovulation detection (BBT)** — `core/prediction/ovulation_detector.dart`
  Coverline algorithm: 6-day baseline average + 0.2°C threshold, requires 3 consecutive days
  above coverline, needs ≥9 unique daily readings.
- **Symptom/phase correlation** — `core/ml/correlation_engine.dart`
  Real Pearson correlation implementation; `symptomPhaseCorrelation()` bucket-counts symptoms
  by estimated cycle phase.
- **Encryption** — `core/security/encryption_service.dart`
  AES-256-GCM via `pointycastle`/`encrypt`, random 12-byte nonce per encrypt call, key generated
  with `Random.secure()` and stored via `flutter_secure_storage`. This is correctly implemented,
  not a placeholder.
- **Privacy/security layer** — `core/security/privacy_service.dart`, `biometric_auth_service.dart`,
  `pin_auth_service.dart`, `audit_service.dart`, `data_export_service.dart`
  Private mode, auto-lock timer, **emergency lock** (decoy-screen panic button), screen-capture
  blocking flag, biometric-then-PIN-fallback auth, audit log with configurable retention
  (1–365 days, default 90), and a callback-based data export service that's DB-agnostic by design.
- **Community feature** — `features/community/` (models, repository, providers, 5 screens)
  Fully wired through Supabase Postgrest (`communityTopicsProvider`, `topicPostsProvider`,
  `postDetailProvider`, `myCommunityPostsProvider` all call a real `CommunityRepository`).
  This is the one full-stack feature that appears end-to-end complete.
- **Local database schema** — `core/database/tables/` — 16 Drift tables already defined:
  `cycles`, `cycle_days`, `symptoms`, `symptom_logs`, `bbt_records`, `cervical_mucus`,
  `ovulation_tests`, `journal_entries`, `pregnancies`, `fetal_measurements`, `health_reports`,
  `user_conditions`, `wearable_sources`, `community_posts`, `education_articles`, `app_settings`.
- **Auth/onboarding flow** — onboarding, privacy setup, PIN setup, biometric setup, sign-in,
  lock screen, emergency lock screen all exist and are routed.
- **Design system** — `core/design/` — colors, typography, spacing/radius tokens, and a real
  widget library: `cycle_calendar`, `cycle_overview_chart`, `bbt_chart`, `symptom_bar_chart`,
  `fertility_widget`, `pregnancy_week_widget`, `health_timeline`, `confidence_badge`, etc.
  The visual foundation is more built-out than the screens that consume it.

## 2. What LOOKS built but is not wired up (the main gap)

This is the most important finding and is easy to miss just by using the app:

- **`DashboardScreen`** (`features/cycle/screens/dashboard_screen.dart`) holds its own private
  `_DashboardState extends ChangeNotifier` with **hardcoded values**
  (`currentCycleDay = 14`, `lastPeriodStart = DateTime.now().subtract(Duration(days: 13))`, etc.).
  It never reads `cycleRepositoryProvider`, `activeCycleProvider`, or any real prediction output.
- **`CalendarScreen`** (`features/cycle/screens/calendar_screen.dart`) — same pattern:
  a private `_CalendarState` synthesizes fake period/fertile/ovulation days from
  `DateTime.now()`, not from the database.
- **`LogPeriodScreen`** (`features/cycle/screens/log_period_screen.dart`) — **WIRED (T1 done).**
  Now a `ConsumerStatefulWidget` that persists via `cycleRepositoryProvider` and
  `symptomRepositoryProvider` on save, with loading/error states. Data flows from
  tap-save → Drift DB → (provider invalidation) → downstream screens.
- **`SeedDataService`** (`core/seed/seed_data_service.dart`) generates ~7 synthetic cycles over
  6+ months on first debug run (`kDebugMode` gated) — useful for demoing the design system, but
  masks the fact that the dashboard/calendar don't actually read even this seed data; the seed
  data populates the real DB via repositories, while the screens read neither the seed data nor
  live data.

**Practical implication:** the prediction engine, encryption, and DB schema are production-quality,
but a real user's actual logged data currently has no path from "tap save" to "show on dashboard."
This should be the #1 priority — it's wiring, not new engineering.

## 3. Features with data layer but no UI at all

- **BBT / cervical mucus / OPK logging** — models, tables, repository (`ovulation_repository.dart`)
  all exist under `features/ovulation/`, but there is **no `screens/` folder** for this feature.
  The `bbt_chart` widget exists in the design system but nothing currently feeds it real data.
- **Dedicated symptom logging** — `features/symptoms/` has models/providers/repository but no
  screens folder; symptom selection currently only happens inline inside `LogPeriodScreen`
  (and even that isn't persisted — see above).
- **Pregnancy tracking** — `features/pregnancy/` has models, providers, repository, and
  `weekly_milestones.dart` data, plus a `pregnancy_week_widget` in the design system and an
  `inPregnancyMode` flag on the dashboard's mock state — but **no pregnancy screens exist**.
  This is a fully-scaffolded, unbuilt feature.

## 4. Not started

- **Wearable integration** — `wearable_sources_table` exists in the DB, and
  `androidx.health.platform.client.*` (Health Connect) appears in the Android manifest, but
  there is no `health` (or equivalent) Dart package dependency and no wearable feature folder.
  This is a declared intent, not an implementation.
- **Monetization** — no `in_app_purchase`, no RevenueCat, no paywall screen, no subscription
  table. The app is currently 100% free with no premium tier scaffolding.
- **Push notifications** — only `flutter_local_notifications` is present (device-local
  reminders). No FCM/APNs server-push integration — fine for the privacy story, but means no
  server-triggered re-engagement and no "reminder synced across devices."
- **Analytics / crash reporting** — intentionally absent (consistent with the privacy
  positioning), but worth an explicit product decision: zero telemetry means zero visibility
  into where users drop off, which will need a privacy-preserving alternative eventually
  (e.g., aggregate, opt-in, on-device-computed metrics).
- **Automated tests** — zero project-specific test files found in the bundle. `flutter_test`
  is a dependency (default Flutter scaffolding) but no `_test.dart` files under `test/` belong
  to Cyra's own code.

## 5. Routing note

`app/router.dart` (go_router) only declares 8 top-level routes: `/onboarding`, `/privacy-setup`,
`/lock`, `/emergency-lock`, `/sign-in`, `/dashboard`, `/calendar`, `/insights`, `/community`,
`/settings`, `/settings/privacy`, `/settings/pin`. Screens like `LogPeriodScreen`,
`CycleDetailScreen`, `CycleHistoryScreen`, `PredictionDetailScreen`, and the community/insights/
settings sub-screens are pushed imperatively (`Navigator.push`) from within other screens rather
than declared as `GoRoute`s. This works fine for in-app navigation but means **no deep linking**
to these screens (relevant for "tap a reminder notification → open Log Period" flows later).
