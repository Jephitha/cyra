# Cyra — Architecture Reference

For an agent picking up this codebase cold. Written from decompiled source, so **verify file
contents against the real repo before editing** — paths and class names are accurate, but exact
line-level implementation should be re-read from source, not assumed from this doc.

## Repo layout (inferred)

```
Cyra/
  apps/
    mobile/           # Flutter app — everything below is relative to apps/mobile/lib/
    backend/
      supabase/        # Supabase project — `supabase status` gives local dev credentials
  .env (flutter_assets) -> SUPABASE_URL, SUPABASE_ANON_KEY (local dev instance)
```

## App structure (`apps/mobile/lib/`)

```
app/
  app.dart              # CyraApp — MaterialApp.router root widget, theme wiring
  bootstrap.dart         # bootstrapApp() / bootstrapServices() — Supabase init, encryption init,
                          # seed data load, session restoration
  router.dart             # go_router config + auth/onboarding/emergency redirect logic

core/
  constants/
    api_constants.dart     # Supabase URL/key from --dart-define, timeout, retries
    app_constants.dart     # app name/version, cycle length bounds, fertile window days
    cycle_constants.dart   # canonical cycle/phase constants, flow labels, mucus types
  database/
    app_database.dart       # Drift database definition
    daos/cycle_dao.dart
    tables/                 # 16 Drift table definitions (see PROJECT_STATUS.md §1)
  design/                  # design tokens + widget library (colors, typography, spacing, radius,
                             # buttons, cards, charts, calendar, pickers, privacy_lock, etc.)
  ml/
    correlation_engine.dart     # Pearson correlation, symptom↔phase analysis
    explanation_engine.dart     # template-based natural-language summaries/tips
    health_insights_engine.dart # orchestrates predictor + correlation + explanation → DashboardInsights
    insight_service.dart
  networking/supabase_client.dart
  prediction/
    cycle_predictor.dart    # weighted moving average next-period prediction
    ovulation_detector.dart # BBT coverline ovulation detection
  providers/                # security_providers.dart, settings_providers.dart (Riverpod DI wiring)
  security/
    audit_service.dart          # secure-storage-backed audit log, configurable retention
    biometric_auth_service.dart # local_auth wrapper + PIN fallback
    data_export_service.dart    # callback-based export/delete (DB-agnostic by design)
    encryption_service.dart     # AES-256-GCM via pointycastle/encrypt
    pin_auth_service.dart
    privacy_service.dart        # private mode, auto-lock, emergency lock, screen-capture block
    secure_storage_service.dart
  seed/ + services/seed_data_service.dart   # kDebugMode-gated synthetic data generator
  utils/date_utils.dart, extensions.dart

features/
  auth/            screens: onboarding, lock, privacy_setup, emergency_lock, pin_setup, sign_in
  community/        models, providers, repository (Supabase-backed), screens: hub, topic,
                    post_detail, new_post, guidelines  — FULLY WIRED, use as the reference
                    pattern for how a feature should connect repo → provider → screen
  cycle/            models/cycle.dart, providers/cycle_providers.dart, repositories/cycle_repository.dart
                    screens: dashboard (MOCKED), calendar (MOCKED), log_period (NOT PERSISTED),
                    cycle_detail, cycle_history, prediction_detail
  fertility/        models + repository only, no screens (folded into ovulation/insights elsewhere)
  insights/         models, providers, screens: insights_hub, health_tips, topic_detail, ai_disclaimer
  journal/          models, providers, repository — NO screens
  ovulation/        models (bbt_record, mucus_observation, opk_test_record), providers, repository
                    — NO screens
  pregnancy/         models, providers, repository, weekly_milestones data — NO screens
  privacy/          screens: emergency_setup, privacy_controls
  settings/          providers/settings_notifier.dart, screens: settings, appearance, notifications
  symptoms/          models, providers, repository — NO screens (logging is inline in log_period only)

main.dart
```

## State management pattern

Riverpod throughout, with codegen (`@riverpod` annotations, `riverpod_annotation`). The
**correct, working pattern** is demonstrated in `features/community/`:

