# Architecture Document: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | Architecture Team | Initial release |

---

## 1. Architectural Philosophy

Cyra follows three core architectural principles:

1. **Local-First**: The primary data store is the device. Cloud is optional, additive, and never required for core functionality.
2. **Clean Architecture**: Strict layer separation with unidirectional dependency flow.
3. **Feature-First Organization**: Code is organized by feature, not by technical layer, enabling parallel development and clear ownership.

---

## 2. Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| UI Framework | Flutter 3.x | Cross-platform, single codebase, excellent accessibility |
| State Management | Riverpod 3.x (code-gen) | Compile-time safety, auto-disposal, testable |
| Local Database | Drift (SQLite) | Type-safe, reactive streams, migrations |
| Cloud Sync | Supabase (optional) | PostgreSQL, RLS, realtime, auth, edge functions |
| AI/ML | TensorFlow Lite | On-device inference, privacy-preserving |
| Secure Storage | flutter_secure_storage | Android Keystore / iOS Keychain |
| Encryption | encrypt (AES-256-GCM), pinenacl (libsodium) | Modern, audited cryptography |
| Analytics | Amplitude (privacy-safe) | Limited, no health data |
| Crash Reporting | Sentry | Error tracking |
| CI/CD | GitHub Actions + Codemagic | Build, test, deploy pipeline |

---

## 3. Clean Architecture Layers

```
┌─────────────────────────────────────────────────┐
│                  UI LAYER                        │
│  Widgets, Screens, Routes, Theme                │
│  ├─ Widgets (pure presentational)               │
│  ├─ Screens (connected to State)                │
│  ├─ Route Definitions (GoRouter)                │
│  └─ Theme / Design System tokens                │
├─────────────────────────────────────────────────┤
│                 STATE LAYER                      │
│  Riverpod Providers, State Notifiers            │
│  ├─ AsyncNotifierProvider (data providers)      │
│  ├─ FutureProvider (one-shot)                   │
│  ├─ StreamProvider (reactive)                   │
│  ├─ StateNotifier (UI state)                    │
│  └─ Provider (dependencies)                     │
├─────────────────────────────────────────────────┤
│                DOMAIN LAYER                      │
│  Business Logic, Entities, Use Cases            │
│  ├─ Entities (immutable data models)            │
│  ├─ Use Cases (business operations)             │
│  ├─ Repositories (abstract interfaces)          │
│  ├─ Services (algorithms, AI inference)         │
│  └─ Value Objects (validated types)             │
├─────────────────────────────────────────────────┤
│                DATA LAYER                        │
│  Database, API, Cache, Device Sensors           │
│  ├─ DAOs (Drift database access)                │
│  ├─ Remote Data Sources (Supabase REST/Realtime)│
│  ├─ Local Data Sources (SharedPrefs, File)      │
│  ├─ Platform Channels (sensors, health kit)      │
│  └─ DTOs (Data Transfer Objects)                │
└─────────────────────────────────────────────────┘
     Dependency Direction: UI → State → Domain ← Data
```

### 3.1 Dependency Rule
Dependencies point inward. The Domain layer has zero dependencies on Flutter, Drift, or any external framework. The Data layer depends on Domain (implements interfaces). The State layer bridges UI and Domain. The UI layer depends only on State.

### 3.2 Layer Responsibilities

**Domain Layer** (`lib/domain/`)
- Pure Dart, no platform dependencies
- Defines entities, value objects, repository interfaces, use cases, and service interfaces
- All business logic lives here
- AI inference services are defined here (implemented in Data layer)

**Data Layer** (`lib/data/`)
- Implements Domain interfaces (repositories, services)
- Drift database: DAOs, migrations, type converters
- Supabase client: REST calls, realtime subscriptions
- Platform channels: HealthKit, Google Fit, device sensors
- Caching strategies

**State Layer** (`lib/state/`)
- Riverpod providers using code generation
- Each provider is either a data provider (async) or UI state provider
- Providers auto-retry on failure (3 attempts)
- Offline-first: providers serve cached data then sync in background
- Error states propagated to UI layer

**UI Layer** (`lib/ui/`)
- Feature-organized subdirectories
- Each feature has: screens/ and widgets/
- Shared widgets in `lib/ui/shared/`
- Routes defined in one place with GoRouter
- Theme follows design system tokens

---

