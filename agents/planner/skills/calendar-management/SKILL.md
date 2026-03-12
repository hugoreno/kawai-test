---
name: calendar-management
description: Manage calendar events — schedule, move, cancel, and query. Find free time, detect conflicts, and maintain the daily event log.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Calendar Management Skill

Schedule, query, and manage calendar events.

## When to Use
- User wants to add, move, or cancel an event
- User asks "when am I free?" or "what's on my calendar?"
- User asks about a specific day or time slot
- Conflict detection after adding a new event

## Adding an Event

### Input Parsing
Accept natural language. Examples:
- "Dinner with Alex Friday at 8pm at Carbone"
- "Team standup tomorrow 10am, 30 min"
- "Block off Saturday afternoon for apartment stuff"
- "Coffee with Sarah sometime next week"

### Structured Output Format
Write to `memory/events/YYYY-MM-DD.md`:

```markdown
# Events — YYYY-MM-DD

## [Time] — [Event Title]
- Time: HH:MM - HH:MM ET
- Location: [if provided]
- With: [people, if applicable]
- Type: [meeting / social / personal / block / errand]
- Status: [confirmed / tentative / cancelled]
- Prep: [anything needed beforehand]
- Notes: [any context]
- Reminder: [time before event, if set]
```

### Rules
- If no duration specified, use USER.md default (30 min for meetings, 1h for social, 2h for blocks).
- After adding, immediately check for conflicts with existing events on that day.
- If conflict found: do NOT overwrite. Present the conflict and ask Hugo to choose.
- For vague times ("sometime next week"), suggest 2-3 specific slots based on free time.
- If the event involves travel, note that buffer time may be needed.
- Update `memory/RECURRING.md` if the event repeats.

## Querying Events
- "What's today?" → Read `memory/events/YYYY-MM-DD.md` for today.
- "What's this week?" → Read all event files for the current week.
- "When am I free Thursday?" → Read Thursday's events, return open blocks.
- Default: show events as a clean timeline, earliest first.

## Free Time Search
When asked "when am I free?":
1. Read events for the requested day(s).
2. Read `memory/RECURRING.md` for recurring commitments.
3. Subtract booked time from available hours (default: 8 AM - 10 PM ET).
4. Return open blocks, noting their duration.
5. Mark blocks adjacent to intense events as "technically free but tight."

## Moving Events
- Confirm the move: "Move [event] from [old time] to [new time]?"
- Update the event file. If moving across days, update both files.
- Re-check for conflicts at the new time.

## Cancelling Events
- Mark status as `cancelled` in the event file. Don't delete — keep for reference.
- If the event involved other people, note: "You may want to let [person] know."

## Conflict Detection
After any event change:
1. Check all events on the same day for time overlaps.
2. Check buffer time between events (15 min preferred per USER.md).
3. If conflict: flag immediately with resolution options.
