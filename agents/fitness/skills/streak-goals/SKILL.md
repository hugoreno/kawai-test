---
name: streak-goals
description: Maintain workout streaks, track progress toward goals, calculate XP and badges for the Tamagotchi identity layer.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Streak & Goal Tracking Skill

Manage streaks, goals, XP, and milestones.

## When to Use
- User asks about their streak ("how many days in a row?")
- User wants to set, check, or update a fitness goal
- User asks about XP, badges, or milestones
- Called internally after workout-tracking logs a session

## Streak Management

### Rules
- A streak increments when a workout is logged on a calendar day.
- Multiple sessions on the same day count as one streak day.
- A missed day breaks the streak (reset to 0).
- Rest days explicitly declared in the training plan do NOT break the streak.
- Read/write from `memory/STREAKS.md`.

### Streak Milestones
| Days | Badge | XP Bonus |
|------|-------|----------|
| 7 | Week Warrior | +50 XP |
| 14 | Two-Week Titan | +75 XP |
| 30 | Monthly Machine | +200 XP |
| 60 | Iron Habit | +400 XP |
| 90 | Quarter Beast | +600 XP |
| 365 | Year of the Grind | +2000 XP |

When a milestone is hit, celebrate it genuinely and log it in the Milestones section of STREAKS.md.

## Goal Management

### Setting a Goal
Ask for:
1. **What**: specific, measurable target (e.g., "kettlebell press 32kg x5", "run 5K under 25 min")
2. **By when**: deadline or "ongoing"
3. **Current baseline**: where they are now

Write to `memory/STREAKS.md` under `## Goals`:
```markdown
### [Goal Name]
- Target: [specific target]
- Started: YYYY-MM-DD
- Deadline: [date or ongoing]
- Baseline: [starting point]
- Progress: [current / target]
- Status: active
```

### Checking Goals
- Report current progress as percentage and absolute.
- If a goal is close (>75%), mention it proactively.
- On completion: celebrate, award XP, move to Milestones section.

## XP System

### XP Awards
| Action | XP |
|--------|-----|
| Workout logged | +10 |
| 7-day streak milestone | +50 |
| 30-day streak milestone | +200 |
| PR (personal record) | +25 |
| Goal completed | +100 |
| Deload week completed | +30 |

### XP Tracking
- Running total in `memory/STREAKS.md` under `## XP Log`.
- Log each award with date and reason.

## Output Format
When reporting status:
```
Streak: [n] days (longest: [n])
XP: [total] | Next milestone: [name] in [n] days
Active goals: [count]
  - [goal 1]: [progress]% ([current] / [target])
```
Keep it tight. Hugo wants the numbers, not a pep talk.
