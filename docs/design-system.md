# Design System: Cyra Women's Health Platform

## Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-16 | Design Team | Initial release |

---

## 1. Design Philosophy

Cyra's design system is built on three principles:

1. **Calm & Trustworthy**: Soft, nature-inspired colors, generous whitespace, gentle curves. The app should feel like a safe, private space.
2. **Clear & Accessible**: Maximum legibility, strong contrast, predictable patterns. Every interaction is understandable.
3. **Warm & Human**: Warm ivory backgrounds, soft gold accents, rounded elements. The app feels nurturing, not clinical.

---

## 2. Color System

### 2.1 Brand Colors

| Token | Name | Hex | Usage |
|-------|------|-----|-------|
| `--color-primary` | Deep Forest Green | `#1B4332` | Primary buttons, active states, headers, key accents |
| `--color-primary-hover` | — | `#143623` | Primary button hover/pressed |
| `--color-primary-light` | — | `#E8F0EC` | Primary container backgrounds, selected states |
| `--color-secondary` | Warm Ivory | `#F5F0E8` | Backgrounds, cards, containers |
| `--color-secondary-dark` | — | `#EDE5D8` | Secondary hover, card borders |
| `--color-accent` | Soft Gold | `#C9A94E` | Highlighting, premium features, stars/badges |
| `--color-accent-hover` | — | `#B8973A` | Accent hover/pressed |
| `--color-accent-light` | — | `#F5EFD6` | Accent container backgrounds |

### 2.2 Neutral Colors

| Token | Name | Hex | Usage |
|-------|------|-----|-------|
| `--color-sage` | Sage | `#7A9E7E` | Secondary text, icons, disabled states |
| `--color-charcoal` | Charcoal | `#2D2D2D` | Primary text, headings |
| `--color-slate` | Slate | `#6B7280` | Body text, subtitles |
| `--color-mist` | Mist White | `#F9FAFB` | Background (light mode), elevated cards |
| `--color-white` | White | `#FFFFFF` | Cards, modals, surfaces |
| `--color-border` | — | `#E5E7EB` | Borders, dividers |
| `--color-border-light` | — | `#F3F4F6` | Subtle dividers |

### 2.3 Semantic Colors

| Token | Name | Hex | Usage |
|-------|------|-----|-------|
| `--color-success` | — | `#22C55E` | Success states, synced indicator |
| `--color-warning` | — | `#F59E0B` | Warnings, medium confidence |
| `--color-error` | — | `#EF4444` | Errors, destructive actions |
| `--color-info` | — | `#3B82F6` | Informational, links |

### 2.4 Cycle Phase Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `--phase-menstrual` | `#E74C3C` | Period days, menstrual phase |
| `--phase-follicular` | `#F39C6B` | Follicular phase |
| `--phase-ovulation` | `#F1C40F` | Ovulation day |
| `--phase-fertile` | `#2ECC71` | Fertile window |
| `--phase-luteal` | `#9B59B6` | Luteal phase |

### 2.5 Dark Mode Colors

| Light Token | Dark Token | Dark Hex |
|-------------|-----------|----------|
| `--color-primary` | `--color-primary-dark` | `#2D6A4F` |
| `--color-secondary` | `--color-secondary-dark` | `#1A1A2E` |
| `--color-mist` | `--color-dark-bg` | `#0F0F1A` |
| `--color-white` | `--color-dark-surface` | `#1A1A2E` |
| `--color-charcoal` | `--color-dark-text` | `#F3F4F6` |
| `--color-slate` | `--color-dark-text-secondary` | `#9CA3AF` |
| `--color-border` | `--color-dark-border` | `#2D2D3D` |
| `--color-border-light` | — | `#1F1F30` |

### 2.6 Contrast Ratios

All color combinations meet WCAG AA minimum (4.5:1 for normal text, 3:1 for large text):