## 4. Feature-First Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   └── logger/
│
├── domain/
│   ├── entities/
│   │   ├── cycle.dart
│   │   ├── cycle_day.dart
│   │   ├── symptom.dart
│   │   ├── bbt_record.dart
│   │   ├── pregnancy.dart
│   │   ├── journal_entry.dart
│   │   └── user_condition.dart
│   ├── value_objects/
│   │   ├── flow_intensity.dart
│   │   ├── temperature.dart
│   │   ├── cycle_phase.dart
│   │   └── confidence_score.dart
│   ├── repositories/
│   │   ├── cycle_repository.dart
│   │   ├── symptom_repository.dart
│   │   ├── bbt_repository.dart
│   │   ├── journal_repository.dart
│   │   └── ...
│   ├── use_cases/
│   │   ├── predict_next_period.dart
│   │   ├── predict_ovulation.dart
│   │   ├── calculate_fertility_window.dart
│   │   ├── analyze_symptom_correlations.dart
│   │   ├── generate_health_report.dart
│   │   └── ...
│   └── services/
│       ├── cycle_prediction_service.dart      # interface
│       ├── symptom_analysis_service.dart      # interface
│       ├── fertility_service.dart             # interface
│       └── explanation_service.dart           # interface
│
├── data/
│   ├── database/
│   │   ├── app_database.dart                  # Drift database definition
│   │   ├── migrations/                        # SQL migration files
│   │   ├── converters/                        # Type converters
│   │   └── daos/
│   │       ├── cycle_dao.dart
│   │       ├── symptom_dao.dart
│   │       ├── bbt_dao.dart
│   │       └── ...
│   ├── remote/
│   │   ├── supabase_client.dart
│   │   ├── auth_service.dart
│   │   ├── sync_service.dart
│   │   └── api/
│   │       ├── cycle_api.dart
│   │       ├── symptom_api.dart
│   │       └── ...
│   ├── local/
│   │   ├── preferences_service.dart
│   │   ├── file_storage_service.dart
│   │   └── cache_service.dart
│   ├── platform/
│   │   ├── health_kit_bridge.dart
│   │   ├── wearable_bridge.dart
│   │   └── biometric_bridge.dart
│   ├── repositories/
│   │   ├── cycle_repository_impl.dart
│   │   ├── symptom_repository_impl.dart
│   │   └── ...
│   └── services/
│       ├── tflite_prediction_service.dart     # TensorFlow Lite impl
│       ├── symptom_analysis_service_impl.dart
│       ├── fertility_service_impl.dart
│       └── explanation_service_impl.dart
│
├── state/
│   ├── providers/
│   │   ├── cycle_providers.dart
│   │   ├── symptom_providers.dart
│   │   ├── bbt_providers.dart
│   │   ├── pregnancy_providers.dart
│   │   ├── journal_providers.dart
│   │   ├── auth_providers.dart
│   │   ├── settings_providers.dart
│   │   └── sync_providers.dart
│   └── notifiers/
│       ├── daily_log_notifier.dart
│       ├── fertility_notifier.dart
│       ├── prediction_notifier.dart
│       └── ...
│
├── ui/
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── cyra_button.dart
│   │   │   ├── cyra_card.dart
│   │   │   ├── cyra_chart.dart
│   │   │   ├── cyra_calendar.dart
│   │   │   ├── loading_indicator.dart
│   │   │   ├── error_display.dart
│   │   │   └── empty_state.dart
│   │   └── layouts/
│   │       ├── app_scaffold.dart
│   │       └── bottom_sheet.dart
│   ├── navigation/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   ├── typography.dart
│   │   └── spacing.dart
│   └── features/
│       ├── onboarding/
│       ├── dashboard/
│       ├── calendar/
│       ├── daily_log/
│       ├── period/
│       ├── ovulation/
│       ├── fertility/
│       ├── pregnancy/
│       ├── symptoms/
│       ├── hormones/
│       ├── conditions/
│       ├── ai_insights/
│       ├── predictions/
│       ├── journal/
│       ├── reports/
│       ├── wearables/
│       ├── community/
│       ├── education/
│       └── settings/
│
└── generated/                                 # Code-gen output
    └── ...
```

---

## 5. Local-First Architecture

### 5.1 Data Flow Diagram

```
┌──────────────┐    ┌──────────────────┐    ┌──────────────┐
│  User Action  │───▶│  State Layer     │───▶│  UI Update   │
│  (UI Event)   │    │  (Riverpod)      │    │  (Rebuild)   │
└──────────────┘    └────────┬─────────┘    └──────────────┘
                             │
                             ▼
                    ┌────────────────────┐
                    │  Domain Layer      │
                    │  (Use Case)        │
                    └────────┬───────────┘
                             │
                    ┌────────▼───────────┐
                    │  Repository (iface)│
                    └────────┬───────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
     ┌────────────┐  ┌────────────┐  ┌────────────┐
     │  Drift DB  │  │  Supabase  │  │  Sensors   │
     │  (Local)   │  │  (Remote)  │  │  (Device)  │
     └────────────┘  └────────────┘  └────────────┘
