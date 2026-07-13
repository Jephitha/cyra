# Cyra Manual Test Walkthrough and Results Workbook

Use this file for a complete real-device acceptance test. Edit it in place, tick exactly one result for every check, attach evidence paths or links, and upload the partially or fully completed file to the agent. You may stop and upload it immediately when a blocker prevents further testing.

## How to record results

For each numbered check, tick exactly one result:

- `[ ] PASS` — observed result matches the expected result.
- `[ ] FAIL` — test can continue, but the result is wrong.
- `[ ] BLOCKED` — this issue prevents this test or later tests.
- `[ ] N/A` — the device or test account cannot support the feature; explain why.

Never enter real medical information. Use the synthetic values in this workbook. For every FAIL or BLOCKED result, add an entry to the Issue Log at the end and preserve screenshots, screen recordings, and logs. Do not uninstall or clear the app after a failure until the agent has reviewed it.

## Test run record

| Field | Tester input |
|---|---|
| Test run ID | `[enter, e.g. CYRA-2026-07-13-A]` |
| Tester name | `[enter]` |
| Start date/time and timezone | `[enter]` |
| End date/time and timezone | `[enter when complete]` |
| Git commit/build identifier | `[enter]` |
| App version shown in Settings | `[enter]` |
| Build file installed | `[enter full filename]` |
| Platform | `[Android / iOS]` |
| Device make and model | `[enter]` |
| OS version | `[enter]` |
| Screen size/orientation | `[enter]` |
| Install type | `[clean install / upgrade from version ___]` |
| Network | `[Wi-Fi name or offline]` |
| Local API URL | `http://192.168.100.8:54321` |
| Test account email | `[synthetic address used]` |
| Test account ID, if visible | `[enter or N/A]` |

## Synthetic test data

Use these values unless a check explicitly says otherwise.

| Field | Value used |
|---|---|
| Profile name | `Cyra Manual Tester` |
| Profile email | `cyra.manual.tester@example.com` |
| Date of birth | `1994-06-15` |
| PIN | `2468` |
| Period start | `[enter a date 14–21 days before today]` |
| Period end | `[enter 4 days after start]` |
| Symptom | `Cramps`, severity `7/10` |
| BBT | `36.62 °C` (or corresponding °F) |
| Journal title | `Manual QA private note` |
| Journal body | `Synthetic entry for Cyra manual testing. No real health data.` |
| Community post | `Manual QA connectivity check — synthetic content.` |

## Stop-and-upload procedure

If testing is blocked:

1. Leave the app and server in their current state.
2. Tick BLOCKED on the exact step.
3. Fill an Issue Log row and its detailed issue template.
4. Record the last passing step: `[enter ID]`.
5. Record what screen is currently visible: `[enter]`.
6. Upload this file and the referenced evidence to the agent. The agent can review it before the rest of the walkthrough is complete.

## A. Preflight and installation

### A1. Backend reachability

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Connect the phone and this Mac to the same Wi-Fi. Open `http://192.168.100.8:54321/rest/v1/` in the phone browser.
- Expected: A Supabase response appears. An authorization error is acceptable; a timeout or connection-refused page is not.
- Actual: `[enter]`
- Evidence: `[enter path/link]`

### A2. Clean installation and launch

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Install the supplied build and launch Cyra.
- Expected: The app installs under the name Cyra, shows the Cyra launcher icon, opens without a crash, and presents onboarding on a clean install.
- Actual: `[enter]`
- Evidence: `[enter screenshot of launcher and first screen]`

### A3. Layout smoke check

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Rotate the device where supported, open and close the keyboard, and return to portrait.
- Expected: No clipped controls, overflow stripes, blank screen, or stuck keyboard.
- Actual: `[enter]`

## B. Onboarding, privacy setup, and lock

### B1. Onboarding

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Read each onboarding page, move forward and backward, then complete it.
- Expected: Progress is clear; Back/Continue work; medical/privacy language is readable; completion advances to privacy setup only once.
- Actual: `[enter]`

### B2. PIN setup and validation

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Enable PIN using `2468`, enter a mismatched confirmation once, then confirm correctly. Background and reopen the app after the configured lock interval.
- Expected: Mismatch is rejected without losing context; correct PIN saves; reopen shows the lock; a wrong PIN is rejected; `2468` unlocks.
- Actual: `[enter]`

