---
name: cooking-walkthrough
description: Walk through cooking a specific recipe step by step. Provide clear instructions, timing cues, and technique tips. Adapt to skill level and answer questions mid-cook.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Cooking Walkthrough Skill

Guide the user through cooking a dish, one step at a time.

## When to Use
- User says "walk me through [recipe]" or "help me cook [dish]"
- User picks a recipe from recipe-finder and wants guidance
- User is mid-cook and has a question about technique or timing
- User wants to learn how to make something specific

## Walkthrough Flow

### Before Starting
1. Confirm the recipe and serving size.
2. List all ingredients with amounts — ask user to confirm they have everything.
3. If anything is missing, suggest substitutions or flag it.
4. List any equipment needed (specific pans, tools, etc.).
5. Estimate total time: prep + cook.

### During Cooking
- **One step at a time.** Don't dump the entire recipe.
- After each step, wait for the user to confirm they're ready for the next.
- Include timing cues: "This will take about 3 minutes" or "While that's simmering..."
- Offer technique tips when relevant: "Dice the onion fine so it melts into the sauce."
- If a step has idle time (simmering, baking), suggest what to prep next.

### Step Format
```
**Step [n]: [Action]**
[Clear, concise instruction — 1-3 sentences max]

⏱️ [Time estimate if applicable]
💡 [Tip — optional, only when genuinely helpful]

Ready for the next step?
```

### Handling Questions Mid-Cook
- "Is it supposed to look like this?" → Ask them to describe it, give guidance.
- "Can I substitute X?" → Give the best swap and note any impact on the dish.
- "How do I know when it's done?" → Give visual, tactile, or aroma cues.
- "I messed up [step]" → Don't panic. Suggest a recovery if possible, or adjust the plan.

## Technique Library
When a step involves a technique, briefly explain if the user's skill level suggests they need it:

- **Mise en place**: Prep and measure everything before you start cooking.
- **Deglaze**: Add liquid to a hot pan to lift browned bits (fond) — that's where the flavor is.
- **Bloom spices**: Toast spices in oil for 30-60 seconds to release aromatics.
- **Fold**: Gently combine by scooping from bottom to top — don't stir or you'll knock out the air.
- **Rest meat**: Let it sit off heat so juices redistribute. Don't cut immediately.
- **Emulsify**: Combine oil and water-based liquids by whisking vigorously or adding an emulsifier.

## Rules
- Never dump the full recipe as a wall of text. Step by step only.
- Adapt verbosity to context: if Hugo seems experienced, be brief. If he's learning, add more detail.
- Always give sensory cues alongside timers: "golden brown", "fragrant", "starts to bubble at the edges."
- If the user goes quiet for a while, check in: "How's it going?"
- Scale all ingredient amounts to the stated serving size.

## Post-Cook Actions
1. Ask: "How did it turn out? Want to rate it?"
2. If rated, log to `memory/meal-log/YYYY-MM-DD.md` using the dining log format.
3. If rated >= 4, suggest saving to favorites.
4. Note any modifications the user made — these are valuable for future suggestions.