```

### 5.2 Write Path
1. User performs action in UI
2. State layer calls domain use case
3. Use case validates business rules
4. Repository writes to Drift DB (always writes locally first)
5. If sync enabled: SyncService queues the write for cloud sync
6. State layer updates, UI rebuilds
7. UX: write is instant (local); cloud sync is background

### 5.3 Read Path
1. Widget requests data via Riverpod provider
2. Provider reads from Drift DB (instant, offline-capable)
3. If sync enabled and stale: background refresh from Supabase
4. Provider emits updated data → widget rebuilds
5. Staleness threshold default: 5 minutes (configurable)

### 5.4 Drift Database

```dart
// lib/data/database/app_database.dart (conceptual)
@DriftDatabase(tables: [
  Cycles,
  CycleDays,
  Symptoms,
  SymptomLogs,
  BbtRecords,
  OvulationTests,
  CervicalMucusObservations,
  Pregnancies,
  FetalMeasurements,
  JournalEntries,
  UserConditions,
  WearableSources,
  EducationArticles,
  CommunityPosts,
  HealthReports,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => ...;
}
```

---

## 6. State Management: Riverpod 3.x

### 6.1 Provider Strategy

| Provider Type | Usage | Example |
|--------------|-------|---------|
| `AsyncNotifierProvider` | CRUD data with refresh | `cycleListProvider` |
| `FutureProvider.autoDispose` | One-shot fetches | `currentCycleProvider` |
| `StreamProvider` | Realtime data | `syncStatusProvider` |
| `StateNotifierProvider` | UI-only state | `dailyLogFormProvider` |
| `Provider` | Service/dependency injection | `authServiceProvider` |

### 6.2 Code Generation Pattern

```dart
// @riverpod annotation generates the provider
@riverpod
class CycleList extends _$CycleList {
  @override
  Future<List<Cycle>> build() async {
    final repo = ref.watch(cycleRepositoryProvider);
    return repo.getAllCycles();
  }

  Future<void> addCycle(Cycle cycle) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(cycleRepositoryProvider);
      await repo.insertCycle(cycle);
      return repo.getAllCycles();
    });
  }
}
```

### 6.3 Auto-Retry & Offline Persistence

```dart
// Wrapper that adds retry and caching
@riverpod
Future<List<Cycle>> cyclesWithRetry(CyclesWithRetryRef ref) async {
  final retryConfig = RetryConfig(maxAttempts: 3, backoff: Duration(seconds: 2));
  return retry(retryConfig, () async {
    final repo = ref.watch(cycleRepositoryProvider);
    return repo.getAllCycles();
  });
}
```

### 6.4 Error Handling in Providers

All data providers follow this error pattern:
- `AsyncLoading` → show skeleton/spinner
- `AsyncData` → show data
- `AsyncError` → show error state with retry button
- Empty data → show empty state illustration + CTA

---

## 7. Dependency Injection

### 7.1 Manual DI via Riverpod Providers

Cyra uses Riverpod's built-in dependency injection rather than a separate DI framework. All dependencies are wired in provider definitions.

```dart
// lib/state/providers/cycle_providers.dart

final driftDatabaseProvider = Provider<AppDatabase>((ref) {
  final executor = LazyDatabase(() async {
    final file = await getApplicationDocumentsDirectory();
    return NativeDatabase('${file.path}/cyra.db');
  });
  return AppDatabase(executor);
});

final cycleDaoProvider = Provider<CycleDao>((ref) {
  return ref.watch(driftDatabaseProvider).cycleDao;
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepositoryImpl(
    localDao: ref.watch(cycleDaoProvider),
    remoteApi: ref.watch(cycleApiProvider),
  );
});
```

### 7.2 Test Override Pattern

```dart
// In tests
final container = ProviderContainer(overrides: [
  cycleRepositoryProvider.overrideWith((ref) => MockCycleRepository()),
});
```

---

## 8. Error Handling & Logging

### 8.1 Error Hierarchy

```dart
sealed class AppException implements Exception {
  final String message;
  final String? stackTrace;
  AppException(this.message, [this.stackTrace]);
}

