# Cyra — Backlog

Prioritized for an agent to execute against. Ordered by priority within each phase; phases map to
the "ideal roadmap to compete with Flo/Clue" discussed earlier. **P0 items should be done before
anything else** — the app cannot be meaningfully tested or demoed until logged data actually
shows up on screen.

Each task lists: what's wrong, what "done" looks like, and the files most likely involved (verify
against actual repo, these are inferred from decompiled source).

---

## P0 — Make the core loop actually work

### [x] T1. Wire `LogPeriodScreen` to persist data
**Problem:** `_save()` only pops the screen; class isn't even Riverpod-aware.
**Done when:** Screen is `ConsumerStatefulWidget`; on save, calls the appropriate repository
method(s) (`cycleRepositoryProvider`, `symptomRepositoryProvider`) to write the selected date,
flow intensity, symptoms, and notes to the local DB; shows a loading/error state around the write;
only pops on confirmed success.
**Files:** `features/cycle/screens/log_period_screen.dart`, `features/cycle/repositories/cycle_repository.dart`, `features/symptoms/repositories/symptom_repository.dart`

### [x] T2. Wire `DashboardScreen` to real data
**Problem:** Entirely hardcoded mock `_DashboardState`.
**Done when:** Screen watches `activeCycleProvider`, `cycleDaysProvider`, and a
`dashboardInsightsProvider` (wrapping `HealthInsightsEngine.generateDashboardInsights`) instead of
synthesizing fake values. Empty-state (zero cycles logged) is handled gracefully, matching the
"track 3 cycles for a prediction" messaging already built into `CyclePredictor`.
**Files:** `features/cycle/screens/dashboard_screen.dart`, `core/ml/health_insights_engine.dart`, `features/cycle/providers/cycle_providers.dart`

### [x] T3. Wire `CalendarScreen` to real data
**Problem:** Same mock-state issue as dashboard.
**Done when:** Calendar day statuses (period/fertile/ovulation) are derived from
`cycleDaysProvider` + `OvulationDetector`/fertile-window calculation, not synthetic offsets from
`DateTime.now()`.
**Files:** `features/cycle/screens/calendar_screen.dart`

### [x] T4. End-to-end smoke test of the core loop
**Done when:** A fresh install → onboarding → log a period → dashboard shows it → calendar shows
it → app restart → data still there, works with zero crashes and no mock data visible.

---

## P1 — Fill in missing logging UI (data layer already exists for these)

### [x] T5. Symptom logging screen
Build a dedicated screen (or confirm `LogPeriodScreen`'s embedded `SymptomSelector` is sufficient
for now) that writes to `symptom_logs_table` via `SymptomRepository`, independent of period
logging — symptoms should be loggable on non-period days too.

### [x] T6. Ovulation tracking screens (BBT / cervical mucus / OPK)
`features/ovulation/` has models + repository but no `screens/` folder. Build logging UI for each
(BBT entry feeding `bbt_chart` widget, mucus observation picker, OPK test result entry), and a
summary/history view. `OvulationDetector` is ready to consume this data once it exists.

### [x] T7. Pregnancy tracking flow
`features/pregnancy/` is fully scaffolded at the data layer (models, providers, repository,
`weekly_milestones.dart`) and even has a `pregnancy_week_widget` in the design system, but zero
screens. Build: pregnancy mode toggle/setup, weekly milestone view, fetal measurement logging
(feeds `fetal_measurements_table`). Consider whether this should gate behind a mode switch on the
dashboard (there's already an `inPregnancyMode` flag on the mock dashboard state — carry that
concept into the real provider).

### [x] T8. Cycle detail / history / prediction detail screens
These exist and are pushed via `Navigator.push` already — audit them for the same
mocked-vs-real-data issue found in Dashboard/Calendar before assuming they're done.

---

## P2 — Brand & Visual Identity

Do this early relative to the trust/breadth work below — it touches every screen, and later UI
work should be built against final brand assets rather than placeholder ones to avoid rework.
Full creative direction, palette, typography, and logo brief are in `DESIGN_SYSTEM.md` — read
that in full before starting any task in this section.

### [x] T-BRAND-1. Design and produce the primary logo + wordmark
Follow the brief in `DESIGN_SYSTEM.md` exactly. Produce: primary full-color logo, wordmark-only
version, icon-only mark (monogram/symbol), single-color (black and white) versions, and a
horizontal lockup for tight spaces (e.g. app bar). Deliver as SVG (source of truth) plus exported
PNGs at 1x/2x/3x for in-app use.

