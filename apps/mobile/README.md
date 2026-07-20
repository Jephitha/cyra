# Cyra mobile

Flutter client for Cyra. Health records are local-first; Supabase powers authentication and community features.

## Development

Fetch dependencies and run the automated checks:

```sh
flutter pub get
flutter analyze
flutter test
```

Runtime environment values are provided as Dart defines. Copy `.env.example` to an ignored local file and build with:

```sh
flutter build apk --debug --dart-define-from-file=.env.device
```

Android debug builds install as a separate **Cyra Dev** app with package ID
`com.getmycyra.app.dev`, a development launcher icon, and local seed data enabled. Android release
builds retain `com.getmycyra.app`, the production Cyra icon, and never invoke seed-data loaders.
This allows both variants to be installed on the same device without sharing app data.

For a physical device, `SUPABASE_URL` must use the development computer's LAN address rather than `127.0.0.1`. The phone and computer must be on the same network, and the local Supabase stack must be running.

## Android release signing

Release builds reject local/insecure Supabase URLs and refuse to use the debug signing key. Supply a public HTTPS staging or production environment plus all four signing variables:

```sh
export CYRA_KEYSTORE_PATH=/absolute/path/to/cyra-upload.jks
export CYRA_KEYSTORE_PASSWORD=...
export CYRA_KEY_ALIAS=...
export CYRA_KEY_PASSWORD=...

flutter build appbundle --release \
  --dart-define=APP_ENV=production \
  --dart-define=SUPABASE_URL_PROD=https://PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY_PROD=... \
  --dart-define=SENTRY_DSN=...
```

Keep the keystore, passwords, and environment files outside version control.

Debug builds should keep using the Wi-Fi/LAN Supabase values from `.env.device`
with `SUPABASE_URL` and `SUPABASE_ANON_KEY`. Production release values use the
separate `SUPABASE_URL_PROD` and `SUPABASE_ANON_KEY_PROD` names so they are not
accidentally consumed by the debug app.

## Release feature notes

- Sentry is wired through `SENTRY_DSN` and captures uncaught Flutter, platform,
  and async-zone errors without attaching screenshots or health-data context.
- Health Connect / HealthKit is not included in the release surface. The app no
  longer requests those native permissions; wearable sync is a future roadmap
  feature.
- Debug APKs include a Settings → Notifications simulation control for real
  device notification permission, immediate notification, and pending reminder
  checks.

## Manual acceptance

Use [`mds/MANUAL_TEST_WALKTHROUGH.md`](../../mds/MANUAL_TEST_WALKTHROUGH.md) for real-device acceptance and issue handoff.