### B3. Biometric lock

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Enable biometric lock, authenticate, lock the app, and unlock biometrically. Also cancel one biometric prompt.
- Expected: Successful authentication unlocks; cancellation remains securely locked and offers a valid fallback.
- Actual: `[enter or explain N/A]`

### B4. Relaunch routing

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Force-close and reopen twice.
- Expected: Completed onboarding does not repeat; the lock gate appears when enabled; successful unlock returns to the intended app screen.
- Actual: `[enter]`

## C. Cycle logging, persistence, and calendar

### C1. Log a period

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: From Home or Calendar, log the synthetic start/end dates, vary flow across days, add a note, and save.
- Expected: Save succeeds once, the selected range appears in calendar/history, flow and note persist, and Photo/Voice controls clearly state that attachments belong in Journal rather than silently doing nothing.
- Dates and values used: `[enter]`
- Actual: `[enter]`

### C2. Edit and reopen

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Reopen the saved period, change one flow value, save, force-close, and reopen Cyra.
- Expected: The change remains after relaunch and no duplicate cycle is created.
- Actual: `[enter]`

### C3. Calendar and cycle history

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Change months, select period and non-period dates, open cycle history and cycle detail.
- Expected: Selected dates are correct, legends match colors, future predictions are distinguishable from recorded data, and navigation never lands on Page not found.
- Actual: `[enter]`

### C4. Prediction integrity

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open prediction details and compare dates with Home and Calendar.
- Expected: All screens agree; estimates are labeled as predictions; confidence/insufficient-data messaging is honest.
- Actual: `[enter]`

## D. Symptoms, conditions, insights, and education

### D1. Symptom log

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Log Cramps at `7/10` with a synthetic note, save, reopen, edit to `6/10`, and relaunch.
- Expected: One entry exists, all values persist, and the edit is reflected in history and relevant insights.
- Actual: `[enter]`

### D2. Quick log and mood

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Use Quick Log for a second symptom and Mood Tracker for one mood.
- Expected: Each confirmation is clear, entries appear on the correct date, and repeated taps do not create accidental duplicates.
- Actual: `[enter]`

### D3. Condition tracking

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open Conditions, select a condition, enable tracking, review details and patterns, then disable/re-enable tracking.
- Expected: Tracking state persists. Pattern Recognition shows only statements derived from logged entries; no invented frequency chart or unsupported diagnosis appears.
- Actual: `[enter]`

### D4. Education hub

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open education from Insights and from the fertility education links; search, open an article, bookmark it, and return.
- Expected: Both links open the hub; search and article navigation work; bookmark state persists; medical disclaimer is visible.
- Actual: `[enter]`

## E. Ovulation and fertility modes

### E1. BBT, mucus, and OPK

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Log BBT `36.62 °C`, one cervical-mucus observation, and one OPK result on specified dates; reopen each.
- Expected: Values and dates persist and appear in the fertility chart/calendar without claiming confirmed ovulation from insufficient data.
- Dates used: `[enter]`
- Actual: `[enter]`

### E2. Unit conversion

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Settings → Units: choose Imperial and Fahrenheit, leave Settings, reopen it, force-close/relaunch, then switch back to Metric and Celsius.
- Expected: Selected values update immediately and persist through relaunch; temperature displays consistently convert or clearly retain the entered unit.
- Actual: `[enter]`

### E3. Trying to conceive / avoiding pregnancy

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open each fertility mode, log synthetic intercourse data where available, and use its education link.
- Expected: Saved values return after navigation; education links open real articles; contraception/fertility estimates include appropriate cautions.
- Actual: `[enter]`

## F. Pregnancy features

### F1. Pregnancy setup

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Start pregnancy mode with a synthetic last-period or due date, review the calculated due date, then reopen.
- Expected: Dates are plausible and consistent, state persists, and cycle/fertility data is not silently destroyed.
- Values used: `[enter]`
- Actual: `[enter]`

### F2. Weekly dashboard and vitals

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open week detail, log synthetic symptoms and vitals, then edit/reopen.
- Expected: Correct pregnancy week is shown; entries persist; abnormal-value guidance does not diagnose and directs urgent symptoms appropriately.
- Actual: `[enter]`

