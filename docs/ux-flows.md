# UX Flows: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | UX Team | Initial release |

---

## 1. Onboarding → Period Tracking Setup

### Entry Point
- First app launch after splash screen
- Deep link: `cyra://onboarding`

### Screen Flow

```
Screen 1: Welcome
├── App logo, tagline: "Your body, understood."
├── [Get Started] button (prominent)
└── Privacy notice: "All data stays on your device. Always."
    └── [Learn More] → Privacy overview modal

Screen 2: Why Are You Here? (Multi-select)
├── "Help us personalize your experience"
├── Options:
│   ├── Track my cycle
│   ├── Trying to conceive
│   ├── Already pregnant
│   ├── Manage a health condition (PCOS, Endo, etc.)
│   ├── Just exploring
│   ├── Prefer not to say
├── [Continue] (enabled when ≥1 selected)
└── [Skip] → skips to basic tracking

Screen 3: Your Period (If "Track my cycle" selected)
├── "When was your last period?"
├── Date picker (month/day/year, scrollable)
├── [Not sure / I don't remember] link
│   └── → Approximate: "Was it in the last week/month/2 months/longer?"
├── "How long does your period usually last?"
├── Slider: 3-10 days (default: 5)
├── "How long is your typical cycle?"
├── Slider: 21-45 days (default: 28)
└── [Continue]

Screen 4: Health Conditions (if "Manage a condition" selected)
├── "Select any conditions you're managing"
├── Grid: PCOS, Endometriosis, PMDD, Adenomyosis, Fibroids, Thyroid
├── Each: Icon + name + info button (i) → brief description sheet
├── "Not sure? You can set this up later."
└── [Continue]

Screen 5: Privacy Setup
├── "Your privacy, your way"
├── App Lock toggle (biometric + PIN)
├──   → Configure PIN (6 digits, confirm)
├── Hidden Mode toggle
├──   → Choose icon disguise: Weather / Calculator / News / Clock
├── Emergency Lock toggle
├──   → Preview: "Triple-press power button to hide instantly"
└── [Continue]

Screen 6: Notifications
├── "We'll remind you to log, never to stress"
├── Daily check-in reminder (time picker)
├── Period prediction alert (days before: 1, 2, 3)
├── Fertile window notification (if tracking fertility)
├── Premium upsell soft: "Upgrade for AI insights"
└── [Start Your Journey] → Home Screen

### Empty State
- No cycles logged yet: Friendly illustration of calendar with one dot
- Text: "Your first cycle starts today. Log your period to begin tracking."
- CTA: [Log My Period] → Daily Log screen

### Loading State
- Splash with app logo (500ms)
- Onboarding transitions: page curl animation (300ms)
- No data loading needed (local-first)

### Error State
- Any onboarding step fails: "Something went wrong" with [Retry]
- Biometric setup fails: Fallback to PIN only, "Biometric wasn't available. You can set it up later in Settings."

### Success State
- Onboarding complete → Confetti animation (subtle)
- "You're all set! Here's your dashboard." → Dashboard

---

## 2. Daily Check-In (Log Symptoms, Flow, Temperature)

### Entry Point
- Dashboard "Check In" card (if not logged today)
- Notification tap
- Tab bar: + button (center, prominent)
- Deep link: `cyra://daily-log`

### Main Screen Layout
```
┌─────────────────────────────┐
│ Today, June 16     [Close]  │
│ Cycle Day 14 • Follicular   │
├─────────────────────────────┤
│ 🔴 Period Flow              │
│ None  ● ○ ○ ○              │
│ Spotting  ○ ● ○ ○          │
│ Light  ○ ○ ● ○             │
│ Medium  ○ ○ ○ ●            │
│ Heavy  ○ ○ ○ ○ ●           │
├─────────────────────────────┤
│ 😊 How are you feeling?     │
│ [😢] [😐] [😊] [😄] [🤩]   │
├─────────────────────────────┤
│ Symptoms                    │
│ [Search symptoms...]        │
│ ┌───────────────────────┐   │
│ │ Headache    Severity  │   │
│ │ ○ ○ ○ ● ○             │   │
│ │ Bloating    Severity  │   │
│ │ ○ ● ○ ○ ○             │   │
│ │ Cramps      Severity  │   │
│ │ ○ ○ ● ○ ○             │   │
│ │ + Add Symptom         │   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ 🌡️ Temperature (Optional)   │
│ [─── 36.5°C ───]           │
│ Measured at: [06:30]       │
│ Method: [Oral ▼]           │
├─────────────────────────────┤
│ 💤 Sleep                    │
│ [─── 7.5 hrs ───]          │
├─────────────────────────────┤
│ 🤸‍♀️ Exercise                │
│ [─── 0 min ───]            │
├─────────────────────────────┤
│ 📝 Notes                    │
│ [What's on your mind?...]   │
├─────────────────────────────┤
│ [Save Entry]                │
└─────────────────────────────┘
```

### Key Interactions
- Flow intensity: Tap pill button (toggle state)
- Mood: Tap emoji, single selection
- Symptoms: Search bar filters grid, tap to add, severity slider per symptom
- Temperature: Drag slider or tap decimal to type
- All fields optional