```
Table (Drift) → Repository (queries table / Supabase) → @riverpod provider function
  (e.g. communityTopics(ref) => ref.watch(communityRepositoryProvider).getTopics())
  → ConsumerWidget/ConsumerStatefulWidget screen does ref.watch(communityTopicsProvider)
```

The **broken pattern** to fix is in `features/cycle/screens/dashboard_screen.dart` and
`calendar_screen.dart`: a private `ChangeNotifier` holding hardcoded fields, declared and watched
via a private `ChangeNotifierProvider` local to the screen file, never touching
`cycleRepositoryProvider` or any real data. When rebuilding these screens, follow the community
pattern instead — the repositories (`cycleRepositoryProvider`, `activeCycleProvider`,
`allCyclesProvider`, `cycleDaysProvider`, `cyclePredictorProvider`, `cycleSummaryProvider`) already
exist and are referenced from `cycle_providers.dart` — they just aren't consumed by these screens yet.

## Data flow for "log a period" (target state, not current state)

```
LogPeriodScreen (should be ConsumerStatefulWidget)
  → on save: ref.read(cycleRepositoryProvider).createOrUpdateCycle(...)
             + ref.read(symptomRepositoryProvider).logSymptoms(...)
  → CycleRepository writes to Drift DB (encrypted fields via EncryptionService where applicable)
  → if Supabase session exists, repository (or a sync layer) also pushes to Supabase for backup/sync
  → DashboardScreen / CalendarScreen watch activeCycleProvider / cycleDaysProvider and rebuild
```

Currently every arrow above except "Drift DB exists" and "repository classes exist" is either
missing or unverified. This is the primary integration work — see `BACKLOG.md`.

## Security model (already solid, preserve when extending)

1. On first launch, `EncryptionService.initialize()` generates a 256-bit AES key via
   `Random.secure()`, stored through `flutter_secure_storage` (OS keystore/keychain-backed).
2. Sensitive fields are encrypted with AES-GCM, unique nonce per write, before persisting.
3. App access is gated by biometric auth with PIN fallback (`BiometricAuthService`).
4. `PrivacyService` provides: private mode (hide values), auto-lock timer (default 5 min),
   emergency lock (decoy screen, activated presumably via a gesture/duress PIN — verify),
   and a screen-capture-block flag.
5. `AuditService` keeps a secure, retention-limited log (default 90 days) — verify what events
   it currently logs; the class exists but audit call-sites weren't confirmed during this review.
6. `DataExportService` is deliberately decoupled from any specific DB implementation via
   constructor callbacks — this is a clean seam for wiring up a real "export my data" /
   "delete my data" settings flow.

**When adding any new feature that touches health data, follow this existing pattern** — encrypt
at the repository layer, never log plaintext health data, and route deletion through
`DataExportService`'s callback contract rather than ad hoc DB calls.

## Backend

Supabase, currently configured against a local dev instance
(`http://192.168.100.8:54321` in the shipped `.env` — **replace before any real deployment**).
`SupabaseClientService.initialize()` is called in `bootstrap.dart` and failure is caught silently
so the app can run fully offline — this offline-first fallback is intentional and should be
preserved. Anonymous sign-in (`signInAnonymously()`) is used to establish a session after local
unlock, ahead of a "real" account being linked — verify this doesn't leak health data to Supabase
before the user has explicitly opted into cloud sync (the local-first/opt-in-sync architecture is
a stated product goal — this boundary should be tested).

## Known third-party stack

Flutter, `flutter_riverpod` + `riverpod` + `riverpod_annotation`, `go_router`, `drift` +
`drift_flutter` + `sqlite3`, `supabase_flutter` (+ `gotrue`, `postgrest`, `realtime_client`,
`storage_client`), `flutter_secure_storage`, `local_auth`, `encrypt` + `pointycastle`,
`flutter_local_notifications`, `fl_chart`, `freezed_annotation` + `json_annotation` (codegen),
`google_fonts`, `shimmer`, `image_picker`, `share_plus`, `url_launcher`, `device_info_plus`,
`app_links`, `flutter_dotenv`, `intl`, `uuid`, `equatable`, `rxdart`.

Notably **absent**: `health`/Health Connect package, any IAP/RevenueCat package, any
analytics/crash-reporting SDK, any push (FCM/APNs) package, any AI/LLM client package.
