---
name: training-plan
description: Generate and adapt multi-week training plans based on user goals. Adjust volume and intensity based on logged performance and recovery signals.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Training Plan Generation Skill

Build, adjust, and manage structured training programs.

## When to Use
- User asks for a training plan, program, or schedule
- User asks "what should I do today?"
- User wants to adjust current plan (more volume, less intensity, different split)
- User reports fatigue, soreness, or wants a deload

## Plan Generation

### Inputs Required
Before generating, confirm or infer from USER.md:
1. **Goal**: strength, endurance, Muay Thai performance, general fitness, or specific target
2. **Available days**: how many days per week (Hugo trains daily, so default to 6-7)
3. **Modalities**: kettlebells, cardio, Muay Thai (all three for Hugo)
4. **Constraints**: injuries, equipment, time per session

### Plan Structure
Write to `memory/plan/ACTIVE_PLAN.md`:

```markdown
# Active Training Plan

## Overview
- Goal: [primary goal]
- Duration: [weeks]
- Start date: YYYY-MM-DD
- Structure: [e.g., Push/Pull/Muay Thai/Cardio rotation]

## Weekly Template

### Day 1 — [Focus]
| Exercise | Sets | Reps | Weight/Intensity | Rest | Notes |
|----------|------|------|------------------|------|-------|
| [name] | [n] | [n] | [detail] | [sec] | [optional] |

### Day 2 — [Focus]
...

## Progression Rules
- [How to increase weight/volume week over week]
- [When to deload]
- [How to auto-regulate based on RPE]

## Deload Protocol
- Week [n]: reduce volume by 40%, maintain intensity
- Active recovery options: light cardio, mobility, easy bag work
```

### Programming Principles for Hugo
- **Kettlebell days**: compound movements — swings, cleans, presses, Turkish get-ups, goblet squats. Progressive overload via reps then weight.
- **Cardio days**: varied modality — bike, run, row, jump rope. Mix steady-state and intervals.
- **Muay Thai days**: skill work is its own session. Don't stack heavy strength before MT.
- **Cognitive training tie-in**: complex movement patterns (KB flows, combinations) serve both strength and cognitive goals.
- **Recovery**: at least 1 lighter day per week. Deload every 4-6 weeks.

## Daily Session Recommendation

When asked "what should I do today?":
1. Check ACTIVE_PLAN.md for today's scheduled session.
2. Check recent workout logs for fatigue signals (high RPE, missed sessions, repeated soreness notes).
3. If fatigued: suggest modified session or active recovery.
4. If on track: present today's planned session.
5. If no plan exists: suggest a session based on what hasn't been trained recently.

## Plan Adjustment
- User says "this is too much" → reduce volume 20%, keep frequency.
- User says "too easy" → increase intensity or add sets.
- User reports persistent soreness → suggest deload or modality swap.
- Always explain the reasoning behind adjustments.
