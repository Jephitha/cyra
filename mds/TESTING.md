# Cyra — Testing Plan

Current state: **zero project-specific automated tests.** `flutter_test` is present only as the
default Flutter scaffolding dependency. This doc gives an agent a concrete place to start.

## Priorities, in order

### 1. Pure-logic unit tests (no Flutter widgets, no DB, fastest to write, highest value)

These protect the actual competitive differentiators (prediction accuracy, security), and are
pure Dart so no widget/mocking setup is needed.

- **`CyclePredictor`** (`core/prediction/cycle_predictor.dart`)
  - Fewer than 3 completed cycles → returns 28-day fallback with 0.0 confidence and the correct
    "track N more cycles" message.
  - Exactly 3+ cycles → weighted average correctly weights the most recent 3 cycles at 2x.
  - Known input arrays → assert exact `averageLength`, `variabilityScore`, `confidenceScore`
    against hand-calculated expected values (regression-proof the math itself).
  - Irregular cycle history → variability score rises appropriately, confidence falls.

- **`OvulationDetector`** (`core/prediction/ovulation_detector.dart`)
  - Fewer than 9 unique daily BBT readings → `isConfirmed: false`, correct explanation string.
  - Duplicate same-day readings are deduped correctly before the 9-reading check.
  - Synthetic BBT series with a clear post-ovulatory shift → `isConfirmed: true` at the expected
    day, using the 6-day baseline / 0.2°C coverline / 3-day-shift constants.
  - Borderline case (shift of exactly the threshold, or only 2 of 3 days above coverline) → not
    confirmed — test the edges deliberately, this is exactly where off-by-one bugs hide.

- **`CorrelationEngine`** (`core/ml/correlation_engine.dart`)
  - `pearsonCorrelation`: known input pairs → exact expected coefficient; fewer than 3 points or
    mismatched lengths → returns 0.0 without throwing.
  - `symptomPhaseCorrelation`: fewer than 6 cycle days → returns the "not enough data" result with
    `isSignificant: false`.

- **`EncryptionService`** (`core/security/encryption_service.dart`)
  - Encrypt then decrypt round-trips to the original plaintext.
  - Two encryptions of the same plaintext produce different ciphertext (nonce uniqueness).
  - Tampered ciphertext (flip a byte) fails to decrypt / throws `EncryptionException` rather than
    silently returning garbage.
  - Key persists across service instances that share the same `SecureStorageService` (i.e., a new
    `EncryptionService` picks up the previously-generated key rather than generating a new one).

### 2. Repository / DB tests (in-memory Drift database)

Use Drift's in-memory `NativeDatabase.memory()` (or equivalent) so these run fast without device
I/O.

- `CycleRepository`: create cycle → appears in `getAllCycles()`; update an existing cycle's
  `endDate`/`cycleLength` persists correctly; deleting a cycle cascades or is blocked as intended
  (verify actual FK behavior against the schema — don't assume).
- `SymptomRepository`, `OvulationRepository`, `JournalRepository`: basic CRUD round-trips.
- Confirm encrypted fields are actually stored encrypted at rest (read the raw DB row, assert the
  stored value is not the plaintext) for any table holding sensitive free-text (journal entries,
  notes).

### 3. Widget tests

- **`LogPeriodScreen` save flow** — this is the highest-priority widget test in the whole app,
  because it directly regression-proofs the exact bug found during this review (save button
  currently doesn't persist anything). Once T1 in `BACKLOG.md` is fixed: pump the widget, step
  through all 5 steps, tap save, assert the repository's write method was called with the
  expected data (use a mock/fake repository via Riverpod overrides).
- Dashboard/Calendar: once wired to real providers (T2/T3), test empty-state rendering (zero
  cycles logged) and populated-state rendering separately using `ProviderScope` overrides with
  fake repository data — don't let these tests depend on the real DB or `SeedDataService`.
- Auth flow: PIN setup validates length (4–8 digits per `BiometricAuthService.setPinCode`'s
  existing validation), lock screen correctly blocks navigation until authenticated.
- Emergency lock: activating it immediately shows the decoy screen and blocks access to real
  screens (this is a security-critical UI path — test it explicitly, including that backgrounding
  and returning to the app doesn't leak real data before re-auth).

### 4. Integration tests

- Full smoke flow: fresh install → onboarding → privacy setup (PIN/biometric) → log a period →
  dashboard reflects it → force-quit and relaunch → data still present and correctly displayed →
  lock screen appears per the configured auto-lock timer.
- Offline-first behavior: simulate Supabase being unreachable at launch → app still functions
  fully on local data (per `bootstrap.dart`'s try/catch around `SupabaseClientService.initialize()`)
  → no crash, no blocking error UI.
- Emergency lock under duress scenario: activate emergency lock → verify zero real health data is
  visible or accessible anywhere in the widget tree, including via back-navigation.

### 5. Manual QA checklist (until automated coverage exists)

- [ ] Log a period, force-close the app, reopen — data is still there (currently **will fail**,
      see T1/T2 in `BACKLOG.md`)
- [ ] Log 3+ cycles with varying lengths — dashboard prediction updates and confidence score
      changes sensibly
- [ ] Enable biometric lock, background the app past the auto-lock timeout, return — locked
- [ ] Activate emergency lock — decoy screen shown, no real data reachable
- [ ] Turn off network (airplane mode) — app remains fully usable
- [ ] Community: post a message, view it in the topic list, open post detail — all reflect real
      Supabase state (this feature is expected to already work — use it as the "known good"
      baseline when something else seems broken)
- [ ] Settings → change appearance/theme — persists across restart
- [ ] Toggle the OS system light/dark setting while the app is open on Dashboard, Calendar,
      Insights, and Community — every screen updates live and remains legible in both modes, with
      no manual in-app override available (per `DESIGN_SYSTEM.md` §10 / `BACKLOG.md` T-THEME-1)
- [ ] Attempt data export (once T10 is implemented) — produces a complete, correctly-scoped export

## Suggested test directory structure

```
test/
  unit/
    prediction/cycle_predictor_test.dart
    prediction/ovulation_detector_test.dart
    ml/correlation_engine_test.dart
    security/encryption_service_test.dart
  repositories/
    cycle_repository_test.dart
    symptom_repository_test.dart
    ovulation_repository_test.dart
  widgets/
    log_period_screen_test.dart
    dashboard_screen_test.dart
    emergency_lock_test.dart
  integration_test/
    core_loop_test.dart
    offline_first_test.dart
```

## Notes for whoever (human or agent) picks this up

- Don't trust this document's claims about "what's wired vs. mocked" as gospel forever — it was
  produced by reading a compiled debug build, not the live repo. Re-verify `dashboard_screen.dart`
  and `log_period_screen.dart` against current source before starting T1–T3, in case work has
  already progressed since this snapshot.
- Prioritize the P0/T1–T4 items in `BACKLOG.md` before writing extensive new tests for
  Dashboard/Calendar — testing mocked screens just locks in the mock behavior as "correct."
