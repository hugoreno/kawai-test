---
name: morning-briefing
description: Generate a concise daily briefing covering today's schedule, key reminders, weather, and anything that needs attention. Designed to be read in 30 seconds.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Morning Briefing Skill

Deliver a clean, scannable daily summary.

## When to Use
- Morning heartbeat trigger (7:30 AM)
- User asks "what's today look like?" or "brief me"
- User asks "what do I need to know today?"

## Briefing Structure

Write to `memory/briefings/YYYY-MM-DD.md` and deliver to user:

```markdown
# Briefing — YYYY-MM-DD ([Day of Week])

## Schedule
| Time | Event | Notes |
|------|-------|-------|
| [HH:MM] | [Event] | [location, people, prep] |
| ... | ... | ... |

**Free blocks**: [list available windows]

## Reminders
- [Any active reminders for today from REMINDERS.md]

## Heads Up
- [Tomorrow's early commitment, if any]
- [Upcoming deadline within 48h]
- [Anything flagged from weekly plan]

## Weather
- NYC: [conditions, high/low]
- [Dress suggestion if weather is notable — rain, extreme cold/heat]
```

## Assembly Rules

### Schedule
1. Read `memory/events/YYYY-MM-DD.md` for today's events.
2. Read `memory/RECURRING.md` for recurring items on this day of week.
3. Merge and sort chronologically.
4. Include fitness session from fitness sub-agent schedule if known.

### Reminders
1. Read `memory/REMINDERS.md` for any reminders due today.
2. Include prep reminders for tomorrow's events if flagged.

### Heads Up
1. Check tomorrow's events for anything requiring prep tonight.
2. Check this week's plan for upcoming deadlines (48h window).
3. Flag any unresolved scheduling conflicts.

### Weather
1. [Future integration: Weather API]
2. For now: omit or note "weather integration not yet active."

## Output Rules
- **30-second read.** If Hugo can't scan it in 30 seconds, it's too long.
- No preamble. Start with the schedule table.
- Only include sections that have content. Skip empty sections.
- If the day is clear: "Clear day. No scheduled events. Free to go deep."
- If the day is packed: lead with the first event and total count.
- Time format: 24h with ET timezone (e.g., 09:30 ET).

## Delivery
- Deliver proactively via heartbeat at 7:30 AM.
- Also available on-demand when user asks.
- Archive in `memory/briefings/YYYY-MM-DD.md` for reference.
