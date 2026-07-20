# Cyra Linear Manual Test Walkthrough

Follow this document from top to bottom after a clean installation. Do not skip ahead unless a step explicitly says you may. Each result option is on its own line so it can be marked independently.

Use synthetic information only. Do not enter real health information.

If any issue prevents further testing, mark **Blocked**, complete the issue fields for that step, stop changing the app, and upload this partially completed file to the agent.

## Test run details

| Field | Tester input |
| --- | --- |
| Test run ID | `[enter, for example CYRA-2026-07-13-A]` |
| Tester name | `[enter]` |
| Start date and time | `[enter]` |
| Device and model | `[enter]` |
| Android/iOS version | `[enter]` |
| Cyra version | `[enter]` |
| Build filename | `[enter]` |
| Git commit | `[enter]` |
| Local server URL | `http://192.168.100.8:54321` |
| Wi-Fi network | `[enter]` |

## Standard result block

Every numbered test has four separate result checkboxes. Mark exactly one:

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

For every **Fail** or **Blocked** result, enter an issue ID and complete the Issue Log at the end.

## Synthetic values used throughout this run

| Field | Test value |
| --- | --- |
| PIN | `123456` |
| Profile name | `Cyra Manual Tester` |
| Profile email | `cyra.manual.tester@example.com` |
| Date of birth | `1994-06-15` |
| Account email | `[enter a synthetic email you can access]` |
| Account password | `[enter a test-only password; do not upload the password]` |
| Period date | `[choose a date 14 days before today]` |
| Period note | `Synthetic period entry for Cyra manual QA.` |
| Symptom | `Cramps` |
| Symptom severity | `7/10` |
| Symptom note | `Synthetic symptom entry for Cyra manual QA.` |
| BBT | `36.62 °C` |
| Pregnancy date | `[choose a synthetic date that produces a valid current pregnancy]` |

## Previous-run observations preserved from the superseded workbook

These notes are preserved for traceability. They are not marked as results in this new run.

- Backend was reachable.
- Clean installation and launch passed.
- Initial layout smoke check passed.
- Onboarding passed.
- The old walkthrough incorrectly supplied a four-digit PIN. A five-digit PIN was accepted by the build even though the screen requests six digits. This walkthrough now uses the requested six-digit value `123456`.
- Biometrics were not enrolled on the test device and were recorded as not applicable.

---

## Step 1 — Confirm the local server is reachable

1. Connect the phone and the development Mac to the same Wi-Fi.
2. On the phone, open a browser.
3. Visit `http://192.168.100.8:54321/rest/v1/`.
4. Confirm the browser receives a response. An authorization message is acceptable. A timeout or connection-refused message is not.

Expected: The local Supabase endpoint responds.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 2 — Verify the clean installation

1. Confirm Cyra was uninstalled before this build was installed.
2. Find **Cyra** in the device launcher.
3. Confirm the normal Cyra icon is shown.
4. Tap **Cyra**.
5. Wait up to 20 seconds on the first launch.

Expected: Cyra opens without a crash and displays **Your Body, Your Data**. It must not open on Home, Privacy Setup, or a previously used screen.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Evidence: `[screenshot path or link]`

## Step 3 — Complete the three onboarding pages

1. On **Your Body, Your Data**, read the text and tap **Next**.
2. On **Understand Your Cycle**, swipe back once and confirm the first page returns.
3. Tap **Next** twice to return to the second page and advance.
4. On **Your Lifelong Companion**, tap **Get Started**.

Expected: Pages move in the requested direction, the progress indicator updates, text remains visible without clipping, and **Privacy Setup — Step 1 of 4** opens.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 4 — Choose initial privacy options

1. On **What matters most to you?**, leave **Biometric Lock** off if the device has no enrolled biometric.
2. Turn **Private Mode** on.
3. Leave **Hide App Icon** off for now. It is tested later.
4. Leave **Emergency Privacy Gesture** off for now. It is tested later.
5. Open the **Auto-Lock** selector and choose **5 Minutes**.
6. Tap **Continue**.

Expected: Each selected control visibly changes state and the next applicable setup step opens.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Selections used: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 5 — Handle biometric setup

