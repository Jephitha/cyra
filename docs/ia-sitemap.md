# Information Architecture & Sitemap: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | UX Team | Initial release |

---

## 1. Navigation Architecture

### 1.1 Global Navigation Structure

```
┌────────────────────────────────────────────────────────────────────────────┐
│                          Tab Bar (Persistent)                              │
├──────────┬──────────┬──────────┬──────────┬──────────┬────────────────────┤
│   Home   │ Calendar │ Insights │Education │Community │  Settings          │
│  (Dashboard)│         │  (AI)    │  (Learn) │ (Social) │                    │
└──────────┴──────────┴──────────┴──────────┴──────────┴────────────────────┘
│ Tab 1    │ Tab 2   │ Tab 3    │ Tab 4    │ Tab 5    │ Tab 6              │
│          │         │          │          │          │                    │
│ • Today  │ • Month │ • Cycle  │ • Browse │ • Feed   │ • Account          │
│   overview│   view  │   summary│   by cat │ • Topics │ • Privacy          │
│ • Quick  │ • Phase │ • Pattern│ • Offline│ • Post   │ • Security         │
│   log    │   colors│   detect │   saved  │ • Search │ • Data             │
│ • Cycle  │ • Day   │ • Explain│ • Read   │ • Guide- │ • Subscription     │
│   stats  │   detail│   -ation │   aloud  │   lines  │ • Wearables        │
│ • Fert.  │ • Fert. │ • Confid-│          │          │ • Conditions       │
│   window │   window│   ence   │          │          │ • About            │
│ • Next   │ • BBT   │          │          │          │                    │
│   period │   chart │          │          │          │                    │
│ • Sympt. │ • OPK   │          │          │          │                    │
│   corr.  │   log   │          │          │          │                    │
│          │ • Journ.│          │          │          │                    │
│          │   ent.  │          │          │          │                    │
└──────────┴──────────┴──────────┴──────────┴──────────┴────────────────────┘
```

### 1.2 Plus Button (FAB)

A floating action button centered above the tab bar provides quick access to the daily log:

```
[+ FAB] → Daily Check-In (modal)
            ├── Log Period
            ├── Log Symptoms
            ├── Log BBT
            ├── Log OPK
            ├── Journal Entry
            ├── Log Intercourse
            └── Log Pregnancy Vitals (if pregnant)
```

---

## 2. Tab 1: Home / Dashboard

### 2.1 Screen Hierarchy

```
Home (Dashboard)
├── Today's Summary Card
│   ├── Cycle day + phase
│   ├── Flow status (if menstruating)
│   ├── Quick stats: temp, symptoms logged
│   └── [Check In] CTA (if not logged today)
│
├── Next Period Prediction Card
│   ├── Predicted date ± range
│   ├── Confidence score
│   ├── [Why?] → Expands explanation
│   └── [View Calendar ▸] → Calendar Tab
│
├── Fertility Window Card (if tracking fertility)
│   ├── Current fertility status
│   ├── Window dates
│   ├── Daily probability
│   └── [View Details ▸] → Calendar Tab (fertility view)
│
├── Pregnancy Card (if pregnant)
│   ├── Current week + trimester
│   ├── Due date + days remaining
│   ├── Baby size comparison
│   └── [Open Dashboard ▸] → Pregnancy Dashboard
│
├── Symptom Highlights Card
│   ├── Most logged symptom this cycle
│   ├── Symptom count
│   ├── New correlation detected badge
│   └── [View All ▸] → Symptoms Screen
│
├── AI Insight Card (premium)
│   ├── One highlight insight
│   ├── Tapping expands full insight
│   └── [Full Analysis ▸] → Insights Tab
│
├── Journal Prompt Card
│   ├── "How are you feeling today?"
│   ├── Quick mood emoji selector
│   └── [Write ▸] → Journal New Entry (modal)
│
├── Education Card
│   ├── Recommended article
│   ├── Continue reading (bookmarked)
│   └── [Browse ▸] → Education Tab
│
└── Community Card
    ├── Trending post preview
    └── [Join Discussion ▸] → Community Tab
```

### 2.2 Deep Links
- `cyra://home`
- `cyra://dashboard`
- `cyra://daily-log` → opens daily check-in modal
- `cyra://period/new` → quick period start log

