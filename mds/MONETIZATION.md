# Cyra monetization boundary

Cyra uses one optional **Cyra Premium** entitlement. The free product remains useful,
private, and ad-free; a subscription buys automation and deeper longitudinal analysis,
not safety, privacy, or access to a user's own records.

## Always free

- Onboarding, local accounts, PIN/biometric lock, private mode, emergency lock, hidden icon,
  encryption, audit history, and all privacy controls.
- Period and cycle-day logging, symptoms, journal, BBT, cervical mucus, ovulation tests,
  pregnancy tracking, and viewing/editing the resulting history.
- Core period, fertile-window, and ovulation estimates with confidence and safety context.
- Local cycle reminders, education, community access, and Smart Local Insights needed to
  explain current predictions.
- Data deletion and all data portability, including JSON and clinician-facing PDF export.
  A user must never pay to retrieve, share, or delete their own health data.

## Cyra Premium

- Apple Health / Health Connect synchronization and automatic wearable refresh.
- Advanced longitudinal analysis: multi-cycle correlations, extended trend views, and
  comparative reports beyond the current-cycle explanation included free.
- Future convenience features may join Premium only when they do not weaken the free core or
  create a safety, privacy, or data-portability paywall.

## Subscription contract

- Entitlement ID: `cyra_premium`.
- Store products: `cyra_premium_monthly` and `cyra_premium_annual`.
- The app must derive access from verified active purchases and restore purchases on request.
- Pricing and trial language must come from the store product metadata; never hard-code or
  promise a trial that is not configured in App Store Connect / Play Console.
- Purchase services must fail closed to the free tier without blocking app startup or access
  to free health records. Cancellation or expiry removes only Premium capabilities.
- No ads and no sale of health data in either tier.

## Gate placement

Gates belong at the entry point to a Premium capability and must explain what remains free.
Existing health records are never hidden after expiry. If wearable sync expires, previously
synced readings remain visible and usable; only new synchronization is paused.
