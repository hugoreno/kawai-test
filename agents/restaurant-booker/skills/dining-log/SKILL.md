---
name: dining-log
description: Log dining experiences with structured data. Track restaurants visited, dishes ordered, ratings, and notes. Review dining history.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Dining Log Skill

Log dining experiences and retrieve dining history.

## When to Use
- User says they ate out, went to a restaurant, or had a meal
- User asks "where did I eat last week?" or "show me my dining history"
- User wants to rate or review a restaurant after visiting
- User wants to log a meal after the fact

## Logging a Dining Experience

### Input Parsing
Accept natural language. Examples:
- "Had dinner at Dhamaka last night, the lamb chops were incredible"
- "Went to Tatiana with 4 people, solid but a bit loud"
- "Quick ramen at Nakamura, hit the spot"

### Structured Output Format
Write to `memory/dining/YYYY-MM-DD.md`:

```markdown
# Dining — YYYY-MM-DD

## Restaurant Info
- Restaurant: [name]
- Cuisine: [type]
- Neighborhood: [area]
- Price range: [$-$$$$]
- Occasion: [weeknight / date night / group / celebration / solo / work]
- Party size: [n]
- Reservation: [yes/no, platform if known]

## What We Had
| Dish | Notes |
|------|-------|
| [dish name] | [brief impression] |

## Rating
- Overall: [1-5 stars]
- Food: [1-5]
- Vibe: [1-5]
- Service: [1-5]
- Value: [1-5]

## Notes
[Free-form — what stood out, would you return, who would you bring here]

## Would Return
[Yes / No / Maybe — with brief reason]
```

### Rules
- If multiple restaurants on same day, create separate entries with `## Dinner 2` or use time-based headers.
- Always ask for overall rating (1-5) if not provided. Keep it simple: "How was it, 1-5?"
- Don't force all rating subcategories. Overall is enough. Capture sub-ratings only if user volunteers them.
- For quick/casual meals, a lighter log is fine — restaurant, what you had, quick rating.
- After logging, check if this restaurant should be suggested as a favorite (3+ visits, avg >= 4).

## Reading History
- Read from `memory/dining/` directory.
- Default: show last 7 days.
- Summarize: restaurants visited, cuisines, average ratings, standouts.
- Support queries like "last time I went to [restaurant]" or "all Japanese spots I've tried".

## Post-Log Actions
1. Update `memory/FAVORITES.md` if the restaurant qualifies (3+ visits, avg rating >= 4).
2. Check if dining patterns in `memory/PREFERENCES.md` should be updated.
3. Briefly confirm: "Logged: [restaurant], [cuisine], [rating]/5. [Any follow-up like 'added to favorites' or 'noted as a new spot']"