---

## 3. Tab 2: Calendar

### 3.1 Screen Hierarchy

```
Calendar
├── Month View (primary)
│   ├── Grid: 42 days (6 weeks)
│   ├── Phase coloring per day
│   │   ├── 🩸 Red: Menstrual
│   │   ├── 🌸 Pink: Follicular
│   │   ├── 🌿 Green: Fertile window
│   │   ├── 🌰 Yellow: Ovulation day
│   │   └── 💜 Purple: Luteal
│   ├── Day indicators:
│   │   ├── Dots: period/data logged/journal
│   │   └── Ring: predicted ovulation
│   ├── Month picker (swipe or tap year header)
│   ├── [Today] button
│   └── Legend toggle
│
├── Day Detail (bottom sheet, tap day)
│   ├── Date, cycle day, phase
│   ├── Flow intensity indicator
│   ├── Mood emoji
│   ├── Symptom summary list
│   ├── BBT reading (if logged)
│   ├── OPK result (if logged)
│   ├── Journal entry preview
│   ├── Intercourse indicator
│   ├── [Edit] → Daily Check-In (pre-filled)
│   └── [Add Journal Entry] → Journal New Entry
│
├── Cycle Summary (header below month)
│   ├── Cycle number, start date, end date
│   ├── Cycle length, period length
│   ├── Ovulation day (if confirmed)
│   ├── Predicted next period
│   └── [View Full Cycle Stats ▸]
│
└── Calendar Sub-views (toggle at top)
    ├── Month View (default)
    ├── Fertility View
    │   ├── Fertile window highlighted
    │   ├── Daily fertility probability
    │   ├── BBT chart mini-preview
    │   └── [Full BBT Chart ▸]
    ├── Year View
    │   ├── 12-month overview
    │   └── Each month shows period days
    └── Cycle List View
        ├── Chronological cycle cards
        └── Each shows start, length, period, notes
```

### 3.2 Deep Links
- `cyra://calendar`
- `cyra://calendar/{year}/{month}`
- `cyra://calendar/{year}/{month}/{day}`
- `cyra://calendar/fertility`
- `cyra://calendar/cycle/{cycleId}`

---

## 4. Tab 3: Insights (AI)

### 4.1 Screen Hierarchy

```
Insights
├── Cycle Summary (current/most recent)
│   ├── Cycle stats card
│   │   ├── Length, period length, ovulation day
│   │   ├── Luteal phase length
│   │   └── Variability score
│   ├── Next period prediction
│   │   ├── Date ± range
│   │   ├── Confidence score + bar
│   │   └── Feature contribution breakdown
│   │       ├── Recent cycles: +2.1 days
│   │       ├── BBT pattern: -0.5 days
│   │       ├── OPK data: +0.3 days
│   │       └── Overall prediction: +1.9 days
│   └── Explanation card (collapsible)
│       └── Natural language explanation
│
├── Pattern Detection Section
│   └── Card list:
│       ├── Cycle length pattern
│       │   └── "Your cycles are regular (SD: 1.2 days)"
│       ├── Symptom patterns
│       │   ├── "Headache peaks in luteal phase"
│       │   ├── "Bloating 2 days before period"
│       │   └── "Low energy on Day 1-2"
│       └── Anomaly alerts
│           ├── "Unusually long cycle detected"
│           └── "Missing ovulation this cycle?"
│
├── Symptom Correlations Section
│   ├── Strongest correlations
│   ├── Time-lagged patterns
│   └── [View All Correlations ▸] → Full list
│
├── Fertility Analysis Section (premium)
│   ├── Ovulation confidence per cycle
│   ├── Fertile window accuracy
│   └── BBT pattern analysis
│
├── Data Quality Section
│   ├── Overall data quality score
│   ├── Logging streak
│   ├── Missing data prompts
│   └── Improvement tips
│
└── History Section
    └── Past cycle summaries (scrollable list)
```

### 4.2 Deep Links
- `cyra://insights`
- `cyra://insights/cycle/{cycleId}`
- `cyra://insights/correlations`
- `cyra://insights/fertility`

---

## 5. Tab 4: Education (Learn)

