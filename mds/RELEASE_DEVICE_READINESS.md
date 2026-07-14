# Cyra release and device readiness

This checklist separates what Cyra needs for a release build today from the
future setup required by backlog features. Cyra handles reproductive health,
pregnancy, fertility, and community data, so production release work should
treat privacy, signing, and store declarations as launch blockers rather than
polish.

## Current release blockers

### Production and staging backend

- Create separate Supabase projects for staging and production.
- Apply all migrations in `apps/backend/supabase/migrations/`.
- Configure Supabase Auth, anonymous sessions, email auth if enabled, and email
  templates.
- Verify row-level security on all user, cycle, pregnancy, community, report,
  and audit tables.
- Deploy any required Edge Functions for moderation, reports, or pattern
  analysis.
- Configure backups, retention, rate limits, monitoring, and incident alerts.
- Keep production URL and publishable anon key outside Git.

Release builds must be built with public HTTPS Supabase values:

```sh
flutter build appbundle --release \
  --dart-define=APP_ENV=production \
  --dart-define=SUPABASE_URL=https://PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=...
```

The Android Gradle and iOS build validation already reject release builds that
target local/private Supabase URLs or missing placeholder keys.

### Android release setup

- Create or recover the production upload keystore.
- Store these values in the local shell or CI secret manager, never in Git:
  - `CYRA_KEYSTORE_PATH`
  - `CYRA_KEYSTORE_PASSWORD`
  - `CYRA_KEY_ALIAS`
  - `CYRA_KEY_PASSWORD`
- Publish to Google Play with an Android App Bundle (`.aab`), not a raw APK.
- Enable Play App Signing.
- Confirm package name: `com.getmycyra.app`.
- Confirm version name/code from `apps/mobile/pubspec.yaml`.
- Confirm target SDK meets Google Play's current requirement.
- Harden `android:usesCleartextTraffic`; release should not allow cleartext.
- Real-device test the primary icon and hidden weather launcher alias.
- Real-device test local notifications, boot rescheduling, emergency lock, PDF
  export, and deletion.

Current debug install can coexist as `com.getmycyra.app.dev`; release installs
as `com.getmycyra.app`.

### iOS release setup

- Enroll/use an Apple Developer Program account, preferably an organization
  account because healthcare/sensitive-data apps are scrutinized more heavily.
- Register the final bundle identifier. Current project value is
  `com.cyra.cyra`; decide whether to keep it or align with `getmycyra`.
- Configure signing certificates and provisioning profiles.
- Enable HealthKit capability if wearable sync remains in the submitted build.
- Enable In-App Purchase capability if Premium remains visible.
- Verify alternate weather icon assets and behavior on real iOS hardware.
- Confirm the app runs correctly through TestFlight before App Store review.

### Store listing, policy, and legal

- Publish a public privacy policy URL.
- Publish support/contact URL.
- Publish terms of service.
- Publish medical disclaimer.
- Publish community guidelines and moderation policy.
- Complete Google Play Data Safety.
- Complete Apple App Privacy labels.
- Complete content rating and target audience declarations.
- Declare no ads if the app remains ad-free.
- Provide reviewer instructions for:
  - onboarding,
  - privacy setup,
  - emergency lock,
  - hidden app icon,
  - community moderation/reporting,
  - subscriptions if enabled.

The privacy policy must clearly distinguish local-only data from data sent to
Supabase. It should cover cycle and pregnancy records, community posts/replies,
reports, anonymous auth/session IDs, HealthKit/Health Connect reads, PDF export,
deletion, support requests, and the no-sale/no-ads posture if that remains true.

### Health permissions

The app currently includes Health Connect permissions on Android and HealthKit
entitlement/usage strings on iOS. Before store submission:

- Keep these permissions only if wearable sync is genuinely ready for release.
- Complete Google Play health permissions declarations.
- Explain exactly why temperature, heart rate, HRV, and sleep are read.
- Confirm no health data is used for ads, sale, or unrelated purposes.
- Confirm HealthKit/Health Connect data is not sent to cloud services unless
  the user explicitly opts into a documented sync feature.

### Subscriptions

If Premium ships:

- Create store products:
  - `cyra_premium_monthly`
  - `cyra_premium_annual`
- Configure pricing, free trial/intro offers, and localization in both stores.
- Test purchase, cancellation, expiry, and restore flows.
- Prefer server-side receipt validation before trusting long-lived entitlement
  state.
- Keep export, deletion, core cycle tracking, privacy features, and existing
  health records outside the paid boundary.

## Acceptance before release

- `flutter analyze`
- `flutter test`
- Android debug install on a real device.
- Android release install on a real device, signed with production or staging
  release signing.
- iOS TestFlight install on real hardware.
- Fresh install onboarding.
- Log period start/end, current period, and past period.
- Calendar day selection and Today behavior.
- Back navigation through bottom tabs.
- Privacy setup skip/selected-step flows.
- Emergency lock activation and deactivation.
- Hidden launcher icon round trip.
- Notification permission and scheduled reminders.
- PDF export after fresh authentication.
- Delete date range and delete all local data.
- Community post/report/moderation happy path.
- Premium paywall and restore purchases if enabled.

## Future backlog prerequisites

### Cloud sync and restore

Required before implementation:

- Explicit opt-in sync product spec.
- Account identity model and account upgrade path.
- End-to-end or server-side encryption design.
- Key recovery and device replacement policy.
- Conflict resolution and offline merge rules.
- Consent UX and privacy policy updates.
- Audit logging without leaking health data.
- Tests proving local-only users never upload health records.

### Permanent account deletion and anonymization

Required before implementation:

- Server-side deletion/anonymization job.
- Complete data inventory across database, storage, logs, exports, backups, and
  community moderation records.
- Legal retention policy.
- Verified unlinking from email, phone, device IDs, Supabase IDs, and purchase
  IDs where possible.
- Idempotent deletion API.
- Tests proving same-email re-registration does not restore old records.

### User data request package

Required before implementation:

- Authenticated request API.
- Background job queue.
- Export format spec.
- Encrypted temporary export storage.
- Expiring signed links.
- Fresh authentication before download.
- Audit events and retry/failure states.
- Automatic deletion of generated export packages after expiry.

### Conception window from saved sex activity

Required before implementation:

- Confirmed persistence and encryption model for sex activity records.
- Consent-oriented UX copy.
- Date-window validation rules.
- Pregnancy-mode setup integration.
- Limits preventing implausibly wide conception windows.
- Clear uncertainty language.
- Tests for selecting, deselecting, and updating conception estimates.

### Educational onboarding and glossary

Required before implementation:

- Reviewed glossary for luteal phase, BBT, OPK, cervical mucus, fertile window,
  cycle variability, and pregnancy terms.
- Age-appropriate and non-alarmist wording.
- Local-only scheduling.
- Skip, dismiss, and reset controls.
- No analytics requirement unless separately reviewed.

### Community at scale

Required before broad rollout:

- Human moderation workflow.
- Admin role access control.
- Rate limits and abuse controls.
- User blocking/reporting policy.
- Escalation path for self-harm, abuse, medical misinformation, and minors.
- Data retention policy for removed or reported content.

## Release-hardening notes

- Do not ship local Supabase URLs.
- Do not ship debug seed data.
- Do not commit keystores, passwords, `.env.production`, or store API keys.
- Prefer organization-owned Apple and Google developer accounts.
- Keep privacy forms aligned with actual SDK behavior.
- Re-run store privacy declarations whenever adding SDKs, sync, analytics,
  crash reporting, HealthKit/Health Connect, subscriptions, or cloud storage.