### Empty State
- N/A (daily check-in shows today always)

### Loading State
- Shimmer placeholder for symptom grid (if loading from DB)
- Quick load (<100ms from local DB)

### Error State
- Save fails: "Couldn't save. [Retry]" banner at top
- Symptom search fails: "No symptoms found" with suggestion to create custom

### Success State
- Saved! Toast: "Logged for today ✅"
- Auto-navigate back to Dashboard or Calendar

---

## 3. Cycle Calendar View → Day Detail

### Entry Point
- Tab bar: Calendar (second tab)
- Deep link: `cyra://calendar`

### Main Screen Layout
```
┌─────────────────────────────┐
│ < June 2026           [Today]│
│ Mon Tue Wed Thu Fri Sat Sun │
│ 01  02  03  04  05  06  07  │
│ 08  09  10  11  12  13  14  │
│ 15  16  17  18  19  20  21  │
│ 22  23  24  25  26  27  28  │
│ 29  30                      │
├─────────────────────────────┤
│ Cycle Day 14                │
│ Predicted period: Jun 28    │
│ 🩸 Period (Jun 1-5)         │
│ 🌸 Fertile (Jun 12-17)      │
│ 🌰 Ovulation (Jun 15)       │
│ 📝 Journal entry exists     │
├─────────────────────────────┤
│ [Today's Log] [Add Entry]   │
└─────────────────────────────┘
```

### Day Detail (tap a day)
```
┌─────────────────────────────┐
│ < June 16, 2026    [Edit]   │
│ Cycle Day 14 • Follicular   │
├─────────────────────────────┤
│ Flow: None                  │
│ Mood: 😊 Good               │
├─────────────────────────────┤
│ Symptoms                    │
│ ┌─────────────────────┐     │
│ │ Headache   Severity │     │
│ │ ●●○○○               │     │
│ └─────────────────────┘     │
├─────────────────────────────┤
│ 🌡️ 36.5°C (oral, 06:30)    │
│ 💤 7.5 hrs                  │
├─────────────────────────────┤
│ 💬 Journal entry...         │
│ [Read More]                 │
├─────────────────────────────┤
│ [Edit] [Delete Day]         │
└─────────────────────────────┘
```

### Key Interactions
- Swipe month left/right
- Tap day → Day Detail sheet (bottom sheet)
- Tap "Today" → scroll to current date
- Phase coloring: Red (period), Light pink (follicular), Green (fertile), Yellow (ovulation), Purple (luteal)
- Day dots: Red dot (period logged), Green dot (data logged), Blue dot (fertility data)
- Long press day → Quick log context menu

### Empty State
- No cycles: "Tap + to start tracking your cycle"
- No data for selected day: "Nothing logged for this day" with [Log Now]

### Loading State
- Calendar renders immediately (local data)
- Year selection: month grid loads instantly

### Error State
- N/A (local data, always available offline)

### Success State
- Day detail sheet shows all logged data clearly
- Edit navigates to Daily Log pre-filled with that day's data

---

## 4. Fertility Window View → BBT Chart → OPK Logging

### Entry Point
- Dashboard "Fertility" card (if tracking fertility)
- Tab: Calendar → Fertility tab inside calendar
- Deep link: `cyra://fertility`

### Main Screen Layout
```
┌─────────────────────────────┐
│ Fertility Window            │
│ Cycle 4 of 2026             │
├─────────────────────────────┤
│ Fertility This Cycle        │
│ ┌───────────────────────┐   │
│ │ Jun 12 13 14 15 16 17 │   │
│ │       Fertile    Peak   │   │
│ │ Low  Med  High Peak Low │   │
│ │ 🌸   🌸   🌸   🌰   📉  │   │
│ └───────────────────────┘   │
│ 📊 Ovulation Probability    │
│ [Bar chart: 60% 75% 90%    │
│  95% 80% 40%]              │
├─────────────────────────────┤
│ [BBT Chart ▸]              │
│ [OPK Logging ▸]             │
│ [Cervical Mucus ▸]         │
├─────────────────────────────┤
│ 💡 Today: High fertility   │
│ Your mucus is egg-white    │
│ and temperature is rising. │
│ This is your fertile       │
│ window.                    │
└─────────────────────────────┘
```

### BBT Chart Screen
```
┌─────────────────────────────┐
│ < BBT Chart     Cycle 4    │
├─────────────────────────────┤
│ 37.0°C ┤                 ● │
│        ┤              ●    │
│ 36.5°C ┤───●────●───────── │ ← Cover line
│        ┤  ●   ●           │
│ 36.0°C ┤ ●                 │
│        ┤                   │
│        └───┬──┬──┬──┬──┬── │
│          5  10 15 20 25 30 │
│          Cycle Day          │
├─────────────────────────────┤
│ 📊 Statistics               │
│ Cover line: 36.4°C          │
│ Ovulation confirmed: Day 15 │
│ Post-O average: 36.8°C      │
│ High readings: 6 of 6       │
├─────────────────────────────┤
│ [Add Reading]               │
│ [Explain This Chart]        │
└─────────────────────────────┘
```