### 5.1 Screen Hierarchy

```
Education Hub
├── Search Bar (always visible)
│   └── Full-text search across all articles
│
├── Featured Section (horizontal scroll)
│   ├── Hero article card (larger)
│   └── 3-4 secondary article cards
│
├── Categories (horizontal scroll chips)
│   ├── Cycle Basics
│   ├── Fertility
│   ├── Pregnancy
│   ├── Conditions
│   ├── Nutrition
│   ├── Exercise
│   ├── Mental Health
│   └── General
│
├── Recommended For You (personalized)
│   ├── Based on tracked conditions
│   ├── Based on cycle phase
│   └── Based on reading history
│
├── Continue Reading (in-progress articles)
│   └── Horizontal scroll with progress bar
│
├── Bookmarked Articles
│   └── Grid of bookmarked cards
│
├── Offline Downloads
│   └── List of downloaded articles with size
│
└── Category Detail (tap category chip)
    └── Article list for that category
        ├── Filter: All / Beginner / Intermediate / Advanced
        └── Sort: Popular / Recent / Title

Article Detail (push navigation)
├── Header: title, category, read time
├── Medical reviewer badge
├── Last reviewed date
├── Read Aloud button
├── Bookmark button
├── Download button (offline)
├── Share button
├── Article content (Markdown rendered)
│   ├── Headers, paragraphs, images
│   ├── Info boxes, warnings (callouts)
│   └── Diagrams / charts
├── Sources section at bottom
└── Related articles (carousel)
```

### 5.2 Deep Links
- `cyra://education`
- `cyra://education/category/{categorySlug}`
- `cyra://education/article/{articleSlug}`
- `cyra://education/search?q={query}`

---

## 6. Tab 5: Community

### 6.1 Screen Hierarchy

```
Community
├── Topic Tabs (horizontal scroll)
│   ├── General (default)
│   ├── TTC
│   ├── Pregnancy
│   ├── PCOS
│   ├── Endometriosis
│   ├── PMDD
│   ├── Teens
│   └── New Moms
│
├── Sort Toggle
│   ├── Hot (default)
│   ├── New
│   └── Top (today/week/month/all)
│
├── Post List (scrollable feed)
│   └── Post Card:
│       ├── Anonymous user avatar
│       ├── Topic badge
│       ├── Title
│       ├── Content preview (2 lines)
│       ├── Upvote count + button
│       ├── Reply count
│       └── Time ago
│
├── [+ New Post] FAB
│
└── Post Detail (push navigation)
    ├── Full post content
    ├── Upvote button
    ├── Reply button
    ├── Report button (⋯ menu)
    ├── Replies (chronological)
    │   └── Reply card:
    │       ├── Anonymous avatar
    │       ├── Content
    │       ├── Upvote
    │       └── Time ago
    └── Reply input (bottom)
        ├── Text input
        └── [Reply] button

New Post (modal)
├── Topic selector (dropdown)
├── Title input
├── Content input (multiline)
├── Anonymous toggle
├── Community Guidelines reminder
└── [Post] button

Community Guidelines (push nav)
└── Full guidelines text
```

### 6.2 Deep Links
- `cyra://community`
- `cyra://community/topic/{topicId}`
- `cyra://community/post/{postId}`
- `cyra://community/new`

---

## 7. Tab 6: Settings

### 7.1 Screen Hierarchy

