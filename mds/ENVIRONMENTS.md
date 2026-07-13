# Mobile environment configuration

Supabase configuration is compile-time and is never loaded from a bundled `.env` asset.
Use three explicit environments:

- `development`: local Supabase is allowed over HTTP and the app can run fully offline when
  values are omitted.
- `staging`: release-like testing against a public HTTPS Supabase project.
- `production`: the public HTTPS project used for store releases.

Keep value files ignored by Git. Starting from `apps/mobile/.env.example`, run locally with:

```bash
flutter run --dart-define-from-file=.env
```

Build release artifacts only with a staging or production file:

```bash
flutter build apk --release --dart-define-from-file=.env.production
flutter build ios --release --dart-define-from-file=.env.production
```

The Android Gradle build and iOS Xcode build phase reject release builds when `APP_ENV` is not
`staging`/`production`, the URL is missing, non-HTTPS, or local/private, or the publishable key is
missing/placeholder-like. Dart validates the same contract before Supabase initialization, so a
misconfigured release cannot silently fall back to a LAN endpoint.

The real URLs and publishable keys belong in the CI/store secret manager, not in this repository.
Before deployment, provision the two subscription products from `MONETIZATION.md` and inject the
selected environment's values into the build command.
