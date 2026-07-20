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

Production release files must use the production-only variable names:

```bash
APP_ENV=production
SUPABASE_URL_PROD=https://PROJECT.supabase.co
SUPABASE_ANON_KEY_PROD=...
SENTRY_DSN=...
SENTRY_ENVIRONMENT=production
```

Debug and development builds continue to use the earlier Wi-Fi/LAN setup:

```bash
APP_ENV=development
SUPABASE_URL=http://YOUR_COMPUTER_LAN_IP:54321
SUPABASE_ANON_KEY=...
```

Do not put `SUPABASE_URL_PROD` or `SUPABASE_ANON_KEY_PROD` in a debug `.env`
file. The mobile runtime only selects those values in a production release
build; debug builds should keep targeting local Supabase over Wi-Fi.

The Android Gradle build and iOS Xcode build phase reject release builds when `APP_ENV` is not
`staging`/`production`, the URL is missing, non-HTTPS, or local/private, or the publishable key is
missing/placeholder-like. Dart validates the same contract before Supabase initialization, so a
misconfigured release cannot silently fall back to a LAN endpoint.

The real URLs and publishable keys belong in the CI/store secret manager, not in this repository.
Before deployment, provision the two subscription products from `MONETIZATION.md` and inject the
selected environment's values into the build command.

## Supabase CLI deployment access

`SUPABASE_URL_PROD` and `SUPABASE_ANON_KEY_PROD` are mobile runtime values. They
let the release app connect to the production Supabase API, but they do not give
the Supabase CLI permission to apply database migrations or deploy Edge
functions.

For remote backend deployment, an authenticated shell must have one of:

```bash
supabase login
# or
export SUPABASE_ACCESS_TOKEN=...
```

Then link the repo to the remote project and deploy from `apps/backend`:

```bash
cd apps/backend
supabase link --project-ref <project-ref>
supabase db push
supabase functions deploy content_moderation
supabase functions deploy generate_report
supabase functions deploy analyze_cycle_patterns
```

Local Docker must be running for local verification commands such as
`supabase migration up --local` and `supabase db lint --local`.

## Observability and analytics

Sentry is optional locally and required for release candidates. The repo now
wires uncaught Flutter, platform-dispatcher, and zone errors through
`SENTRY_DSN` when present. To finish the SaaS-side Sentry setup in an
authenticated shell, run:

```bash
brew install getsentry/tools/sentry-wizard
sentry-wizard -i flutter --saas --org jephitha-jotham --project my-cyra
```

Microsoft Clarity project `xmqziknu58` is installed only on the public landing
surfaces (`apps/admin` root landing page and `apps/landing`). It is intentionally
not loaded inside authenticated moderation queues because those screens can show
sensitive reports and support content.
