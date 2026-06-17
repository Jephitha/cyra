# Cyra

> A holistic women's health tracking application — track your cycle, understand your body with AI insights, and connect with a supportive anonymous community.

## Architecture

Cyra is a multi-platform app built with three main components:

| Component | Tech | Directory |
|---|---|---|
| **Mobile App** | Flutter + Riverpod + Drift + Supabase | `apps/mobile/` |
| **Landing Page** | Next.js 14 + Tailwind CSS | `apps/landing/` |
| **Admin Dashboard** | Next.js 14 + Supabase Admin | `apps/admin/` |
| **Backend** | Supabase (Postgres, Auth, Edge Functions) | `apps/backend/supabase/` |

## Prerequisites

- [Flutter](https://flutter.dev) ^3.44.0 (with Dart ^3.12.0)
- [Node.js](https://nodejs.org) ^18
- [Docker Desktop](https://docker.com) (for local Supabase)
- [Supabase CLI](https://supabase.com/docs/guides/cli)
- Android device or emulator (for mobile development)

## Quick Start

### 1. Start Supabase

```bash
cd apps/backend/supabase
npx supabase start
```

This starts all Supabase services locally (Postgres, PostgREST, GoTrue, Storage, Realtime, Studio).

**Services:**
- Studio (admin UI): `http://localhost:54323`
- API: `http://localhost:54321`
- Database: `postgresql://postgres:postgres@localhost:54322/postgres`

### 2. Configure Environment

```bash
# Mobile app env
cp apps/mobile/.env.example apps/mobile/.env
# Edit SUPABASE_URL and SUPABASE_ANON_KEY with values from `npx supabase status`
```

### 3. Run Mobile App

```bash
cd apps/mobile
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### 4. Run Landing Page

```bash
cd apps/landing
npm install
npm run dev
# http://localhost:3001
```

### 5. Run Admin Dashboard

```bash
cd apps/admin
npm install
npm run dev
# http://localhost:3000
```

**Admin login:** `admin@cyra.app` / `admin123456`

## Features

### Cycle Tracking
- Log period days with flow intensity, spotting, clotting
- Track symptoms, BBT, cervical mucus, OPK results
- Calendar view with phase indicators (period, fertile, ovulation, luteal)
- Cycle history and statistics

### AI Insights
- Personalized health tips based on cycle phase and symptoms
- Topic-based educational content (period prediction, ovulation detection, fertility, etc.)
- Weekly summary of symptoms and mood patterns
- Disclaimer-guaranteed medical information

### Anonymous Community
- Topic-based discussion groups (TTC, Pregnancy, PCOS Support, etc.)
- Anonymous posting and replying
- Like/unlike posts
- Report concerning content
- Content moderation (automated + human review)
- Moderation notifications

### Privacy & Security
- Anonymous community participation
- Biometric authentication
- PIN lock with auto-lock timer
- Emergency lock (disguised app)
- Local encryption of sensitive health data
- Supabase Row-Level Security

## Backend

### Database Migrations

Migrations are in `apps/backend/supabase/migrations/`:

| Migration | Contents |
|---|---|
| `001_initial_schema.sql` | Core tables: users, cycles, community_posts, health_reports, audit_logs |
| `002_community_features.sql` | Community: topics, replies, likes, reports, moderation notifications |

Apply migrations manually with:
```bash
npx supabase db reset
```

### Edge Functions

Functions are in `apps/backend/supabase/functions/`:

| Function | Purpose |
|---|---|
| `content_moderation` | Automated content moderation — scans posts and replies for harmful patterns (hate speech, harassment, medical misinformation, etc.) |
| `analyze_cycle_patterns` | Analyzes cycle data for pattern insights |
| `generate_report` | Generates PDF health reports |

### Seed Data

The app auto-seeds 6+ months of realistic cycle data on first launch in debug mode. This includes:

- 7 menstrual cycles with varying lengths (26-33 days)
- Phase-appropriate symptoms (cramps, bloating, mood swings, etc.)
- BBT with biphasic temperature patterns
- OPK test results around fertile windows
- Journal entries for key cycle events

## Admin Dashboard

The admin dashboard at `http://localhost:3000` provides:

- **Dashboard** — Overview stats (pending reports, flagged content)
- **Reports** — Moderation queue showing reported content, aggregated by report count (reporter identities are NEVER exposed)
- **Posts** — Browse and moderate all community posts
- **Replies** — Browse and moderate all community replies

Moderation actions: Approve, Flag, or Remove content.

## Development

### Regenerate Code

```bash
cd apps/mobile
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Lint

```bash
cd apps/mobile
flutter analyze
```

### Build APK

```bash
cd apps/mobile
flutter build apk --debug
```

## Attribution

Built with:
- [Flutter](https://flutter.dev) — Cross-platform UI framework
- [Supabase](https://supabase.com) — Backend as a Service
- [Next.js](https://nextjs.org) — React framework
- [Riverpod](https://riverpod.dev) — State management
- [Drift](https://drift.simonbinder.eu) — Local database
- [Freezed](https://freezed.dev) — Code generation
