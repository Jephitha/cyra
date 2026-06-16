# Product Requirements Document: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | Product Team | Initial release |

---

## 1. Product Overview & Vision

### 1.1 Elevator Pitch
Cyra is a privacy-first, AI-powered women's health companion that tracks menstrual cycles, ovulation, pregnancy, and symptoms while keeping all data encrypted and local on the user's device. Unlike competitors that monetize health data, Cyra's core differentiator is **explainable AI** — every prediction comes with a clear, plain-English explanation of why and how it was made.

### 1.2 Vision Statement
To empower every woman with personalized, private, and understandable insights into her reproductive health, without ever compromising her data privacy or treating her health as a black box.

### 1.3 Mission
Build the most trusted women's health platform by combining rigorous privacy engineering with transparent, explainable AI that helps users understand _why_ their cycle behaves the way it does.

### 1.4 Core Values
- **Privacy by Design**: Data never leaves the device without explicit consent
- **Explainability**: No black-box predictions — every insight comes with rationale
- **Inclusivity**: Designed for all bodies, gender identities, and health conditions
- **Clinical Rigor**: All medical content reviewed by healthcare professionals
- **Accessibility**: WCAG AA+ compliant, usable by everyone

---

## 2. Target Users

### 2.1 Primary Audience
Women and individuals aged 13-45 who menstruate, across all lifecycle stages.

### 2.2 Secondary Audiences

| Segment | Need | Cyra Solution |
|---------|------|---------------|
| **TTC (Trying to Conceive)** | Accurate ovulation prediction, fertility window identification | BBT tracking, OPK integration, cervical mucus analysis, fertility probability scoring |
| **Pregnant Users** | Pregnancy week-by-week tracking, kick counting, contraction timing | Pregnancy dashboard, fetal measurement logging, due date calculation |
| **PCOS Management** | Irregular cycle tracking, symptom correlation | Condition-specific tracking, pattern recognition across longer cycles |
| **Endometriosis** | Pain logging, flare prediction | Symptom correlation engine, treatment effectiveness tracking |
| **PMDD** | Mood/symptom tracking across luteal phase | Pattern detection, premenstrual prediction with confidence scoring |
| **Perimenopause** | Irregular cycle recognition, symptom tracking | Long-term cycle variability analysis, symptom trend reporting |
| **Postpartum** | Cycle return tracking, breastfeeding correlation | Lactation-aware cycle prediction |
| **Teens (13-17)** | Education, cycle normalization | Simplified UI, education hub, anonymous community |

### 2.3 User Personas

**Persona 1: Maya (28, TTC)**
Maya has been trying to conceive for 8 months. She needs accurate ovulation prediction with clear explanations of why her fertile window is predicted when it is. She wants to log BBT, OPKs, and cervical mucus, and see correlations between these signals. She is privacy-conscious and does not want her data shared with third parties.

**Persona 2: Priya (22, PCOS)**
Priya was diagnosed with PCOS at 19. Her cycles are irregular (35-60 days). She needs a tracker that adapts to long cycles, identifies patterns in her symptoms (acne, hair growth, weight fluctuations), and explains why predictions have high or low confidence. She wants educational content about managing PCOS.

**Persona 3: Elena (34, Pregnant)**
Elena is 24 weeks pregnant. She wants weekly updates on fetal development, a kick counter, contraction timer, and the ability to log symptoms like blood pressure and glucose. She wants to generate PDF reports for her doctor visits.

**Persona 4: Aisha (16, Teen)**
Aisha just started menstruating. She needs a simple, non-intimidating way to track her cycle, learn about what's normal, and understand her body. She values privacy from family members and wants a hidden mode.

---

## 3. Core Differentiator: Explainability

### 3.1 The Problem
Existing women's health apps provide predictions (e.g., "Your period will start in 3 days") without explaining _why_. Users are left to trust black-box algorithms with intimate health decisions. This erodes trust, especially when predictions are wrong.

### 3.2 Cyra's Approach
Every AI-generated insight in Cyra is accompanied by:

1. **Feature Contribution Breakdown**: A simple visualization showing which factors influenced the prediction (e.g., "Based on your last 3 cycles of 28, 29, and 27 days, plus the BBT rise detected 2 days ago")
2. **Confidence Score**: A percentage indicating how reliable the prediction is, with an explanation of what affects confidence
3. **Variability Range**: A date range rather than a single date, acknowledging biological variability
4. **Natural Language Explanation**: A sentence or paragraph in plain English
5. **Disclaimer**: Every AI output carries: "This is not a medical diagnosis. Consult your healthcare provider for medical advice."

### 3.3 Explainability by Module