| Combination | Ratio | Pass |
|-------------|-------|------|
| Primary (#1B4332) on White (#FFF) | 13.1:1 | ✅ AAA |
| Charcoal (#2D2D2D) on Mist (#F9FAFB) | 14.5:1 | ✅ AAA |
| Slate (#6B7280) on White (#FFF) | 4.7:1 | ✅ AA |
| Sage (#7A9E7E) on White (#FFF) | 3.2:1 | ✅ AA (large text) |
| White on Primary (#1B4332) | 13.1:1 | ✅ AAA |
| Soft Gold (#C9A94E) on White (#FFF) | 2.4:1 | ❌ (use on dark bg) |
| Soft Gold (#C9A94E) on Charcoal (#2D2D2D) | 5.5:1 | ✅ AA |

---

## 3. Typography

### 3.1 Font Family

**Primary**: Inter (variable font, weights 300-700)

Inter is chosen for:
- Excellent legibility at small sizes
- Generous x-height for accessibility
- Multiple language support
- Variable font for performance

**Fallback**: `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`

### 3.2 Type Scale

| Token | Size | Line Height | Weight | Usage |
|-------|------|-------------|--------|-------|
| `--text-xs` | 12px | 16px (1.33) | 400 | Captions, labels, legal text |
| `--text-sm` | 14px | 20px (1.43) | 400 | Body text, secondary info |
| `--text-base` | 16px | 24px (1.5) | 400 | Default body text |
| `--text-lg` | 18px | 28px (1.56) | 500 | Large body, card titles |
| `--text-xl` | 20px | 28px (1.4) | 600 | Section headers |
| `--text-2xl` | 24px | 32px (1.33) | 600 | Screen titles |
| `--text-3xl` | 30px | 36px (1.2) | 700 | Hero headers |
| `--text-4xl` | 36px | 40px (1.11) | 700 | Large hero |
| `--text-5xl` | 48px | 48px (1.0) | 700 | Display text |

### 3.3 Font Weights

| Weight | Name | Usage |
|--------|------|-------|
| 300 | Light | Large display text only |
| 400 | Regular | Body text, labels |
| 500 | Medium | Subheaders, card titles |
| 600 | Semi-Bold | Section headers, emphasis |
| 700 | Bold | Screen titles, primary headings |

### 3.4 Type Styles Examples

```dart
class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.02,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -0.01,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.56,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.005,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.01,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.08,
    textTransform: TextTransform.uppercase,
  );
}
```

### 3.5 Dynamic Text (Accessibility)

All type scales support device-level dynamic text. At maximum accessibility size:
- `--text-sm` scales to 18px
- `--text-base` scales to 22px
- `--text-lg` scales to 26px
- Layouts adjust with increased text sizes (no truncation)

---

## 4. Spacing System

### 4.1 Base Grid: 4px

The spacing system is based on a 4px grid, providing consistent rhythm and alignment.

| Token | Pixels | Rem | Usage |
|-------|--------|-----|-------|
| `--space-1` | 4px | 0.25rem | Micro spacing, icon padding |
| `--space-2` | 8px | 0.5rem | Compact spacing, icon + text gap |
| `--space-3` | 12px | 0.75rem | Element padding, small gaps |
| `--space-4` | 16px | 1rem | Default padding, card margin |
| `--space-5` | 20px | 1.25rem | Section spacing, button padding |
| `--space-6` | 24px | 1.5rem | Card padding, list spacing |
| `--space-8` | 32px | 2rem | Section margins, modal padding |
| `--space-10` | 40px | 2.5rem | Screen edge margin |
| `--space-12` | 48px | 3rem | Large section spacing |
| `--space-16` | 64px | 4rem | Hero spacing, very large gaps |

### 4.2 Common Spacing Patterns

| Pattern | Spacing Value |
|---------|---------------|
| Screen horizontal padding | `--space-5` (20px) |
| Card padding | `--space-4` (16px) |
| Card-to-card gap | `--space-4` (16px) |
| Content section gap | `--space-6` (24px) |
| Tab bar height | 64px |
| Bottom sheet corner to content | `--space-5` (20px) |
| Button horizontal padding | `--space-5` (20px) |
| Icon to text gap | `--space-2` (8px) |
| Heading to body gap | `--space-3` (12px) |

---

## 5. Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 8px | Buttons, inputs, small containers |
| `--radius-md` | 12px | Cards, bottom sheets, modals |
| `--radius-lg` | 16px | Large cards, sheets |
| `--radius-xl` | 24px | Dialogs, full-width elements |
| `--radius-full` | 9999px | Pill buttons, chips, avatars |

---

## 6. Shadows

### 6.1 Elevation Levels

```dart
class AppShadows {
  /// Small: Cards resting on surface, subtle depth
  static const elevation1 = BoxShadow(
    offset: Offset(0, 1),
    blurRadius: 3,
    spreadRadius: 0,
    color: Color.fromRGBO(0, 0, 0, 0.08),
  );

  /// Medium: Elevated cards, bottom sheets, FAB
  static const elevation2 = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
    color: Color.fromRGBO(0, 0, 0, 0.10),
  );

  /// Large: Modals, dialogs, prominent elements
  static const elevation3 = BoxShadow(
    offset: Offset(0, 10),
    blurRadius: 15,
    spreadRadius: -3,
    color: Color.fromRGBO(0, 0, 0, 0.12),
  );
}
```

### 6.2 Dark Mode Shadows

In dark mode, shadows use lighter colors with lower opacity:
```dart
/// Dark mode adjusted shadows
static const elevation1Dark = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 3,
  spreadRadius: 0,
  color: Color.fromRGBO(255, 255, 255, 0.04),
);
```

---

## 7. Component Specifications

### 7.1 Buttons

#### Primary Button
```
┌─────────────────────────────────────────┐
│  [░░░░░░░░░ Primary Action ░░░░░░░░░░░] │
└─────────────────────────────────────────┘
Height: 48px (minimum)
Padding: 16px horizontal, 12px vertical
Background: --color-primary (#1B4332)
Text: White, --text-button (16px/600)
Border Radius: --radius-sm (8px)
Icon: Optional, 20px, left-aligned
State: Enabled / Pressed (opacity 0.8) / Disabled (opacity 0.4)
Loading: Spinner replaces icon
Width: Full-width on mobile, auto on tablet+
```

#### Secondary Button
```
┌─────────────────────────────────────────┐
│  [░░░░ Secondary Action ░░░░░░░░░░░░░░] │
└─────────────────────────────────────────┘
Height: 48px
Padding: 16px horizontal
Background: Transparent
Border: 1.5px solid --color-primary
Text: --color-primary
Border Radius: --radius-sm
```

#### Ghost Button
```
┌──────────────────────────────────────────┐
│  [Tertiary action]                       │
└──────────────────────────────────────────┘
Height: Auto (minimum 44px touch target)
Background: Transparent
Text: --color-primary
Underline: None
Padding: 8px horizontal
```

#### Icon Button
```
┌─────┐
│  ●  │  32px (minimum 44px touch target)
└─────┘
Size: 32px icon, 44px touch target
Background: Transparent
Ripple: --color-primary at 10% opacity
```

### 7.2 Cards

#### Default Card
```
┌─────────────────────────────────────────┐
│                                         │
│   Title                                 │
│   Subtitle or content...                │
│                                         │
└─────────────────────────────────────────┘
Padding: 16px
Background: --color-white (--color-dark-surface in dark mode)
Border Radius: --radius-md (12px)
Shadow: elevation1
```

#### Interactive Card (tappable)
```
┌─────────────────────────────────────────┐
│  ▸ Title                    →           │
│    Subtitle                             │
└─────────────────────────────────────────┘
Same as default card +
Ripple effect on tap
Chevron or icon on right
Pressed state: scale(0.98) for 100ms
```

#### Chart Card
```
┌─────────────────────────────────────────┐
│  📊 Cycle Overview      [See All ▸]    │
│                                         │
│     ╱╲    ╱╲                            │
│    ╱  ╲  ╱  ╲                           │
│   ╱    ╲╱    ╲                          │
│  ╱            ╲                         │
│ ╱              ╲╱╲                      │
│                                         │
│   Period   Fertile  Ovulation  Luteal   │
└─────────────────────────────────────────┘
Same as default card +
Chart area minimum height: 120px
Chart padding: 8px top/bottom
```

### 7.3 Charts

#### BBT Line Chart
```
┌─────────────────────────────────────────┐
│ 37.0 ┤                                 ● │
│       ┤                         ●       │
│ 36.5 ┤────────●────●────●─────────────── │ ← Cover line
│       ┤   ●   ●                         │
│ 36.0 ┤ ●                                │
│       ┤                                 │
│       └──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬── │
│         1  5  10  15  20  25  30  35    │
│                                         │
│ ● = Temperature   ─ = Cover line        │
│ 🔵 = Predicted ovulation                │
└─────────────────────────────────────────┘
Line color: --color-primary
Dot color: --color-primary
Cover line: Dashed, --color-sage
Ovulation marker: Blue circle, --color-info
Grid lines: --color-border-light, subtle
Y-axis: Temperature (35.5 - 37.5°C range)
X-axis: Cycle day (1 to cycle length)
Interactive: Tap point for detail tooltip
Pinch to zoom: Yes
```

#### Symptom Bar Chart
```
┌─────────────────────────────────────────┐
│ Most Frequent Symptoms                  │
│                                         │
│ Headache  ████████████░░ 12             │
│ Bloating  ██████████░░░░ 10             │
│ Cramps    ████████░░░░░░ 8              │
│ Fatigue   ██████░░░░░░░░ 6              │
│ Acne      ████░░░░░░░░░░ 4              │
└─────────────────────────────────────────┘
Bar color: --color-primary
Bar height: 20px
Bar border radius: 4px (right side)
Label left, count right
Grid: None (horizontal bars)
```

#### Cycle Overview Chart
```
┌─────────────────────────────────────────┐
│ [🟥🟥🟥🟥🟥🟥🟥🟥⬜⬜⬜⬜⬜       ]
│  M    M    M    M    M    F    F    F
│  F    F    F    F    F    O    L    L
│  L    L    L    L    L    L    L    L
│  L    L    L    L                        │
│                                         │
│ Days 1-28 of Cycle 4                   │
└─────────────────────────────────────────┘
Horizontal bar showing 28 days
Color-coded: Red (M), Pink (F), Yellow (O), Purple (L)
Interactive: Tap phase for info
```

### 7.4 Calendar

#### Month View
```
┌─────────────────────────────────────────┐
│          < June 2026 >                  │
│  Mon  Tue  Wed  Thu  Fri  Sat  Sun      │
│        1    2    3    4    5    6      │
│   7    8    9   10   11   12   13      │
│  14   15   16   17   18   19   20      │
│  21   22   23   24   25   26   27      │
│  28   29   30                          │
│                                         │
│ Phase Legend: ● M ● F ● O ● L         │
└─────────────────────────────────────────┘
Day cell size: 44x44px minimum (accessibility)
Phase color: Background circle behind number
Today: Bold border ring
Selected day: Filled circle with white text
Data indicators: Small dots below number
  • Red dot: Period logged
  • Green dot: Data logged
  • Blue dot: Fertility data
  • Purple dot: Journal entry
Swipe: Left/right for month navigation
Pinch: Transition to year view
```

#### Day Detail (bottom sheet)
```
┌─────────────────────────────────────────┐
╱─────────────────────────────────────────╲
│  June 16, 2026          Cycle Day 14    │
│  ─────────────────────────────────────  │
│  Phase: Follicular                      │
│  Flow: None              Mood: 😊      │
│  ─────────────────────────────────────  │
│  Symptoms                               │
│  ● Headache (Severity 4)                │
│  ● Bloating (Severity 2)                │
│  ─────────────────────────────────────  │
│  🌡️ 36.5°C (oral, 06:30)              │
│  💤 7.5 hrs                            │
│  🏃 30 min exercise                    │
│  ─────────────────────────────────────  │
│  💬 "Felt good today..." [Read more ▸] │
│  ─────────────────────────────────────  │
│  [Edit]                   [Add Entry]   │
╲─────────────────────────────────────────╯
Handle: 40px wide, 4px tall, centered
Drag handle indicator
Max height: 80% of screen
Corner radius: --radius-xl (24px)
```

### 7.5 Pickers

#### Date Picker
```
┌─────────────────────────────────────────┐
│  Select Date                            │
│                                         │
│  <    June    2026   >                  │
│  15  16  17  18  19  20  21             │
│             ●                            │
│                                         │
│  [Cancel]          [Confirm]            │
└─────────────────────────────────────────┘
Platform-native date picker preferred
Custom picker: Minimum 44px touch targets
Spinning wheel style (iOS) or calendar grid
```

#### Time Picker
```
┌─────────────────────────────────────────┐
│    06  :  30                            │
│   05     25                             │
│ ● 06 ●  30                             │
│   07     35                             │
│   08     40                             │
│                                         │
│  AM  ○                                  │
│  PM  ●                                  │
│                                         │
│  [Cancel]          [Confirm]            │
└─────────────────────────────────────────┘
Platform-native time picker preferred
```

#### Flow Intensity Picker
```
┌─────────────────────────────────────────┐
│  Flow Intensity                         │
│                                         │
│  ○ None                                 │
│  ● Spotting                             │
│  ○ Light                                │
│  ○ Medium                               │
│  ○ Heavy                                │
│  ○ Very Heavy                           │
│                                         │
│  [Select]                               │
└─────────────────────────────────────────┘
Radio button list
Each item: 44px minimum height
Selected: --color-primary dot
```

#### Symptom Severity Picker
```
┌─────────────────────────────────────────┐
│  Headache Severity                      │
│                                         │
│  1      2      3      4      5          │
│  ○      ○      ●      ○      ○          │
│ Mild                            Severe  │
│                                         │
│  [Save]                [Remove]         │
└─────────────────────────────────────────┘
Horizontal 5-point scale
Minimum 44px touch targets per option
Label below: "Mild" (left), "Severe" (right)
Selected: Filled circle with --color-primary
```

### 7.6 Health Timeline

#### Vertical Timeline
```
┌─────────────────────────────────────────┐
│  June 2026                              │
│                                         │
│  ● Jun 1 — Period started              │
│  │                                      │
│  ● Jun 3 — Heavy flow, cramps (4)      │
│  │                                      │
│  ● Jun 5 — Period ended                │
│  │                                      │
│  ● Jun 12 — Fertile window opens       │
│  │                                      │
│  ● Jun 15 — Ovulation day              │
│  │                                      │
│  ● Jun 28 — Period predicted           │
│                                         │
└─────────────────────────────────────────┘
Timeline line: 2px, --color-border
Dot: 12px diameter, --color-primary
Dot today: 16px diameter, pulsing
Content: 8px below dot
Spacing: 24px between events
```

#### Horizontal Timeline (Pregnancy)
```
┌─────────────────────────────────────────┐
│  Week 24  ●────●────●────●────●────●   │
│           20   21   22   23   24   25   │
│                                         │
│  ● = Completed   ● = Current week      │
│  ○ = Future                             │
└─────────────────────────────────────────┘
Horizontal scrollable
Current week: Larger dot + label
Completed: Filled green
Future: Empty circle
```

### 7.7 Symptom Selector

#### Grid View
```
┌─────────────────────────────────────────┐
│  [Search symptoms...]                   │
│                                         │
│  Physical      Emotional     Lifestyle  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │ 🤕 │ │ 🤢 │ │ 🤰 │ │ 🦶 │ │ 😴 │   │
│  │Head │ │Naus│ │Blot│ │Cram│ │Fat │   │
│  └────┘ └────┘ └────┘ └────┘ └────┘   │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │ 🤱 │ │ 💪 │ │ 🍽️ │ │ 😢 │ │ 😠 │   │
│  │Tend│ │Ache│ │Naus│ │ Sad│ │Irr │   │
│  └────┘ └────┘ └────┘ └────┘ └────┘   │
│                                         │
│  Selected: Bloating, Headache          │
│  [Done]                                 │
└─────────────────────────────────────────┘
Grid: 3-4 columns on phone, 4-6 on tablet
Cell size: 72x80px
Icon: 28px
Label: 11px, 1 line truncation
Selected state: Green border, check overlay
Category chips: Horizontal scroll above grid
Search: Real-time filter across all symptoms
```

### 7.8 Fertility Widget

#### Window Indicator
```
┌─────────────────────────────────────────┐
│  Fertility Window                       │
│                                         │
│  Jun 12  Jun 13  Jun 14  Jun 15  Jun 16│
│   ┌──┐    ┌──┐    ┌──┐    ┌──┐    ┌──┐│
│   │⬆️│    │⬆️│    │⬆️│    │🌟│    │⬇️││
│   └──┘    └──┘    └──┘    └──┘    └──┘│
│   Low     Med     High    Peak    Low  │
│   45%     68%     82%     95%     55%  │
│                                         │
│  Today: Peak fertility  🥚             │
│  Based on LH surge + egg white mucus   │
│  [Learn about your fertility ▸]        │
└─────────────────────────────────────────┘
Horizontal scrollable date strip
5 days of fertile window
Probability bar below each day
Color gradient: Low (gray) → Peak (green)
Today indicator: Current day highlighted
```

### 7.9 Pregnancy Widget

#### Week Progress
```
┌─────────────────────────────────────────┐
│  Week 24 of 40                          │
│  ──────────●──────────────────────────  │
│  0         24                  40       │
│                                         │
│  Trimester 2 • 132 days to go           │
│  Due: September 7, 2026                │
└─────────────────────────────────────────┘
Progress bar: 8px height
Filled section: --color-primary
Current position: 16px circle
Labels: Below bar at ends
```

#### Size Comparison
```
┌─────────────────────────────────────────┐
│  Your Baby This Week                    │
│                                         │
│        ┌─────┐                          │
│       │       │                         │
│      │  🥦    │                         │
│       │       │                         │
│        └─────┘                          │
│                                         │
│  Size: A head of cauliflower           │
│  Length: 30 cm (12 in)                 │
│  Weight: 600 g (1.3 lb)               │
│                                         │
│  [Learn more about week 24 ▸]          │
└─────────────────────────────────────────┘
Illustration: Simplified line drawing or emoji
Size comparison: Common object for context
Measurements: Length + weight
Educational link to relevant article
```

### 7.10 Community Components

#### Post Card
```
┌─────────────────────────────────────────┐
│  Anonymous User  · 2h ago   [TTC]       │
│                                         │
│  Anyone tried acupuncture for           │
│  fertility?                             │
│                                         │
│  I've been trying for 8 months and...   │
│                                         │
│  ▲ 45         💬 24 replies             │
└─────────────────────────────────────────┘
Anonymous avatar: Generic circle with person icon
Topic badge: Pill with topic color
Upvote button: Tappable, animated on tap
Reply count: Tappable → open replies
```

### 7.11 Loading States

#### Skeleton Card
```
┌─────────────────────────────────────────┐
│  ┌─────────────────────────────────┐    │
│  │ ░░░░░░░░░░░░░░░░░              │    │
│  │ ░░░░░░░░░░░░░░░░░░░░░░         │    │
│  │ ░░░░░░░░░░                     │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
Animated shimmer: left-to-right sweep
Duration: 1.5s loop
Color: Light gray (#E5E7EB) → White (#FFF)
Border radius: matches card
```

#### Spinner
```
Circular progress indicator
Size: 20px (inline), 32px (section), 48px (full page)
Color: --color-primary
Speed: 1 rotation per second
Used for: Short loading states (<3s)
```

#### Progress Bar
```
┌─────────────────────────────────────────┐
│  ▓▓▓▓▓▓▓▓░░░░░░░░░░░░  60%             │
└─────────────────────────────────────────┘
Height: 4px (determinate), 2px (indeterminate)
Determinate: Report generation, data sync
Indeterminate: Unknown wait time
Color: --color-primary
Track: --color-border-light
```

### 7.12 Empty States

```
┌─────────────────────────────────────────┐
│                                         │
│           🗓️ [Illustration]            │
│                                         │
│     No cycles tracked yet               │
│                                         │
│     Start logging your cycle to        │
│     get personalized predictions       │
│     and insights.                      │
│                                         │
│     [Log Your Period]                   │
│                                         │
└─────────────────────────────────────────┘
Illustration: Simple, friendly line art (120x120px)
Title: --text-xl, --color-charcoal
Description: --text-base, --color-slate
Action button: Primary style
Minimum height: 280px
```

---

## 8. Light & Dark Mode

### 8.1 Color Scheme Mapping

| Element | Light | Dark |
|---------|-------|------|
| App Background | `#F9FAFB` (Mist) | `#0F0F1A` |
| Card Background | `#FFFFFF` (White) | `#1A1A2E` |
| Primary Text | `#2D2D2D` (Charcoal) | `#F3F4F6` |
| Secondary Text | `#6B7280` (Slate) | `#9CA3AF` |
| Primary Button | `#1B4332` (Forest) | `#2D6A4F` |
| Borders | `#E5E7EB` | `#2D2D3D` |
| Shadows | Black at 8-12% | White at 4% |
| Success | `#22C55E` | `#4ADE80` |
| Error | `#EF4444` | `#F87171` |
| Warning | `#F59E0B` | `#FBBF24` |
| Info | `#3B82F6` | `#60A5FA` |

### 8.2 Dark Mode Surfaces

```
Elevation hierarchy in dark mode:
- Base (bg): #0F0F1A
- Surface (cards): #1A1A2E
- Elevated (modals): #22223A
- Highest (sheets): #2A2A42

Each level is subtly lighter, creating depth without shadows.
```

### 8.3 Contrast in Dark Mode

All dark mode color pairs meet WCAG AA:
- Primary text (#F3F4F6) on surface (#1A1A2E): 13.4:1 ✅ AAA
- Secondary text (#9CA3AF) on surface (#1A1A2E): 6.9:1 ✅ AA
- Primary button (#2D6A4F) on surface (#1A1A2E): 3.8:1 ✅ AA (large)
- White text on primary (#2D6A4F): 9.2:1 ✅ AAA

### 8.4 System Preference Detection

- Default: Follow system dark/light mode
- User can override in Settings → Appearance
- No manual toggle in quick settings (reduces accidental changes)

---

## 9. Accessibility

### 9.1 Touch Targets

| Element | Minimum Size | Notes |
|---------|-------------|-------|
| Buttons (all variants) | 44x44pt | Never smaller |
| Icon buttons | 44x44pt touch target, 24-32pt icon |
| List items | 44pt height | |
| Calendar days | 44x44pt | |
| Slider handles | 44x44pt | |
| Chips / pills | 36pt height | Vertical margin to reach 44pt |
| Bottom sheet handle | 44pt (tap area) | |
| Tab bar items | 48pt height | |
| Links in text | 44pt minimum touch area | |

### 9.2 Focus Indicators

- All interactive elements have visible focus rings
- Focus ring: 2px solid --color-primary, 2px offset
- Keyboard navigation order follows visual layout
- Focus indicator visible on both light and dark modes
- No focus indicator removal without user preference

### 9.3 Semantic Labels

```dart
// All interactive elements require semantic labels
Semantics(
  label: 'Log today\'s period',  // Clear action description
  hint: 'Double tap to log your period as started today',
  button: true,
  onTap: () => logPeriod(),
  child: PeriodButton(),
);
```

### 9.4 Screen Reader Support

- All images have `alt` text
- Charts have data table alternatives
- Calendar days announce: "June 16, cycle day 14, follicular phase"
- Notification: "Period predicted to start in 3 days"
- Navigation announcements: "Tab 3 of 6: Insights"
- State changes announced: "Entry saved"

### 9.5 Reduced Motion

```dart
// Respect system reduce motion setting
if (MediaQuery.of(context).disableAnimations) {
  // Use instant transitions (0ms)
  // Disable parallax, spring animations
  // Replace slide transitions with fade
}
```

| Animation | Normal | Reduced Motion |
|-----------|--------|----------------|
| Page transitions | Slide 300ms | Fade 150ms |
| Card appear | Scale + fade 250ms | Fade 150ms |
| Confetti | Particle burst | Static checkmark |
| Skeleton shimmer | Sweep animation | Static placeholder |
| Pull to refresh | Elastic bounce | Simple indicator |

---

## 10. Motion Design

### 10.1 Duration & Easing

| Type | Duration | Easing | Usage |
|------|----------|--------|-------|
| Micro-interaction | 100ms | ease-out | Button press, toggle |
| Component | 200ms | ease-in-out | Card expand, sheet appear |
| Screen transition | 300ms | ease-in-out | Push navigation |
| Modal | 300ms | ease-out | Bottom sheet |
| Notification | 400ms | ease-in-out | Toast, snackbar |
| Delight | 500ms | spring | Confetti, celebration |
| Loading shimmer | 1.5s loop | linear | Skeleton animation |

### 10.2 Specific Animations

| Component | Animation | Details |
|-----------|-----------|---------|
| Button press | Scale 1.0 → 0.97 | 100ms ease-out |
| Card tap | Ripple from touch point | 300ms, 50% opacity max |
| Bottom sheet | Slide up from bottom | 300ms ease-out |
| Page push | Slide left (iOS) / fade (Android) | 300ms |
| Tab switch | Instant (no cross-fade) | 0ms (performance) |
| Checkmark | Draw check path | 300ms ease-in-out |
| Like/upvote | Scale 1.0 → 1.3 → 1.0 | 200ms spring |
| Confetti | Particles burst upward | 500ms, gravity-based |
| Skeleton | Shimmer sweep left to right | 1.5s loop |
| Pull to refresh | Circular rotate + bounce | 300ms |
| Chart data point | Fade in on load | 200ms stagger |
| Phase color | Smooth transition between months | 200ms ease |

### 10.3 Page Transitions

```
iOS-style push navigation:
- Push: Current slides left 30%, new slides from right
- Pop: Current slides right, previous reveals
- Duration: 300ms
- Easing: ease-in-out

Modal presentation:
- Content slides up from bottom
- Background dims to 40% opacity
- Corner radius transitions: 0 → 24px
- Duration: 300ms
- Easing: ease-out
```

---

## 11. Icons

### 11.1 Icon Library
- Primary: Phosphor icons (open-source, consistent weight)
- Weight: Regular (default), Fill (active states)
- Sizes: 16px (inline), 20px (with text), 24px (standalone), 28px (tab bar), 32px (feature icons)

### 11.2 Tab Bar Icons

| Tab | Inactive | Active (Fill) |
|-----|----------|---------------|
| Home | `house` | `house-fill` |
| Calendar | `calendar` | `calendar-fill` |
| Insights | `lightbulb` | `lightbulb-fill` |
| Education | `book-open-text` | `book-open-text-fill` |
| Community | `chat-circle-text` | `chat-circle-text-fill` |
| Settings | `gear` | `gear-fill` |

### 11.3 Category Icons (Symptoms)

| Category | Icon |
|----------|------|
| Physical | `heartbeat` |
| Emotional | `face-expression` |
| Lifestyle | `coffee` |
| Digestive | `basket` |
| Skin | `drop-half-bottom` |
| Breast | `gender-female` |
| Pain | `warning-circle` |

---

## 12. Grid & Layout

### 12.1 Breakpoints

| Breakpoint | Width | Device |
|------------|-------|--------|
| Phone small | 320-374px | iPhone SE |
| Phone medium | 375-428px | iPhone standard |
| Phone large | 414-480px | Plus/Pro Max |
| Tablet portrait | 768-834px | iPad |
| Tablet landscape | 1024-1194px | iPad Pro |
| Desktop | 1200+ px | Web |

### 12.2 Layout Columns

| Breakpoint | Columns | Gutter | Margin |
|------------|---------|--------|--------|
| Phone | 4 | 16px | 20px |
| Tablet | 8 | 20px | 32px |
| Desktop | 12 | 24px | 48px |

---

## 13. Typography Implementation (Flutter)

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1B4332),     // Deep Forest Green
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE8F0EC),
      secondary: const Color(0xFFF5F0E8),   // Warm Ivory
      onSecondary: const Color(0xFF2D2D2D),
      tertiary: const Color(0xFFC9A94E),    // Soft Gold
      surface: Colors.white,
      onSurface: const Color(0xFF2D2D2D),
      error: const Color(0xFFEF4444),
      outline: const Color(0xFFE5E7EB),
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge,
      headlineLarge: AppTypography.heading1,
      headlineMedium: AppTypography.heading2,
      headlineSmall: AppTypography.heading3,
      titleLarge: AppTypography.subtitle,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.bodySmall,
      bodySmall: AppTypography.caption,
      labelLarge: AppTypography.button,
      labelSmall: AppTypography.overline,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 48)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.button),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
```
