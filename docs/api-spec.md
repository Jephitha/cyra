# API Specification: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | API Team | Initial release |

---

## 1. Architecture Overview

### 1.1 API Base URL
- Production: `https://api.cyrahealth.com/v1`
- Staging: `https://staging-api.cyrahealth.com/v1`
- Local Dev: `http://localhost:54321/v1` (Supabase local)

### 1.2 Authentication
- Supabase Auth using anonymous JWT tokens
- Tokens refreshed automatically by Supabase client SDK
- Biometric verification is client-side only (not an API endpoint)
- All API requests require `Authorization: Bearer <token>` header

### 1.3 Standard Headers

| Header | Value | Required |
|--------|-------|----------|
| `Authorization` | `Bearer <jwt_token>` | Yes |
| `Content-Type` | `application/json` | Yes (POST/PUT/PATCH) |
| `X-Client-Version` | `1.0.0` | Yes |
| `X-Client-Platform` | `ios` / `android` | Yes |
| `X-Request-ID` | UUID string | Recommended (idempotency) |

### 1.4 Standard Response Format

```json
{
  "data": { ... },
  "error": null,
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-06-16T10:00:00Z",
    "version": "1.0.0"
  }
}
```

**Error Response:**
```json
{
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Cycle start_date is required",
    "details": { "field": "start_date" },
    "request_id": "uuid"
  },
  "meta": { ... }
}
```

### 1.5 HTTP Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | Success | GET, PUT, PATCH |
| 201 | Created | POST |
| 204 | No Content | DELETE |
| 400 | Bad Request | Validation errors |
| 401 | Unauthorized | Invalid/missing token |
| 403 | Forbidden | RLS policy violation |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Sync conflict (LWW) |
| 422 | Unprocessable | Business logic violation |
| 429 | Too Many Requests | Rate limited |
| 500 | Server Error | Internal error |

---

## 2. Authentication Endpoints

### 2.1 Anonymous Sign-In
```
POST /auth/signup
```

Used for local-first onboarding. Creates anonymous account.

**Request:**
```json
{
  "options": {
    "data": {
      "onboarding_completed": false,
      "app_version": "1.0.0"
    }
  }
}
```

**Response (200):**
```json
{
  "data": {
    "user_id": "uuid",
    "access_token": "jwt_token",
    "refresh_token": "refresh_token",
    "expires_at": "2026-06-17T10:00:00Z"
  },
  "error": null,
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-06-16T10:00:00Z"
  }
}
```

### 2.2 Email/Password Sign-Up
```
POST /auth/signup
```

**Request:**
```json
{
  "email": "user@example.com",
  "password": "secure_password",
  "options": {
    "data": {
      "display_name": "User",
      "onboarding_completed": false
    }
  }
}
```

### 2.3 Email/Password Sign-In
```
POST /auth/token?grant_type=password
```

**Request:**
```json
{
  "email": "user@example.com",
  "password": "secure_password"
}
```

### 2.4 Token Refresh
```
POST /auth/token?grant_type=refresh_token
```

**Request:**
```json
{
  "refresh_token": "refresh_token"
}
```

### 2.5 Magic Link (Passwordless)
```
POST /auth/magic_link
```

**Request:**
```json
{
  "email": "user@example.com"
}
```

### 2.6 Account Upgrade (Anonymous → Full)
```
POST /auth/user
```

**Request:**
```json
{
  "email": "user@example.com",
  "password": "secure_password",
  "data": {
    "display_name": "User"
  }
}
```

### 2.7 Account Deletion
```
DELETE /auth/user
```

Initiates account deletion process. All user data is queued for deletion within 30 days.

---

## 3. REST Endpoints

### 3.1 Cycles

