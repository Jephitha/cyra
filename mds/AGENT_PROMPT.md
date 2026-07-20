# Agent Instructions: Executing the Cyra Backlog

Use this as your operating instructions when picking up development on Cyra. Read
`PROJECT_STATUS.md`, `ARCHITECTURE.md`, `BACKLOG.md`, `TESTING.md`, and `DESIGN_SYSTEM.md` in
full before writing any code — in that order. They contain the current state of the codebase,
how it's structured, what to build and in what order, how to test it, and the brand/visual
standard everything should meet. Do not skip this reading step, and do not rely on assumptions
about what a "typical" period-tracking app should have instead of what these docs say Cyra
specifically needs.

---

## 1. Operating principle: one backlog item at a time, fully closed out before moving on

`BACKLOG.md` is ordered intentionally — P0 before P1, and within each phase, T-numbers in
listed order, with the exception that **T-BRAND tasks (P2) should be interleaved wherever
convenient once P0 is done**, since later screens should be built against final visual assets
rather than placeholders. Otherwise:

1. Work exactly one backlog item (one `T#` or `T-BRAND-#`) at a time.
2. Do not start the next item until the current one has passed **every** step in Section 3
   ("Definition of done") below.
3. Do not batch multiple backlog items into a single commit or a single verification pass — if
   you find yourself touching files unrelated to the current item, stop and either fold that
   work into the current item's scope deliberately (if it's a true dependency) or note it as a
   new backlog candidate and leave it for its own pass.
4. If a task's original scope turns out to be wrong or incomplete once you're in the code (e.g.
   you discover an assumption in `PROJECT_STATUS.md` was inaccurate), fix your understanding,
   note the discrepancy in your task summary, and adjust scope — but don't silently expand scope
   without flagging it.

This discipline matters more here than in a typical codebase: the whole reason this backlog
exists is that a previous pass built a lot of UI against mock data instead of wiring it to real
repositories. Don't repeat that pattern by moving fast and leaving things half-connected.

## 2. Before touching anything: establish a clean baseline

Before starting **any** backlog item, including the very first one:

```bash
flutter --version
flutter pub get
flutter analyze
flutter test
```

- If `flutter analyze` reports pre-existing errors or warnings, record them (screenshot or copy
  the output into your working notes) so you can distinguish pre-existing issues from anything
  you introduce. Do not attempt to fix unrelated pre-existing issues as part of an unrelated
  backlog item — note them and, if they block your current task, treat that as a resolvable
  dependency; otherwise leave them for their own backlog item.
- If `flutter test` fails on the clean baseline (unlikely, since there are currently no
  project-specific tests — see `TESTING.md`), treat that as a P0 blocker before proceeding.
- Confirm you can produce a working debug build before starting:
  ```bash
  flutter build apk --debug        # Android
  flutter build ios --debug --no-codesign   # iOS, if on macOS
  ```
  If neither build succeeds from a clean checkout, stop and resolve that first — everything
  else assumes you have a working build baseline.

## 3. Definition of done for every single backlog item

A task is not complete until **all** of the following pass, in order:

### 3.1 Implementation matches the acceptance criteria
Re-read the specific `T#` entry in `BACKLOG.md` and confirm your change satisfies every bullet
under "Done when," not just the first/easiest one.

### 3.2 Static analysis is clean
```bash
flutter analyze
```
Zero new errors or warnings compared to your recorded baseline (Section 2). If `flutter analyze`
was already noisy at baseline, your change must not add to that noise — new code should be
clean even if the surrounding code isn't yet.

### 3.3 Automated tests pass, and you added tests for what you built
```bash
flutter test
```
- All existing tests still pass — a regression here blocks moving to the next item, full stop.
- Per `TESTING.md`, add tests appropriate to what you just built:
  - Pure logic changes (prediction, correlation, encryption, PDF data assembly) → unit tests.
  - Repository/DB changes → repository tests against an in-memory Drift DB.
  - New/changed screens → widget tests, especially for anything that persists data (this is
    non-negotiable for cycle/log-period/symptom/ovulation/pregnancy screens specifically,
    since "the UI looks right but doesn't save anything" is the exact bug this whole backlog
    exists to fix — see `PROJECT_STATUS.md` §2).
- If a task is genuinely UI/visual-only with no testable logic (e.g. some T-BRAND tasks), state
  that explicitly rather than skipping this step silently.

### 3.4 Manual verification against real data, not mocks
This is the step most likely to be skipped, and it's the most important one given this
codebase's history. For any task touching a screen or a data flow:

1. Run the app on a real emulator/device/simulator (`flutter run`), not just a widget test.
2. **Delete any local database / reinstall to a clean state first** — don't verify against
   whatever `SeedDataService`-generated or previously-mocked data happens to already be sitting
   in the emulator's storage. You need to see this working from zero.
3. Perform the actual user action (log a period, view the dashboard, export a PDF, toggle the
   hidden icon, etc.) as a real user would — not by inspecting state in a debugger.
4. **Force-quit and relaunch the app**, and confirm the result persisted. A huge fraction of the
   bugs already found in this codebase (dashboard/calendar mock state, log-period not saving)
   would have been caught immediately by this one step. Do not skip it.
5. For anything touching encryption, security, or the hidden-icon feature specifically: verify
   on a **real device**, not just an emulator/simulator — icon-switching and some secure-storage
   behaviors don't reliably reproduce in emulators.