If the device has an enrolled fingerprint or face:

1. Follow the biometric prompt.
2. Cancel the first prompt.
3. Confirm Cyra remains on setup and does not enable biometrics.
4. Try again and authenticate successfully.

If the device has no enrolled biometric, confirm Cyra skips the biometric step or explains that it is unavailable, then mark **Not applicable**.

Expected: Cancellation is safe; success enables biometrics; an unsupported device does not become stuck.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 6 — Create the six-digit PIN

1. On **Set a Passcode**, enter `123456`.
2. In confirmation, enter `123450`.
3. Tap **Continue** and confirm the mismatch is rejected.
4. Replace confirmation with `123456`.
5. Tap **Continue**.

Expected: The mismatched PIN is rejected without leaving the page. The matching six-digit PIN advances to **You're all set**.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 7 — Finish privacy setup

1. Review the choices shown on **You're all set**.
2. Confirm the summary matches the options selected in Step 4 and Step 5.
3. Tap **Start Your Journey**.

Expected: Home opens and shows **Welcome to Cyra! Start by logging your first period.**

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 8 — Verify first-run Home and bottom navigation

1. Confirm Home shows **Log Your Period** and **Explore Calendar**.
2. Tap the bottom **Calendar** tab, then **Insights**, **Community**, **Settings**, and **Home** in that order.
3. Confirm the selected tab indicator follows each tap.
4. Return to **Home**.

Expected: Every bottom tab opens the correctly named Cyra screen. No blank screen, crash, unrelated app feature, or **Page not found** appears.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 9 — Log the first period

1. On Home, tap **Log Your Period**.
2. On **When did your period start?**, select the synthetic **Period date**.
3. Leave **I'm spotting** off, then tap **Next**.
4. On **How heavy is your flow?**, choose **Medium**, then tap **Next**.
5. On **Any symptoms?**, choose **Cramps**, then tap **Next**.
6. On **Add notes (optional)**, enter the synthetic period note.
7. Confirm **Photo (journal only)** and **Voice Note (journal only)** are disabled and clearly labeled, then tap **Next**.
8. On **Review & Save**, check the date, flow, symptom, and note.
9. Tap **Save** once.

Expected: A success message appears, the screen closes, and Home changes from the empty state to the populated cycle dashboard.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Date/flow used: `[enter]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 10 — Verify the populated Home dashboard

1. Confirm Home shows the cycle day and cycle phase.
2. Confirm **Log today**, **Ovulation Tracking**, **Pregnancy Mode**, and **Cycle Overview** are visible while scrolling.
3. If a prediction card is shown, tap it and confirm **Prediction Details** opens; then go back.
4. Scroll to **Recent Activity**.
5. Confirm the period entry from Step 9 appears.
6. Tap **View full history**, open the listed cycle, then return to Home.

Expected: Dates and recorded values agree across Home, prediction details, history, and cycle detail. Predictions are labeled as estimates rather than recorded facts.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 11 — Verify Calendar and edit a period day

1. Tap the bottom **Calendar** tab.
2. Move to the previous month and back to the current month.
3. Tap **Today**.
4. Select the recorded period date from Step 9.
5. Confirm the selected-day panel shows the correct date, flow, spotting, and note.
6. Tap **Log Period** in the selected-day panel.
7. Complete the five-page period wizard again for that same date, selecting **Light** flow and changing the note to `Updated synthetic period entry for Cyra manual QA.`
8. On **Review & Save**, tap **Save**, then return to Calendar.
9. Re-select the date.

Expected: Calendar colors match the Period/Fertile/Ovulation legend, the selected date is correct, and the edited value is shown without creating a duplicate cycle.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 12 — Log and verify a symptom

1. Tap the bottom **Home** tab.
2. Under **Log today**, tap **Log Symptoms**.
3. Choose the category containing **Cramps**.
4. Select **Cramps**.
5. Set severity to `7/10`.
6. Enter the synthetic symptom note if a note field is available.
7. Tap **Save Symptoms** once.
8. Confirm the screen closes and Home returns without an error message.

Expected: **Save Symptoms** is disabled before a symptom is selected, becomes enabled afterward, and saving returns to Home without an error. Visual symptom-history verification is not included because the existing history screen has no reachable user entry point in this build.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 13 — Log basal body temperature

1. Return to **Home**.
2. Under **Ovulation Tracking**, tap **BBT**.
3. Select today's date and enter `36.62 °C`.
4. Enter any required measurement time.
5. Tap **Save** once.

Expected: Saving returns to Home without an error. Visual BBT-history verification is not included because the screens that display saved ovulation records have no reachable user entry point in this build.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 14 — Log cervical mucus

1. Return to **Home**.
2. Under **Ovulation Tracking**, tap **Mucus**.
3. Select today's date.
4. Select one mucus type and any other required fields.
5. Tap **Save** once.

Expected: Saving returns to Home without an error. Visual mucus-history verification is not included because the screens that display saved ovulation records have no reachable user entry point in this build.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Values used: `[enter]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 15 — Log an ovulation test