#### List Cycles
```
GET /cycles
```

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | integer | 20 | Max records (max 100) |
| `offset` | integer | 0 | Pagination offset |
| `sort_by` | string | `start_date` | Sort field |
| `sort_order` | string | `desc` | asc/desc |
| `from_date` | date | — | Filter from date |
| `to_date` | date | — | Filter to date |
| `include_days` | boolean | false | Include cycle days |

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "start_date": "2026-01-15",
      "end_date": "2026-02-11",
      "cycle_length": 27,
      "period_length": 5,
      "ovulation_day": 14,
      "is_ovulation_confirmed": true,
      "luteal_phase_length": 13,
      "notes": "Felt stressed this cycle",
      "tags": ["stressful", "travel"],
      "created_at": "2026-01-15T08:00:00Z",
      "updated_at": "2026-02-11T12:00:00Z",
      "cycle_days": [] // if include_days=true
    }
  ],
  "error": null,
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-06-16T10:00:00Z",
    "total_count": 12,
    "limit": 20,
    "offset": 0
  }
}
```

#### Get Cycle
```
GET /cycles/:id
```

**Response:** Single cycle object

#### Create Cycle
```
POST /cycles
```

**Request:**
```json
{
  "start_date": "2026-01-15",
  "end_date": "2026-02-11",
  "period_length": 5,
  "notes": "Felt stressed",
  "tags": ["stressful"]
}
```

#### Update Cycle
```
PATCH /cycles/:id
```

**Request:** Partial cycle object

#### Delete Cycle
```
DELETE /cycles/:id
```

Soft delete (sets `deleted_at`). Hard deletion occurs after 30 days.

---

### 3.2 Cycle Days

#### List Cycle Days
```
GET /cycle_days
```

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `cycle_id` | uuid | Filter by cycle |
| `date` | date | Filter by date |
| `from_date` | date | Date range start |
| `to_date` | date | Date range end |
| `limit` | integer | Pagination |
| `offset` | integer | Pagination |

#### Get Cycle Day
```
GET /cycle_days/:id
```

#### Create/Update Cycle Day (Upsert)
```
POST /cycle_days
```

Upsert pattern: creates if no record exists for `cycle_id + date`, updates otherwise.

**Request:**
```json
{
  "cycle_id": "uuid",
  "date": "2026-01-15",
  "day_number": 1,
  "flow_intensity": "medium",
  "spotting": false,
  "pain_level": 3,
  "mood": "low",
  "sleep_hours": 7.5,
  "stress_level": 4,
  "notes": "Cramps in the morning"
}
```

#### Delete Cycle Day
```
DELETE /cycle_days/:id
```

---

### 3.3 Symptoms & Symptom Logs

#### List Symptoms (Lookup)
```
GET /symptoms
```

**Response:** Array of predefined + custom symptoms

**Query:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `category` | string | Filter by category |
| `search` | string | Text search |

#### Create Custom Symptom
```
POST /symptoms
```

**Request:**
```json
{
  "name": "Rosacea flare-up",
  "category": "skin",
  "icon": "skin_face"
}
```

#### List Symptom Logs
```
GET /symptom_logs
```

**Query:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `cycle_day_id` | uuid | Filter by cycle day |
| `symptom_id` | uuid | Filter by symptom |
| `from_date` | date | Via cycle_day join |
| `to_date` | date | Via cycle_day join |

#### Create Symptom Log
```
POST /symptom_logs
```

**Request:**
```json
{
  "cycle_day_id": "uuid",
  "symptom_id": "uuid",
  "severity": 4,
  "time_of_day": "morning",
  "duration_minutes": 120,
  "notes": "Started after breakfast"
}
```

---

### 3.4 BBT Records

```
GET    /bbt_records           # List with date filters
GET    /bbt_records/:id       # Single record
POST   /bbt_records           # Create
PATCH  /bbt_records/:id       # Update
DELETE /bbt_records/:id       # Delete
```

**Query Parameters (list):** `user_id`, `date`, `from_date`, `to_date`, `limit`, `offset`

**Request (create):**
```json
{
  "date": "2026-01-16",
  "temperature": 36.52,
  "measurement_method": "oral",
  "time": "06:30:00",
  "sleep_hours": 7.5,
  "disturbances": "none",
  "notes": ""
}
```

---

### 3.5 Ovulation Tests

```
GET    /ovulation_tests           # List with cycle/date filters
GET    /ovulation_tests/:id       # Single record
POST   /ovulation_tests           # Create
PATCH  /ovulation_tests/:id       # Update
DELETE /ovulation_tests/:id       # Delete
```

**Request (create):**
```json
{
  "cycle_id": "uuid",
  "date": "2026-01-16",
  "time_of_day": "morning",
  "result": "positive",
  "line_intensity": 85,
  "notes": "Very dark line"
}
```

---

### 3.6 Cervical Mucus Observations

```
GET    /cervical_mucus_observations
GET    /cervical_mucus_observations/:id
POST   /cervical_mucus_observations
PATCH  /cervical_mucus_observations/:id
DELETE /cervical_mucus_observations/:id
```

---

### 3.7 Pregnancies

```
GET    /pregnancies                 # List user's pregnancies
GET    /pregnancies/:id             # Single with fetal_measurements
POST   /pregnancies                 # Start pregnancy tracking
PATCH  /pregnancies/:id             # Update (e.g., mark completed)
DELETE /pregnancies/:id             # Soft delete
```

**Request (create):**
```json
{
  "lmp_date": "2025-12-01",
  "estimated_due_date": "2026-09-07",
  "baby_count": 1
}
```

---

### 3.8 Fetal Measurements

```
GET    /fetal_measurements?pregnancy_id=uuid
GET    /fetal_measurements/:id
POST   /fetal_measurements
PATCH  /fetal_measurements/:id
DELETE /fetal_measurements/:id
```

---

### 3.9 Journal Entries

```
GET    /journal_entries?user_id=uuid&limit=20&offset=0
GET    /journal_entries/:id
POST   /journal_entries
PATCH  /journal_entries/:id
DELETE /journal_entries/:id
```

**Notes:** Photo and voice note files are stored locally only. The API stores metadata paths only.

---

### 3.10 User Conditions

```
GET    /user_conditions?user_id=uuid
GET    /user_conditions/:id
POST   /user_conditions
PATCH  /user_conditions/:id
DELETE /user_conditions/:id
```

---

### 3.11 Wearable Sources

```
GET    /wearable_sources?user_id=uuid
GET    /wearable_sources/:id
POST   /wearable_sources
PATCH  /wearable_sources/:id    # Update connection status
DELETE /wearable_sources/:id
```

---

### 3.12 Health Reports

```
GET    /health_reports?user_id=uuid
GET    /health_reports/:id
POST   /health_reports          # Triggers Edge Function generation
DELETE /health_reports/:id
```

**Request (create/report generation):**
```json
{
  "report_type": "cycle_history",
  "date_range_start": "2026-01-01",
  "date_range_end": "2026-06-01",
  "parameters": {
    "include_charts": true,
    "include_symptoms": true,
    "include_notes": false
  }
}
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "report_type": "cycle_history",
    "status": "generating",
    "date_range_start": "2026-01-01",
    "date_range_end": "2026-06-01",
    "created_at": "2026-06-16T10:00:00Z"
  },
  "error": null,
  "meta": { "request_id": "uuid", "timestamp": "..." }
}
```

---

### 3.13 Education Articles

```
GET    /education_articles?category=cycle_basics&limit=20
GET    /education_articles/:id
GET    /education_articles/featured
GET    /education_articles/search?q=ovulation
```

No write endpoints (admin-only via service role).

---

### 3.14 Community Posts

```
GET    /community_posts?topic_id=ttc&limit=20&offset=0&sort=hot
GET    /community_posts/:id
POST   /community_posts
PATCH  /community_posts/:id        # Edit own post
DELETE /community_posts/:id        # Delete own post
```

**Request (create):**
```json
{
  "topic_id": "ttc",
  "title": "Anyone tried acupuncture?",
  "content": "Looking for experiences with acupuncture for fertility...",
  "is_anonymous": true
}
```

---

### 3.15 App Settings

```
GET    /app_settings?user_id=uuid
GET    /app_settings/:key?user_id=uuid    # Get specific setting
POST   /app_settings                       # Bulk upsert
DELETE /app_settings/:key?user_id=uuid     # Delete setting
```

**Request (upsert):**
```json
{
  "settings": [
    { "key": "cycle_length_average", "value": 28 },
    { "key": "premium_enabled", "value": true },
    { "key": "theme", "value": "dark" }
  ]
}
```

---

## 4. Realtime Subscriptions

### 4.1 Architecture
Cyra uses Supabase Realtime via WebSocket connections. The client subscribes to specific channel filters.

### 4.2 Available Channels

#### Cycle Updates
```dart
// Client-side subscription pattern
Supabase.instance.client
  .channel('cycles:user_id=${userId}')
  .on(
    RealtimeListenTypes.postgresChanges,
    ChannelFilter(
      event: '*',
      schema: 'public',
      table: 'cycles',
      filter: 'user_id=eq.${userId}',
    ),
    (payload) => handleCycleUpdate(payload),
  )
  .subscribe();