### OPK Logging Screen
```
┌─────────────────────────────┐
│ < OPK Results    Cycle 4   │
├─────────────────────────────┤
│ [New Reading]               │
├─────────────────────────────┤
│ Jun 12   Negative  ◻️ 08:00│
│ Jun 13   Negative  ◻️ 08:15│
│ Jun 14   Positive  🔵 10:00│
│ Jun 15   Peak      🔵 14:00│
│ Jun 16   Fading    ◻️ 12:00│
├─────────────────────────────┤
│ Pattern detected:           │
│ LH surge on Jun 14-15       │
│ Ovulation likely Jun 15-16  │
└─────────────────────────────┘
```

### Key Interactions
- Fertility window: Horizontal scrollable date strip
- BBT chart: Pinch to zoom, tap point for reading details
- OPK: Tap row to edit result
- Intercourse logging: Tap "💕" icon on any day

### Empty State
- No BBT data: "Start tracking your temperature to see your chart"
- No OPK data: "Log your first OPK result"
- Insufficient data: "We need 2 more cycles for fertility predictions"

### Loading State
- Chart shimmer loading
- Spinner when toggling between chart types

### Error State
- BBT data inconsistent: "Some temperatures seem unusual. Check your readings."
- OPK photo upload: "Could not save photo"

### Success State
- Ovulation confirmed: "🎉 Ovulation detected! Based on BBT shift + LH surge"
- Fertile window identified with probability scores

---

## 5. Pregnancy Dashboard → Week-by-Week → Kick Counter

### Entry Point
- Dashboard "Pregnancy" card (when pregnancy active)
- Tab: Calendar → Pregnancy mode (calendar shows pregnancy weeks)
- Deep link: `cyra://pregnancy`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 👶 Your Pregnancy           │
│ Week 24 • Trimester 2       │
├─────────────────────────────┤
│ [≡] Pregnancy Dashboard     │
├─────────────────────────────┤
│ 📅 Due: September 7, 2026   │
│    (132 days to go)         │
├─────────────────────────────┤
│ Your Baby This Week         │
│ ┌───────────────────────┐   │
│ │ [Fetal size graphic]  │   │
│ │ Size: A head of        │   │
│ │       cauliflower      │   │
│ │ Length: 30cm (12 in)   │   │
│ │ Weight: 600g (1.3 lb)  │   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ Quick Actions               │
│ [🦶 Kick Counter]           │
│ [🩺 Log Vitals]             │
│ [📊 Generate Report]        │
│ [📅 Appointments]           │
├─────────────────────────────┤
│ Week-by-Week                │
│ [1-12] [13-24] [25-40]     │
│ ───────●──────────────────  │
│ Last: Week 23 symptoms      │
│ Next: Week 25 milestones    │
└─────────────────────────────┘
```

### Kick Counter Screen
```
┌─────────────────────────────┐
│ < Kick Counter              │
├─────────────────────────────┤
│ 🦶 Kick Counter             │
│                             │
│      [ Start ]              │
│   or [ 10 kicks ]           │
│                             │
│   Timer: 00:00              │
├─────────────────────────────┤
│ Last session:               │
│ 10 kicks in 18 minutes      │
│ Yesterday: 22 min           │
│ 3-day avg: 20 min           │
├─────────────────────────────┤
│ 💡 Normal: 10 kicks in     │
│ under 2 hours. Most babies │
│ have a sleep-wake cycle.   │
│ [Learn More]               │
└─────────────────────────────┘
```

### Key Interactions
- Week progress: Horizontal slider or tap on timeline
- Kick counter: Tap button for each kick, auto-timer
- Vitals: BP, weight, glucose entry forms
- Appointments: Add to calendar, set reminder

### Empty State
- No pregnancy: "Expecting? Start tracking your pregnancy journey"
- No kick counts: "Start counting kicks. Your baby's movements are a sign of wellbeing."

### Loading State
- Week info loads from local DB
- Size comparison image loads from local assets

### Error State
- Due date calculation: "Could not calculate due date. Please check your LMP date."

### Success State
- Kick count complete: "✅ 10 kicks in 18 minutes. Normal range."
- Weekly milestone displayed with relevant info

---

## 6. Symptom Selector → Log Severity → View Correlations

### Entry Point
- Daily Log → "Symptoms" section → "Add Symptom"
- Dashboard → "Symptoms" card
- Deep link: `cyra://symptoms`

### Main Screen Layout
```
┌─────────────────────────────┐
│ Select Symptoms             │
│ [Search all symptoms...]   │
├─────────────────────────────┤
│ Physical                    │
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐   │
│ │ 🤕 │ │ 🤢 │ │ 🤰 │ │ 🦶 │   │
│ │Hdache│Nausea│Bloating│Cramps│
│ └───┘ └───┘ └───┘ └───┘   │
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐   │
│ │ 🤱 │ │ 😴 │ │ 💪 │ │ 🍽️ │   │
│ │Tendrns│Fatigue│Body Ach│Naus │
│ └───┘ └───┘ └───┘ └───┘   │
├─────────────────────────────┤
│ Emotional                   │
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐   │
│ │ 😢 │ │ 😠 │ │ 😰 │ │ 😶 │   │
│ │ Sad │ │Iritable│Anxiety│Numb │
│ └───┘ └───┘ └───┘ └───┘   │
├─────────────────────────────┤
│ Lifestyle                   │
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐   │
│ │ 🏃 │ │ 🍷 │ │ ☕ │ │ 💊 │   │
│ │Exercis│Alcohol│Caffeine│Med  │
│ └───┘ └───┘ └───┘ └───┘   │
└─────────────────────────────┘
```