1. Return to **Home**.
2. Under **Ovulation Tracking**, tap **OPK**.
3. Select today's date.
4. Choose **Negative**.
5. Tap **Save** once.

Expected: Saving returns to Home without an error. Visual OPK-history verification is not included because the screens that display saved ovulation records have no reachable user entry point in this build.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 16 — Review Insights after entering data

1. Tap the bottom **Insights** tab.
2. Read the current phase and weekly summary areas.
3. Open each visible enabled **View Details**, **Learn More**, or health-tip action one at a time.
4. Use Back after each detail screen.
5. If a premium card opens the paywall, confirm the paywall identifies premium features and what remains free, then return.

Expected: Insights use the period/symptom data entered earlier, clearly distinguish estimates, show medical/AI disclaimers, and never invent unlogged measurements.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 17 — Test Community loading and offline recovery

1. Tap the bottom **Community** tab while Wi-Fi is on.
2. Wait up to 15 seconds.
3. Confirm **Cyra Community** and either topic cards or a clear server error are shown.
4. Turn airplane mode on.
5. Pull down to refresh Community.
6. Confirm an actionable offline/error state appears rather than an endless loader or crash.
7. Turn airplane mode off and reconnect to Wi-Fi.
8. Pull down to refresh again.

Expected: Community loads from the local Cyra server when online, fails clearly when offline, and recovers without restarting the app.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter exact server error text if shown]`

Issue ID/evidence: `[enter or leave blank]`

## Step 18 — Create or sign in to a test account

1. On Community, tap **Sign in to sync your activity**.
2. On **Sign In**, tap **Don't have an account? Create one** if a test account does not already exist.
3. Enter the synthetic account email.
4. Enter a test-only password and a deliberately different confirmation.
5. Tap **Create Account** and confirm the mismatch is rejected.
6. Correct the confirmation and create the account.
7. Follow any confirmation process provided by the local test server.
8. Return to **Sign In** and sign in with the test account.

Expected: The app uses the email and password fields shown, validates mismatched passwords, displays server errors clearly, and returns to Cyra after successful sign-in.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Test email: `[enter; do not enter the password]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 19 — Exercise Community content

Complete only if Community topics loaded and sign-in succeeded.

1. Open one topic card.
2. Return and tap **Join** on that topic.
3. Reopen the topic.
4. Create the synthetic post if a **New Post** action is visible.
5. Open the created post and add a synthetic reply/reaction if those controls are visible.
6. Delete your synthetic content where deletion is offered.
7. Return to Community and open **Community Guidelines**.
8. Return and open **Report a Concern**; verify validation with an empty description, then cancel without submitting.

Expected: Only visible/enabled controls are exercised, server changes survive refresh, no duplicate content is created, and private health records are never exposed to Community.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 20 — Save profile information

1. Tap the bottom **Settings** tab.
2. Tap **Profile**.
3. Enter `Cyra Manual Tester`.
4. Enter `cyra.manual.tester@example.com`.
5. Enter `1994-06-15` for date of birth.
6. Tap **Save**.
7. Leave Settings for Home, then return to Settings.

Expected: The Profile row displays **Cyra Manual Tester**, and reopening Profile shows all three saved values.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 21 — Verify units persist