```
Settings
├── Account
│   ├── Profile
│   │   ├── Display name
│   │   ├── Email (if signed up)
│   │   ├── Date of birth
│   │   └── Avatar (optional)
│   ├── Subscription
│   │   ├── Current plan (Free / Premium)
│   │   ├── [Upgrade] / [Manage]
│   │   ├── Plan features comparison
│   │   └── Billing history
│   └── [Sign Out] / [Delete Account]
│
├── Privacy & Security
│   ├── Privacy Controls
│   │   ├── Cloud Sync toggle
│   │   │   └── [Configure E2EE Key]
│   │   ├── Anonymous analytics toggle
│   │   ├── Data Inventory → Full list of stored data types
│   │   ├── [Export All Data] → JSON/CSV
│   │   └── [Delete All Data] → Confirmation flow
│   ├── App Lock
│   │   ├── Toggle: On / Off
│   │   ├── Lock timeout: Immediately / 1m / 5m / 15m
│   │   ├── Biometric type (Face ID / Touch ID / Fingerprint)
│   │   ├── [Change PIN]
│   │   └── [Reset App Lock]
│   ├── Emergency Lock
│   │   ├── Toggle: On / Off
│   │   ├── Trigger methods
│   │   │   ├── Triple-press power button
│   │   │   ├── Shake device
│   │   │   └── On-screen panic button
│   │   ├── Safe screen: Weather / Calculator / News / Clock / Custom
│   │   ├── [Test Emergency Lock]
│   │   └── [Learn More]
│   └── Hidden Mode
│       ├── Toggle: On / Off
│       ├── App disguise: Weather / Calculator / News / Clock
│       ├── Notification content: Hide / Show generic
│       └── App icon: Default / Calculator / Weather
│
├── Health Data
│   ├── Health Conditions
│   │   ├── List of conditions
│   │   ├── [Add Condition]
│   │   └── Condition dashboard per item
│   ├── Wearable Devices
│   │   ├── Connected devices list
│   │   ├── [Connect Device]
│   │   └── Data source priority (drag reorder)
│   ├── Cycle Settings
│   │   ├── Typical cycle length
│   │   ├── Typical period length
│   │   ├── Luteal phase length
│   │   └── Ovulation day offset
│   ├── Symptom Preferences
│   │   └── Custom symptoms management
│   └── [Import Data] → from other apps (CSV import)
│
├── Notifications
│   ├── Daily check-in reminder
│   │   ├── Toggle
│   │   └── Time picker
│   ├── Period prediction alert
│   │   ├── Toggle
│   │   └── Days before: 1 / 2 / 3
│   ├── Fertile window alert
│   │   ├── Toggle
│   │   └── Time of day
│   ├── Ovulation day alert
│   │   ├── Toggle
│   │   └── Time of day
│   ├── Community notifications
│   │   ├── Replies to my posts
│   │   └── Upvotes
│   ├── AI insight notifications
│   │   └── "New insight available"
│   └── Quiet hours
│       ├── From / To
│       └── Override toggle
│
├── Appearance
│   ├── Theme
│   │   ├── System (default)
│   │   ├── Light
│   │   └── Dark
│   ├── Accent Color
│   │   └── Deep Forest Green / Sage / Soft Gold
│   ├── Text Size
│   │   └── Small / Medium / Large / Extra Large
│   ├── Calendar Start of Week
│   │   └── Monday / Sunday
│   └── Temperature Unit
│       └── Celsius / Fahrenheit
│
├── Language & Region
│   ├── App Language
│   │   └── English (en) / Spanish (es) / French (fr) / German (de) / etc.
│   └── Date Format
│       └── MM/DD/YYYY / DD/MM/YYYY / YYYY-MM-DD
│
├── Data & Storage
│   ├── Storage Usage
│   │   ├── Database size
│   │   ├── Photos & recordings
│   │   ├── Offline articles
│   │   └── Cache size
│   ├── [Clear Cache]
│   ├── [Clear Offline Articles]
│   └── [Reset All Data]
│
├── Accessibility
│   ├── Screen Reader Optimization
│   ├── Reduce Motion toggle
│   ├── High Contrast toggle
│   └── Focus Indicator toggle
│
├── Support
│   ├── Help Center (webview)
│   ├── Contact Support
│   ├── FAQ
│   └── Report Bug
│
└── About
    ├── Version: 1.0.0 (build 1)
    ├── What's New
    ├── Terms of Service
    ├── Privacy Policy
    ├── Medical Disclaimer
    ├── Open Source Licenses
    ├── Third-Party Credits
    └── [Licenses]
```

### 7.2 Deep Links
- `cyra://settings`
- `cyra://settings/privacy`
- `cyra://settings/security`
- `cyra://settings/emergency-lock`
- `cyra://settings/hidden-mode`
- `cyra://settings/conditions`
- `cyra://settings/wearables`
- `cyra://settings/subscription`
- `cyra://settings/notifications`
- `cyra://settings/appearance`

---

## 8. Modal Screens