### Severity Dialog (tap symptom)
```
┌─────────────────────────────┐
│ Headache                    │
├─────────────────────────────┤
│ How severe?                 │
│                             │
│ [1] [2] [3] [4] [5]        │
│ Mild                  Severe│
│                             │
│ Time: [Morning ▼]          │
│ Duration: [120 min ▼]      │
│                             │
│ Notes (optional)            │
│ [________________]          │
│                             │
│ [Save] [Delete]             │
└─────────────────────────────┘
```

### Correlations Screen (from Dashboard)
```
┌─────────────────────────────┐
│ < Symptom Correlations      │
├─────────────────────────────┤
│ Your Top Correlations       │
│                             │
│ Bloating → 2 days before   │
│ period start                │
│ ────────●────────────────  │
│ Strength: Strong (r=0.72)  │
│ Based on: 12 cycles        │
│ [Show Details]              │
│                             │
│ Headache → Follicular phase │
│ ──────●──────────────────  │
│ Strength: Moderate (r=0.54)│
│ Based on: 8 cycles         │
│ [Show Details]              │
├─────────────────────────────┤
│ [View All Correlations]     │
│ [What does this mean?]     │
└─────────────────────────────┘
```

### Key Interactions
- Symptom grid: Scrollable, categorized
- Search: Real-time filter as user types
- Tap symptom → Bottom sheet with severity selector
- Custom symptom: "Can't find it?" → Create custom

### Empty State
- No symptoms logged yet: "Start logging symptoms to discover patterns"
- No correlations yet: "Log 3+ cycles to unlock correlations"

### Loading State
- Skeleton grid while symptoms load
- Spinner for correlation computation

### Error State
- Symptom creation fails: "Could not create custom symptom"
- Correlation calculation fails: "Not enough data for analysis"

### Success State
- Symptom logged: Toast "Bloating added ✓"
- Correlation found: Animated card reveal "New pattern detected!"

---

## 7. AI Insights → Cycle Explanation → Confidence Breakdown

