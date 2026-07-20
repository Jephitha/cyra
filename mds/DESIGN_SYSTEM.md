# Cyra — Design System & Brand Identity

This document is the single source of truth for Cyra's visual and verbal identity. Any agent
(design or engineering) working on branding, UI, or copy should read this in full before making
changes. It is meant to be opinionated enough that two different people (or two different agent
runs) arrive at consistent output.

---

## 1. Brand values

Everything Cyra makes — visual, verbal, or interaction design — should express:

- **Care** — the product looks after the user, not the other way around. Nothing should feel
  clinical, cold, or like a spreadsheet with a pink theme.
- **Empathy** — the app acknowledges that a body's data is personal and sometimes difficult.
  Never chirpy in a way that dismisses discomfort; never so clinical it feels indifferent.
- **Support** — quietly competent, not showy. The app is a steady presence, not a coach shouting
  encouragement or a nag issuing reminders.
- **Appreciation of feminine energy** — warm, organic, cyclical, natural — expressed through
  curves, natural color references (botanical, warm-earth, soft light), and rhythm rather than
  through cliché (this explicitly does not mean pink, florals-as-wallpaper, or "girly" tropes).
- **Trust** — the privacy-first architecture is a genuine product differentiator; the visual
  language should feel private and considered, like something you'd trust with your body's data —
  not loud, not ad-like, not gamified in a manipulative way.

## 2. Tone: "invitingly playful"

The product should feel like a warm, capable friend — not a hospital form, and not a cutesy
sticker-book. Concretely:

- **Playful, not childish.** Rounded shapes and soft motion are fine; cartoon mascots, baby-talk
  copy, and gratuitous emoji are not.
