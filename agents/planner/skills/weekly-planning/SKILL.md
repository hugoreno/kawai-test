---
name: weekly-planning
description: Plan and review the week ahead. Coordinate logistics across domains, optimize schedule balance, and maintain weekly plan files.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Weekly Planning Skill

Plan, review, and optimize the week.

## When to Use
- User asks "what does my week look like?"
- User wants to plan the upcoming week
- User asks to rearrange or optimize their schedule
- Sunday evening heartbeat triggers weekly planning
- User needs to coordinate plans across multiple days

## Weekly Plan Generation

### Inputs
1. Read all `memory/events/` files for the target week.
2. Read `memory/RECURRING.md` for recurring commitments.
3. Read USER.md for preferences (meeting windows, buffer time, protected blocks).
4. Check with fitness sub-agent schedule if relevant.

### Plan Structure
Write to `memory/weeks/YYYY-Www.md`:

```markdown
# Week Plan — YYYY-Www

## Overview
- Busiest day: [day]
- Lightest day: [day]
- Open blocks: [count] across the week
- Key deadlines: [list]
- Decisions needed: [list]

## Monday
| Time | Event | Type | Notes |
|------|-------|------|-------|
| 08:00 | Morning routine | block | Protected |
| 09:30 | [Event] | [type] | [notes] |
| ... | ... | ... | ... |
- Free blocks: [list open windows]

## Tuesday
...

## Sunday
...

## Week Notes
- [Coordination needs, prep items, things to watch for]
```

### Planning Principles
- **Protect mornings**: Don't schedule meetings before Hugo's morning routine finishes.
- **Batch meetings**: When possible, group meetings on the same day. Keep other days maker-schedule.
- **Balance intensity**: Don't stack heavy meeting days back-to-back.
- **Respect energy**: Put creative/deep work on lighter days. Keep logistics and calls on busy days.
- **Buffer travel**: If events have different locations, account for transit time.
- **Weekend defaults**: Keep weekends lighter unless Hugo explicitly fills them.

## Weekly Review
When reviewing a past week:
1. Compare planned vs. actual (what was added, moved, cancelled).
2. Note patterns: which days were overloaded? Which had slack?
3. Surface any recurring conflicts or scheduling friction.
4. Suggest adjustments for the coming week.

## Schedule Optimization
When asked to "fix my week" or "this week is too packed":
1. Identify movable events (tentative, flexible, self-imposed).
2. Identify immovable events (external meetings, deadlines, social commitments).
3. Suggest rearrangements that improve balance.
4. Present before/after view. Don't move anything without confirmation.

## Cross-Domain Coordination
- Fitness sessions: check fitness sub-agent's plan, reserve gym slots.
- Social plans: if going-out or group events are being planned, hold tentative time.
- Work deadlines: flag days where deep work should be protected.
- Always note dependencies: "If dinner moves to Saturday, your Sunday morning is lighter."

## Output Format
When presenting a week:
- Use clean tables for dense days.
- Use simple lists for light days.
- Always include free blocks — Hugo should see his breathing room.
- Keep it to one screenful when possible.
