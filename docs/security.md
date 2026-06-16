# Security Architecture: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | Security Team | Initial release |

---

## 1. Security Philosophy

Cyra handles some of the most sensitive data a person can have — reproductive health information, pregnancy status, fertility data, and intimate health details. Our security philosophy is:

1. **Privacy by Design**: Data minimization, local-first, encryption by default
2. **Defense in Depth**: Multiple security layers so no single failure is catastrophic
3. **Zero Trust Architecture**: No implicit trust for any component, including the cloud
4. **User Control**: Users own their data and control who accesses it
5. **Transparency**: Complete visibility into what data is stored and how it's protected

---

## 2. OWASP Mobile Top 10 Compliance Checklist

### 2.1 M1: Improper Platform Usage

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| No use of deprecated platform APIs | ✅ | Target SDK versions current, code review gating |
| Secure use of WebView | ✅ | No WebView for sensitive operations |
| Root/jailbreak detection | ✅ | App detects and warns, can disable on request |
| Input validation on all platform channels | ✅ | All method channel data validated |
| No debug logging in release builds | ✅ | Conditional compilation strips debug logs |

### 2.2 M2: Insecure Data Storage

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| No plaintext PII in SQLite | ✅ | AES-256-GCM encryption at rest |
| No sensitive data in SharedPreferences | ✅ | flutter_secure_storage for all secrets |
| No caching of sensitive data in screenshots | ✅ | FLAG_SECURE on Android, iOS snapshot protection |
| Keyboard input not saved to predictive text | ✅ | Autofill disabled on sensitive fields |
| Clipboard cleared on app background | ✅ | Custom clipboard manager |
| No sensitive data in crash logs | ✅ | Crash reporter filters sensitive fields |
| Temp files encrypted or deleted | ✅ | Temporary file cleanup on exit |

### 2.3 M3: Insecure Communication

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| TLS 1.3 mandatory | ✅ | TLS 1.3 only, no fallback to older versions |
| Certificate pinning | ✅ | Public key pins for all API endpoints |
| No mixed content (HTTPS + HTTP) | ✅ | ATS enforces HTTPS-only |
| Certificate transparency check | ✅ | CT monitoring for all certs |
| Secure WebSocket (WSS) for realtime | ✅ | Realtime connections over WSS |
| HSTS preload | ✅ | HSTS header with preload directive |

### 2.4 M4: Insecure Authentication

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Biometric authentication | ✅ | Face ID / Touch ID / fingerprint |
| Secure fallback (PIN) | ✅ | PBKDF2-derived key, rate-limited |
| Session management | ✅ | Short-lived JWT, refresh rotation |
| No session tokens in plaintext | ✅ | Stored in secure keychain/keystore |
| Account lockout after failed attempts | ✅ | 5 attempts → 2-minute lockout, 10 → 30-minute |
| Session invalidation on logout | ✅ | Token revoked server-side |

### 2.5 M5: Insufficient Cryptography

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| No deprecated algorithms | ✅ | No MD5, SHA-1, RC4, DES, 3DES |
| AES-256-GCM for data at rest | ✅ | NIST-compliant implementation |
| TLS 1.3 with X25519 | ✅ | Modern key exchange |
| PBKDF2 with 600K iterations | ✅ | PIN-based key derivation |
| Random IVs for each encryption operation | ✅ | Secure random IV generation |
| Keys not hardcoded | ✅ | Keys derived or stored in platform keychain |
| Cryptographic audit | ✅ | External audit prior to v1.0 release |

### 2.6 M6: Insecure Authorization

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| RLS policies on all Supabase tables | ✅ | Per-table policies with user isolation |
| No IDOR vulnerabilities | ✅ | All resources checked against auth.uid() |
| Server-side authorization enforcement | ✅ | Supabase RLS + Edge Function checks |
| Minimal privilege principle | ✅ | Service role only for admin operations |

### 2.7 M7: Client Code Quality

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Regular security audits | ✅ | Quarterly internal + annual external |
| Static analysis in CI | ✅ | dart analyze, SEMGrep rules |
| Dependency scanning | ✅ | Dependabot, Snyk monitoring |
| No debug code in release | ✅ | `--release` build mode enforced |

