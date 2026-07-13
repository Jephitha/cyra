# Clinician PDF export — visual contract

Status: reviewed against `DESIGN_SYSTEM.md` on 2026-07-13 before renderer work began.

The document should feel like a calm, human handover rather than a lab report: warm ivory accents,
forest-green headings, generous white space, plain language, and no diagnostic claims.

## Export flow

```text
┌──────────────────────────────────────────┐
│ Export my data                       ×   │
│ A readable summary for you or your care  │
│ team. Generated privately on this device.│
│                                          │
│ Name on report (optional)                │
│ [____________________________________]   │
│                                          │
│ Date range                               │
│ [ 13 Jan 2026  —  13 Jul 2026       > ] │
│                                          │
│ [✓] Include detailed daily log           │
│ [ ] Include journal entries              │
│     Personal writing is excluded unless  │
│     you deliberately include it.         │
│                                          │
│ [ Generate PDF ]                         │
│                                          │
│ Advanced                                 │
│   Export raw JSON (developer format)     │
└──────────────────────────────────────────┘

After generation:  [ Share PDF ]  [ Save to device ]
```

Authentication happens immediately after **Generate PDF** (or the advanced JSON action), before
any data is assembled. The successful or failed export is added to the security audit log.

## PDF pages

```text
PAGE 1 — AT A GLANCE
┌──────────────────────────────────────────┐
│ CYRA                         CYCLE HEALTH │
│                                          │
│ Cycle & symptom summary                  │
│ Prepared for: Amina K.                   │
│ 13 Jan–13 Jul 2026 · Generated 13 Jul    │
│                                          │
│ ┌────────┐ ┌────────┐ ┌────────┐         │
│ │6 cycles│ │28 days │ │5 days  │         │
│ │tracked │ │average │ │period  │         │
│ └────────┘ └────────┘ └────────┘         │
│                                          │
│ Cycle history                            │
│ Start       End         Cycle Period Flow│
│ 14 Jun      11 Jul      28 d   5 d   Med │
│ ...                                      │
│                                          │
│ Symptoms seen most often                 │
│ Cramps  8 days  ·  Headache  4 days ... │
│                                          │
│ Patterns are based only on logged data   │
│ and are not a diagnosis.                 │
└──────────────────────────────────────────┘

PAGE 2+ — DAILY DETAIL (optional, on by default)
┌──────────────────────────────────────────┐
│ Date       Cycle day  Flow  Symptoms      │
│ 14 Jun     Day 1      Heavy Cramps (4/5) │
│ ...                                      │
└──────────────────────────────────────────┘

FINAL APPENDIX — JOURNAL (explicit opt-in only)
┌──────────────────────────────────────────┐
│ Personal journal entries                 │
│ Included at the user's request           │
│ 18 Jun 2026                              │
│ [entry text…]                            │
└──────────────────────────────────────────┘
```

Empty exports keep the same cover and say “No cycle data was logged in this date range,” with a
short suggestion to choose another range. A one-cycle export avoids averages that imply a trend.
Long histories use repeated table headers, page numbers, and row wrapping; content never shrinks
below a readable size merely to fit one page.