| Module | What Is Explained |
|--------|-------------------|
| Period Prediction | Why this date ± range; which historical cycles contributed most |
| Ovulation Prediction | Which signals (temperature shift, LH surge, mucus pattern) triggered the prediction |
| Fertility Window | Probability distribution across days; why some days are higher probability |
| Symptom Correlations | Statistical strength of correlation; number of data points supporting it |
| Pregnancy Milestones | Standard medical timelines vs. personalized adjustments |
| AI Insights | SHAP-like feature importance values, simplified |

---

## 4. Detailed Module Specifications

### 4.1 Period Tracking
- Log period start/end dates
- Track flow intensity (light, medium, heavy, very heavy)
- Spotting and clotting logging
- Cycle length statistics (average, min, max, variability)
- Period length statistics
- Calendar view with phase coloring
- Prediction with explanation

### 4.2 Ovulation Tracking
- BBT charting with cover line
- Cervical mucus tracking (type, consistency, color, amount)
- Cervical position tracking
- OPK result logging (positive, negative, fading)
- Ovulation confirmation after 3 high temperatures
- Prediction explanation

### 4.3 Fertility Tracking
- Fertility window calculation (5 days before ovulation + ovulation day)
- Daily fertility probability (low, medium, high, peak)
- Intercourse logging with optional notes
- TTC mode with enhanced guidance
- Explanation of fertility probability per day