### [x] T-BRAND-2. Produce production app icon sets
From the icon-only mark, generate full platform icon sets:
- **Android:** adaptive icon (foreground + background layers per Android's adaptive icon spec),
  plus legacy `ic_launcher.png` at mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi densities, plus a round icon
  variant. Use `flutter_launcher_icons` to generate from a single source image/config rather than
  hand-exporting each density.
- **iOS:** full `AppIcon.appiconset` at all required sizes (20pt–1024pt across all multipliers),
  no transparency, no rounded corners baked in (iOS applies the mask).
- Verify the icon reads clearly at the smallest sizes (notification-bar/settings-list size,
  ~29–40px) — test by actually viewing it that small, not just at 1024px.

### [x] T-BRAND-3. Produce the neutral "hidden mode" icon set
A **separate, unrelated-looking** icon (weather-themed per `DESIGN_SYSTEM.md`) with its own full
platform icon set (same density/size requirements as T-BRAND-2), used by the `activity-alias` /
alternate-icon implementation in backlog item T9a. This icon must not visually reference Cyra's
brand in any way — that's the entire point of it.

### [x] T-BRAND-4. Apply the new palette/typography across the app
Update `core/design/app_colors.dart`, `app_theme.dart`, `app_typography.dart`, and the design
token files to match `DESIGN_SYSTEM.md`. Sweep existing screens for hardcoded colors that bypass
the design tokens (common in early-stage codebases) and replace them with token references so a
future palette change doesn't require another manual sweep.

### [x] T-BRAND-5. Splash screen / launch screen
Update the native splash screen (Android `launch_background`, iOS `LaunchScreen.storyboard` or
equivalent) to use the new mark, not the default Flutter splash. Verify it looks correct under
both system light and dark mode (see T-THEME-1) — native splash screens are easy to leave
hardcoded to one appearance by accident.

### [x] T-THEME-1. System-only dark/light mode — remove manual toggle, verify full coverage
**Problem:** `app.dart` already wires `MaterialApp.router`'s `themeMode` from
`themeModeSettingProvider`, and `AppearanceScreen` exposes a manual light/dark/system picker
(`_buildThemeModeSection`, `themeModeSettingNotifierProvider`) that lets a user override the
system setting. Product direction: **no manual override, system setting only, for now.**
**Done when:**
- The theme mode resolves to `ThemeMode.system` unconditionally — no code path can force
  light-only or dark-only.
- The manual theme picker UI is removed from `AppearanceScreen`. Decide and note explicitly
  whether the underlying `themeModeSettingNotifierProvider`/persisted preference is deleted
  outright or just no longer surfaced in the UI (either is acceptable — just be consistent and
  say which you did, since a future task may want to reintroduce a manual toggle and should know
  what's still there to build on).
- Every screen and every design-system widget is audited against both system settings. This
  includes screens not yet fixed by other backlog items — a mocked screen (e.g. pre-T2 Dashboard)
  should still not be visually broken in dark mode even before its data-wiring bug is fixed,
  since a user could hit dark mode before that other fix lands.
- Grep for hardcoded `Color(0x...)` / named color literals outside `app_colors.dart` and the
  theme files, and replace any found with the correct light/dark-aware token — same sweep
  described in T-BRAND-4, but treat dark-mode correctness as its own explicit pass, not just a
  side effect of the brand-color sweep (a hardcoded color can be "on-brand" in hue and still
  break in dark mode if it's not using the paired light/dark token).
- Manually verify by toggling the OS-level dark mode setting (Android: Settings > Display, or
  `adb shell "cmd uimode night yes"` / `night no`; iOS: Settings > Display & Brightness, or the
  simulator's Appearance toggle) while the app is running, and confirming every currently-open
  screen updates correctly without a restart.



### [x] T9. Surface privacy features in onboarding
`PrivacyService`'s private mode, auto-lock, and emergency lock are strong differentiators vs Flo —
confirm the onboarding flow actually explains and offers these (not just buries them in settings),
since "privacy-first" only works as a competitive moat if users know about it.

### T9a. Implement "Hide App Icon" for real — Weather-themed disguise
**Implementation status (2026-07-13):** Platform-channel, Android alias, and iOS alternate-icon
support are implemented. Android compiles and its packaged manifest/assets have been inspected.
Final real-device verification remains pending because no Android or iOS device is attached to the
development host. iOS supports changing the icon but does not expose a public API for changing the
home-screen label at runtime, so its label remains "Cyra"; Android switches both icon and label.

**Problem:** `privacy_setup_screen.dart` and `privacy_controls_screen.dart` already have a
"Hide App Icon" toggle (`config.hiddenAppIconEnabled`) with copy promising "Replace the Cyra icon
with a neutral icon on your home screen" — but this is currently a UI checkbox with no OS-level
implementation. The manifest has a single `MainActivity`, a single hardcoded label ("Cyra"), and
a single `ic_launcher` icon set. Flipping the toggle currently does nothing to the actual home
screen icon.
**Scope note:** this is icon + label swap only — confirmed. When launched via the disguised
icon, the app opens to the normal Cyra lock screen exactly as it does today. Do not build a
decoy/fake weather screen behind it; see `DESIGN_SYSTEM.md` §9 for the full scope statement.
**Done when:**
- **Android:** add an `<activity-alias>` in `AndroidManifest.xml` targeting `MainActivity`, with
  its own `android:icon` (the neutral weather icon, see `DESIGN_SYSTEM.md`) and
  `android:label` (a neutral name — see naming note below). Toggle between the real icon and the
  alias at runtime via `PackageManager.setComponentEnabledSetting()`, disabling the real launcher
  activity's icon and enabling the alias (and vice versa to restore). This requires a small
  platform channel or an existing plugin (e.g. `flutter_launcher_icons` handles build-time icon
  generation but not runtime switching — you likely need a platform channel calling
  `PackageManager` directly, or a plugin like `dynamic_app_icon` if it fits the Flutter version in
  use — verify compatibility before adding a new dependency).
- **iOS:** implement via `UIApplication.shared.setAlternateIconName(_:)`, with the weather icon
  registered as an alternate icon in `Info.plist` under `CFBundleIcons > CFBundleAlternateIcons`.
- **App label when hidden:** the icon alone isn't a disguise if the app name underneath still
  says "Cyra." Use a neutral label such as "Weather" or a specific invented name (see
  `DESIGN_SYSTEM.md` for the recommended name/icon pairing) for the alias/alternate icon.
- **Toggle round-trips correctly:** enabling → icon changes on the home screen without requiring
  a full reinstall; disabling → real icon restored. Test on both a real Android device and a real
  iOS device — icon-switching behavior is not reliably testable in a simulator/emulator alone for
  iOS, and Android launchers sometimes cache the old icon until a home-screen refresh.
- **No functional regression:** switching icons must not lose app state, log the user out, or
  clear the local database. Treat this as strictly a launcher-level visual change.
- Update the "Hide App Icon" description copy in `privacy_setup_screen.dart` /
  `privacy_controls_screen.dart` if the final neutral icon's theme changes what's being promised.

### [x] T10. Wire `DataExportService` into Settings — PDF output, not JSON
Add a visible "Export my data" flow in `settings_screen.dart` or `privacy_controls_screen.dart`
using the existing callback-based `DataExportService`. **Output format: PDF, not raw JSON.**
JSON is a developer format — the target user is not technical, and a PDF is also what most
people actually want (something readable, printable, and shareable with a doctor). Rationale
and full spec in T10a below; treat this as a rename/refinement of the original task, not an
additional one.

### [x] T10a. PDF export — detailed spec
**Problem:** `DataExportService`'s existing callback contract returns raw
`List<Map<String, dynamic>>` data, which is fine as an internal representation but must not be
the thing a user receives when they tap "Export."
**Done when:**
- A new rendering layer takes the data returned by `DataExportService` and produces a clean,
  readable PDF (use `pdf` + `printing` packages, or the platform's native PDF generation —
  pick whichever integrates best with the existing Flutter stack).
- PDF includes, at minimum: a cover section (name/date range/generated date), a cycle summary
  table (dates, lengths, flow), a symptom frequency summary, and an optional detailed daily log —
  structured so a page can be handed to or emailed to a clinician and understood in under a
  minute.
- Journal entries are **excluded from the clinician-facing PDF by default** (opt-in only, via a
  checkbox) since journal content is more personal than clinical and the user should consciously
  choose to include it.
- The export flow offers "Share" (share sheet → email/AirDrop/etc.) and "Save to device."
- A JSON export can still exist as a secondary, clearly-labeled "Advanced / Developer export"
  option buried under an "Advanced" disclosure — don't remove the capability, just don't make it
  the primary or default path.
- Respect the existing security model: exporting should require a fresh biometric/PIN
  authentication (`BiometricAuthService`) immediately before generating the file, and the action
  should be recorded via `AuditService`.

### [x] T11. Confirm `AuditService` is actually logging real events
Verify call-sites exist for security-relevant events (unlock attempts, emergency lock
activation, data export/delete). If not called anywhere yet, wire it in — an audit log that's
never written to is a false promise.

### [x] T12. Local reminder notifications
`flutter_local_notifications` is a dependency and `notifications_screen.dart` exists (settings for
"notify how many days before") — confirm actual scheduled notifications are implemented against
real predicted period/fertile dates, not just a settings UI with no backing logic.

---

## P4 — Breadth (parity + differentiation vs. incumbents)

### [x] T13. Wearable integration (Health Connect / Apple Health)
DB table (`wearable_sources_table`) and Android manifest permission already present, but no
`health` package dependency exists yet. Add it, build a sync service that reads
temperature/sleep/HRV and feeds it into `OvulationDetector`/`HealthInsightsEngine`, and add a
"Connect a wearable" flow in Settings.

### [x] T14. Clinician export (PDF/shareable summary)
Completed by T10/T10a: the authenticated `DataExportService` flow now generates a readable,
shareable cycle and symptom PDF for care-team or OB-GYN visits, with journals opt-in only.

### [x] T15. AI-assisted insights (optional, evaluate positioning first)
Decision: keep the deterministic, on-device prediction, correlation, and template engines and
market them honestly as **Smart Local Insights**. No health data is sent to a remote model, and
user-facing copy now states this explicitly instead of claiming an AI-powered implementation.

---

## P5 — Monetization (only after the free experience is solid)

### [x] T16. Design the free/paid boundary
Defined in `MONETIZATION.md`: core tracking, prediction explanations, privacy/security, reminders,
and data deletion/export (including clinician PDF) remain free and ad-free. Premium covers wearable
sync and advanced longitudinal analysis; previously synced or user-authored records are never hidden.

### T17. Integrate `in_app_purchase` or RevenueCat
Standard subscription plumbing once the boundary is decided.

---

## Cross-cutting: fix before/alongside the above

### T18. Add automated tests
Zero project-specific tests currently exist. Priority order:
1. Unit tests for `CyclePredictor`, `OvulationDetector`, `CorrelationEngine` (pure logic, easiest
   and highest-value to test, protects the core competitive differentiator).
2. Unit tests for `EncryptionService` (encrypt/decrypt round-trip, tampered-ciphertext rejection).
3. Repository tests against an in-memory Drift DB for `CycleRepository`, `SymptomRepository`,
   `OvulationRepository`.
4. Widget tests for `LogPeriodScreen` save flow once T1 is done (regression-proof this specifically
   — it's the exact bug we just found).
5. Integration test for the T4 end-to-end smoke flow.

See `TESTING.md` for detail.

### T19. Point Supabase config at a real environment before any release build
`.env` currently has `SUPABASE_URL=http://192.168.100.8:54321` (a LAN-local dev instance) baked
into the shipped debug APK. Confirm build config properly separates dev/staging/prod before this
goes anywhere near a real user.

### T20. Add routes for imperatively-pushed screens
`LogPeriodScreen`, `CycleDetailScreen`, `PredictionDetailScreen`, etc. aren't declared as
`GoRoute`s. Not urgent, but needed before deep-linking (e.g., a reminder notification opening
`LogPeriodScreen` directly) can work.

---

## P6 — Additional feature ideas (not yet scoped — evaluate before committing)

Domain-relevant ideas beyond the original roadmap, worth considering once P0–P3 are solid.
Don't build any of these without an explicit go-ahead — they're here as a menu, not a mandate.

- **Perimenopause mode** — a distinct tracking mode (irregular-cycle-aware, hot flash/sleep/mood
  logging) rather than forcing perimenopausal users through a regular-cycle-shaped UI. Large,
  underserved, and an aging early-adopter base will eventually need this.
- **PCOS / endometriosis condition modules** — `user_conditions_table` already exists; build
  condition-specific symptom sets, educational content, and pattern-flagging ("your cramp
  severity has trended up over 3 cycles — consider discussing with a doctor") for these two
  common, underserved conditions specifically.
- **Partner/care-team share link** — a read-only, time-boxed, revocable link (not a full account)
  a user can share with a partner or caregiver, showing only what they choose (e.g. just fertile
  window, not symptoms/journal). Different from and more granular than a full account share.
- **Medication / birth control reminders** — pill/patch/ring reminders tied to the existing local
  notification infrastructure, separate from period predictions.
- **Home screen widget** — next period/fertile window at a glance, no need to open the app.
  High engagement value, works well with the local-first architecture (no network needed).
- **"Doctor visit prep" mode** — a guided flow that surfaces the PDF export (T10a) plus a
  checklist of things to mention, generated from recent symptom patterns.
- **Multi-language support** — `flutter_localizations` is already a dependency; verify whether
  any localization is actually wired up, and prioritize based on target markets.
- **Accessibility audit** — screen reader labels (TalkBack/VoiceOver) across the charting widgets
  in particular (charts are notoriously bad for accessibility if not deliberately labeled).
- **Teen-appropriate mode** — simplified language, age-appropriate educational content, and an
  explicit product/legal decision about parental access (default to none, matching the app's
  general privacy stance) — relevant given period tracking apps see meaningful use from younger
  users.
- **Community safety tooling** — since `features/community/` is a real, working feature: add
  reporting/blocking and basic moderation before the community grows, not after.
