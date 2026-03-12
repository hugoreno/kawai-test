---
name: recipe-finder
description: Suggest recipes based on available ingredients, cravings, time constraints, dietary preferences, and skill level. Personalized to cooking history and taste profile.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Recipe Finder Skill

Find and suggest recipes for any occasion.

## When to Use
- User asks "what should I cook?" or "give me a recipe for..."
- User lists ingredients and wants ideas
- User has a craving and wants a matching recipe
- User wants quick/easy options for tonight
- User wants to try something new

## Input Gathering

### Required Context (ask if not provided)
- **Time available**: how long do they have? (15 min, 30 min, 1 hour, all afternoon)
- **Effort level**: quick & easy, moderate, or project cooking

### Optional Context (use if provided, don't force)
- Ingredients on hand (check PANTRY.md if available)
- Cuisine preference
- Serving size
- Specific craving or mood
- Dietary constraints

## Recipe Search Flow

1. Read `memory/PREFERENCES.md` for taste profile and cooking patterns.
2. Read `memory/FAVORITES.md` for known-good recipes to potentially suggest again.
3. Read `memory/PANTRY.md` (if exists) for available ingredients.
4. Read recent meal logs in `memory/meal-log/` to avoid repeating recent dishes.
5. Generate recipe suggestions that match:
   - Available time and effort level
   - Ingredients on hand (prioritize using what they have)
   - Cuisine preferences and cooking history
   - Dietary requirements from USER.md
6. Check USER.md blacklist — never suggest blacklisted ingredients or recipes.

## Output Format

### Recipe Suggestion Response
Lead with the top pick, then offer 2 alternatives:

```
**Top Pick: [Recipe Name]**
[Cuisine] · [Time] · [Difficulty: Easy/Medium/Challenging]
Why: [1-2 sentences — why this fits right now]
Ingredients you need: [brief list, flag any you likely don't have]

**Also Great:**
1. [Recipe Name] — [Cuisine] · [Time] · [Difficulty]. [One line why]
2. [Recipe Name] — [Cuisine] · [Time] · [Difficulty]. [One line why]
```

### Full Recipe Format (when user picks one)
```markdown
# [Recipe Name]

## Overview
- Cuisine: [type]
- Time: [prep] + [cook] = [total]
- Difficulty: [Easy / Medium / Challenging]
- Serves: [n]

## Ingredients
- [ ] [ingredient 1] — [amount]
- [ ] [ingredient 2] — [amount]
...

## Quick Steps
1. [Step 1 — brief]
2. [Step 2 — brief]
...

## Tips
- [Any helpful notes, substitutions, or make-ahead options]
```

## Rules
- Prioritize recipes using ingredients the user already has.
- If pantry is tracked and ingredients are expiring, suggest recipes that use them.
- For weeknight requests, default to 30-45 min total time unless told otherwise.
- Never suggest more than 3 options unless explicitly asked for more.
- When suggesting a favorite (from FAVORITES.md), note it: "One you've loved before."
- When suggesting something new, note it: "Something new to try."
- Always mention key substitutions if a recipe can flex around missing ingredients.

## Post-Suggestion
- Ask: "Want me to walk you through it step by step?"
- If ingredients are missing: "Want me to add the missing items to a grocery list?"