### Entry Point
- Dashboard "Insights" card
- Tab: Insights (third tab)
- Deep link: `cyra://insights`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 🔮 AI Insights              │
├─────────────────────────────┤
│ Your Cycle Summary          │
│ Cycle 4 • May 15 - Jun 11   │
│                             │
│ Next period predicted:      │
│ July 9 ± 2 days             │
│                             │
│ Why this prediction?        │
│ ┌───────────────────────┐   │
│ │ Your last 4 cycles:   │   │
│ │ 28, 29, 27, 28 days   │   │
│ │ Average: 28 days      │   │
│ │ Variability: ±0.8 days│   │
│ │ → Very regular cycles │   │
│ │                       │   │
│ │ BBT: Ovulation        │   │
│ │ confirmed on Day 15   │   │
│ │ Luteal phase: 13 days │   │
│ │ → Normal luteal phase │   │
│ └───────────────────────┘   │
│                             │
│ Confidence: 92%             │
│ [████████░░]                │
│                             │
│ [View Full Analysis ▸]     │
├─────────────────────────────┤
│ Patterns Detected           │
│ ┌─────────────────────┐     │
│ │ 📈 Headache peaks   │     │
│ │   in luteal phase   │     │
│ │   (9 of 11 cycles)  │     │
│ └─────────────────────┘     │
├─────────────────────────────┤
│ 💡 Did you know?            │
│ Your cycle is 28 days,      │
│ the most common length.     │
│ [Read About Cycle Lengths]  │
└─────────────────────────────┘
```

### Key Interactions
- Tap "Why?" on any prediction → Expand explanation section
- Confidence bar: Tap for breakdown
- Patterns: Tap for detailed statistics
- Insights: Swipe carousel through different insight cards

### Empty State
- No cycles yet: "Start tracking your cycle to get personalized AI insights"
- <3 cycles: "Track 3+ cycles for pattern analysis"

### Loading State
- Skeleton cards with shimmer
- Loading spinner for AI computation

### Error State
- AI computation failed: "Couldn't analyze this cycle. [Retry]"
- Insufficient data: "More data needed for pattern detection"

### Success State
- Insight card with explanation, confidence, and data quality indicator
- "New insight available" badge on Insights tab

---

## 8. Journal → New Entry → Attach Photo/Voice

### Entry Point
- Tab: Calendar → Day detail → "Journal" tab
- Dashboard "Journal" card
- Deep link: `cyra://journal`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 📝 Journal                  │
│ June 16, 2026               │
│ Cycle Day 14                │
├─────────────────────────────┤
│ [New Entry]                 │
├─────────────────────────────┤
│ Recent Entries              │
│ ┌───────────────────────┐   │
│ │ Jun 14                │   │
│ │ 😊 Great day          │   │
│ │ Had a productive...   │   │
│ │                       │   │
│ │ 🏷️ work, exercise    │   │
│ └───────────────────────┘   │
│ ┌───────────────────────┐   │
│ │ Jun 12                │   │
│ │ 😴 Tired              │   │
│ │ Felt really drained   │   │
│ │ [🎤 Voice note]       │   │
│ │ 🏷️ health, sleep     │   │
│ └───────────────────────┘   │
│ ┌───────────────────────┐   │
│ │ Jun 10                │   │
│ │ 📷 [Photo thumbnail]  │   │
│ │ Walk in the park      │   │
│ └───────────────────────┘   │
└─────────────────────────────┘
```

### New Entry Screen
```
┌─────────────────────────────┐
│ < New Journal Entry  [Save] │
├─────────────────────────────┤
│ Date: June 16, 2026         │
│ [Change Date ▸]            │
├─────────────────────────────┤
│ Title (optional)            │
│ [________________________]  │
├─────────────────────────────┤
│ How are you feeling?        │
│ [😢] [😐] [😊] [😄] [🤩]   │
├─────────────────────────────┤
│ Content                     │
│ [What's on your mind?...   │
│                           │
│                           │
│                           │
│                           │
│                           │]
├─────────────────────────────┤
│ Attachments                 │
│ [📷 Photo] [🎤 Voice Note] │
│ ┌───────────────────────┐   │
│ │ Thumbnails of photos   │   │
│ │ or voice note indicator│   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ Tags: [Add tags...]         │
│ [work] [health] [×]         │
├─────────────────────────────┤
│                            │
│ [                          │
└─────────────────────────────┘
```

### Key Interactions
- New entry: Rich text editor with formatting toolbar
- Photo: Camera/gallery picker, multi-select, drag to reorder
- Voice note: Tap record, waveform visualization, pause/resume
- Tags: Autocomplete from existing tags, create new

### Empty State
- No entries: "Start journaling. Your thoughts, your cycle, your story."
- Illustration: Open journal with pen

### Loading State
- Entries list: Fade in from bottom
- Photo loading: Progressive JPEG / thumbnail first

### Error State
- Save fails: "Could not save journal entry. [Retry]"
- Photo too large: "Photo exceeds size limit. Choose a smaller photo."
- Voice note fails: "Could not save recording"

### Success State
- Entry saved: "Entry saved ✓" with animation
- Photo attached: Thumbnail appears
- Voice note recorded: Waveform + duration shown

---

## 9. Health Reports → Generate → Export PDF

### Entry Point
- Settings → "Health Reports"
- Dashboard "Reports" card
- Deep link: `cyra://reports`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 📊 Health Reports           │
├─────────────────────────────┤
│ [Generate New Report ▸]    │
├─────────────────────────────┤
│ Past Reports                │
│ ┌───────────────────────┐   │
│ │ Cycle History Report   │   │
│ │ Jan 2026 - Jun 2026   │   │
│ │ Generated Jun 15      │   │
│ │ [View] [Share] [Delete]│   │
│ └───────────────────────┘   │
│ ┌───────────────────────┐   │
│ │ Fertility Report      │   │
│ │ Mar 2026 - Jun 2026   │   │
│ │ Generated Jun 10      │   │
│ │ [View] [Share] [Delete]│   │
│ └───────────────────────┘   │
└─────────────────────────────┘
```

### Generate Report Screen
```
┌─────────────────────────────┐
│ < Generate Report           │
├─────────────────────────────┤
│ Report Type                 │
│ ● Cycle History             │
│ ○ Symptom Summary           │
│ ○ Fertility Analysis        │
│ ○ Pregnancy Progress        │
│ ○ Full Health Report        │
├─────────────────────────────┤
│ Date Range                  │
│ From: [Jan 1, 2026 ▸]     │
│ To:   [Jun 16, 2026 ▸]    │
├─────────────────────────────┤
│ Include                     │
│ ☑ Cycle statistics          │
│ ☑ Symptoms & correlations   │
│ ☐ BBT charts                │
│ ☑ Journal notes             │
│ ☐ Photos                    │
│ ☑ Summary & insights        │
├─────────────────────────────┤
│ [Generate PDF]              │
│ [Preview Report]            │
└─────────────────────────────┘
```

### Key Interactions
- Report type: Radio button selection
- Date range: Tap to open calendar picker
- Include toggles: Checkbox per section
- Generate: Shows progress bar, then opens report
- Preview: In-app PDF viewer
- Share: System share sheet (with privacy warning)

### Empty State
- No reports: "Generate your first health report to share with your doctor"
- No data for range: "No data in selected date range. Choose a different range."

### Loading State
- Generating: Progress bar with "Gathering data... Creating charts... Building PDF..."
- Generation time: 5-15 seconds typical

### Error State
- Insufficient data: "Need at least 1 cycle of data to generate report"
- Generation failed: "Report generation failed. [Retry]"
- Export failed: "Could not save PDF to device"

### Success State
- Report ready: "✅ Report ready!" with confetti
- PDF viewer opens automatically
- Share button prominent

---

## 10. Education Hub → Browse → Read Offline

### Entry Point
- Tab: Education (fourth tab)
- Dashboard "Learn" card
- Deep link: `cyra://education`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 📚 Education Hub            │
├─────────────────────────────┤
│ [Search articles...]        │
├─────────────────────────────┤
│ Featured                    │
│ ┌───────────────────────┐   │
│ │ Understanding Your    │   │
│ │ Menstrual Cycle       │   │
│ │ ★ 4.8 • 5 min read   │   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ Categories                  │
│ [Cycle Basics] [Fertility]  │
│ [Pregnancy] [Conditions]   │
│ [Nutrition] [Exercise]     │
│ [Mental Health] [General]  │
├─────────────────────────────┤
│ Recommended For You         │
│ (Based on your conditions)  │
│ ┌───────────────────────┐   │
│ │ PCOS & Cycle          │   │
│ │ Irregularity          │   │
│ │ ★ 4.7 • 8 min read    │   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ Continue Reading            │
│ ┌───────────────────────┐   │
│ │ Fertility 101:        │   │
│ │ Understanding Ovulation│   │
│ │ 60% complete ██████░░░│   │
│ └───────────────────────┘   │
└─────────────────────────────┘
```

### Article Screen
```
┌─────────────────────────────┐
│ < Back        [🔖] [⬇️] [🔊]│
├─────────────────────────────┤
│ Understanding Your          │
│ Menstrual Cycle             │
│                             │
│ Reviewed: Mar 2026          │
│ By: Dr. Sarah Chen, OB-GYN │
│ 8 min read                  │
├─────────────────────────────┤
│ [Article content in         │
│  scrollable Markdown        │
│  with inline images         │
│  and diagrams]              │
│                             │
│ ...                         │
├─────────────────────────────┤
│ Sources                     │
│ [1] ACOG, "Menstrual Cycle" │
│ [2] WHO, "Reproductive     │
│      Health"                │
├─────────────────────────────┤
│ [Mark as Read] [Share]      │
└─────────────────────────────┘
```

### Key Interactions
- Search: Real-time full-text search
- Category: Horizontal scroll tabs
- Article tap → Full article with scrollable content
- Bookmark: Tap bookmark icon
- Download: Tap download for offline reading
- Read Aloud: Text-to-speech playback

### Empty State
- No articles loaded: "Connect to download articles" (initial load)
- No search results: "No articles found. Try a different search."

### Loading State
- Article list: Skeleton cards
- Article content: Progressive content reveal

### Error State
- Download fails: "Could not download article for offline reading"
- Search fails: "Search temporarily unavailable"

### Success State
- Article displays with proper formatting and images
- Download complete: "Saved for offline reading ✓"
- Read Aloud active: Highlighted text following narration

---

## 11. Community → Anonymous Post → Topic Groups

### Entry Point
- Tab: Community (fifth tab)
- Deep link: `cyra://community` or `cyra://community/topic/{topicId}`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 💬 Community                │
├─────────────────────────────┤
│ Topics                      │
│ [General] [TTC] [Pregnancy] │
│ [PCOS] [Endometriosis]     │
│ [PMDD] [Teens] [New Moms]  │
├─────────────────────────────┤
│ 🔥 Trending                 │
│ ┌───────────────────────┐   │
│ │ Anyone tried          │   │
│ │ acupuncture for       │   │
│ │ fertility?            │   │
│ │ 🗨️ 24 replies • 👍 45  │   │
│ └───────────────────────┘   │
│ ┌───────────────────────┐   │
│ │ PCOS-friendly meal    │   │
│ │ ideas 💡              │   │
│ │ 🗨️ 18 replies • 👍 32  │   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ [+ New Post]                │
└─────────────────────────────┘
```

### New Post Screen
```
┌─────────────────────────────┐
│ < New Post       [Post]    │
├─────────────────────────────┤
│ Topic: [TTC ▼]            │
├─────────────────────────────┤
│ Title                      │
│ [________________________] │
├─────────────────────────────┤
│ Content                    │
│ [                        │
│  Share your thoughts...   │
│                         ] │
├─────────────────────────────┤
│ 📎 Anonymous Post          │
│ [✓] Show my name as        │
│     "Anonymous User"       │
├─────────────────────────────┤
│ 📋 Community Guidelines     │
│ • Be respectful            │
│ • No medical advice        │
│ • No harassment            │
│ [Read Full Guidelines ▸]  │
└─────────────────────────────┘
```

### Key Interactions
- Topic tabs: Horizontal scroll, swipeable
- Post: Tap to expand, upvote, reply
- New Post: Form with title, content, topic, anonymous toggle
- Report: Long press → "Report Post"

### Empty State
- No posts in topic: "Be the first to start a conversation in this topic"
- User's posts: "You haven't posted yet. Share your experience."

### Loading State
- Posts list: Shimmer cards
- New post submission: Spinner on Post button

### Error State
- Post submission fails: "Could not post. [Retry]"
- Network required: "Community requires internet connection"
- Content rejected: "Your post contains words that violate our guidelines. Please edit."

### Success State
- Post published: "Posted ✓" with animation
- Reply posted: "Reply added ✓"

---

## 12. Settings → Privacy Controls → Emergency Lock

### Entry Point
- Tab: Settings (far right tab)
- Deep link: `cyra://settings`

### Main Screen Layout
```
┌─────────────────────────────┐
│ ⚙️ Settings                 │
├─────────────────────────────┤
│ Account                     │
│ [Profile] [Subscription]    │
├─────────────────────────────┤
│ Privacy & Security          │
│ [Privacy Controls ▸]       │
│ [App Lock ▸]               │
│ [Emergency Lock ▸]         │
│ [Hidden Mode ▸]            │
├─────────────────────────────┤
│ Notifications               │
│ [Daily Reminder]            │
│ [Prediction Alerts]         │
│ [Community Notifications]   │
├─────────────────────────────┤
│ Appearance                  │
│ [Theme: System ▼]          │
│ [Text Size: Medium ▼]      │
├─────────────────────────────┤
│ Data                        │
│ [Export All Data ▸]        │
│ [Delete All Data ▸]        │
│ [Sync Status ▸]            │
├─────────────────────────────┤
│ About                       │
│ [Version 1.0.0]             │
│ [Terms of Service]          │
│ [Privacy Policy]            │
│ [Open Source Licenses]      │
└─────────────────────────────┘
```

### Privacy Controls Screen
```
┌─────────────────────────────┐
│ < Privacy Controls          │
├─────────────────────────────┤
│ Data Storage                │
│ All data stored on device   │
│ [🗂️ View Data Inventory]    │
├─────────────────────────────┤
│ Cloud Sync                  │
│ [● Off] [○ Encrypted Sync] │
│ When enabled, data is      │
│ encrypted before leaving   │
│ your device.               │
│ [Learn About E2EE ▸]      │
├─────────────────────────────┤
│ Analytics                   │
│ [✓] Share anonymous usage   │
│     data (no health info)   │
├─────────────────────────────┤
│ Data Management             │
│ [📥 Export All Data]        │
│ [🗑️ Delete All Data]       │
└─────────────────────────────┘
```

### Emergency Lock Settings
```
┌─────────────────────────────┐
│ < Emergency Lock            │
├─────────────────────────────┤
│ 🚨 Emergency Lock ON        │
│ [Toggle: ON]                │
├─────────────────────────────┤
│ Trigger Method              │
│ ☑ Triple-press power       │
│ ☑ Shake device             │
│ ☑ On-screen panic button   │
├─────────────────────────────┤
│ Safe Screen                 │
│ [Weather ▼]                │
│ • Weather (real data)      │
│ • Calculator                │
│ • News Feed                 │
│ • Blank + Clock             │
│ • Custom...                 │
├─────────────────────────────┤
│ [Test Emergency Lock]       │
│ [What happens when I        │
│  trigger it? ▸]            │
└─────────────────────────────┘
```

### Key Interactions
- Toggle switches for all settings
- Navigation to detail screens via chevron (▸)
- Danger actions (Delete) with confirmation dialog
- Password/biometric re-auth for sensitive changes

### Empty State
- N/A (Settings always has content)

### Loading State
- Settings load immediately (local prefs)
- Export: Progress bar

### Error State
- Export fails: "Could not export data. [Retry]"
- Delete fails: "Could not delete data. [Retry]"

### Success State
- Export: Share sheet with JSON/CSV file
- Delete: "All data deleted" with confirmation
- Settings change: Immediate, no confirmation needed for minor changes

---

## 13. Wearable Connection → Device List → Sync Data

### Entry Point
- Settings → "Wearables"
- Dashboard "Wearables" card
- Deep link: `cyra://wearables`

### Main Screen Layout
```
┌─────────────────────────────┐
│ ⌚️ Connected Devices        │
├─────────────────────────────┤
│ Connected                   │
│ ┌───────────────────────┐   │
│ │ ⌚️ Oura Ring          │   │
│ │ Synced: 2 min ago     │   │
│ │ Heart rate, HRV,      │   │
│ │ sleep, skin temp      │   │
│ │ [Sync Now] [Disconnect]│   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ Available                   │
│ ┌───────────────────────┐   │
│ │ 🍎 Apple Watch        │   │
│ │ [Connect]              │   │
│ └───────────────────────┘   │
│ ┌───────────────────────┐   │
│ │ 🔵 Fitbit             │   │
│ │ [Connect]              │   │
│ └───────────────────────┘   │
│ ┌───────────────────────┐   │
│ │ 🟢 Garmin             │   │
│ │ [Connect]              │   │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ Data Sources                │
│ [?] Heart Rate: Oura       │
│ [?] Temperature: Oura      │
│ [?] Steps: None            │
├─────────────────────────────┤
│ 💡 Connecting wearables     │
│ helps Cyra correlate your  │
│ physiological data with    │
│ your cycle phases.         │
│ [Learn more]               │
└─────────────────────────────┘
```

### Connection Flow (iOS HealthKit example)
```
1. Tap "Connect" on Apple Watch
2. System health permissions sheet:
   "Cyra" would like to access:
   ☑ Heart Rate
   ☑ Resting Heart Rate
   ☑ Heart Rate Variability
   ☑ Sleep Analysis
   ☑ Steps
   ☑ Walking Heart Rate Average
   ☐ Blood Pressure (if available)
   ☐ Blood Glucose (if available)
   [Allow All] [Select...]
3. Permissions granted → "Connected ✓"
4. First sync: "Fetching your data..."
5. Data appears in Cycle Insights
```

### Key Interactions
- Connect: Launches platform health permission flow
- Sync Now: Manual sync trigger
- Disconnect: Removes device, confirmation dialog
- Data source priority: Drag to reorder

### Empty State
- No devices: "Connect a wearable to enrich your cycle insights with health data"

### Loading State
- Connecting: Spinner with "Connecting to [device]..."
- Syncing: "Syncing your data..." with progress
- First sync can take 30-60 seconds

### Error State
- Connection fails: "Could not connect to [device]. Make sure it's paired."
- Sync fails: "Sync failed. [Retry]" or "Device not reachable"
- Permissions denied: "Health permissions required. [Open Settings]"

### Success State
- Connected: "✅ [Device] connected!" with checkmark animation
- Synced: "Data synced ✓" with timestamp
- New data available: Badge on Wearables tab

---

## 14. Condition Mode Setup → Specialized Tracking

### Entry Point
- Settings → "Health Conditions"
- Onboarding (if selected)
- Deep link: `cyra://conditions`

### Main Screen Layout
```
┌─────────────────────────────┐
│ 🏥 Health Conditions        │
├─────────────────────────────┤
│ Your Conditions             │
│ ┌───────────────────────┐   │
│ │ PCOS                  │   │
│ │ Diagnosed: Mar 2022   │   │
│ │ [Active] [Edit] [Remove]│ │
│ └───────────────────────┘   │
├─────────────────────────────┤
│ [Add Condition ▸]          │
├─────────────────────────────┤
│ Active Condition Insights   │
│ ┌───────────────────────┐   │
│ │ PCOS Insights         │   │
│ │ • Average cycle: 42d  │   │
│ │ • Longest cycle: 58d  │   │
│ │ • Common symptoms:    │   │
│ │   Acne, fatigue,      │   │
│ │   irregular bleeding  │   │
│ │ [View Full Report]    │   │
│ └───────────────────────┘   │
└─────────────────────────────┘
```

### PCOS Setup Flow (example)
```
Screen 1: Condition Selected
├── "Let's customize your PCOS tracking"
├── Common symptoms to track:
│   ☑ Irregular cycles
│   ☑ Acne
│   ☑ Excess hair growth
│   ☑ Weight changes
│   ☑ Fatigue
│   ☑ Mood changes
│   ☐ Custom...
├── [Continue]

Screen 2: Cycle Patterns
├── "How would you describe your cycles?"
├── ○ Regular (21-35 days)
├── ● Irregular (>35 days or unpredictable)
├── ○ Very infrequent (3-6+ months)
├── ○ I haven't had a period in a while
├── [Continue]

Screen 3: Medication & Treatment
├── "Are you currently managing PCOS?"
├── Medications:
│   [✓] Metformin
│   [ ] Birth control
│   [ ] Spironolactone
│   [ ] Other...
├── Lifestyle:
│   [✓] Diet changes
│   [ ] Exercise routine
│   [ ] Supplements
├── [Continue]

Screen 4: Insights Preferences
├── "What would you like to track?"
├── ☑ Cycle irregularity patterns
├── ☑ Symptom triggers
├── ☑ Treatment effectiveness
├── ☑ Weight correlation
├── ☑ Fertility (if trying)
├── [Done]
```

### Condition Dashboard (PCOS example)
```
┌─────────────────────────────┐
│ 🏥 PCOS Dashboard           │
├─────────────────────────────┤
│ Current Cycle: Day 38       │
│ [████░░░░░░░░░░░░░░░░]      │
│ Predicted: Day 42 ± 8      │
├─────────────────────────────┤
│ This Cycle Symptoms         │
│ Acne: 4 episodes            │
│ Fatigue: 6 episodes         │
│ Bloating: 3 episodes        │
├─────────────────────────────┤
│ Cycle History (last 6)      │
│ [28] [35] [42] [38] [45] [52]│
│ Avg: 40 days                │
│ Longest: 52 days            │
├─────────────────────────────┤
│ 💡 Insight                  │
│ Your cycles tend to be      │
│ longer in winter months.    │
│ [Learn about seasonal       │
│  effects on PCOS ▸]        │
└─────────────────────────────┘
```

### Key Interactions
- Add condition: Multi-step setup wizard
- Condition card: Tap for condition dashboard
- Edit: Adjust tracking parameters, symptoms, treatments
- Remove: Confirmation dialog, preserves logged data

### Empty State
- No conditions: "Add a health condition to get specialized tracking and insights"

### Loading State
- Setup wizard: Smooth transitions between steps
- Dashboard loading: Skeleton cards

### Error State
- Condition setup fails: "Could not save condition settings. [Retry]"

### Success State
- Condition added: "✅ PCOS tracking activated!" with animation
- Dashboard shows condition-specific insights
- Calendar adapts to condition (longer cycles, phase adjustments)
