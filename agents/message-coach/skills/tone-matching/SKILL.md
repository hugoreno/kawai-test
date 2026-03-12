---
name: tone-matching
description: Rewrite messages with adjusted tone, or help match tone to situation. Transform drafts between registers (formal/casual/warm/direct) while preserving the user's voice.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Tone Matching Skill

Adjust the temperature of a message without losing Hugo's voice.

## When to Use
- Hugo asks to rewrite a message with a different tone ("make this more casual")
- Hugo is unsure what tone to use and wants guidance
- Hugo has a draft that "doesn't sound right" and needs calibration
- Hugo wants to soften a blunt message or sharpen a vague one
- Hugo needs help matching tone to a specific audience or situation

## Tone Spectrum

```
← More Formal                                          More Casual →
Corporate → Professional → Friendly-Professional → Casual → Texting
```

### Corporate
- Full sentences, proper grammar, no contractions
- "Dear [Name]," / "Kind regards,"
- Used for: legal, executive communication, external stakeholders
- Hugo probably hates this. Only use when explicitly requested.

### Professional
- Clean, structured, but human
- "Hi [Name]," / "Best,"
- Used for: clients, new colleagues, investors, cold outreach
- Hugo's likely default for work emails

### Friendly-Professional
- Contractions okay, slightly warmer, less rigid
- "Hey [Name]," / "Thanks!" / "Cheers,"
- Used for: colleagues he knows, recurring contacts, warm intros
- The sweet spot for most of Hugo's professional writing

### Casual
- Short sentences, lowercase okay, emoji optional
- "hey" or no greeting / no sign-off or just a name
- Used for: friends, close colleagues, group chats
- Hugo's natural state for DMs and texts

### Texting
- Minimal. Fragments. Vibes over grammar.
- No greeting, no sign-off, maybe an emoji
- Used for: close friends, quick replies
- Where Hugo lives most of the time

## Tone Adjustment Process

### 1. Analyze the Current Draft
- What tone is it currently at on the spectrum?
- What channel is it for?
- Who's the recipient?

### 2. Identify the Target Tone
From Hugo's request:
- Explicit: "make it more formal" → shift right on spectrum
- Implicit: "this is for my boss" → match to relationship-based tone
- Vague: "it doesn't feel right" → ask: "Too formal? Too casual? Too long?"

### 3. Transform
Key adjustments by direction:

**Making it more formal:**
- Expand contractions
- Complete sentence fragments
- Add appropriate greeting/sign-off
- Remove emoji
- Soften direct statements ("I need X" → "Would it be possible to X?")

**Making it more casual:**
- Use contractions
- Shorten sentences
- Drop unnecessary greetings/sign-offs
- Allow fragments and lowercase
- Be more direct ("Would it be possible..." → "Can we...")

**Making it warmer:**
- Add personal touches ("Hope your week's going well")
- Use softer language ("I'd love to" vs. "I want to")
- Show appreciation where genuine
- Use the person's name

**Making it more direct:**
- Cut filler words and hedge phrases
- Lead with the ask or point
- Remove unnecessary pleasantries
- Shorter paragraphs, shorter sentences

## Output Format

### Before/After
```
**Before** (your original):
> [original text]

**After** ([target tone]):
[rewritten text]

**What changed**: [brief explanation — e.g., "shortened, dropped the greeting, more direct"]
```

### Multiple Tone Options
```
**Original**:
> [original text]

**Warmer version**:
[rewritten text]

**More direct version**:
[rewritten text]

**What's different**: [brief comparison]
```

## Tone Guidance

When Hugo isn't sure what tone to use:

1. Ask about the relationship: "How well do you know them?"
2. Ask about the stakes: "Is this casual or does it matter?"
3. Suggest based on voice profile: "Based on how you usually write to [type], I'd go [tone]."
4. When in doubt, draft in friendly-professional — it's rarely wrong.

## Preserving Voice

Critical: tone adjustment changes the register, NOT the voice. Hugo's writing should still sound like Hugo, just dialed up or down.

- Keep his sentence rhythm (short and punchy stays short and punchy, even in formal)
- Keep his vocabulary (don't introduce words Hugo wouldn't use)
- Keep his personality (if he's witty in texts, a warmer email can still have a touch of wit)
- The blacklist from VOICE_PROFILE.md always applies regardless of tone

## Red Flags

Flag these to Hugo:
- "This might come across as passive-aggressive" → quote the specific line
- "This is pretty blunt — want me to soften it?" → offer an alternative
- "The tone shift from your greeting to your ask is jarring" → suggest smoothing
- "This reads like a template — want me to make it more you?" → rewrite in his voice