### 4.4 Pregnancy Tracking
- Due date calculation (Naegele's rule + LMP)
- Current week and trimester display
- Weekly fetal development information
- Kick counter with timer
- Contraction timer
- Appointment logging
- Weight, blood pressure, glucose tracking
- PDF report generation for healthcare providers
- Postpartum tracking mode

### 4.5 Symptom Tracking
- 50+ predefined symptoms across physical, emotional, and lifestyle categories
- Custom symptom creation
- Severity rating (1-5 scale)
- Time-of-day logging
- Symptom correlation analysis (which symptoms co-occur)
- Treatment logging (medication, supplements, exercise)
- Symptom trends over time

### 4.6 Hormone Insights
- Hormone phase visualization (estrogen, progesterone, LH, FSH across cycle)
- Personalized hormone curve based on cycle length
- Correlation between hormone phases and logged symptoms
- Educational content about hormonal health

### 4.7 Conditions Support
- Condition-specific tracking modes:
  - PCOS: Cycle irregularity tracking, symptom correlation, long cycle support
  - Endometriosis: Pain mapping, flare prediction, treatment tracking
  - PMDD: Luteal phase symptom tracking, pattern recognition
  - Adenomyosis: Pain and bleeding pattern tracking
  - Fibroids: Bleeding and symptom tracking
  - Thyroid: Menstrual impact tracking
- Condition-specific education articles
- Integration with symptom logging

### 4.8 AI Insights
- Monthly cycle summary with AI analysis
- Pattern detection (short luteal phase, anovulatory cycles, etc.)
- Anomaly detection (unusual bleeding, significant cycle changes)
- Personalized recommendations (non-diagnostic)
- Full explainability features
- Data quality indicators

### 4.9 Prediction Engine
- Cycle length prediction using hybrid statistical + LSTM model
- Period date prediction with confidence and variability
- Ovulation day prediction
- Fertility window prediction
- Symptom flare prediction (conditions)
- Model versioning and performance tracking

### 4.10 Journal
- Diary-style entries linked to cycle days
- Rich text with formatting
- Photo attachments (stored locally, encrypted)
- Voice note recordings (stored locally, encrypted)
- Mood emoji selector
- Tag system for searchability
- Calendar integration (see which days have journal entries)

### 4.11 Health Reports
- Cycle history reports (PDF)
- Symptom summary reports
- Fertility analysis reports
- Pregnancy progress reports
- Custom date range selection
- Export and share (with privacy warning)
- Clinic-ready formatting

### 4.12 Wearables Integration
- Apple Watch (HealthKit)
- Fitbit
- Garmin
- Oura Ring
- OnePlus Watch
- Oppo Watch
- Redmi Watch
- Data imported: resting heart rate, HRV, sleep, steps, skin temperature
- Wearable data correlation with cycle phases
- Manual sync + automatic background sync

### 4.13 Community
- Topic-based discussion groups
- Anonymous posting option
- Upvote/reply system
- Moderated content (AI + human moderation)
- Topic categories: TTC, Pregnancy, PCOS, Endometriosis, General, Teens
- No DMs or private messaging (safety by design)
- Report and block functionality
- Content guidelines enforcement

### 4.14 Education Hub
- 200+ medically reviewed articles
- Categories: Cycle Basics, Fertility, Pregnancy, Conditions, Nutrition, Exercise, Mental Health
- Offline download
- Read-aloud (text-to-speech)
- Bookmarks and reading history
- Personalized recommendations based on tracked conditions
- Medical review dates and author credentials displayed
- Sources and references cited

---

## 5. Privacy Requirements

### 5.1 Local-First Architecture
- All health data stored locally on device
- Cloud sync is optional and opt-in
- No cloud storage without explicit user consent
- User can delete all data at any time
- Anonymous analytics only (no health data in analytics)

### 5.2 End-to-End Encryption
- If cloud sync enabled: data encrypted before leaving device
- Server never has access to decryption keys
- E2EE protocol: libsodium-based with X25519 key agreement
- Metadata (sync timestamps, file sizes) minimized

### 5.3 Biometric Lock
- App unlock with Face ID / Touch ID / fingerprint
- Configurable time-out (immediately, 1 min, 5 min, 15 min)
- Fallback PIN code
- PIN derived key for additional data encryption

### 5.4 Emergency Lock
- Quick exit button on every screen
- Trigger: shake device, triple-press power, or tap button
- On trigger: app shows safe screen (weather app mock, calculator, or generic screen)
- In-memory data wiped
- Requires biometric or PIN to restore
- Configurable safe screen appearance

### 5.5 Hidden Mode
- App icon can be renamed/hidden
- Notification content hidden (show generic notifications)
- No health data in app switcher preview
- Discreet name in settings
- Icon can be changed to generic icon (calculator, weather, etc.)

### 5.6 Data Collection Transparency
- Complete data inventory available in settings
- What data is stored, where, for how long
- One-tap data export
- One-tap data deletion
- Third-party data sharing: NONE

---

## 6. Security Requirements

### 6.1 OWASP Top 10 Mobile Compliance
- M1: Improper Platform Usage — Secure API usage, no rooted/jailbroken detection
- M2: Insecure Data Storage — All sensitive data encrypted at rest (AES-256-GCM)
- M3: Insecure Communication — TLS 1.3 mandatory, certificate pinning
- M4: Insecure Authentication — Biometric + PIN, no session tokens stored in plaintext
- M5: Insufficient Cryptography — Modern algorithms only (no MD5, SHA-1, RC4)
- M6: Insecure Authorization — RLS policies on all Supabase tables
- M7: Client Code Quality — Regular security audits, code obfuscation
- M8: Code Tampering — Integrity checks, app signing verification
- M9: Reverse Engineering — ProGuard/R8, Flutter obfuscation
- M10: Extraneous Functionality — Minimal permissions, no debug code in release

### 6.2 Encryption Standards
- **At Rest**: AES-256-GCM with per-file random IVs
- **In Transit**: TLS 1.3 with X25519 key exchange
- **Key Storage**: Android Keystore / iOS Keychain via flutter_secure_storage
- **Key Derivation**: PBKDF2 with 600,000 iterations for PIN-based keys
- **Backup**: Encrypted backups only, user-controlled key

### 6.3 Certificate Pinning
- Public key pinning for all API endpoints
- Backup pins for key rotation
- Certificate transparency monitoring

### 6.4 Security Headers
- Strict-Transport-Security
- Content-Security-Policy
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY

---

## 7. Accessibility Requirements

### 7.1 WCAG 2.2 AA+ Compliance

| Principle | Requirement | Implementation |
|-----------|-------------|----------------|
| Perceivable | All content available to senses | Screen reader support, alt text on all images |
| Operable | All functionality via keyboard | Full keyboard navigation, focus indicators |
| Understandable | Content readable and predictable | Clear language, consistent navigation |
| Robust | Compatible with assistive tech | Semantic elements, ARIA labels where needed |

### 7.2 Specific Requirements
- **Screen Readers**: Full TalkBack and VoiceOver support
- **Dynamic Text**: All text scales with system font size (up to 200%)
- **High Contrast**: Both light and dark modes meet 4.5:1 minimum contrast ratio
- **Touch Targets**: Minimum 44x44pt for all interactive elements
- **Focus Indicators**: Visible focus rings on all focusable elements
- **Captions**: All video content captioned
- **Text-to-Speech**: Education articles and AI explanations readable aloud
- **Color Blindness**: Charts and graphs use patterns + labels, not color alone
- **Motor Accessibility**: All timed actions can be extended or disabled

---

## 8. Subscription Strategy

### 8.1 Free Tier

| Feature | Details |
|---------|---------|
| Period Tracking | Full period logging, calendar, basic statistics |
| Basic Predictions | Next period date with ±3 day range |
| Symptom Logging | All symptoms, severity, notes |
| Journal | Text entries, mood logging |
| Education Hub | 50 free articles |
| Community | Browse and post |
| Cycle Calendar | Current cycle view |
| Fertility Window | Basic prediction (last 3 cycles average) |

### 8.2 Premium Tier (Cyra Plus)

| Feature | Details |
|---------|---------|
| Advanced Predictions | AI-powered with explainability, ±1 day accuracy |
| Fertility Tracking | Full fertile window, probability scoring |
| Ovulation Tracking | BBT charting, OPK integration, cervical mucus |
| Pregnancy Tracking | Full dashboard, kick counter, reports |
| AI Insights | Monthly cycle analysis, pattern detection, anomaly alerts |
| Health Reports | PDF generation, export, clinic-ready |
| Wearables Integration | All wearable devices, data correlation |
| Education Hub | Full library (200+ articles), offline download |
| Advanced Symptom Correlations | Statistical analysis, condition-specific patterns |
| Condition Support | PCOS, Endometriosis, PMDD, etc. |
| All previous features | Everything from free tier |

### 8.3 Pricing (Proposed)
- Monthly: $9.99/month
- Annual: $79.99/year (33% savings)
- Lifetime: $199.99 (one-time)
- Free Trial: 14-day full premium trial

### 8.4 Discount Programs
- Student discount: 50% off with valid .edu email
- Hardship discount: 75% off, application-based
- Gift cards available
- Family plan (up to 5 accounts): $19.99/month

---

## 9. Success Metrics

### 9.1 Key Performance Indicators

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Store Rating | 4.8+ stars | App Store / Play Store |
| Day 1 Retention | ≥60% | Amplitude / Mixpanel |
| Day 7 Retention | ≥40% | Amplitude / Mixpanel |
| Day 30 Retention | ≥25% | Amplitude / Mixpanel |
| Premium Conversion | ≥8% of active users | RevenueCat |
| Premium Retention | ≥85% monthly | RevenueCat |
| Daily Active Users (DAU) | ≥40% of MAU | Analytics |
| Monthly Active Users (MAU) | Tracked | Analytics |
| Average Session Length | ≥4 minutes | Analytics |
| Cycle Logging Compliance | ≥80% logged cycles | Internal metrics |
| NPS Score | ≥60 | Quarterly survey |
| CSAT Score | ≥4.5/5 | In-app feedback |
| Crash-Free Rate | ≥99.9% | Crashlytics / Sentry |
| AI Prediction Accuracy | ≥90% within ±2 days | Internal evaluation |

### 9.2 Quality Gates for Release
- All critical/blocker bugs resolved
- WCAG AA+ audit passed
- Security penetration test passed
- AI prediction accuracy ≥90%
- Performance: Cold start <2s, UI <60fps
- Test coverage ≥80% (unit) + ≥70% (integration)

---

## 10. Regulatory & Compliance

### 10.1 GDPR Compliance
- Right to access all data
- Right to deletion (right to be forgotten)
- Data portability (one-tap export in standard format)
- Data Processing Agreement for any third-party services
- Privacy Impact Assessment completed

### 10.2 HIPAA Compliance (US Market)
- Not a covered entity (not providing medical services)
- Best practices followed voluntarily
- Business Associate Agreements with relevant vendors
- No sharing of PHI without explicit consent

### 10.3 CCPA Compliance
- Right to know what data is collected
- Right to delete
- Right to opt-out of sale (no data sold)
- Minors (under 16): affirmative consent required

### 10.4 Regional Considerations
- EU: GDPR, full compliance
- UK: UK GDPR
- Brazil: LGPD
- India: Digital Personal Data Protection Act
- Australia: Privacy Act 1988
- Canada: PIPEDA

---

## 11. Technical Constraints

- iOS 16+ support
- Android 12+ support
- Offline-first: full functionality without internet
- Storage: ≤500MB max (including offline content)
- RAM: ≤200MB peak usage
- Battery: Minimal background processing
- AI models: ≤50MB total download
- Sync: ≤5MB per sync session
- Accessibility: WCAG AA+ minimum

---

## 12. Glossary

| Term | Definition |
|------|------------|
| BBT | Basal Body Temperature |
| OPK | Ovulation Predictor Kit |
| LH | Luteinizing Hormone |
| FSH | Follicle Stimulating Hormone |
| TTC | Trying to Conceive |
| PCOS | Polycystic Ovary Syndrome |
| PMDD | Premenstrual Dysphoric Disorder |
| LMP | Last Menstrual Period |
| E2EE | End-to-End Encryption |
| RLS | Row Level Security |
| SHAP | SHapley Additive exPlanations |