### F3. Kick and contraction counters

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Record several kicks; start, lap, stop, and reset a contraction session.
- Expected: Timers update accurately, accidental navigation does not corrupt a saved session, and safety guidance remains accessible.
- Actual: `[enter]`

## G. Journal, reports, export, and deletion

### G1. Encrypted journal entry

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Create the synthetic journal entry, add a test photo and short test voice note, save, reopen, edit, and relaunch.
- Expected: Text and attachments persist; permission denial is handled; privacy labels are clear; deleted attachments are no longer accessible.
- Actual: `[enter]`

### G2. Generate report

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Generate a report for a range containing the synthetic records, preview it, export/share it, and open the resulting PDF outside Cyra.
- Expected: PDF opens, has readable pages, correct date range/data, no clipping, and no unrelated private information.
- Output filename/path: `[enter]`
- Actual: `[enter]`

### G3. JSON data export

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Settings → Export Data (or Privacy & Security), export JSON, save/share it, and inspect the file.
- Expected: Export flow is reachable; file is valid JSON; synthetic records are present; export reports failures instead of claiming success.
- Output filename/path: `[enter]`
- Actual: `[enter]`

### G4. Selective and full deletion

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Delete one disposable record, verify it is gone after relaunch, then test full deletion only after exports are preserved.
- Expected: Destructive actions require confirmation, cancellation is safe, confirmed data is removed from UI/storage, and the app returns to a coherent first-use state.
- Actual: `[enter]`

## H. Privacy and emergency controls

### H1. Private mode and app-switcher privacy

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Enable Private Mode, background Cyra, inspect the recent-apps preview, and return.
- Expected: Sensitive values are concealed as designed and the app-switcher snapshot does not expose health content.
- Actual: `[enter]`

### H2. Hidden launcher icon — Android real device

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Enable Hidden App Icon, return to the launcher, wait up to 10 seconds, launch the Weather-disguised icon, disable it, and repeat after reboot.
- Expected: Cyra icon disappears and Weather icon appears without duplicate launchers; Weather opens Cyra; disabling restores Cyra; state survives reboot. This check closes backlog item T9a.
- Actual: `[enter, including launcher name/version]`
- Evidence: `[required screenshots before, hidden, restored]`

### H3. Emergency lock

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Configure the emergency action, trigger it, attempt Back/relaunch, then use the documented recovery path.
- Expected: Protected content remains inaccessible until recovery; app does not crash or leak data; recovery is possible with valid credentials.
- Actual: `[enter]`

## I. Notifications and deep links

### I1. Permissions and master toggle

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Deny notification permission once, retry and allow it, then toggle All Notifications off/on.
- Expected: Denial is explained without a loop; settings remain usable; master-off prevents scheduling; state persists.
- Actual: `[enter]`

### I2. Scheduled notification privacy

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Schedule a near-term reminder, lock the phone, and wait for delivery under each preview setting.
- Expected: One notification arrives near the chosen time; lock-screen text matches privacy preference; tapping it unlocks if required and opens the intended destination.
- Scheduled time / received time: `[enter]`
- Actual: `[enter]`

### I3. Reboot persistence

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Schedule a future reminder, reboot the device, and wait.
- Expected: Reminder is restored and delivered once, not duplicated.
- Actual: `[enter]`

## J. Community and local server

### J1. Sign-up/sign-in

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Create or sign into the synthetic account using the local server. Test one invalid credential/OTP first.
- Expected: Invalid input is rejected clearly; valid authentication succeeds; no secret token appears in UI/logs; session survives relaunch.
- Actual: `[enter]`

### J2. Community read/write

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open Community, read guidelines, create the synthetic post, open it, react/comment where supported, then delete your content.
- Expected: Server data loads without timeout; authorship and timestamps are correct; optimistic UI reconciles with server; deletion removes the content after refresh.
- Actual: `[enter]`

### J3. Offline and recovery

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Turn on airplane mode while viewing Community, retry an action, restore Wi-Fi, and retry.
- Expected: App displays an actionable offline/error state without losing local health data; restored connectivity succeeds without duplicate posts.
- Actual: `[enter]`

## K. Wearables and premium

### K1. Paywall/store behavior

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open Premium, attempt purchase/restore using a sandbox store account, cancel once, then complete where configured.
- Expected: Products/prices come from the store, cancellation is non-destructive, success unlocks premium, and restore survives relaunch.
- Store environment/account: `[enter or explain N/A]`
- Actual: `[enter]`

