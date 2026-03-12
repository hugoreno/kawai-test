---
name: dining-preferences
description: Manage and evolve dining preferences over time. Track cuisine tastes, budget comfort, neighborhood preferences, favorite spots, and blacklisted restaurants.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Dining Preferences Skill

Learn, store, and evolve Hugo's dining preferences.

## When to Use
- User explicitly states a preference ("I love Japanese food", "I don't like FiDi for dinner")
- User asks to see their preference profile
- User wants to add/remove a favorite or blacklist a restaurant
- After analyzing dining logs, patterns suggest a preference update

## Memory Files
- Preferences: `memory/PREFERENCES.md`
- Favorites: `memory/FAVORITES.md`
- User profile: `USER.md` (read-only for context, write for blacklist/dietary updates)

## PREFERENCES.md Structure

```markdown
# Dining Preferences

## Last Updated
YYYY-MM-DD

## Cuisine Rankings
| Cuisine | Affinity | Based On |
|---------|----------|----------|
| [e.g., Japanese] | High | [3 logged visits, all rated 4+] |
| [e.g., Italian] | Medium | [user stated] |

## Neighborhood Preferences
| Neighborhood | Preference | Notes |
|--------------|-----------|-------|
| [e.g., West Village] | Favorite | [great date night spots] |
| [e.g., FiDi] | Avoid evenings | [user stated — dead after 7pm] |

## Budget Comfort
- Weeknight default: $$
- Date night default: $$-$$$
- Special occasion: $$$$

## Vibe Preferences
- Prefers: [e.g., intimate, counter seating, natural wine bars]
- Avoids: [e.g., loud/clubby, tourist traps]

## Patterns (auto-detected)
- [e.g., Tends to eat Japanese on weeknights]
- [e.g., Prefers Italian for group dinners]
```

## FAVORITES.md Structure

```markdown
# Favorite Restaurants

## Last Updated
YYYY-MM-DD

| Rank | Restaurant | Cuisine | Neighborhood | Price | Visits | Avg Rating | Notes |
|------|-----------|---------|--------------|-------|--------|------------|-------|
| 1 | [name] | [type] | [area] | [$$] | [n] | [4.5] | [go-to for X] |
```

## Operations

### Add Preference
- User says "I love [cuisine/neighborhood/vibe]" → update PREFERENCES.md
- Confirm: "Got it — added [X] to your preferences."

### Remove/Update Preference
- User says "I'm over [cuisine]" or "actually I like [neighborhood] now" → update accordingly
- Confirm the change.

### Add Favorite
- Triggered by dining log with rating >= 4, or explicit "add to favorites"
- Insert into FAVORITES.md, sorted by average rating then visit count.

### Blacklist
- User says "never recommend [restaurant] again" → add to USER.md blacklist section.
- Confirm: "Done — [restaurant] won't come up again."

### View Profile
- When user asks "what are my preferences?" — return a clean summary from PREFERENCES.md and FAVORITES.md.

## Auto-Learning Rules
- After every 5 new dining logs, scan for patterns and update PREFERENCES.md "Patterns" section.
- If a cuisine appears in 3+ logs with avg rating >= 4, auto-suggest promoting it to "High" affinity.
- If a restaurant has 3+ visits with avg rating >= 4, auto-suggest adding to favorites.
- Always confirm auto-detected changes with the user before writing.