1. In Settings, scroll to **Units**.
2. Tap **Units System** and choose **Imperial**.
3. Tap **Temperature** and choose **Fahrenheit**.
4. Leave Settings and return.
5. Confirm both rows show the new choices.
6. Force-close and reopen Cyra.
7. Unlock with `123456` if required.
8. Return to Settings and confirm the choices still show.
9. Change them back to **Metric** and **Celsius**.

Expected: Unit choices update immediately and survive relaunch.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 22 — Verify appearance controls

1. In Settings, tap **Theme & Display**.
2. Select **Light** and inspect the screen.
3. Select **Dark** and inspect the screen.
4. Select **System**.
5. Move text size to the largest option.
6. Turn **High Contrast** on if available.
7. Turn **Reduce Motion** on if available.
8. Return to Home, Calendar, Insights, Community, and Settings.
9. Return to Theme & Display and restore preferred values.

Expected: Every selection changes the intended appearance, persists while navigating, remains readable, and produces no clipped text or overflow at maximum text size.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 23 — Verify notification settings

1. In Settings, tap **Notification Settings**.
2. Turn **All notifications** on.
3. If Android asks permission, deny it once.
4. Confirm Cyra reports that permission was not granted and returns the master toggle to off.
5. Turn it on again and grant permission.
6. Enable **Period prediction**, **Fertile window**, and **Estimated ovulation day** one at a time.
7. Open the days-before and time controls and change each visible value.
8. Change each notification preview option under **Privacy**.
9. Return to Settings, reopen Notifications, and confirm values remain.

Expected: Permission denial is recoverable, schedules use real cycle dates, choices persist, and pregnancy reminders are honestly labeled as not scheduled yet.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 24 — Verify privacy controls and lock behavior

1. In Settings, tap **Privacy & Security**.
2. Confirm **PIN Code** is enabled.
3. Open the auto-lock selector and confirm the chosen duration.
4. Turn **Private Mode** off, then on again.
5. Background Cyra and inspect the recent-apps preview.
6. Return to Cyra.
7. Tap **Change** beside PIN if visible, set a temporary six-digit PIN, verify it, then change back to `123456`.
8. Force-close and reopen Cyra.
9. Enter one incorrect PIN, then `123456`.

Expected: Private Mode protects previews as described, incorrect PIN is rejected, correct PIN unlocks, and PIN changes persist securely.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 25 — Verify the hidden launcher icon on Android

Android real device only.

1. In **Privacy & Security**, turn **Hidden App Icon** on.
2. Wait up to 10 seconds.
3. Go to the device launcher.
4. Confirm the Cyra launcher entry disappears and one **Weather** entry appears.
5. Take a screenshot.
6. Tap **Weather** and confirm it opens the same Cyra installation.
7. Return to **Privacy & Security** and turn **Hidden App Icon** off.
8. Wait up to 10 seconds and return to the launcher.
9. Confirm **Cyra** returns and **Weather** disappears.
10. Take a screenshot.

Expected: Exactly one launcher entry is present in either state, both launcher identities open Cyra, and switching does not delete app data.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter launcher name/version and timing]`

Evidence: `[required screenshot paths/links]`

## Step 26 — Verify emergency lock

1. In **Privacy & Security**, turn **Emergency Lock** on.
2. Complete **Emergency Setup** using only synthetic values.
3. Trigger the emergency gesture exactly as instructed by the setup screen.
4. Confirm the calculator/disguised emergency screen appears.
5. Try Android Back once.
6. Follow the configured recovery action.

Expected: Health content cannot be reached with Back while emergency lock is active, the disguise contains no Cyra health data, and valid recovery returns safely to Cyra.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Gesture/recovery configured: `[enter without recording a real secret]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 27 — Export a readable PDF

1. In **Privacy & Security**, scroll to **Your Data**.
2. Tap **Export my data**.
3. In **Name on report (optional)**, enter `Cyra Manual Tester`.
4. Tap **Date range** and select a range containing the synthetic period and symptom entries.
5. Leave **Include detailed daily log** checked.
6. Leave **Include journal entries** unchecked.
7. Tap **Generate PDF** and complete any requested PIN or biometric authentication.
8. Confirm **Your PDF is ready** appears.
9. Tap **Save to device**, choose a test location in the system share sheet, and save the file.
10. Open the PDF outside Cyra.

