---
name: restaurant-discovery
description: Recommend restaurants based on cuisine, occasion, budget, neighborhood, and party size. Uses dining preferences and history to personalize suggestions.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Restaurant Discovery Skill

Find and recommend restaurants for any occasion.

## When to Use
- User asks "where should I eat?" or "recommend a restaurant"
- User specifies a cuisine, neighborhood, occasion, or budget
- User wants options for a specific date or group size
- User asks for something new vs. returning to a favorite

## Input Gathering

### Required Context (ask if not provided)
- **Occasion**: casual weeknight, date night, group dinner, celebration, quick bite
- **Party size**: default to 2 if not specified

### Optional Context (use if provided, don't force)
- Cuisine preference
- Neighborhood preference
- Budget range
- Specific vibe (loud/lively, quiet/intimate, outdoor, counter seating)
- Time of day (lunch vs. dinner)

## Recommendation Flow

1. Read `memory/PREFERENCES.md` for taste profile and preference patterns.
2. Read `memory/FAVORITES.md` for known-good spots.
3. Read recent dining logs in `memory/dining/` to avoid repeating recent visits (unless requested).
4. Generate recommendations using:
   - User preferences and history
   - Neighborhood knowledge (Downtown Manhattan focus)
   - Occasion matching (budget, vibe, party size)
5. Check `USER.md` blacklist — never recommend blacklisted restaurants.

## Output Format

### Recommendation Response
Lead with the top pick, then offer 2 alternatives:

```
**Top Pick: [Restaurant Name]**
[Cuisine] · [Neighborhood] · [Price Range]
Why: [1-2 sentences — what makes it right for this occasion]

**Also Great:**
1. [Restaurant Name] — [Cuisine] · [Neighborhood] · [Price Range]. [One line why]
2. [Restaurant Name] — [Cuisine] · [Neighborhood] · [Price Range]. [One line why]
```

## Rules
- Prioritize Downtown Manhattan neighborhoods unless user asks otherwise.
- If recommending a favorite (from FAVORITES.md), note it: "One of your go-tos."
- If recommending somewhere new, note it: "Haven't tried this one yet."
- For special occasions, lean toward higher-end picks.
- For quick/casual, prioritize proximity and no-reservation-needed spots.
- When reservation integrations are active, include availability. Until then, suggest the user book directly and mention the platform (Resy/OpenTable) if known.
- Never recommend more than 3 options unless explicitly asked for more.

## Post-Recommendation
- Ask: "Want me to log this if you end up going?"
- If user confirms a choice, note it for follow-up.