```

| Table | Filter | Events | Use Case |
|-------|--------|--------|----------|
| `cycles` | `user_id=eq.{uid}` | INSERT, UPDATE, DELETE | Sync across devices |
| `cycle_days` | via cycle join | INSERT, UPDATE, DELETE | Daily log sync |
| `symptom_logs` | via cycle join | INSERT, UPDATE, DELETE | Symptom sync |
| `bbt_records` | `user_id=eq.{uid}` | INSERT, UPDATE, DELETE | BBT sync |
| `community_posts` | `moderation_status=eq.approved` | INSERT | New community posts |
| `health_reports` | `user_id=eq.{uid}` | UPDATE | Report generation status |

#### Community Updates
```dart
// Subscribe to new posts in specific topic
Supabase.instance.client
  .channel('community:topic=ttc')
  .on(
    RealtimeListenTypes.postgresChanges,
    ChannelFilter(
      event: 'INSERT',
      schema: 'public',
      table: 'community_posts',
      filter: 'topic_id=eq.ttc AND moderation_status=eq.approved',
    ),
    (payload) => handleNewPost(payload),
  )
  .subscribe();
```

### 4.3 Connection Lifecycle
1. Client connects WebSocket on app start (if sync enabled)
2. Client subscribes to relevant channels
3. Realtime sends initial snapshot, then incremental changes
4. On disconnect (offline), client automatically reconnects with exponential backoff
5. Missed messages are recovered via a REST catch-up query on reconnect

---

## 5. Edge Functions

Edge Functions are Supabase Edge Functions (Deno-based) deployed to regional edge nodes.

### 5.1 `generate_report`

**Purpose:** Generates a PDF health report from user data.

**Trigger:** POST to `/health_reports` or manual call

**Request:**
```json
{
  "user_id": "uuid",
  "report_id": "uuid",
  "report_type": "cycle_history",
  "date_range_start": "2026-01-01",
  "date_range_end": "2026-06-01",
  "parameters": {
    "include_charts": true,
    "include_symptoms": true,
    "include_notes": false,
    "language": "en"
  }
}
```

**Implementation:**
1. Fetch user data from Supabase (cycles, cycle_days, symptoms, BBT)
2. Generate chart SVGs server-side (if requested)
3. Compose PDF using PDF generation library
4. Encrypt PDF with user's public key (if available)
5. Upload PDF to Supabase Storage
6. Update `health_reports` record with `status: completed` and `file_path`
7. Send push notification to user

**Response:**
```json
{
  "status": "completed",
  "file_url": "https://assets.cyrahealth.com/reports/uuid/report.pdf",
  "file_size_bytes": 245000,
  "generated_at": "2026-06-16T10:05:00Z"
}
```

**Error States:**
| Condition | Response |
|-----------|----------|
| Insufficient data | `{"status": "failed", "error": "INSUFFICIENT_DATA", "message": "Need at least 3 cycles to generate report"}` |
| Generation timeout | `{"status": "failed", "error": "TIMEOUT"}` |
| Rate limit | `{"status": "failed", "error": "RATE_LIMITED", "retry_after_seconds": 300}` |

### 5.2 `analyze_cycle_patterns`

**Purpose:** Server-side cycle pattern analysis for premium users.

**Trigger:** Called by client after cycle ends, or on demand

**Request:**
```json
{
  "user_id": "uuid",
  "cycle_id": "uuid",
  "include_symptoms": true,
  "include_bbt": true
}
```

**Analysis Output:**
```json
{
  "cycle_summary": {
    "cycle_length": 28,
    "period_length": 5,
    "ovulation_day": 15,
    "luteal_phase_length": 13,
    "is_anovulatory": false,
    "short_luteal_phase": false
  },
  "patterns_detected": [
    {
      "pattern": "SYMPTOM_CORRELATION",
      "description": "Bloating typically occurs 3 days before period start",
      "confidence": 0.85,
      "supporting_data_points": 8
    },
    {
      "pattern": "CYCLE_VARIABILITY",
      "description": "Cycle length variability is low (std dev: 1.2 days)",
      "confidence": 0.95,
      "value": 1.2
    }
  ],
  "anomalies": [],
  "recommendations": [
    "Your luteal phase of 13 days is within normal range"
  ]
}
```

### 5.3 `content_moderation`

**Purpose:** AI-powered community post moderation.

**Trigger:** On INSERT to `community_posts` via Supabase Database Webhook

**Request:**
```json
{
  "post_id": "uuid",
  "user_id": "uuid",
  "title": "Post title",
  "content": "Post body content",
  "topic_id": "ttc"
}
```

**Decision:**
```json
{
  "post_id": "uuid",
  "moderation_status": "approved",
  "confidence": 0.97,
  "reasons": [],
  "reviewed_at": "2026-06-16T10:00:05Z"
}
```

**Possible moderation_status values:**
- `approved` — Passes all checks
- `rejected` — Contains prohibited content (medical advice, harassment, spam)
- `flagged` — Needs human review (edge case, uncertain)
- `pending` — Default before moderation runs

**Content Checks:**
1. Medical advice detection (claims that could be dangerous)
2. Harassment / hate speech detection
3. Spam detection
4. PII detection (phone numbers, addresses)
5. NSFW content detection
6. Language filter

**Human Moderation Queue:**
- `flagged` posts appear in admin dashboard
- Human moderators review and approve/reject
- Target: 95% automated approval, 5% human review
- Target response time: <5 minutes for automated, <1 hour for human review

### 5.4 `sync_wearable_data`

**Purpose:** Process and normalize wearable device data.

**Trigger:** Called by wearable integration service after device sync

**Request:**
```json
{
  "user_id": "uuid",
  "source_type": "oura",
  "data": {
    "date": "2026-06-15",
    "heart_rate": { "average": 68, "min": 54, "max": 98 },
    "hrv": { "average": 42, "rmssd": 38 },
    "sleep": { "duration_minutes": 420, "efficiency": 0.85, "deep_minutes": 90, "rem_minutes": 100 },
    "steps": 8432,
    "skin_temperature": 36.1,
    "respiratory_rate": 14.5
  }
}
```

**Response:**
```json
{
  "status": "success",
  "records_processed": 1,
  "correlations_found": [
    {
      "metric": "resting_heart_rate",
      "cycle_phase": "luteal",
      "deviation": "+3.2 bpm above baseline",
      "significance": "expected"
    }
  ],
  "stored_in_cycle_day": "uuid"
}
```

---

## 6. Row Level Security (RLS) Policies

### 6.1 RLS Policy Summary

All tables implement user-level isolation. The core pattern:

```sql
-- Generic RLS template applied to all user-owned tables
CREATE POLICY user_data_isolation ON {table_name}
  FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