Expected: The PDF opens, uses the chosen date range, contains the synthetic Cyra health entries, has readable pages without clipping, and does not invent data.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Export filename/path: `[enter]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 28 — Export raw JSON

1. Return to **Privacy & Security → Your Data**.
2. Expand **Advanced exports**.
3. Tap **Export date range as JSON**.
4. Choose a range containing the synthetic entries.
5. Record the success message and filename.
6. Repeat with **Export all data as JSON**.
7. Open each exported file using a suitable text viewer if available.

Expected: Both actions report success only when a file exists, files contain valid JSON, and synthetic entries use the correct dates and values.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Export filenames/paths: `[enter]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 29 — Verify connected-device and premium behavior

1. Return to Settings.
2. Under **Wearables**, tap **Connected Devices**.
3. Confirm no Apple Health or Health Connect connection is offered in the release build.
4. Deny permission once, then retry and grant it if the device supports the service.
5. Return to Settings and turn **Auto Sync** on.
6. If the paywall opens, confirm the premium explanation is shown.
7. On the paywall, test **Restore purchases** only with a sandbox store account.
8. Cancel without making a real purchase.

Expected: Unsupported hardware shows an honest message, permission denial is recoverable, premium gating is consistent, and no real charge occurs.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Device/store environment: `[enter]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 30 — Exercise all enabled Settings links

Starting on Settings, open each item below and return before opening the next:

1. **Sync Preferences**.
2. **Cloud Account**.
3. **Export Data**.
4. **Manage Data**.
5. **App Language**.
6. **Licenses**.
7. **Privacy Policy**.
8. **Terms of Service**.
9. **Medical Disclaimer**.
10. **Contact Us**.
11. **FAQ**.
12. **Send Feedback**.

Expected: Every enabled row opens a Cyra screen, sheet, or dialog. Coming-soon languages are visibly disabled. No row silently ignores a tap, and every opened page contains only Cyra content.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[list any row that failed or contained placeholder text]`

Issue ID/evidence: `[enter or leave blank]`

## Step 31 — Test Pregnancy Mode

Pregnancy testing changes the synthetic app state. Complete it after the cycle, insight, and export checks above.

1. Tap the bottom **Home** tab.
2. Scroll to **Pregnancy Mode** and tap **Open**.
3. On **Welcome to Your Pregnancy Journey**, tap **Set Up Pregnancy**.
4. On **How did you calculate your due date?**, select **From my last period**, then tap **Continue**.
5. Select the synthetic pregnancy date as the first day of the last period, then tap **Continue**.
6. Review the calculated due date and tap **Start Tracking**.
7. Confirm the dashboard shows a plausible week, trimester, and estimated due date.
8. Open the current week detail and return.
9. Tap **Weight**, enter a synthetic value, and save.
10. Tap **Blood Pressure**, enter `120/80`, and save.
11. Tap **Glucose**, enter a synthetic in-range value, and save.
12. Reopen the dashboard and confirm the latest values are shown.

Expected: Pregnancy setup and vitals persist, calculations agree across screens, and the app does not diagnose from synthetic values.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Dates/values used: `[enter]`

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 32 — Test pregnancy counters

Complete only after Step 31 creates an active synthetic pregnancy.

1. From Pregnancy dashboard, open **Kick Counter**.
2. Start a session, record three kicks, stop the session, and return.
3. Reopen Kick Counter and confirm the session appears in history.
4. Return to Pregnancy dashboard and open **Contraction Timer**.
5. Start a contraction, wait at least five seconds, and stop it.
6. Repeat once.
7. Confirm summary statistics and the two entries appear.
8. Return, reopen Contraction Timer, and confirm the entries persist.

Expected: Counters respond once per tap, saved sessions survive navigation, and safety guidance remains visible without making a diagnosis.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 33 — Final relaunch and persistence check

