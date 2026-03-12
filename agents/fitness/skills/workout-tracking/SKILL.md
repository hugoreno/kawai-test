---
name: workout-tracking
description: Track and log workouts with structured data. Parse natural language workout descriptions into structured logs. Read recent session history.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Workout Tracking Skill

Log workouts and retrieve training history.

## When to Use
- User says they worked out, trained, or did a session
- User asks "what did I do last time?" or "show me this week's workouts"
- User wants to log a session after the fact

## Logging a Workout

### Input Parsing
Accept natural language. Examples:
- "Did kettlebell swings 5x10 at 24kg, then 20 min on the bike"
- "Muay Thai session, 90 minutes, felt good"
- "Legs today — goblet squats, lunges, kettlebell deadlifts"

### Structured Output Format
Write to `memory/workouts/YYYY-MM-DD.md`:

```markdown
# Workout — YYYY-MM-DD

## Session Info
- Date: YYYY-MM-DD
- Type: [Kettlebells / Cardio / Muay Thai / Mixed]
- Duration: [estimated or stated]
- RPE: [1-10, ask if not provided]
- Notes: [any context — mood, energy, soreness]

## Exercises
| Exercise | Sets | Reps | Weight | Notes |
|----------|------|------|--------|-------|
| [name] | [n] | [n] | [kg/lbs] | [optional] |

## Post-Session
- [Any observations, how it felt, what to remember]
```

### Rules
- If multiple sessions on same day, append with `## Session 2` header.
- Always ask for RPE if not provided. Frame it as: "How hard was that on a 1-10 scale?"
- For Muay Thai: log duration, type of work (pads, sparring, bag, drills), and intensity.
- For cardio: log modality (bike, run, row), duration, and intensity/pace if known.
- After logging, update `memory/STREAKS.md` streak counter.

## Reading History
- Read from `memory/workouts/` directory.
- Default: show last 7 days.
- Summarize: sessions count, total volume, modality split, average RPE.

## Post-Log Actions
1. Update streak in `memory/STREAKS.md` (increment current streak, update last workout date).
2. Check if any goals in STREAKS.md have progressed.
3. Briefly confirm the log: "Logged: [type] session, RPE [n]. Streak: [n] days."
