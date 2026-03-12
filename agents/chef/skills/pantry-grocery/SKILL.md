---
name: pantry-grocery
description: Track pantry inventory, generate grocery lists for missing ingredients, and manage shopping needs. Connects recipe suggestions to real-world shopping.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Pantry & Grocery Skill

Manage pantry inventory and generate grocery lists.

## When to Use
- User wants to update what they have at home ("I just bought X", "I'm out of Y")
- User asks "what do I have?" or "what's in my pantry?"
- User needs a grocery list for a specific recipe or meal plan
- User wants to check if they can make something with what they have
- Called internally by recipe-finder to check available ingredients

## Pantry Management

### PANTRY.md Structure
Write to `memory/PANTRY.md`:

```markdown
# Pantry Inventory

## Last Updated
YYYY-MM-DD

## Staples (always on hand)
| Item | Category | Notes |
|------|----------|-------|
| Olive oil | Oil | |
| Salt | Seasoning | |
| Rice | Grain | |

## Fresh (update frequently)
| Item | Category | Approximate Qty | Added |
|------|----------|-----------------|-------|
| Chicken thighs | Protein | 1 lb | YYYY-MM-DD |
| Spinach | Vegetable | 1 bag | YYYY-MM-DD |

## Frozen
| Item | Category | Approximate Qty | Added |
|------|----------|-----------------|-------|

## Running Low
| Item | Category | Notes |
|------|----------|-------|
```

### Operations

**Add Items**
- User says "I bought chicken, broccoli, and rice" → update PANTRY.md
- Categorize automatically: protein, vegetable, grain, dairy, seasoning, oil, etc.
- Confirm: "Updated pantry: added chicken, broccoli, rice."

**Remove Items**
- User says "I used up the chicken" or recipe-finder marks ingredients as used → update PANTRY.md
- After cooking a recipe, suggest removing used ingredients.

**Check Inventory**
- User asks "what do I have?" → return clean summary from PANTRY.md
- User asks "can I make [dish]?" → compare recipe ingredients against pantry, report what's missing.

**Flag Expiring Items**
- Fresh items older than 5 days: flag as "use soon"
- Suggest recipes that prioritize these ingredients.

## Grocery List Generation

### From a Recipe
When a recipe is chosen and ingredients are missing:
1. Compare recipe ingredients against PANTRY.md.
2. List only what's missing.
3. Group by store section (produce, protein, dairy, pantry, etc.).

### From a Meal Plan
When multiple recipes are planned for the week:
1. Aggregate all ingredients across recipes.
2. Subtract what's already in PANTRY.md.
3. Consolidate duplicates (e.g., 2 recipes need onions → list once with total quantity).
4. Group by store section.

### Grocery List Format
```markdown
# Grocery List — YYYY-MM-DD

## For: [Recipe name(s) or "Weekly meal plan"]

### Produce
- [ ] [item] — [quantity]

### Protein
- [ ] [item] — [quantity]

### Dairy
- [ ] [item] — [quantity]

### Pantry
- [ ] [item] — [quantity]

### Other
- [ ] [item] — [quantity]

**Estimated items: [n]**
```

## Rules
- Keep pantry categories simple and consistent.
- Don't ask for exact quantities unless the user volunteers them — approximations are fine.
- When generating grocery lists, always check pantry first to avoid buying duplicates.
- Staples section is for things the user always keeps on hand — don't include these in grocery lists unless explicitly out.
- After generating a grocery list, ask: "Want to order these or just use the list for shopping?"
- When grocery integrations are active, offer to send the list to Instacart/FreshDirect. Until then, present the list for manual use.

## Post-Action
- After pantry update: briefly confirm what changed.
- After grocery list: ask if they want to adjust anything.
- If a recipe used ingredients: suggest updating pantry.