final class DatabaseException extends AppException {}
final class NetworkException extends AppException {}
final class SyncConflictException extends AppException {}
final class ValidationException extends AppException {}
final class AIPredictionException extends AppException {}
final class AuthenticationException extends AppException {}
final class NotFoundException extends AppException {}
```

### 8.2 Logging Strategy

| Level | Usage | Destination |
|-------|-------|-------------|
| `DEBUG` | Development info | Console (debug builds only) |
| `INFO` | Key lifecycle events | Console + Sentry |
| `WARN` | Non-critical issues | Console + Sentry |
| `ERROR` | Recoverable errors | Console + Sentry |
| `FATAL` | Crash conditions | Sentry |

- No health data in log messages
- User IDs are hashed in logs
- Log retention: 7 days on device

---

## 9. Offline Sync Strategy

### 9.1 Sync Queue Architecture

```
┌──────────────┐    Queue (Drift)    ┌──────────────┐
│  Local Write  │ ───▶ ┌─────────┐ ──▶│  Supabase    │
│  (Offline)    │      │ Pending │    │  Sync        │
└──────────────┘      │ Changes │    └──────┬───────┘
                      └─────────┘           │
                                            ▼
                                     ┌──────────────┐
                                     │  Conflict     │
                                     │  Resolution   │
                                     │  LWW          │
                                     └──────────────┘
```

### 9.2 Conflict Resolution: Last-Write-Wins (LWW)
- Each record has `updated_at` timestamp
- On conflict: the record with the later `updated_at` wins
- Lost data is logged for potential manual recovery
- User is notified: "Some changes couldn't be synced. We kept the most recent version."

### 9.3 Sync Triggers
- App foregrounded
- Network becomes available
- Manual pull-to-refresh
- Periodic background sync (every 30 min, configurable)

### 9.4 Sync Status Indicators
- Green checkmark: All data synced
- Yellow pending: Changes waiting to sync
- Red warning: Sync failed, tap to retry
- Offline badge: No network connection

---

## 10. Security Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                   App Layer                           │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  │
│  │ Biometric   │  │ Emergency    │  │ Hidden     │  │
│  │ Lock        │  │ Lock         │  │ Mode       │  │
│  └──────┬──────┘  └──────┬───────┘  └─────┬──────┘  │
│         │                │                 │         │
├─────────┼────────────────┼─────────────────┼─────────┤
│         ▼                ▼                 ▼         │
│  ┌─────────────────────────────────────────────┐    │
│  │           Encryption Layer                   │    │
│  │  AES-256-GCM (local data)                   │    │
│  │  TLS 1.3 (network)                          │    │
│  │  libsodium (E2EE key exchange)              │    │
│  └──────────────────┬──────────────────────────┘    │
│                     │                                │
├─────────────────────┼────────────────────────────────┤
│                     ▼                                │
│  ┌─────────────────────────────────────────────┐    │
│  │           Key Storage                       │    │
│  │  Android Keystore / iOS Keychain            │    │
│  │  flutter_secure_storage                     │    │
│  │  PBKDF2 key derivation (PIN fallback)       │    │
│  └─────────────────────────────────────────────┘    │
│                                                      │
│  ┌─────────────────────────────────────────────┐    │
│  │           Audit Log                         │    │
│  │  Privacy-preserving, no health data         │    │
│  │  Tracks: login attempts, sync events,       │    │
│  │  emergency lock triggers                     │    │
│  └─────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────┘
```

---

## 11. Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Cold Start | <2 seconds | Firebase Performance |
| Screen Navigation | <300ms | Custom timing |
| Scroll Jank | <1% frames >16ms | Flutter DevTools |
| Database Query (simple) | <10ms | Drift timing |
| Database Query (complex) | <100ms | Drift timing |
| AI Inference | <500ms | TFLite benchmark |
| Sync Latency | <5 seconds | Custom timing |
| Image Load | <500ms | Cached network image |
| APK/IPA Size | <50MB | Build output |
| Memory Usage (idle) | <80MB | DevTools |
| Memory Usage (active) | <200MB | DevTools |
| Battery Impact | <5% per hour | Device testing |

---

## 12. Testing Strategy

| Test Type | Scope | Tool | Coverage Target |
|-----------|-------|------|-----------------|
| Unit Tests | Domain entities, use cases, value objects | flutter_test | 90% |
| Widget Tests | UI components in isolation | flutter_test | 80% |
| Integration Tests | Feature flows | integration_test | 70% |
| Golden Tests | Visual regression | alchemist | Key screens |
| Provider Tests | State layer | flutter_test + ProviderContainer | 85% |
| Security Tests | Encryption, storage, auth | Custom + OWASP ZAP | All controls |
| Performance Tests | Startup, scroll, db | DevTools + benchmarks | All targets |
| Accessibility Tests | WCAG compliance | `accessibility_tools` | AA+ standard |

---

## 13. CI/CD Pipeline

```
GitHub Push
    │
    ▼
┌──────────────┐
│  Lint +      │
│  Format Check │
│  (dart analyze)│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Unit Tests  │
│  Widget Tests│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Build       │
│  (Android    │
│   + iOS)     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Integration │
│  Tests       │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Deploy to   │
│  TestFlight  │
│  / Firebase  │
│  App Distribution│
└──────────────┘
```