### 2.8 M8: Code Tampering

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Code signing | ✅ | Platform standard signing (iOS/Android) |
| Integrity check on startup | ✅ | App binary hash verification |
| Obfuscation | ✅ | Flutter `--obfuscate`, ProGuard/R8 |
| Repackage detection | ✅ | Signature verification mismatch triggers alert |

### 2.9 M9: Reverse Engineering

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Code obfuscation | ✅ | Symbol obfuscation enabled |
| String encryption | ✅ | Sensitive strings encrypted in binary |
| Control flow obfuscation | ✅ | Dart compilation to native ARM code |
| Anti-debugging detection | ✅ | Debugger detection on startup |

### 2.10 M10: Extraneous Functionality

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Minimal permissions | ✅ | Only health_kit, biometric, storage permissions |
| No debug endpoints in release | ✅ | Stripped during build |
| No backdoor accounts | ✅ | Zero hardcoded credentials |
| No hidden APIs | ✅ | All API surface documented |

---

## 3. Encryption Strategy

### 3.1 Encryption Layers

```
┌─────────────────────────────────────────────┐
│  Layer 4: Application-Level Encryption      │
│  (Health data fields encrypted before       │
│   database write)                           │
│  Algorithm: AES-256-GCM                     │
│  Key: Derived from user PIN + device key    │
├─────────────────────────────────────────────┤
│  Layer 3: Database-Level Encryption         │
│  (SQLite encryption extension)              │
│  Algorithm: AES-256-CBC or SQLCipher        │
│  Key: Derived from device key               │
├─────────────────────────────────────────────┤
│  Layer 2: File-Level Encryption             │
│  (Photos, voice notes, PDF reports)         │
│  Algorithm: AES-256-GCM                     │
│  Key: Per-file random key, wrapped by       │
│       user master key                       │
├─────────────────────────────────────────────┤
│  Layer 1: Platform-Level Encryption         │
│  (iOS Data Protection / Android File-Based  │
│   Encryption)                               │
│  Algorithm: Platform-default (AES-XTS)      │
│  Key: Platform keychain/keystore            │
└─────────────────────────────────────────────┘
```

### 3.2 AES-256-GCM Implementation

```dart
// Conceptual encryption utility
class HealthDataEncryptor {
  static const int _keyLength = 32;  // 256 bits
  static const int _nonceLength = 12; // 96 bits for GCM
  static const int _tagLength = 16;   // 128 bits auth tag

  Future<Uint8List> encrypt({
    required Uint8List plaintext,
    required Uint8List key,
    Uint8List? associatedData,
  }) async {
    final nonce = _generateSecureRandom(_nonceLength);
    final secretBox = SecretBox(
      plaintext,
      nonce: nonce,
      mac: Mac.empty(), // GCM includes auth tag
    );
    final cipher = StreamCipher.aesGcm(key);
    final encrypted = await cipher.encrypt(secretBox,
      associatedData: associatedData,
    );
    return combineNonceCiphertext(encrypted.nonce, encrypted.cipherText);
  }
}
```

### 3.3 TLS 1.3 Configuration

```dart
// Android Network Security Config (XML)
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <base-config cleartextTrafficPermitted="false">
    <trust-anchors>
      <certificates src="system" />
    </trust-anchors>
  </base-config>
  <domain-config cleartextTrafficPermitted="false">
    <domain includeSubdomains="true">api.cyrahealth.com</domain>
    <domain includeSubdomains="true">*.supabase.co</domain>
    <pin-set expiration="2027-06-01">
      <pin digest="SHA-256">// Primary pin hash</pin>
      <pin digest="SHA-256">// Backup pin hash</pin>
    </pin-set>
  </domain-config>
</network-security-config>
```