These screens appear as full-screen modals or bottom sheets, not tab navigation.

### 8.1 Daily Check-In (Modal)
```
Daily Check-In (full-screen modal)
├── Date header (today)
├── Cycle day + phase
├── Flow intensity selector
├── Mood emoji selector
├── Symptom grid (searchable, categorized)
├── Temperature input
├── Sleep input
├── Exercise input
├── Intercourse toggle
├── Notes text area
├── [Save] button
└── [Cancel] / Swipe to dismiss
```

### 8.2 Symptom Selector (Bottom Sheet)
```
Symptom Selector (bottom sheet, searchable)
├── Search bar
├── Category chips
├── Symptom grid (filtered)
├── Tap → Severity dialog (inline)
└── [Done] button
```

### 8.3 Journal Entry (Modal)
```
Journal Entry (full-screen modal)
├── Date picker
├── Title input
├── Mood selector
├── Rich text editor
├── Photo attachments
├── Voice note recorder
├── Tag input
├── [Save] button
└── [Cancel]
```

### 8.4 BBT Reading (Bottom Sheet)
```
BBT Reading (bottom sheet)
├── Temperature input (slider + manual)
├── Measurement time
├── Method selector
├── Sleep hours
├── Disturbances selector
└── [Save]
```

### 8.5 OPK Reading (Bottom Sheet)
```
OPK Reading (bottom sheet)
├── Date
├── Time of day
├── Result: Negative / Positive / Fading / Invalid
├── Line intensity (slider, if positive)
├── Photo attachment (optional)
├── Notes
└── [Save]
```

### 8.6 Intercourse Log (Bottom Sheet)
```
Intercourse Log (bottom sheet)
├── Date
├── Time of day
├── Protected / Unprotected
├── Notes (optional)
└── [Save]
```

### 8.7 Kick Counter (Full Screen)
```
Kick Counter (full screen from pregnancy dashboard)
├── [Start Counting] button (large)
├── Counter display
├── Timer display
├── [Baby Kicked] button (tap for each kick)
├── [Stop] button
├── History (last 3 sessions)
└── [Done]
```

### 8.8 Contraction Timer (Full Screen)
```
Contraction Timer (full screen from pregnancy dashboard)
├── [Start] / [Stop] for each contraction
├── Duration display
├── Interval display
├── Contraction list
└── [Save Session]
```

### 8.9 New Community Post (Modal)
```
New Post (full-screen modal)
├── Topic selector
├── Title input
├── Content input
├── Anonymous toggle
├── Guidelines reminder
├── [Post] button
└── [Cancel]
```

---

## 9. Hidden / Private Screens

### 9.1 Emergency Lock Safe Screens

These screens are displayed after an emergency lock trigger. They disguise the app.

```
Safe Screen: Weather
├── Current weather display (real API)
├── Hourly forecast
├── 7-day forecast
├── Weather maps (optional)
└── No Cyra content visible

Safe Screen: Calculator
├── Standard calculator UI
├── History of calculations
└── No Cyra content visible

Safe Screen: News Feed
├── RSS feed of generic headlines
├── Article previews
└── No Cyra content visible

Safe Screen: Blank + Clock
├── Large clock display
├── Date
└── No Cyra content visible
```

### 9.2 Post-Emergency Recovery
```
After biometric/PIN verification:
├── Restore Confirmation
│   ├── "Welcome back. Your data is safe."
│   ├── [Restore App] → Reloads from encrypted local store
│   └── [Continue in Safe Mode] → Stays in safe screen
└── Post-restore: full app state reloaded
```

---

## 10. Deep Linking Scheme

### 10.1 Deep Link Format
```
cyra://{feature}/{action}/{id}?{parameters}
```

### 10.2 Complete Deep Link Index