- **Warm, not saccharine.** Copy can be gentle and human ("Looks like your period's a bit early
  this month — that's still within your normal range") without being falsely cheerful about
  something that might be uncomfortable or worrying.
- **Confident, not clinical.** Data and predictions are presented with clear confidence framing
  (the app already does this well — `confidence_badge.dart`, explanation strings like "track 3
  more cycles for a reliable prediction") — lean into that honesty as a personality trait, not
  just a UX pattern.
- **Quiet, not naggy.** Notifications and prompts should feel like a considerate nudge, never
  guilt, urgency, or streak-shaming (avoid Duolingo-style guilt mechanics entirely — they're
  antithetical to "care" and "support" as brand values).

Litmus test for any new copy or visual: *would this make someone having a hard cycle day feel
looked after, or would it feel like being handled by a system?* If the latter, redo it.

---

## 3. Logo & wordmark brief

### Direction
A mark built from a single continuous, organic curve — evoking both a natural cycle (the literal
subject matter) and a sense of gentle motion/growth, rather than anything literal (no flowers,
no drops, no literal uterus/anatomical iconography, no moon-phase cliché unless executed very
subtly). Think closer to the restraint of Clue's dot-based mark or Headspace's soft geometric
calm than to the more literal, saturated iconography common in the category.

Two acceptable directions to explore, pick the stronger execution:
1. **An abstract spiral/arc mark** — a single soft, asymmetric curve that can also double as a
   subtle "C" for Cyra, suggesting a cycle without being a literal circle-with-days-in-it
   calendar cliché.
2. **A soft leaf/petal-adjacent abstract form** — organic, closed shape, but deliberately
   abstracted so it reads as a considered symbol rather than a literal botanical illustration.

### Constraints
- Must work as a single-color mark (pure black, pure white) with zero loss of legibility —
  test this first, not last.
- Must be legible at 24×24px (notification/status-bar scale) — no fine detail, no thin strokes
  that disappear at small sizes.
- No gradients baked into the master mark (gradients are fine in the broader brand palette/UI,
  but the icon-only mark should hold up as flat color for platform icon requirements).
- Wordmark uses a warm, humanist sans or serif (see Typography below) — avoid anything
  aggressively geometric/tech-startup (no hard grotesques like a generic SaaS logo) and avoid
  anything overtly feminine-coded in a cliché way (no script fonts, no thin decorative serifs).

### Deliverables (see `BACKLOG.md` T-BRAND-1/2/3)
- Primary lockup (mark + wordmark)
- Horizontal lockup (for app bars/tight spaces)
- Icon-only mark (for the app icon and favicon-equivalent uses)
- Wordmark-only (for contexts where the mark would be redundant)
- Single-color (black/white) versions of all of the above
- SVG source files for every version, PNG exports at 1x/2x/3x for in-app use

### Suggested generation prompt (for an image-generation tool or human designer brief)
> "A minimal, abstract logo mark for a women's health app called Cyra. A single continuous,
> organic curved line forming a soft asymmetric spiral or arc — suggesting a natural cycle and
> gentle forward motion, not a literal calendar or flower. Warm, calm, confident — not cute,
> not clinical. Flat single-color design that reads clearly at very small sizes (like a phone
> app icon). No gradients, no drop shadows, no anatomical imagery, no moon phases, no pink
> stereotypes. Palette: warm ivory background, deep forest green or soft gold mark. Style
> reference: the restraint of Headspace or Clue's brand mark, not the literal iconography common
> in period-tracking apps."

---

## 4. Color palette

The existing codebase already has a palette defined in `core/design/app_colors.dart`
(`forestGreen` / `forestGreenLight` / `forestGreenDark`, `warmIvory` / `warmIvoryDark`,
`softGold` / `softGoldLight` / `softGoldDark`, `sage`, `charcoal`, `slate`, `mistWhite`, plus
semantic `success`/`warning`/`error`/`info` and light/dark background-surface-text-border sets).

**This palette is good and already aligned with the brand values above** — forest green and soft
gold read as warm, natural, and calm rather than the pink/red cliché of the category, and
ivory/mist-white keep it airy rather than clinical. Recommendation: **keep this palette as the
foundation** rather than starting over; refine rather than replace.

| Role | Token | Use |
|---|---|---|
| Primary | `forestGreen` | Primary actions, active states, brand moments |
| Primary variants | `forestGreenLight` / `forestGreenDark` | Hover/pressed states, dark mode primary |
| Accent | `softGold` | Highlights, celebratory/positive moments, badges |
| Accent variants | `softGoldLight` / `softGoldDark` | Secondary accents, dark mode adjustments |
| Neutral warm | `warmIvory` / `warmIvoryDark` | Backgrounds — this is what keeps the app feeling warm rather than sterile white |
| Neutral cool | `sage`, `mistWhite`, `slate` | Supporting neutrals, borders, secondary text |
| Ink | `charcoal` | Primary text |
| Semantic | `success` / `warning` / `error` / `info` | Status only — never decorative |

**Explicit direction:** do not introduce a bright/saturated pink or red as a primary brand color,
even though it's the category default (Flo, most competitors). It's precisely the cliché this
brand should avoid. Red/warning tones remain reserved for the semantic `error`/period-flow-data
context only (e.g., flow intensity indicators may reasonably use warmer tones since that's
literal data, not brand decoration).

## 5. Typography

Keep a warm, humanist typeface for body copy and UI (something like the existing Google Fonts
integration already in the dependency list — confirm which family is currently configured in
`app_typography.dart` and evaluate against this brief rather than assuming a change is needed).

- **Headlines:** a humanist sans with a bit of warmth and personality — avoid anything that reads
  as a generic fintech/SaaS grotesque.
- **Body:** highly legible, slightly rounded humanist sans, comfortable at small sizes for dense
  data screens (calendar, history, charts).
- **Numerals:** tabular figures for any place numbers align in a column (cycle history, charts) —
  verify the chosen typeface supports this.

## 6. Iconography & illustration

- Rounded terminals, consistent stroke weight, no sharp clinical/medical-cross iconography.
- Where illustration is used (empty states, onboarding), favor abstract organic shapes echoing
  the logo's curve language over literal illustrations of bodies, flowers, or babies — keep it
  warm without being twee.
- Charts (`bbt_chart`, `cycle_overview_chart`, `symptom_bar_chart`) should use the primary/accent
  palette consistently — avoid introducing chart-specific colors that clash with the brand
  palette (a common design-system failure mode).

## 7. Motion

Soft, natural easing (ease-in-out, never linear or bouncy/elastic) — motion should feel like a
gentle breath, not a notification ping. Avoid anything gamified (no confetti bursts, no streak
counters with aggressive animation) — celebratory moments (e.g., "3 cycles tracked, prediction
unlocked") should be warm and understated, a soft glow or gentle scale, not a game-app burst.

---

## 8. App icon: primary

Derived directly from the icon-only logo mark (Section 3), on the `warmIvory` or `forestGreen`
background per platform convention testing (test both — see which holds up better across
Android's adaptive icon masking and iOS's rounded-square mask before finalizing). Must pass the
small-size legibility test described in Section 3.

## 9. App icon: hidden mode (neutral disguise)

**Decision: use a neutral weather icon and app identity when "Hide App Icon" is enabled**, per
product direction. This replaces whatever generic "neutral icon" was previously implied by the
unimplemented toggle (see `BACKLOG.md` T9a for the technical implementation).

**Scope is confirmed as icon + label swap only.** No decoy weather screen or fake functionality
behind the disguised icon — when launched via the alias, the app still opens to Cyra's real lock
screen exactly as it does today. The disguise applies purely at the home-screen/launcher level.
Do not build a functional weather screen as part of this feature; if that's ever wanted later,
it's a separate, larger, separately-scoped feature.

### Requirements
- The hidden-mode icon must look like a **plausible, boring, real weather app** — nothing about
  it should hint at Cyra. Use a simple sun/cloud motif in a generic blue/grey palette,
  deliberately *not* sharing any color, shape language, or motif with Cyra's actual brand. This
  is a security feature — any visual echo of the real brand defeats the purpose.
- Pair it with a neutral app label under the icon — recommend something plausible and forgettable
  like **"Weather"** or **"Skycast"** (avoid anything that could be confused with a real,
  well-known weather app's exact name/trademark — keep it generic rather than impersonating a
  specific existing app).
- Icon must meet the same full platform size/format requirements as the primary icon (Section 8;
  see `BACKLOG.md` T-BRAND-3).

---

## 10. Dark mode and light mode

**The entire app must support both light and dark appearance, driven only by the OS/system
setting — there is no in-app manual theme toggle for now.** Concretely:

- `MaterialApp.router`'s `themeMode` should always resolve to `ThemeMode.system`. There is no
  user-facing control that overrides this.
- The existing `AppearanceScreen` (`features/settings/screens/appearance_screen.dart`) currently
  has a manual theme-mode picker (`_buildThemeModeSection`, backed by
  `themeModeSettingNotifierProvider`) — **remove this control from the UI** (see `BACKLOG.md`
  T-THEME-1). Whether the underlying provider/persistence is deleted or just no longer exposed
  in the UI is an implementation detail — the important thing is the user has no way to force
  light or dark mode independent of their system setting.
- The color token system already has the right shape for this —
  `core/design/app_colors.dart` already defines paired light/dark tokens
  (`backgroundLight`/`backgroundDark`, `surfaceLight`/`surfaceDark`,
  `textPrimaryLight`/`textPrimaryDark`, `textSecondaryLight`/`textSecondaryDark`,
  `borderLight`/`borderDark`), and `AppTheme.light` / `AppTheme.dark` both already exist. **The
  infrastructure is there — the work is verifying every screen actually uses it correctly**,
  not building it from scratch.
- Every screen, widget, and chart must render correctly and legibly in both modes — this
  includes the design-system widget library (`cycle_calendar`, `bbt_chart`,
  `symptom_bar_chart`, `cycle_overview_chart`, `fertility_widget`, `pregnancy_week_widget`,
  `health_timeline`, `confidence_badge`, etc.), not just the simpler static screens. Charts in
  particular are a common place for hardcoded colors that look fine in light mode and become
  illegible or jarring in dark mode.
- This applies to new brand assets too: the primary app icon (Section 8) and any splash screen
  work (`BACKLOG.md` T-BRAND-5) should be checked against both an OS set to light mode and one
  set to dark mode, since some platforms (Android 13+) apply themed/monochrome icon treatments
  that respond to system dark mode.
- The hidden-mode weather icon (Section 9) is a static launcher icon and is not expected to
  respond to in-app theme state — no action needed there beyond standard adaptive-icon dark/light
  masking if the platform applies it automatically.

## 11. Voice & copy guidelines

- Use "you"/"your" — direct, warm, personal. Never third-person clinical framing.
- Prefer plain language over medical jargon; where a medical term is necessary, briefly explain
  it inline rather than assuming familiarity.
- Never guilt, shame, or create urgency around logging ("Don't forget to log today!" with a red
  badge is out; "Want to log today?" as a calm, dismissible prompt is in).
- Acknowledge discomfort honestly rather than being relentlessly positive — e.g., prefer
  "Cramps can be rough — here's what helps" over "You've got this! 💪"
- Avoid exclamation points as a default register; use warmth through word choice, not punctuation
  volume.
- Confidence/uncertainty framing (already present in `CyclePredictor`'s explanation strings)
  should extend to all copy: be honest about what the app knows and doesn't know, rather than
  presenting predictions as certainties.

---

## 12. What "on-brand" looks like vs. doesn't

| On-brand | Off-brand |
|---|---|
| Soft forest green primary button, warm ivory background | Bright pink/magenta primary color |
| "Your period's likely to start in 2–3 days" | "PERIOD INCOMING! 🔴" |
| Gentle scale/fade transitions | Bouncy, elastic, gamified animations |
| Abstract organic mark | Literal flower/drop/uterus iconography |
| Quiet streak acknowledgment in Insights | Duolingo-style guilt-driven streak banners |
| A calm, boring weather icon in hidden mode | A pastel/rounded icon that still "feels like" Cyra |
| App follows system light/dark setting everywhere | A screen or chart that's still hardcoded light-only, or an in-app toggle that overrides the system setting |

Use this table as a fast sanity check for any new screen, illustration, or piece of copy before
it ships.