```swift
// iOS ATS Configuration (Info.plist)
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <false/>
  <key>NSPinnedDomains</key>
  <dict>
    <key>api.cyrahealth.com</key>
    <dict>
      <key>NSIncludesSubdomains</key>
      <true/>
      <key>NSPinnedLeafIdentities</key>
      <array>
        <dict>
          <key>SPKI-SHA256-BASE64</key>
          <string>// Primary pin</string>
        </dict>
        <dict>
          <key>SPKI-SHA256-BASE64</key>
          <string>// Backup pin</string>
        </dict>
      </array>
    </dict>
  </dict>
</dict>
```

### 3.4 Key Exchange (libsodium)

For E2EE when cloud sync is enabled, Cyra uses the X25519 key agreement protocol via libsodium:

```dart
// Key exchange for E2EE sync (conceptual)
class E2EEKeyManager {
  // Generate user's key pair on first sync enable
  Future<KeyPair> generateUserKeyPair() async {
    final seed = await _fetchEntropy();
    return crypto_sign_keypair(seed);
  }

  // Shared secret derivation
  Future<Uint8List> deriveSharedSecret(
    Uint8List theirPublicKey,
    Uint8List myPrivateKey,
  ) async {
    return crypto_kx_client_session_keys(
      myPrivateKey,
      theirPublicKey,
    );
  }
}
```

---

## 4. Certificate Pinning

### 4.1 Pin Configuration
- **Public Key Pins**: SHA-256 hashes of the public key (not certificate)
- **Primary Pin**: Current production certificate public key
- **Backup Pin**: Reserved certificate public key (different CA)
- **Expiration**: Updated annually, 60-day grace period before old pin expires
- **Monitoring**: Certificate Transparency log monitoring for unauthorized issuance

### 4.2 Pin Rotation Process
1. New certificate generated with backup key material
2. Backup pin added to client configuration (both pins active)
3. Server switches to new certificate
4. After 30 days of stability, primary pin updated
5. Old pin removed in next client release

### 4.3 Pinning Failure Behavior
- First failure: Log and report to Sentry (non-blocking)
- Subsequent failures within 5 minutes: Block connection, show error
- User notification: "Security check failed. Please update the app."

---

## 5. Secure Key Storage

### 5.1 Android: Android Keystore

```kotlin
// Android Keystore integration (via flutter_secure_storage)
val keyGenerator = KeyGenerator.getInstance(
    KeyProperties.KEY_ALGORITHM_AES,
    "AndroidKeyStore"
)
val keySpec = KeyGenParameterSpec.Builder(
    "cyra_master_key",
    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
)
    .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
    .setKeySize(256)
    .setUserAuthenticationRequired(true)
    .setUserAuthenticationValidityDurationSeconds(60)
    .build()
keyGenerator.init(keySpec)
```

### 5.2 iOS: iOS Keychain

```swift
// iOS Keychain access (via flutter_secure_storage)
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: "cyra_master_key",
    kSecAttrAccessControl as String: SecAccessControlCreateWithFlags(
        nil,
        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        .biometryCurrentSet,
        nil
    ),
    kSecAttrSynchronizable as String: false,
    kSecUseAuthenticationContext as String: LAContext()
]
```

### 5.3 Key Hierarchy

```
┌────────────────────────────────────┐
│  Biometric Key (Platform Keystore) │ ← Unlocked by biometric
└────────────┬───────────────────────┘
             │ wraps
             ▼
┌────────────────────────────────────┐
│  Master Key (AES-256)             │ ← Stored in secure storage
│  Used to derive:                   │
│   • Data encryption key            │
│   • File encryption key            │
│   • E2EE identity key              │
└────────────┬───────────────────────┘
             │ derives via HKDF
             ▼
┌────────────┴────────────┐
│  Per-Operation Keys     │
│  (derived on demand,    │
│   never persisted)      │
└─────────────────────────┘
```

---

## 6. Biometric Authentication

### 6.1 Authentication Flow