| Deep Link | Target | Notes |
|-----------|--------|-------|
| `cyra://home` | Dashboard | Tab 1 |
| `cyra://calendar` | Calendar | Tab 2, current month |
| `cyra://calendar/{y}/{m}` | Calendar | Specific month |
| `cyra://calendar/{y}/{m}/{d}` | Calendar | Specific day → Day detail |
| `cyra://calendar/fertility` | Calendar | Fertility sub-view |
| `cyra://calendar/cycle/{id}` | Calendar | Cycle detail |
| `cyra://insights` | Insights | Tab 3 |
| `cyra://insights/cycle/{id}` | Insights | Cycle analysis |
| `cyra://insights/correlations` | Insights | Symptom correlations |
| `cyra://education` | Education | Tab 4 |
| `cyra://education/category/{slug}` | Education | Filtered by category |
| `cyra://education/article/{slug}` | Education | Article detail |
| `cyra://education/search?q={text}` | Education | Search results |
| `cyra://community` | Community | Tab 5 |
| `cyra://community/topic/{topic}` | Community | Topic filtered |
| `cyra://community/post/{id}` | Community | Post detail |
| `cyra://community/new` | Community | New post modal |
| `cyra://settings` | Settings | Tab 6 |
| `cyra://settings/privacy` | Settings | Privacy controls |
| `cyra://settings/security` | Settings | Security |
| `cyra://settings/emergency-lock` | Settings | Emergency lock config |
| `cyra://settings/hidden-mode` | Settings | Hidden mode config |
| `cyra://settings/conditions` | Settings | Health conditions |
| `cyra://settings/wearables` | Settings | Device list |
| `cyra://settings/subscription` | Settings | Plan management |
| `cyra://settings/notifications` | Settings | Notification prefs |
| `cyra://settings/appearance` | Settings | Theme, text size |
| `cyra://daily-log` | Daily check-in | Full-screen modal |
| `cyra://period/new` | Log period start | Quick action |
| `cyra://symptoms` | Symptom selector | Modal |
| `cyra://journal/new` | New journal entry | Modal |
| `cyra://bbt/new` | New BBT reading | Bottom sheet |
| `cyra://opk/new` | New OPK reading | Bottom sheet |
| `cyra://pregnancy` | Pregnancy dashboard | |
| `cyra://pregnancy/kick-counter` | Kick counter | |
| `cyra://pregnancy/contractions` | Contraction timer | |
| `cyra://reports` | Health reports | |
| `cyra://reports/new` | Generate report | |
| `cyra://onboarding` | Onboarding flow | |
| `cyra://upgrade` | Subscription upgrade | |

---

## 11. Universal Link Scheme

For web-based deep linking:

```
https://cyra.health/app/...
```

Maps directly to `cyra://...` scheme.

---

## 12. Navigation Rules

### 12.1 Tab Persistence
- Tab state is preserved when switching tabs
- Scrolling position is saved per tab
- Tab bar is hidden during modal presentations

### 12.2 Modal Dismissal
- Daily check-in: Swipe down or tap Cancel
- Bottom sheets: Swipe down or tap backdrop
- Unsaved changes: Confirmation dialog "Discard changes?"

### 12.3 Back Navigation
- Push screens: Back button in app bar (←)
- iOS: Swipe back gesture
- Android: System back button
- Deep links: Push onto current navigation stack or replace

### 12.4 Authentication Gate
- If app lock is enabled, the auth gate intercepts all navigation
- After unlock, returns to the original destination
- Emergency lock triggers override all navigation

---

## 13. Information Architecture Principles

### 13.1 Task Completion Rate Targets

| Task | Target Path Length | Target Time |
|------|-------------------|-------------|
| Log today's period | 2 taps (FAB → Save) | <5 seconds |
| Log a symptom | 3 taps (FAB → Symptom → Severity) | <8 seconds |
| Check next period prediction | 1 tap (Dashboard card) | <2 seconds |
| Find a correlation | 3 taps (Insights → Correlations → View) | <10 seconds |
| Connect a wearable | 4 taps (Settings → Wearables → Connect → Allow) | <30 seconds |
| Generate a report | 4 taps (Settings → Reports → Generate → Configure) | <15 seconds |
| Find an article | 2 taps (Education → Search/Category) | <5 seconds |
| Emergency hide app | 1 action (Triple-press power) | <1 second |

### 13.2 Content Hierarchy
- **Level 1**: Tab bar items (always visible)
- **Level 2**: Screen sections (cards)
- **Level 3**: Detail views (push navigation)
- **Level 4**: Modals (focused tasks)
- **Level 5**: Bottom sheets (quick data entry)