6. **For any screen you touch, verify it in both system light mode and system dark mode**
   (toggle the OS setting while the app is running and confirm it updates live — see
   `BACKLOG.md` T-THEME-1 for exact commands). This applies to every UI task from here forward,
   not just T-THEME-1 itself — dark mode is a standing requirement per `DESIGN_SYSTEM.md` §10,
   not a one-time fix. Do not introduce a new screen or modify an existing one without checking
   both modes, even if the task you're working isn't nominally about theming.
7. Cross-check against the manual QA checklist in `TESTING.md` §5 — if your change affects any
   item on that checklist, physically re-walk it, don't assume it's still fine.

### 3.5 No regressions in adjacent, already-working features
Community (`features/community/`) is currently the one confirmed fully-working, end-to-end
feature in this codebase — treat it as a canary. If your change touches shared infrastructure
(routing, providers, the database layer, auth/lock state), do a quick smoke pass on Community
and the auth/lock flow even if your task didn't target them directly.

### 3.6 Build is clean end-to-end
```bash
flutter build apk --debug
flutter build ios --debug --no-codesign   # if applicable
```
Both must succeed with no new errors. If you only have access to one platform's toolchain, say
so explicitly in your task summary rather than silently skipping the other platform's build
check — don't claim "build is clean" for a platform you didn't actually build.

### 3.7 Commit cleanly, one task per commit
- Commit message references the task ID, e.g. `T1: persist LogPeriodScreen data via
  CycleRepository`.
- Commit body briefly states: what was broken, what changed, how it was verified (reference
  which of 3.2–3.6 you ran and their results).
- Do not squash unrelated tasks together, even small ones — the history should make it possible
  to bisect exactly which task introduced any future regression.

### 3.8 Update the backlog and status docs
- Mark the completed item in `BACKLOG.md` (e.g. prefix with `[x]` or move to a "Done" section —
  pick one convention and use it consistently).
- If your work revealed that `PROJECT_STATUS.md` or `ARCHITECTURE.md` was inaccurate or is now
  outdated (e.g. a screen you just fixed is no longer "mocked"), update those docs in the same
  commit or an immediately-following one. Stale status docs are how this kind of gap
  (mock-data screens looking finished) happens in the first place — don't let it happen again
  by leaving docs unmaintained.

**Only once all of 3.1–3.8 are satisfied should you move to the next backlog item.**

## 4. If something breaks and you can't immediately fix it

- Do not proceed to the next backlog item with a known-broken build or failing test suite.
- Revert your change (`git revert` or `git checkout` to the last known-good commit) rather than
  leaving the working tree in a broken state "to come back to later."
- If a task turns out to be blocked by something outside its stated scope (e.g. T2 dashboard
  wiring reveals `cycleRepositoryProvider` itself has a bug), fix the blocking issue as a
  prerequisite — but treat it as its own small, separately-verified change (own commit, own
  pass through Section 3) rather than folding an unrelated fix silently into the current task's
  diff.

## 5. Branding/visual tasks (P2 / T-BRAND-*) specifics

- Follow `DESIGN_SYSTEM.md` exactly for palette, typography, tone, and the logo/icon brief. Do
  not improvise a different visual direction even if you think you have a better idea — flag
  disagreements for human review rather than deviating silently.
- For the hidden-icon feature (T9a + T-BRAND-3): the weather-themed disguise icon must share
  **zero** visual DNA with the real Cyra brand (no shared colors, shapes, or motifs) — this is a
  security property, not just a style choice. Verify this explicitly by placing both icons side
  by side and confirming nothing about the disguise icon would tip someone off.
- Icon legibility must be verified at actual small size (render at 24–29px and look at it, don't
  just eyeball the 1024px master).
- After applying new brand colors/typography (T-BRAND-4), grep the codebase for hardcoded color
  values (hex literals, `Color(0x...)`) outside the design token files, and flag or fix any
  found — this is how design-system drift happens.

## 6. PDF export task (T10/T10a) specifics

- Before writing PDF-generation code, produce a plain visual mock/description of the intended
  PDF layout and check it against `DESIGN_SYSTEM.md`'s tone guidance (a clinician-facing export
  should still feel calm and human, not like a lab report) — get this reviewed before building
  the full rendering pipeline.
- Test the PDF export against **empty data** (zero cycles logged), **minimal data** (one cycle),
  and **substantial data** (a full seeded history) — these are three genuinely different layout
  cases and all three need to look correct, not just error-free.
- Confirm the exported PDF actually opens correctly in a real PDF viewer (not just "the file
  generation function didn't throw") as part of your manual verification step (Section 3.4).

## 7. General judgment calls

- If `BACKLOG.md` or `PROJECT_STATUS.md` conflicts with what you actually find in the live
  repository (they were written from a decompiled build, not the source of truth — see the
  disclaimer at the top of `PROJECT_STATUS.md`), trust the live repository and note the
  discrepancy rather than assuming the docs are correct.
- Prefer wiring existing scaffolding (repositories, providers, services already present per
  `ARCHITECTURE.md`) over writing new parallel infrastructure. Most of P0–P1 is connection work,
  not new engineering — resist the urge to rewrite what's already there and working (e.g. don't
  touch `CyclePredictor`'s algorithm while wiring T2; it's correct, just unused).
- When in doubt about scope, smaller and fully-verified beats larger and partially-verified.