```

### 6.2 Table-Specific Policy Details

| Table | Policy | Notes |
|-------|--------|-------|
| `cycles` | `user_id = auth.uid()` | Direct ownership |
| `cycle_days` | Via `cycles.user_id` join check | Cascade ownership |
| `symptom_logs` | Via `cycle_days → cycles → user_id` | Cascade ownership |
| `symptoms` | `user_id IS NULL OR user_id = auth.uid()` | System + custom |
| `bbt_records` | `user_id = auth.uid()` | Direct ownership |
| `ovulation_tests` | `user_id = auth.uid()` | Direct ownership |
| `cervical_mucus_observations` | Via join to cycle_days → cycles | Cascade ownership |
| `pregnancies` | `user_id = auth.uid()` | Direct ownership |
| `fetal_measurements` | Via join to pregnancies | Cascade ownership |
| `journal_entries` | `user_id = auth.uid()` | Direct ownership |
| `user_conditions` | `user_id = auth.uid()` | Direct ownership |
| `wearable_sources` | `user_id = auth.uid()` | Direct ownership |
| `education_articles` | `is_published = true` | Read-only for users |
| `community_posts` | `moderation_status = 'approved' OR user_id = auth.uid()` | Public read for approved |
| `health_reports` | `user_id = auth.uid()` | Direct ownership |
| `app_settings` | `user_id = auth.uid()` | Direct ownership |

### 6.3 Service Role Escalation

Edge Functions and admin operations use the `service_role` key (not user tokens) to bypass RLS for operations like:
- Education article CRUD (admin)
- Content moderation updates
- Report PDF storage

---

## 7. Rate Limiting

### 7.1 Endpoint Rate Limits

| Endpoint Group | Limit | Window | Burst |
|----------------|-------|--------|-------|
| Auth (signup, token) | 10 requests | 1 minute | 5 |
| Auth (magic link) | 3 requests | 1 hour | — |
| CRUD (reads) | 100 requests | 1 minute | 20 |
| CRUD (writes) | 30 requests | 1 minute | 10 |
| Realtime connections | 10 connections | per user | — |
| Report generation | 3 requests | 1 hour | 1 |
| AI pattern analysis | 5 requests | 1 hour | 2 |
| Content moderation | 1 request | per post (automatic) | — |
| Wearable sync | 10 requests | 1 hour | — |

### 7.2 Rate Limit Headers

All responses include:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1623849600
```