### K2. Health Connect / Apple Health

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open Connected Devices, deny then grant health permissions, run sync with synthetic health data, and disable Auto Sync.
- Expected: Premium gate is enforced consistently; denied permission is recoverable; supported values sync once with correct units/dates; unsupported devices show an honest message.
- Actual: `[enter]`

## L. Settings, appearance, accessibility, and support

### L1. Profile persistence

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Save the synthetic name/email/date of birth, leave Settings, force-close, and reopen.
- Expected: Profile row displays `Cyra Manual Tester`; all three fields remain populated after relaunch.
- Actual: `[enter]`

### L2. Appearance

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Test System, Light, and Dark themes; each text-size option; high contrast; reduce motion; and phase colors. Relaunch after the final choice.
- Expected: Changes apply throughout the app, persist, remain legible, do not overflow at largest text, and honor reduced motion.
- Actual: `[enter]`

### L3. Settings links

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Open Export Data, Manage Data, Licenses, Privacy Policy, Terms, Medical Disclaimer, Contact Us, FAQ, Send Feedback, Sync Preferences, and Language.
- Expected: Every enabled row opens a real screen/dialog; none silently ignores a tap. Coming-soon options are visibly disabled/labeled.
- Actual: `[enter]`

## M. Stability and final regression

### M1. Navigation sweep

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Visit every bottom tab repeatedly, use Android Back/iOS swipe-back, open nested screens, and return Home.
- Expected: Correct tab remains selected, Back is predictable, no Page not found/blank screens occur, and input is not unexpectedly lost.
- Actual: `[enter]`

### M2. Stress and duplicate-action check

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Rapidly tap Save once on a disposable entry, scroll long screens, background/foreground during loading, and use Cyra for at least 15 minutes.
- Expected: No crash, freeze, duplicate record, permanent spinner, excessive heat, or obvious memory/performance degradation.
- Actual: `[enter]`

### M3. Final relaunch

- [ ] PASS  [ ] FAIL  [ ] BLOCKED  [ ] N/A
- Action: Force-close, reopen, unlock, and spot-check cycle, symptom, settings, and server-backed content.
- Expected: Data and preferences match the completed run and the app remains usable.
- Actual: `[enter]`

## Issue Log

Use severity: `S0 data loss/security`, `S1 blocker/crash`, `S2 major incorrect behavior`, `S3 minor/cosmetic`.

| Issue ID | Severity | Test step | Short title | Status | Evidence |
|---|---|---|---|---|---|
| `CYRA-MAN-001` | `[S0–S3]` | `[e.g. C2]` | `[enter]` | `[Open/Blocked/Retest pass]` | `[path/link]` |
| `[add rows]` |  |  |  |  |  |

### Detailed issue template — copy once per issue

- Issue ID: `[enter]`
- Test step: `[enter]`
- Severity: `[S0 / S1 / S2 / S3]`
- Device/OS/build: `[enter]`
- Preconditions: `[enter]`
- Exact steps to reproduce:
  1. `[enter]`
  2. `[enter]`
  3. `[enter]`
- Expected result: `[enter]`
- Actual result: `[enter exact visible text where possible]`
- Reproduction rate: `[e.g. 3/3]`
- Does relaunch fix it? `[yes/no/not tried]`
- Does reinstall fix it? `[do not reinstall before agent review; enter not tried]`
- Network/API state: `[online/offline and URL]`
- Evidence paths/links: `[enter]`
- Relevant timestamps and timezone: `[enter]`
- Additional notes: `[enter]`

## Final sign-off

| Result | Count |
|---|---:|
| PASS | `[enter]` |
| FAIL | `[enter]` |
| BLOCKED | `[enter]` |
| N/A | `[enter]` |
| Open S0/S1 issues | `[enter]` |

- [ ] All checks have exactly one status.
- [ ] Every FAIL/BLOCKED check has an Issue Log entry.
- [ ] Required evidence is attached and paths are valid.
- [ ] Synthetic test content was removed from Community if deletion worked.
- [ ] The completed or partial workbook is ready to upload to the agent.

Tester verdict: `[APPROVE / APPROVE WITH KNOWN ISSUES / DO NOT APPROVE]`

Tester notes: `[enter]`