```
App Start / Resume from Background
         │
         ▼
┌────────────────┐     ┌────────────────┐
│  Biometric     │────▶│  Success       │────▶ Unlock App
│  Available?    │     └────────────────┘
└───────┬────────┘
        │ No
        ▼
┌────────────────┐     ┌────────────────┐
│  PIN Fallback  │────▶│  Verify PIN    │────▶ Unlock App
│  Configured?   │     │  (PBKDF2)      │
└───────┬────────┘     └───────┬────────┘
        │ No                   │ Fail (5x)
        ▼                      ▼
┌────────────────┐     ┌────────────────┐
│  Force         │     │  Lockout       │
│  Biometric     │     │  2 min / 30 min│
│  Setup         │     └────────────────┘
└────────────────┘
```

### 6.2 Biometric Configuration
- **Timeout**: Configurable (immediately, 1 min, 5 min, 15 min)
- **Re-authentication**: Required after timeout, or on sensitive operations (PIN change, data export)
- **Fallback**: PIN code (minimum 6 digits, maximum 10 attempts before factory reset)
- **Reset**: Requires biometric + PIN to reset PIN (prevents offline brute force)

### 6.3 PIN Key Derivation

```dart
class PINKDF {
  static Future<Uint8List> deriveEncryptionKey(String pin) async {
    final salt = await SecureStorage.read('pin_salt');
    final key = await PBKDF2.deriveKey(
      password: pin,
      salt: salt,
      iterations: 600000,  // OWASP recommended minimum
      keyLength: 32,       // 256 bits
      hashAlgorithm: HashAlgorithm.sha256,
    );
    return key;
  }

  // Verify PIN without exposing derived key
  static Future<bool> verifyPin(String pin) async {
    final expectedHash = await SecureStorage.read('pin_verification_hash');
    final derived = await deriveEncryptionKey(pin);
    final hash = await sha256(derived);
    return constantTimeEquals(hash, expectedHash);
  }
}
```

---

## 7. Emergency Privacy Lock

### 7.1 Trigger Mechanism
The emergency lock is accessible from any screen via:
1. **Shake gesture** (configurable sensitivity)
2. **Triple press of power button** (iOS: Emergency SOS, Android: power menu)
3. **On-screen emergency button** (always visible in quick action menu)
4. **Accessibility shortcut** (triple-click home/touch)

### 7.2 Emergency Lock Sequence

```
Emergency Trigger
        │
        ▼
┌─────────────────────────────────────┐
│ 1. Wipe in-memory data              │
│    • Clear all Riverpod state       │
│    • Clear clipboard                │
│    • Clear navigation stack         │
│    • Clear image cache              │
│    • Clear temporary files          │
├─────────────────────────────────────┤
│ 2. Display safe screen              │
│    • User-configurable:             │
│      – Weather app mock             │
│      – Calculator                   │
│      – Generic news feed            │
│      – Blank screen with clock      │
│    • No visual indication that      │
│      Cyra was previously active     │
├─────────────────────────────────────┤
│ 3. Disable notifications            │
│    • Suppress all Cyra notifs       │
│    • Turn off notification dots     │
│    • Pause background sync          │
├─────────────────────────────────────┤
│ 4. Log emergency event              │
│    • Timestamp (no health context)  │
│    • Trigger method (for UX metric) │
│    • Stored locally only            │
├─────────────────────────────────────┤
│ 5. Require biometric/PIN to restore │
│    • Full biometric scan needed     │
│    • PIN fallback available         │
│    • On successful auth: reload app │
│      state from encrypted storage   │
└─────────────────────────────────────┘
```

### 7.3 Safe Screen Options

| Screen | Description | Benefit |
|--------|-------------|---------|
| Weather | Simple weather display (uses real weather API) | Most convincing |
| Calculator | Standard calculator | Fast, common |
| News Feed | Generic headlines (uses real RSS feed) | Engaging, plausible |
| Blank + Clock | Minimal clock display | Simplest, least suspicious |
| Custom | User-uploaded image/app mock | Most personalizable |

---

## 8. Audit Logging (Privacy-Preserving)

### 8.1 Audit Log Scope
Only non-health metadata is logged for security auditing:

| Event | Data Logged | Retention |
|-------|-------------|-----------|
| App launch | Timestamp, app version | 90 days |
| Biometric auth attempt | Result (success/failure) | 90 days |
| PIN auth attempt | Result (success/failure) | 90 days |
| Emergency lock trigger | Trigger type, timestamp | 30 days |
| Sync session | Start/end time, records count | 30 days |
| Account deletion | Timestamp, request source | 90 days |
| Data export | Timestamp, export type | 30 days |
| Permission change | Permission, new status | 90 days |
| Subscription change | Old plan, new plan | 90 days |

### 8.2 Audit Log Storage
- **Local**: Encrypted SQLite table in Drift database
- **Remote**: Only if sync enabled; encrypted before transmission
- **User Accessible**: Viewable in Settings → Privacy → Security Log
- **Deletion**: User can delete audit logs at any time

---

## 9. Threat Model (STRIDE)

### 9.1 Per-Module Threat Analysis

| Module | Spoofing | Tampering | Repudiation | Info Disclosure | DoS | Elevation |
|--------|----------|-----------|-------------|-----------------|-----|-----------|
| **Authentication** | Biometric bypass | — | Audit trail | Token theft | Rate limiting | Token exchange | ← LOW |
| **Local Database** | — | SQL injection | — | Plaintext data | DB corruption | — | ← LOW |
| **Cloud Sync** | MitM attack | Data modification | — | E2EE prevents | Connection flood | RLS bypass | ← MODERATE |
| **AI Engine (local)** | Model swap | Weight tampering | — | Model inversion | Resource exhaustion | — | ← LOW |
| **Community** | Fake accounts | Post manipulation | Content moderation | PII leakage | Spam flood | Moderation bypass | ← MODERATE |
| **Wearables** | Device spoofing | Data injection | — | Health data leak | Sync flood | Platform API abuse | ← MODERATE |
| **File Storage** | — | Photo metadata | — | Photo content | Storage fill | — | ← LOW |
| **Notifications** | Fake notification | Content tampering | — | Cycle info in notif | Notification flood | — | ← LOW |
| **Education** | Content spoofing | Article tampering | — | — | — | — | ← LOW |

**Risk Rating:**
- **LOW**: Mitigated by platform security, no user data at risk
- **MODERATE**: Requires active attack, limited data exposure
- **HIGH**: Would require action, mitigated by encryption

### 9.2 Threat: Authentication Bypass

**Description:** Attacker bypasses biometric or PIN check to access app.

**Mitigations:**
- Biometric: Platform-level biometric APIs, cannot be bypassed in software
- PIN: PBKDF2 with 600K iterations, rate-limited (5 attempts → 2 min, 10 → 30 min)
- After 20 consecutive failed attempts: Local data encrypted with a randomized key, requiring app reinstall
- Fallback: Cannot disable biometric if device supports it

### 9.3 Threat: Physical Device Access

**Description:** Attacker gains physical access to unlocked device.

**Mitigations:**
- Auto-lock: App locks after configurable timeout (default: 1 minute)
- Emergency lock: Quick trigger hides all Cyra content
- Hidden mode: App disguised as different app (calculator, weather)
- Notification hiding: No health content in notifications or lock screen

### 9.4 Threat: Cloud Data Breach

**Description:** Supabase/S3 database compromised.

**Mitigations:**
- End-to-end encryption: Server stores ciphertext only
- Zero-knowledge architecture: Server has no access to encryption keys
- RLS: Even if server is breached, RLS limits per-user data access
- Data minimization: Only synced data is stored; journal text, photos, voice notes are local-only by default

### 9.5 Threat: Man-in-the-Middle

**Description:** Attacker intercepts network traffic between app and server.

**Mitigations:**
- TLS 1.3: Mandatory for all connections
- Certificate pinning: App validates server identity cryptographically
- No HTTP fallback: HSTS enforced
- WSS for WebSocket: All realtime channels encrypted

### 9.6 Threat: AI Model Inversion

**Description:** Attacker extracts training data characteristics from AI model.

**Mitigations:**
- On-device inference only: Model never leaves device
- Models trained on synthetic/public data only
- No user-specific fine-tuning performed
- Model weights encrypted at rest