### 7.3 Rate Limit Response

```json
{
  "data": null,
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests. Try again in 45 seconds.",
    "retry_after_seconds": 45
  },
  "meta": { ... }
}
```

---

## 8. Pagination

### 8.1 Offset-Based Pagination (Default)

```
GET /cycles?limit=20&offset=0&sort_by=start_date&sort_order=desc
```

**Response Meta:**
```json
{
  "meta": {
    "total_count": 47,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

### 8.2 Cursor-Based Pagination (Community Posts)

```
GET /community_posts?topic_id=ttc&limit=20&cursor=2026-06-15T10:00:00Z
```

**Response Meta:**
```json
{
  "meta": {
    "next_cursor": "2026-06-10T08:30:00Z",
    "has_more": true,
    "limit": 20
  }
}
```

---

## 9. Idempotency

Write operations support idempotency via `X-Request-ID` header. If a request is retried with the same ID within 24 hours and the original succeeded, the server returns the original response (not a duplicate).

---

## 10. Error Codes Reference

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Request validation failure |
| `MISSING_FIELD` | 400 | Required field missing |
| `INVALID_FORMAT` | 400 | Field format invalid |
| `UNAUTHORIZED` | 401 | Authentication required |
| `TOKEN_EXPIRED` | 401 | JWT token expired |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource conflict (sync) |
| `RATE_LIMITED` | 429 | Rate limit exceeded |
| `INSUFFICIENT_DATA` | 422 | Not enough data for operation |
| `SYNC_CONFLICT` | 409 | Last-write-wins conflict resolved |
| `INTERNAL_ERROR` | 500 | Unexpected server error |
| `SERVICE_UNAVAILABLE` | 503 | Temporary maintenance |

---

## 11. API Versioning

- Version is in URL path: `/v1/cycles`
- Current version: `v1`
- Older versions supported for 12 months after deprecation
- Deprecation communicated via `Sunset` header: `Sunset: Sat, 01 Jun 2027 00:00:00 GMT`
- Breaking changes: new endpoint version, old version maintained
- Non-breaking changes: additive only within version
