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
  --dart-define=SUPABASE_URL=https://PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=...
```

Keep the keystore, passwords, and environment files outside version control.

## Manual acceptance

Use [`mds/MANUAL_TEST_WALKTHROUGH.md`](../../mds/MANUAL_TEST_WALKTHROUGH.md) for real-device acceptance and issue handoff.