1. Force-close Cyra.
2. Reopen it from the normal Cyra launcher icon.
3. Unlock with `123456` if required.
4. Confirm onboarding and Privacy Setup do not repeat.
5. Confirm the period, profile, units, privacy settings, and synthetic pregnancy state still appear in their reachable screens.
6. Visit all five bottom tabs once.

Expected: Cyra returns to a coherent app state, all user-visible saved values remain, and no crash, blank screen, **Page not found**, or unrelated-app content appears. Saved symptom and ovulation-record persistence cannot be visually rechecked until their existing history/dashboard screens receive user-reachable navigation.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

## Step 34 — Delete the synthetic health data

Do this only after exported evidence has been preserved.

1. Go to **Settings → Privacy & Security → Your Data**.
2. Tap **Delete Date Range**.
3. Select a range containing only part of the synthetic data.
4. Cancel the first confirmation and verify nothing is deleted.
5. Repeat and confirm deletion.
6. Verify the selected records disappear after relaunch.
7. Return to **Your Data** and tap **Delete All Data**.
8. Cancel at the second confirmation and verify data remains.
9. Repeat, pass both confirmations, and delete all synthetic health data.
10. Force-close and reopen Cyra.

Expected: Cancellation is safe, confirmed deletion removes only the requested scope, full deletion requires two confirmations, and the app returns to a usable empty-data Home state.

- [ ] Pass
- [ ] Fail
- [ ] Blocked
- [ ] Not applicable

Actual result: `[enter]`

Issue ID/evidence: `[enter or leave blank]`

---

## Reachability gaps not represented as test steps

The following Cyra screens exist in source code but have no user-reachable button or route from the current app shell. They are intentionally excluded from the tap-by-tap walkthrough until navigation is added:

- Journal list and journal attachment flows.
- Standalone Health Reports list/generator screens. The reachable PDF export in Privacy is tested instead.
- Conditions hub and condition tracking screens.
- Education Hub and article browsing screens.
- Trying to Conceive and Avoid Pregnancy dashboards.
- Ovulation dashboard and fertility chart; direct BBT, Mucus, and OPK logging remains reachable and is tested.
- Quick Log, Mood Tracker, and Symptom History screens.

Treat these as product/navigation gaps, not as manual-test failures caused by the tester.

## Issue Log

Severity:

- `S0` — security/privacy breach or irreversible data loss.
- `S1` — crash or blocker preventing the main test sequence.
- `S2` — major incorrect behavior with a workaround.
- `S3` — minor, visual, wording, or usability defect.

| Issue ID | Severity | Step | Short title | Status | Evidence |
| --- | --- | --- | --- | --- | --- |
| `CYRA-MAN-001` | `[S0-S3]` | `[step]` | `[enter]` | `Open` | `[path/link]` |
| `[add another row]` |  |  |  |  |  |

### Detailed issue template

Copy this section once for each issue:

- Issue ID: `[enter]`
- Severity: `[S0 / S1 / S2 / S3]`
- Walkthrough step: `[enter]`
- Device, OS, app version, and build: `[enter]`
- Preconditions: `[enter]`
- Exact actions:
  1. `[enter]`
  2. `[enter]`
  3. `[enter]`
- Expected result: `[enter]`
- Actual result and exact visible text: `[enter]`
- Reproduction rate: `[for example 3/3]`
- Does force-close/reopen change it?: `[yes/no/not tried]`
- Network state and server URL: `[enter]`
- Evidence paths/links: `[enter]`
- Timestamp and timezone: `[enter]`
- Additional notes: `[enter]`

## Final sign-off

| Result | Count |
| --- | ---: |
| Pass | `[enter]` |
| Fail | `[enter]` |
| Blocked | `[enter]` |
| Not applicable | `[enter]` |
| Open S0/S1 issues | `[enter]` |

- [ ] Every numbered step has exactly one marked result.
- [ ] Every Fail or Blocked step has an Issue Log entry.
- [ ] Evidence paths are valid and uploaded.
- [ ] Synthetic Community content was removed where deletion was available.
- [ ] No real health information or test password is included in this file.
- [ ] This completed or partial file is ready to upload to the agent.

Tester verdict: `[Approve / Approve with known issues / Do not approve]`

Tester notes: `[enter]`
