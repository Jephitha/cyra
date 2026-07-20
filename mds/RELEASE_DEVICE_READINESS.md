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
  --dart-define=SUPABASE_URL_PROD=https://PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY_PROD=... \
  --dart-define=SENTRY_DSN=...
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
- Do not enable HealthKit capability for this release; wearable sync is future
  roadmap work.
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
reports, anonymous auth/session IDs, PDF export, deletion, support requests,
and the no-sale/no-ads posture if that remains true. HealthKit/Health Connect
should be added only if the future wearable feature is reintroduced.

### Health permissions

Health Connect and HealthKit are not release-ready and have been stripped from
the shipping surface:

- Android no longer declares Health Connect read permissions or the health
  permission-rationale activity alias.
- iOS no longer declares HealthKit usage strings or the HealthKit entitlement.
- Wearables remain a roadmap item, not a Premium launch promise.

Reintroduce these permissions only when the future wearable feature has
real-device verification, store permission declarations, consent copy, and cloud
sync boundaries reviewed.

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
- Debug APK notification simulation:
  - Open Settings → Notifications.
  - Enable All notifications and grant permission.
  - In debug builds only, use **Simulate cycle notification** → **Send now**.
  - Reboot the device, then verify the boot receiver reschedules pending cycle
    reminders after app launch and package replacement.

## Future backlog prerequisites

### Cloud sync and restore

Implemented backend primitives in `003_release_privacy_ops.sql`; remaining
client/product work before launch:

- Explicit opt-in sync product spec.
- Account identity model and account upgrade path in the mobile UI.
- End-to-end encrypted payload format and device key storage.
- Recovery-code UX and device replacement policy.
- Conflict resolution UI for `conflict_state = conflict`.
- Consent UX and privacy policy updates.
- Tests proving local-only users never upload health records.

### Permanent account deletion and anonymization

Backend request/anonymization primitives are present in
`003_release_privacy_ops.sql`; remaining production work:

- Server-side deletion/anonymization job.
- Complete data inventory across database, storage, logs, exports, backups, and
  community moderation records.
- Legal retention policy.
- Verified unlinking from email, phone, device IDs, Supabase IDs, and purchase
  IDs where possible.
- Edge function or worker that calls `anonymize_deleted_user` after deleting
  Supabase Auth and storage records.
- Tests proving same-email re-registration does not restore old records.

### User data request package

Backend request queue and private `user_exports` bucket are present; remaining
production work:

- Edge function/background job processor.
- Export format spec.
- Client flow that requires fresh auth before requesting and downloading.
- Retry/failure states.
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
