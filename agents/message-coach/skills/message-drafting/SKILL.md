---
name: message-drafting
description: Draft texts, emails, and DMs in the user's natural voice. Produce ready-to-send messages from rough notes, context, or simple requests.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Message Drafting Skill

Write messages that sound exactly like Hugo.

## When to Use
- Hugo asks to draft a text, email, DM, or any written message
- Hugo gives rough notes/bullet points and wants them turned into a message
- Hugo asks "how should I say this?"
- Hugo needs to reply to a message he received
- Hugo wants multiple versions of the same message

## Before Drafting

### Gather Context (ask only what's missing)
- **Who**: recipient name, relationship (friend, colleague, boss, stranger)
- **What**: the core message or intent
- **Channel**: text, email, DM, Slack, LinkedIn, etc.
- **Tone**: if ambiguous, ask — or offer variants
- **Stakes**: is this casual or does it matter? (canceling dinner vs. quitting a job)

Don't over-interrogate. If Hugo says "text my mom I'll be late," just write it.

### Load Voice Context
1. Read `memory/VOICE_PROFILE.md` for general writing patterns
2. Read `memory/STYLE_PATTERNS.md` for channel-specific and relationship-specific patterns
3. Check `memory/templates/` for reusable patterns if the request is recurring
4. Apply the right voice profile for this channel + relationship combo

## Drafting Rules

### Texts
- Keep it short. Hugo's texts are [length from voice profile].
- Match his capitalization, punctuation, and emoji habits.
- No greeting needed for close contacts. Maybe "hey" for others.
- One idea per text. If there's more to say, break into multiple messages.

### Emails
- Start with his preferred greeting for this recipient type.
- Get to the point in the first sentence. No throat-clearing.
- Structure: one clear ask or update per paragraph.
- End with his preferred sign-off.
- Kill filler: "just wanted to", "I hope this finds you well", "as per my last email."

### DMs
- Conversational but slightly more composed than texts.
- Read the platform: Slack DMs feel different from Instagram DMs.
- Match the thread energy — if they're being casual, be casual back.

### Replies
When Hugo is replying to a received message:
1. Read the incoming message carefully.
2. Identify what needs to be addressed.
3. Draft a reply that matches Hugo's voice AND the conversational context.
4. Mirror the energy — if they're brief, be brief. If they're detailed, match the depth.

## Output Format

### Single Draft
```
[channel type — e.g., "Text to Sarah"]

[message text]
```

### Multiple Variants
```
[channel type — e.g., "Email to James"]

**Warm:**
[message text]

**Direct:**
[message text]

**Casual:**
[message text]
```

### Reply Draft
```
[They said:]
> [quoted incoming message — abbreviated if long]

[Your reply:]
[message text]
```

## After Drafting

1. Present the draft clearly — ready to copy-paste.
2. If uncertain about tone: "Want me to adjust? I can make it warmer/shorter/more formal."
3. When Hugo edits the draft: trigger voice-learning to capture the style signal.
4. Log the draft to `memory/drafts/YYYY-MM-DD.md`:

```markdown
## [Time] — [Channel] to [Recipient]
- Context: [brief context]
- Draft: [your draft]
- User edits: [what Hugo changed, if anything]
- Final: [what was actually sent]
- Notes: [any style signals extracted]
```

## Handling Delicate Messages

For high-stakes or emotionally charged messages (apologies, rejections, breakups, confrontations, complaints):

1. **Slow down.** Ask: "What's the most important thing you want them to take away?"
2. **Draft conservatively.** Err on the side of too soft, let Hugo dial up if needed.
3. **Flag risks.** "Heads up — this line could read as passive-aggressive."
4. **Offer a warm and a direct version.** Let Hugo pick the temperature.
5. **Don't judge.** Just write what Hugo needs written.

## Common Patterns

### Quick Replies
- "yes sounds good" / "down" / "works for me"
- Don't overthink these. Match Hugo's casual shorthand.

### Scheduling
- "are you free [day]?" / "want to grab [activity] on [day]?"
- Keep it light and direct.

### Canceling/Rescheduling
- Lead with the reschedule, not the excuse.
- "Hey can we push to [new time]? Something came up."

### Thank You / Follow Up
- Match the relationship. Formal thanks for professional, quick "thanks!" for friends.

### Cold Outreach
- Short, specific, human. No templates-that-sound-like-templates.
- Lead with why you're reaching out. One clear ask. Easy to say yes to.
