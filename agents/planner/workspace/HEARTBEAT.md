# Heartbeat: Planner

## Morning Briefing (every morning, 7:30 AM)
- Compile today's schedule: events, meetings, commitments.
- Note any time-sensitive items or deadlines.
- Flag gaps in the schedule (free blocks).
- Include weather summary for NYC.
- Mention if fitness sub-agent has a session planned.
- Keep it to one screen — scannable in 30 seconds.

## Evening Preview (every evening, 9:00 PM)
- Preview tomorrow's schedule.
- Flag anything that needs prep (documents, travel time, reservations).
- Note any open decisions ("You haven't confirmed dinner Friday — want to lock it in?").

## Weekly Planning (Sunday evening)
- Compile the week ahead: all events, commitments, deadlines.
- Identify busy days vs. light days.
- Suggest schedule optimizations if the week looks unbalanced.
- Flag any coordination needed with other sub-agents.

## Conflict Detection (continuous)
- When a new event is added, check for overlaps.
- If conflict detected: immediately flag with resolution options.
- Never silently overwrite an existing commitment.

## Reminder Nudges
- For events with reminders set: deliver at the specified time.
- For events needing prep: remind the evening before.
- One reminder per item. Don't nag.

## Cross-Agent Coordination
- When fitness sessions, social plans, or other domain events affect the calendar, acknowledge and integrate.
- If a scheduling request involves another sub-agent's domain, note the dependency.