---

## 10. Penetration Testing Methodology

### 10.1 Testing Frequency

| Test Type | Frequency | Scope |
|-----------|-----------|-------|
| Automated SAST | Every commit | All Dart/Flutter code |
| Automated DAST | Weekly | API endpoints, Edge Functions |
| Dependency scan | Every PR | Third-party packages |
| Internal pen test | Quarterly | Full application |
| External pen test | Annually | Full application + infrastructure |

### 10.2 Testing Scope (Annual External)

| Area | Details |
|------|---------|
| Authentication | Bypass attempts, token manipulation, session fixation |
| API Security | IDOR, injection, rate limit bypass, parameter tampering |
| Encryption | Algorithm correctness, key management, random number quality |
| Local Storage | Data extraction from SQLite, SharedPrefs, temp files, backups |
| Network | TLS downgrade, certificate bypass, traffic interception |
| Binary Analysis | Obfuscation effectiveness, string extraction, debugger detection |
| Device APIs | HealthKit, Google Fit, biometric API abuse |
| Community | XSS, CSRF, injection via community posts |
| AI | Model poisoning, adversarial inputs, side-channel leakage |

### 10.3 Remediation SLAs

| Severity | Definition | Remediation SLA |
|----------|------------|-----------------|
| Critical | Direct user data exposure, authentication bypass | 24 hours |
| High | Significant data exposure risk, limited bypass | 7 days |
| Medium | Partial data exposure, exploitation requires additional steps | 30 days |
| Low | Best-practice violations, minimal risk | 90 days |

### 10.4 Bug Bounty Program
- HackerOne platform
- Scope: Production application (mobile + API + infrastructure)
- Payouts: Critical $5,000 / High $2,000 / Medium $500 / Low $100
- Safe harbor policy published
- Response time: 24 hours acknowledgment, 7 days triage

---

## 11. Privacy Features Summary

| Feature | Description | Default |
|---------|-------------|---------|
| Local-first | All data stored on device by default | ON |
| Encryption at rest | AES-256-GCM for all health data | ON |
| TLS 1.3 | Encrypted network communication | ON |
| Certificate pinning | Prevents MitM attacks | ON |
| Biometric lock | Face ID / fingerprint authentication | OFF (prompt) |
| PIN fallback | Numeric PIN with PBKDF2 | OFF (prompt) |
| Emergency lock | Wipe & hide on trigger | ON |
| Hidden mode | Disguised app, hidden notifications | OFF |
| Anonymous analytics | No health data in analytics | ON |
| Data export | JSON/CSV export with all data | ON |
| Data deletion | One-tap delete all data | ON |
| Auditing | Privacy-preserving audit log | ON |

---

## 12. Compliance Mapping

### 12.1 GDPR Article Mapping

| Article | Requirement | Cyra Implementation |
|---------|-------------|---------------------|
| Art. 5 | Lawful processing | Consent-based, explicit opt-in for sync |
| Art. 12-14 | Transparency | Privacy policy, data inventory in app |
| Art. 15 | Right of access | Settings → Data → Export All |
| Art. 16 | Right to rectification | Edit any data in-app |
| Art. 17 | Right to erasure | Settings → Data → Delete All |
| Art. 20 | Data portability | JSON export with all data |
| Art. 25 | Data protection by design | Local-first, encryption, minimization |
| Art. 32 | Security of processing | AES-256, TLS 1.3, RLS, key management |
| Art. 33-34 | Breach notification | 72-hour notification protocol |

### 12.2 HIPAA Alignment

While Cyra is not a HIPAA-covered entity (does not provide medical services nor bill insurance), we follow HIPAA best practices:

| HIPAA Rule | Cyra Equivalent |
|------------|-----------------|
| Privacy Rule | Strict data minimization, user-controlled sharing |
| Security Rule | AES-256 encryption, access controls, audit logs |
| Breach Notification | 72-hour notification if PHI exposed |
| Patient Access | One-tap full data export |
| Minimum Necessary | Only requested data synced, never all data |
